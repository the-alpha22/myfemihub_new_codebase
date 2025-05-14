import 'dart:convert';
import 'dart:math';

import 'package:bridge_ai/constants/controllers.dart';
import 'package:bridge_ai/controllers/messagingController.dart';
import 'package:bridge_ai/models/message.dart';
import 'package:bridge_ai/screens/home/videocall/videocallScreen.dart';
import 'package:bridge_ai/widgets/helpers/showLoading.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key, required this.id, required this.name})
      : super(key: key);
  final String id;
  final String name;

  @override
  State<ChatPage> createState() => _ChatPage();
}

class _ChatPage extends State<ChatPage> {
  TextEditingController _name = TextEditingController();

  TextEditingController _issue = TextEditingController();

  TextEditingController _content = TextEditingController();

  String conversationId = "";
  List<QueryDocumentSnapshot> listMessage = [];

  final Random random = new Random();
  String location = "";
  late TimeOfDay? time;

  @override
  void initState() {
    super.initState();
    initialCheck();
  }

  void _submit() {
    // you can write your
    // own code according to
    // whatever you want to submit;
    _name.clear();
    _issue.clear();
  }

  void onSendMessage(String content) {
    if (content.trim().isNotEmpty) {
      MessagingController.instance.sendMessage(content, conversationId,
          userController.userModel.value!.id, widget.id);
      _content.clear();
    } else {
      Fluttertoast.showToast(
        msg: 'Nothing to send',
      );
    }
  }

