import 'package:alarm/alarm.dart';
import 'package:bridge_ai/constants/app_constants.dart';
import 'package:bridge_ai/constants/controllers.dart';
import 'package:bridge_ai/widgets/helpers/showLoading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AddMedication extends StatefulWidget {
  const AddMedication({Key? key}) : super(key: key);

  @override
  State<AddMedication> createState() => _AddMedicationState();
}

class _AddMedicationState extends State<AddMedication> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  TextEditingController _title = TextEditingController();
  TextEditingController _name = TextEditingController();
  TextEditingController _prescription = TextEditingController();
  TextEditingController _time = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  late TimeOfDay? time;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Medication',
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: ListView(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 20,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // Add TextFormFields and ElevatedButton here.
                      Text("Medication Title",
                          style: GoogleFonts.poppins(
                            color: Colors.black.withOpacity(0.8),
                            fontSize: 12,
                          )),
                      SizedBox(
                        height: 8,
                      ),
                      Container(
                        color: Colors.white,
                        child: TextFormField(
                          controller: _title,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              hintText: 'eg. cough medication',
                              hintStyle: GoogleFonts.poppins(
                                  color: Colors.black.withOpacity(0.3),
                                  fontSize: 13),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none)),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'title required';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text("Medicine Name",
                          style: GoogleFonts.poppins(
                            color: Colors.black.withOpacity(0.8),
                            fontSize: 12,
                          )),
                      SizedBox(
                        height: 8,
                      ),
                      Container(
                        color: Colors.white,
                        child: TextFormField(
                          controller: _name,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              hintText: 'eg. cetrizine',
                              hintStyle: GoogleFonts.poppins(
                                  color: Colors.black.withOpacity(0.3),
                                  fontSize: 13),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none)),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'medicine name required';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text("Presciption",
                          style: GoogleFonts.poppins(
                            color: Colors.black.withOpacity(0.8),
                            fontSize: 12,
                          )),
                      SizedBox(
                        height: 8,
                      ),
                      Container(
                        color: Colors.white,
                        child: TextFormField(
                          controller: _prescription,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              hintText: 'eg. 1 x 2',
                              hintStyle: GoogleFonts.poppins(
                                  color: Colors.black.withOpacity(0.3),
                                  fontSize: 13),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none)),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'prescription required';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text("Time of Reminder",
                          style: GoogleFonts.poppins(
                            color: Colors.black.withOpacity(0.8),
                            fontSize: 12,
                          )),
                      SizedBox(
                        height: 8,
                      ),
                      Container(
                        color: Colors.white,
                        child: TextFormField(
                          onTap: () async {
                            time = await showTimePicker(
                                context: context, initialTime: TimeOfDay.now());
                            if (time != null) {
                              _time.text = "${time!.hour} : ${time!.minute}";
                            }
                          },
                          controller: _time,
                          keyboardType: TextInputType.none,
                          readOnly: true,
                          decoration: InputDecoration(
                              hintText: 'eg. 10:30am',
                              hintStyle: GoogleFonts.poppins(
                                  color: Colors.black.withOpacity(0.3),
                                  fontSize: 13),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none)),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'time required';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              textStyle: GoogleFonts.poppins(
                                  color: Colors.white, fontSize: 13),),
                          onPressed: () async {
                            // Validate returns true if the form is valid, or false otherwise.
                            if (_formKey.currentState!.validate()) {
                              showLoading(context);
                              final title = _title.text.trim();
                              final name = _name.text.trim();
                              final prescription = _prescription.text.trim();
                              DateTime now = DateTime.now();
                              var dateTime = DateTime(now.year, now.month,
                                  now.day, time!.hour, time!.minute);
                              userController.updateUserData({
                                "medications": FieldValue.arrayUnion([
                                  {
                                    "title": title,
                                    "name": name,
                                    "prescription": prescription,
                                    "time": Timestamp.fromDate(dateTime),
                                  }
                                ])
                              });
                              // final alarmSettings = AlarmSettings(
                              //   id: 42,
                              //   dateTime: dateTime,
                              //   assetAudioPath: 'images/Reminder.mp3',
                              //   loopAudio: true,
                              //   vibrate: true,
                              //   fadeDuration: 3.0,
                              //   notificationTitle:
                              //       "${title.capitalize} Reminder",
                              //   notificationBody: "$name",
                              //   enableNotificationOnKill: true,
                              // );
                              // await Alarm.set(alarmSettings: alarmSettings);
                              dismissLoadingWidget();
                              Fluttertoast.showToast(
                                  msg: "Medication Added",
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.TOP,
                                  timeInSecForIosWeb: 5,
                                  backgroundColor:
                                      Colors.black.withOpacity(0.7),
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                              Get.back();
                              Get.back();
                            }
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.95,
                            margin: EdgeInsets.all(15.0),
                            padding: EdgeInsets.all(3.0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                                child: Text(
                              "Submit",
                              style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500),
                            )),
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
