import 'package:bridge_ai/constants/app_constants.dart';
import 'package:bridge_ai/constants/controllers.dart';
import 'package:bridge_ai/screens/browse/addmedication.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class MedicationsPage extends StatefulWidget {
  @override
  _MedicationsPageState createState() => _MedicationsPageState();
}

class _MedicationsPageState extends State<MedicationsPage> {
  List medications = userController.userModel.value!.medications;
  TextEditingController nameController = TextEditingController();
  TextEditingController medicineController = TextEditingController();
  TextEditingController medicineName = TextEditingController();
  TextEditingController medicationName = TextEditingController();
  TimeOfDay timeOfDay = TimeOfDay.now();
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  int frequency = 1;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Medications',
            style: GoogleFonts.poppins(
              color: Colors.black.withOpacity(0.8),
              fontSize: 12,
            )),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 19,
            color: Colors.black.withOpacity(0.6),
          ),
          onPressed: () {
            Get.back();
          },
        ),
        elevation: 0,
        backgroundColor: primaryColor,
      ),
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.9,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                if (userController.userModel.value!.medications.isEmpty ||
                    userController.userModel.value!.medications == null) ...{
                  InkWell(
                    onTap: () {},
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: SvgPicture.asset(
                                "images/prescription.svg",
                                width: MediaQuery.of(context).size.width,
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  child: Text(
                                      "Let's help you keep tabs on your medication prescriptions.\n\nAdd a medication by tapping the button below",
                                      style: GoogleFonts.poppins(
                                        color: Colors.black.withOpacity(0.6),
                                        fontSize: 13,
                                      )),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                },
                Obx(() => Column(
                      children: userController.userModel.value!.medications
                          .map(
                            (item) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  color: Color.fromARGB(255, 233, 233, 233),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Icon(Icons.history,
                                              color: Color.fromARGB(
                                                  255, 70, 140, 209)),
                                          Text(
                                              "${TimeOfDay.fromDateTime(item['time'].toDate()).format(context)}",
                                              style: GoogleFonts.poppins(
                                                color: Colors.black
                                                    .withOpacity(0.6),
                                                fontSize: 13,
                                              ))
                                        ],
                                      ),
                                      Divider(),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text(item['title'],
                                          style: GoogleFonts.poppins(
                                              color:
                                                  Colors.black.withOpacity(0.7),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600)),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(item['name'],
                                          style: GoogleFonts.poppins(
                                            color:
                                                Colors.black.withOpacity(0.6),
                                            fontSize: 14,
                                          )),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Text(item['prescription'],
                                          style: GoogleFonts.poppins(
                                            color:
                                                Colors.black.withOpacity(0.6),
                                            fontSize: 14,
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    )),
                userController.userModel.value!.medications.isNotEmpty &&
                        userController.userModel.value!.medications != null
                    ? ElevatedButton(
                        onPressed: () {
                          userController.updateUserData({"medications": []});
                          Get.back();
                          Fluttertoast.showToast(
                              msg: "Medications cleared",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.TOP,
                              timeInSecForIosWeb: 5,
                              backgroundColor: Colors.black.withOpacity(0.7),
                              textColor: Colors.white,
                              fontSize: 16.0);
                        },
                        child: Text('Clear Medications'),
                      )
                    : SizedBox(
                        height: 8,
                      )
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Get.to(() => AddMedication());
        },
      ),
    );
  }
}

class Medication {
  String medicationName;
  String medicineName;
  TimeOfDay timeOfIntake;
  int frequency; // in hours

  Medication({
    required this.medicationName,
    required this.medicineName,
    required this.timeOfIntake,
    required this.frequency,
  });
}