  void initialCheck() {
    if (userController.userModel.value!.id.compareTo(widget.id) > 0) {
      conversationId = '${userController.userModel.value!.id}-${widget.id}';
      userController.channelid.text = conversationId;
    } else {
      conversationId = '${widget.id}-${userController.userModel.value!.id}';
      userController.channelid.text = conversationId;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 224, 241, 255),
        iconTheme: IconThemeData(color: Colors.black),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 18,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        actions: [
          IconButton(
              onPressed: () {
                var conversationId;
                if (userController.userModel.value!.id != widget.id) {
                  if (userController.userModel.value!.id.compareTo(widget.id) >
                      0) {
                    conversationId =
                        '${userController.userModel.value!.id}-${widget.id}';
                  } else {
                    conversationId =
                        '${widget.id}-${userController.userModel.value!.id}';
                  }
                  FirebaseFirestore.instance.collection("logs").add({
                    'name': userController.userModel.value!.name,
                    'id': userController.userModel.value!.id,
                    'contact': userController.userModel.value!.phone,
                    'email': userController.userModel.value!.email,
                    'message':
                        "You tried to initiate a video call with ${widget.name.capitalize}.",
                    'time': Timestamp.now()
                  });
                  // SendSms().sendSms("$phone",
                  //     "${userController.userModel.value.name.capitalize}+is+trying+to+initiate+a+video+call+with+you...+Contact:+${userController.userModel.value.phone}.++Message+from+BridgeAI++Obtek");
                  // Get.to(() => VideoScreen(
                  //       callId: conversationId,
                  //     ));
                }
              },
              icon: Icon(Icons.video_call)),
          IconButton(
              onPressed: () {
                if (userController.userModel.value!.nurse == true) {
                  BookAppointment(context);
                } else {
                  if (userController.userModel.value!.tokens == 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            "It seems like you don't have enough appointment tokens",
                            style: GoogleFonts.poppins(
                              color: Colors.white.withOpacity(0.6),
                              fontSize: 12,
                            )),
                      ),
                    );
                  } else {
                    BookAppointment(context);
                  }
                }
              },
              icon: Icon(Icons.calendar_today))
        ],
        title: Text("${widget.name.capitalize}",
            style: GoogleFonts.poppins(
                color: Colors.black87.withOpacity(0.5), fontSize: 13)),
        elevation: 0,
      ),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text("You are currently chatting with ${widget.name}",
                      style: GoogleFonts.poppins(
                        color: Colors.black.withOpacity(0.4),
                        fontSize: 13,
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  buildListMessage(),

                  // Input content
                  buildInput(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> BookAppointment(BuildContext context) {
    return showModalBottomSheet(
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
                  child: CachedNetworkImage(
                    width: MediaQuery.of(context).size.width * 0.65,
                    fit: BoxFit.fill,
                    imageUrl:
                        "https://firebasestorage.googleapis.com/v0/b/bridgeai-e6529.appspot.com/o/assets%2Fappointment.jpg?alt=media&token=76109642-685a-49e1-a508-d2717c0ead2d",
                    placeholder: (context, url) => Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.65,
                          height: MediaQuery.of(context).size.width * 0.65,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Colors.black,
                              strokeWidth: 0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
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
                        child: Text("Select Appointment Type",
                            style: GoogleFonts.poppins(
                                color: Colors.black.withOpacity(0.8),
                                fontSize: 16,
                                fontWeight: FontWeight.w500)),
                      ),
                      SizedBox(height: 10),
                      Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 2),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                  height: 60,
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  child: TextButton(
                                    onPressed: () async {
                                      setState(() {
                                        location = "online";
                                      });
                                      time = await showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.now());
                                      if (time != null) {
                                        _selectDate();
                                      }
                                    },
                                    child: Text("Online",
                                        style: GoogleFonts.poppins(
                                            color:
                                                Colors.black.withOpacity(0.55),
                                            fontSize: 13)),
                                    style: ButtonStyle(
                                        shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)),
                                                side: BorderSide(
                                                    color: Colors.black
                                                        .withOpacity(0.55))))),
                                  )),
                              SizedBox(
                                  height: 60,
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  child: TextButton(
                                    onPressed: () async {
                                      setState(() {
                                        location = "clinic";
                                      });
                                      time = await showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.now());
                                      if (time != null) {
                                        _selectDate();
                                      }
                                    },
                                    child: Text("At Clinic",
                                        style: GoogleFonts.poppins(
                                            color:
                                                Colors.black.withOpacity(0.55),
                                            fontSize: 13)),
                                    style: ButtonStyle(
                                        shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)),
                                                side: BorderSide(
                                                    color: Colors.black
                                                        .withOpacity(0.55))))),
                                  ))
                            ],
                          )),
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

  Widget buildInput() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        child: Row(
          children: <Widget>[
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: SingleChildScrollView(
                    child: TextField(
                      style: GoogleFonts.poppins(
                        color: Colors.black.withOpacity(0.4),
                        fontSize: 13,
                      ),
                      controller: _content,
                      maxLines: null,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          hintText: 'Type message',
                          hintStyle: GoogleFonts.poppins(
                            color: Colors.black.withOpacity(0.4),
                            fontSize: 12,
                          )),
                    ),
                  ),
                ),
              ),
            ),
            // Button send message
            SizedBox(
              width: 2,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                color: Color.fromARGB(255, 0, 150, 255),
                child: IconButton(
                  icon: Icon(
                    Icons.send,
                    color: Colors.white,
                  ),
                  onPressed: () => onSendMessage(_content.text),
                  color: Colors.black.withOpacity(0.7),
                ),
              ),
            ),
            SizedBox(
              width: 8,
            ),
          ],
        ),
        width: double.infinity,
        decoration: BoxDecoration(color: Colors.white),
      ),
    );
  }

  Widget buildListMessage() {
    return Flexible(
      child: conversationId.isNotEmpty
          ? StreamBuilder(
              stream: MessagingController.instance.getMessages(conversationId),
              builder: (BuildContext context,
                  AsyncSnapshot<List<MessageChat>> snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.length > 0) {
                    return ListView(
                      padding: EdgeInsets.all(10),
                      children: snapshot.data!.map((MessageChat message) {
                        if (message.idfrom ==
                            userController.userModel.value!.id) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.25,
                                ),
                                Flexible(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      color: Color.fromARGB(255, 233, 233, 233),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(message.content,
                                          softWrap: true,
                                          style: GoogleFonts.poppins(
                                            color:
                                                Colors.black.withOpacity(0.6),
                                            fontSize: 13,
                                          )),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        } else {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      color: Color.fromARGB(255, 124, 210, 250),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(message.content,
                                          style: GoogleFonts.poppins(
                                            color:
                                                Colors.black.withOpacity(0.6),
                                            fontSize: 13,
                                          )),
                                    ),
                                  ),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.25,
                                ),
                              ],
                            ),
                          );
                        }
                      }).toList(),
                    );
                  } else {
                    return Center(child: Text("No message here yet..."));
                  }
                } else {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Colors.black,
                      strokeWidth: 0,
                    ),
                  );
                }
              },
            )
          : Center(
              child: CircularProgressIndicator(
                color: Colors.black,
                strokeWidth: 0,
              ),
            ),
    );
  }

  void _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2026),
    );

    if (pickedDate != null) {
      showLoading(context);
      var email;
      var dateTime =
          DateTime(pickedDate.year, pickedDate.month, time!.hour, time!.minute);
      setState(() async {
        userController.updateUserData({
          "appointments": FieldValue.arrayUnion([Timestamp.fromDate(dateTime)])
        });
        var snaps = await FirebaseFirestore.instance
            .collection('users')
            .where('id', isEqualTo: widget.id)
            .get();

        for (var doc in snaps.docs) {
          await doc.reference.update({
            "appointments": FieldValue.arrayUnion([dateTime]),
          });
          setState(() {
            email = doc.data()['email'];
          });
        }
        final idNumb = random.nextInt(100000).toString();
        final idnumb = "Appointment-$idNumb$idNumb";
        Map<String, dynamic> data = {
          "id": idnumb,
          "location": location,
          "contact": userController.userModel.value!.phone,
          "name": userController.userModel.value!.name,
          "email": userController.userModel.value!.email,
          "date": Timestamp.fromDate(dateTime),
          "time": Timestamp.fromDate(dateTime),
          "userid": userController.userModel.value!.id,
          "assignednurse": widget.id,
          "partyid": widget.id,
        };
        FirebaseFirestore.instance.collection("appointments").add(data);

        dismissLoadingWidget();
        Get.back();
        sendEmail(
            "${userController.userModel.value!.name.capitalize}",
            userController.userModel.value!.email,
            "We are delighted to inform you that your appointment with ${widget.name.capitalize} has been successfully scheduled through the Bridge Mom app. We look forward to providing you with exceptional care during your upcoming visit.\n\nAppointment Details:\n\nHealthcare Professional: ${widget.name.capitalize}\n\nDate: ${dateTime.day} - ${dateTime.month} - ${dateTime.year}\n\nTime: ${dateTime.hour} : ${dateTime.minute}\n\nLocation: $location\n\nPlease ensure that you arrive at least 10 minutes prior to your scheduled appointment time to allow for check-in and any necessary paperwork. If you need to reschedule or cancel your appointment, you can do so conveniently through the Bridge Mom app.\n\nShould you have any questions or require further assistance, please do not hesitate to contact us directly using the details provided below. We are here to ensure that your experience with Bridge Mom is seamless and satisfactory.\n\nThank you for choosing Bridge Mom for your healthcare needs. We are committed to providing you with the highest standard of care and convenience throughout your pregnancy journey.");
        sendEmail("${widget.name.capitalize}", email,
            "We are delighted to inform you that an appointment was scheduled by ${userController.userModel.value!.name.capitalize} through the Bridge Mom app. We hope you can make but if you can't you can always reschedule.\n\nAppointment Details:\n\nPerson: ${userController.userModel.value!.name.capitalize}\n\nDate: ${dateTime.day} - ${dateTime.month} - ${dateTime.year}\n\nTime: ${dateTime.hour} : ${dateTime.minute}\n\nLocation: $location\n\nPlease ensure that you arrive at least 10 minutes prior to the scheduled appointment time if possible. If you need to reschedule or cancel your appointment, you can do so conveniently through the Bridge Mom app.\n\nShould you have any questions or require further assistance, please do not hesitate to contact us directly using the details provided below. We are here to ensure that your experience with Bridge Mom is seamless and satisfactory.\n\nThank you for choosing Bridge Mom for your healthcare needs. We are glad and grateful to be working with you.");

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
                      child: CachedNetworkImage(
                        width: MediaQuery.of(context).size.width * 0.65,
                        fit: BoxFit.fill,
                        imageUrl:
                            "https://firebasestorage.googleapis.com/v0/b/bridgeai-e6529.appspot.com/o/assets%2Fappointment.jpg?alt=media&token=76109642-685a-49e1-a508-d2717c0ead2d",
                        placeholder: (context, url) => Center(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.65,
                              height: MediaQuery.of(context).size.width * 0.65,
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: Colors.black,
                                  strokeWidth: 0,
                                ),
                              ),
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
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
                            child: Text("Appointment Successfully Scheduled",
                                style: GoogleFonts.poppins(
                                    color: Colors.black.withOpacity(0.8),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500)),
                          ),
                          SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 2),
                            child: Text(
                                "Your appointment has been placed successfully and you will recieve a confirmation email. In case of schedule change, please remember to notify the parties concerned.",
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
      });
    }
  }

  void sendEmail(String name, String email, String content) async {
    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    final response = await http.post(url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'service_id': "service_hhthruv",
          'template_id': "template_7qe3535",
          'user_id': "XUOcEJp3cEew5NNai",
          'accessToken': "LyMrwY7O8bovubs4_ztTU",
          'template_params': {
            'to_name': name,
            'to_email': email,
            'message': content
          }
        }));
    return print("${response.statusCode}");
  }
}
