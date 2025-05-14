import 'dart:async';
import 'dart:convert';

import 'package:bridge_ai/constants/controllers.dart';
import 'package:bridge_ai/constants/firebase.dart';
import 'package:bridge_ai/controllers/messagingController.dart';
import 'package:bridge_ai/models/user.dart';
import 'package:bridge_ai/screens/profile/success.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class PatientController extends GetxController {
  static PatientController instance = Get.find();
  RxList<UserModel> patients = RxList<UserModel>([]);
  String collection = "users";
  var NurseId;
  List<Nurse> _nurses = [];

  late StreamSubscription<QuerySnapshot> nursestream;

  @override
  onReady() {
    super.onReady();
    patients.bindStream(getNurse(NurseId));
  }

  // Stream<List<UserModel>> getPatients(String nurseid) => firebaseFirestore
  //     .collection(collection)
  //     .where("assignednurse", isEqualTo: nurseid)
  //     .snapshots()
  //     .map((query) =>
  //         query.docs.map((item) => UserModel.fromMap(item.data())).toList());
  Future<List<UserModel>> getPatients(String nurseid) async {
    try {
      var querySnapshot = await firebaseFirestore
          .collection(collection)
          .where("assignednurse", isEqualTo: nurseid)
          .get();

      List<UserModel> patientsList = querySnapshot.docs
          .map((documentSnapshot) => UserModel.fromMap(documentSnapshot.data()))
          .toList();

      return patientsList;
    } catch (e) {
      // Handle any errors that might occur during the database query
      print("Error fetching patients: $e");
      return [];
    }
  }

  Stream<List<UserModel>> getNurse(String city) => firebaseFirestore
      .collection(collection)
      .where("nurse", isEqualTo: true)
      .where("city", isEqualTo: city)
      .snapshots()
      .map((query) =>
          query.docs.map((item) => UserModel.fromMap(item.data())).toList());

  Stream<QuerySnapshot> nurseStream(String city) {
    var reference = FirebaseFirestore.instance
        .collection(collection)
        .where("nurse", isEqualTo: true)
        .where("city", isEqualTo: city);
    return reference.snapshots();
  }

  //obtaining suitable nurses for patient
  void getSuitableNurses(BuildContext context, int counter, String city) {
    _nurses.clear();
    bottomwidget(
        context,
        "Looking for a suitable doctor for you and close to you",
        "Sit back and relax, for we are matching you with the most suitable doctor for you.");
    if (nurseStream(city).first != null) {
      Timer.periodic(const Duration(seconds: 1), (timer) async {
        print(timer.tick);
        counter--;
        nursestream = nurseStream(city).listen(
          (event) {
            event.docs.forEach((nurse) async {
              Map<dynamic, dynamic> data =
                  nurse.data()! as Map<dynamic, dynamic>;
              if (_nurses.contains(Nurse(
                    name: data['name'],
                    phone: data['phone'],
                    id: data['id'],
                    email: data['email'],
                    clients: data['clients'],
                    pic: data['pic'],
                  )) ==
                  false) {
                _nurses.add(Nurse(
                  name: data['name'],
                  phone: data['phone'],
                  id: data['id'],
                  email: data['email'],
                  clients: data['clients'],
                  pic: data['pic'],
                ));
              }
              _nurses.sort((a, b) => a.clients.compareTo(b.clients));
            });
          },
        );
        if (counter == 0) {
          timer.cancel();
          nursestream.cancel();
          print(_nurses.length);
          if (_nurses.length != 0) {
            if (_nurses.first.clients >= 10) {
              Get.back();
              bottomwidget(context, "Something isn't right",
                  "Our apologies, it seems like we failed to assign you with a reliable personal doctor. You can try again to find a more suitable doctor.");
              FirebaseFirestore.instance.collection("logs").add({
                'name': userController.userModel.value!.name,
                'id': userController.userModel.value!.id,
                'contact': userController.userModel.value!.phone,
                'email': userController.userModel.value!.email,
                'message':
                    "You tried to request for a doctor and you were not assigned one.",
                'time': Timestamp.now()
              });
            } else {
              final name = _nurses.first.name.capitalize;
              final phone = _nurses.first.phone;
              final email = _nurses.first.email;
              final pic = _nurses.first.pic;
              userController.updateUserData({
                "assignednurse": _nurses.first.id,
              });
              var snaps = await FirebaseFirestore.instance
                  .collection('users')
                  .where('id', isEqualTo: _nurses.first.id)
                  .get();

              for (var doc in snaps.docs) {
                if (doc.data()['balance'] == null) {
                  await doc.reference.update({
                    "balance": 70000,
                  });
                } else {
                  await doc.reference.update({
                    "balance": doc.data()['balance'] + 70000,
                  });
                }
              }
              //to doctor
              sendEmail("${name!.capitalize}", email,
                  "We hope this email finds you well. \n\nWe would love to let you know that you have been assigned a new patient and there details are as follows: \n\nName: ${userController.userModel.value!.name.capitalize} \n\nContact: +${userController.userModel.value!.phone} \n\nCity: $city. \n\nYou have also recieved a fee of UGX. 70,000 from Bridge Mom App.");
              //to patient
              userController.sendEmail(
                  "${userController.userModel.value!.name.capitalize}",
                  userController.userModel.value!.email,
                  "We're happy to inform you that you've been matched with a doctor on Bridge Mom. Your doctor's name is ${name.capitalize} and they will be your primary point of contact for your care.\n\nWe've already sent ${name.capitalize} an introduction email with your contact information. They will be reaching out to you shortly to schedule your first appointment.\n\nIn the meantime, please feel free to contact ${name.capitalize} directly through the app if you have any questions or concerns.\n\nDoctor's Contact: $phone\n\nThank you for choosing Bridge Mom!",
                  "Doctor Request Recieved");
              var conversationId;
              if (userController.userModel.value!.id
                      .compareTo(_nurses.first.id) >
                  0) {
                conversationId =
                    '${userController.userModel.value!.id}-${_nurses.first.id}';
              } else {
                conversationId =
                    '${_nurses.first.id}-${userController.userModel.value!.id}';
              }

              MessagingController.instance.sendMessage(
                  "Hi ${userController.userModel.value!.name.capitalize}, I have been assigned to be your personal doctor. Feel free to tell me anything concerning your health.",
                  conversationId,
                  _nurses.first.id,
                  userController.userModel.value!.id);
              Get.offAll(() => SuccessPage(
                  name: "${name!.capitalize}", phone: phone, email: email));
            }
          } else {
            Get.back();
            bottomwidget(context, "Something wrong happened",
                "Sorry ${userController.userModel.value!.name.capitalize}, we were not able to get for you a doctor at the moment");
          }
        }
      });
    } else {
      Get.back();
    }
  }

  void bottomwidget(BuildContext context, String title, String details) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.8,
          color: Colors.white,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                  child: Image.asset(
                    "images/waiting.jpg",
                    width: MediaQuery.of(context).size.width * 0.65,
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 2),
                        child: Text(title,
                            style: GoogleFonts.poppins(
                                color: Colors.black.withOpacity(0.8),
                                fontSize: 16,
                                fontWeight: FontWeight.w500)),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 2),
                        child: LinearProgressIndicator(
                          backgroundColor: Color.fromARGB(255, 233, 233, 233),
                          color: Colors.blue,
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 2),
                        child: Text(details,
                            style: GoogleFonts.poppins(
                              color: Colors.black.withOpacity(0.4),
                              fontSize: 12,
                            )),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future sendEmail(
    String name,
    String email,
    String message,
  ) async {
    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    final response = await http.post(url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'service_id': "service_eu2ru4a",
          'template_id': "template_bb9fpne",
          'user_id': "XUOcEJp3cEew5NNai",
          'accessToken': "LyMrwY7O8bovubs4_ztTU",
          'template_params': {
            'subject': "Bridge Mom App",
            'to_name': name.capitalize,
            'app': "Bridge Mom App",
            'to_email': email,
            'reply_to': "bridgeai2023@gmail.com",
            'message': message,
          }
        }));
    print(response.statusCode);
    print(response.body);
    return response.statusCode;
  }
}

class Nurse {
  String name;
  String id;
  var clients;
  String phone;
  String email;
  String pic;
  Nurse({
    required this.name,
    required this.phone,
    required this.email,
    required this.id,
    required this.clients,
    required this.pic,
  });
}
