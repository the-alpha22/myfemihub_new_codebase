import 'package:bridge_ai/bottomnav.dart';
import 'package:bridge_ai/constants/app_constants.dart';
import 'package:bridge_ai/constants/controllers.dart';
import 'package:bridge_ai/screens/home/appointments/connect.dart';
import 'package:bridge_ai/screens/home/nurse/pages/medicalrecords.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class NurseDashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            "${userController.userModel.value!.name.capitalize}'s Dashboard",
            style: GoogleFonts.poppins(
              color: Colors.black.withOpacity(0.9),
              fontWeight: FontWeight.w600,
              fontSize: 15,
            )),
        elevation: 0,
        backgroundColor: primaryColor,
      ),
      backgroundColor: Color.fromARGB(255, 245, 245, 245),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          // Padding(
          //   padding: const EdgeInsets.symmetric(vertical: 12.0),
          //   child: Text(
          //     'Upcoming Appointments',
          //     style: GoogleFonts.montserrat(
          //         color: Colors.black.withOpacity(0.7),
          //         fontWeight: FontWeight.w600,
          //         fontSize: 14),
          //     textAlign: TextAlign.left,
          //   ),
          // ),
          // Container(
          //   width: MediaQuery.of(context).size.width * 0.95,
          //   decoration: BoxDecoration(
          //       borderRadius: BorderRadius.all(Radius.circular(10)),
          //       color: Colors.white,
          //       boxShadow: [
          //         BoxShadow(color: Colors.grey.withOpacity(.25), blurRadius: 16)
          //       ]),
          //   child: Padding(
          //     padding: const EdgeInsets.all(12.0),
          //     child: Column(
          //       children: [
          //         ClipRRect(
          //           borderRadius: BorderRadius.circular(10),
          //           child: Container(
          //             height: MediaQuery.of(context).size.width * 0.2,
          //             width: MediaQuery.of(context).size.width * 0.9,
          //             color: Color.fromARGB(255, 245, 245, 245),
          //             child: Column(
          //               mainAxisAlignment: MainAxisAlignment.center,
          //               crossAxisAlignment: CrossAxisAlignment.start,
          //               children: [
          //                 Padding(
          //                   padding: const EdgeInsets.symmetric(
          //                       horizontal: 12, vertical: 5),
          //                   child: Row(
          //                     children: [
          //                       Checkbox(
          //                           value: false, onChanged: (newValue) {}),
          //                       Column(
          //                         crossAxisAlignment: CrossAxisAlignment.start,
          //                         children: [
          //                           Text(
          //                             "Appointment with Baker",
          //                             style: GoogleFonts.montserrat(
          //                                 color: Colors.black,
          //                                 fontWeight: FontWeight.w400,
          //                                 fontSize: 14),
          //                             textAlign: TextAlign.left,
          //                           ),
          //                           Text(
          //                             "04 July, 2023",
          //                             style: GoogleFonts.montserrat(
          //                                 color: Color.fromARGB(
          //                                     255, 144, 202, 249),
          //                                 fontWeight: FontWeight.w400,
          //                                 fontSize: 12),
          //                             textAlign: TextAlign.left,
          //                           ),
          //                         ],
          //                       ),
          //                     ],
          //                   ),
          //                 ),
          //               ],
          //             ),
          //           ),
          //         ),
          //         SizedBox(
          //           height: 10,
          //         ),
          //         ClipRRect(
          //           borderRadius: BorderRadius.circular(10),
          //           child: Container(
          //             height: MediaQuery.of(context).size.width * 0.2,
          //             width: MediaQuery.of(context).size.width * 0.9,
          //             color: Color.fromARGB(255, 245, 245, 245),
          //             child: Column(
          //               mainAxisAlignment: MainAxisAlignment.center,
          //               crossAxisAlignment: CrossAxisAlignment.start,
          //               children: [
          //                 Padding(
          //                   padding: const EdgeInsets.symmetric(
          //                       horizontal: 12, vertical: 5),
          //                   child: Row(
          //                     children: [
          //                       Checkbox(
          //                           value: false, onChanged: (newValue) {}),
          //                       Column(
          //                         crossAxisAlignment: CrossAxisAlignment.start,
          //                         children: [
          //                           Text(
          //                             "Appointment with Barbie",
          //                             style: GoogleFonts.montserrat(
          //                                 color: Colors.black,
          //                                 fontWeight: FontWeight.w400,
          //                                 fontSize: 14),
          //                             textAlign: TextAlign.left,
          //                           ),
          //                           Text(
          //                             "04 July, 2023",
          //                             style: GoogleFonts.montserrat(
          //                                 color: Color.fromARGB(
          //                                     255, 144, 202, 249),
          //                                 fontWeight: FontWeight.w400,
          //                                 fontSize: 12),
          //                             textAlign: TextAlign.left,
          //                           ),
          //                         ],
          //                       ),
          //                     ],
          //                   ),
          //                 ),
          //               ],
          //             ),
          //           ),
          //         ),
          //         Divider(
          //           color: Colors.black.withOpacity(0.3),
          //         ),
          //         ClipRRect(
          //           borderRadius: BorderRadius.circular(10),
          //           child: Container(
          //             child: TextButton(
          //               onPressed: () {
          //                 // Get.to(() => Tasks());
          //               },
          //               child: Text(
          //                 "Go to Appointments",
          //                 style: GoogleFonts.montserrat(
          //                     color: Color.fromARGB(255, 123, 168, 247),
          //                     fontWeight: FontWeight.w600,
          //                     fontSize: 14),
          //                 textAlign: TextAlign.center,
          //               ),
          //             ),
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  Get.to(() => MedicalRecords(),
                      transition: Transition.rightToLeft);
                },
                child: Container(
                  height: MediaQuery.of(context).size.width * 0.45,
                  width: MediaQuery.of(context).size.width * 0.45,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(.25), blurRadius: 16)
                      ]),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.receipt),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 5),
                          child: Text(
                            "Medical Records",
                            style: GoogleFonts.montserrat(
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                                fontSize: 14),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Get.to(() => Connect(), transition: Transition.rightToLeft);
                },
                child: Container(
                  height: MediaQuery.of(context).size.width * 0.45,
                  width: MediaQuery.of(context).size.width * 0.45,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(.25), blurRadius: 16)
                      ]),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.group),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 5),
                          child: Text(
                            "Collaborate",
                            style: GoogleFonts.montserrat(
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                                fontSize: 14),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          InkWell(
            onTap: () {},
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(.25), blurRadius: 16)
                  ]),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Together, we heal.",
                        style: GoogleFonts.poppins(
                            color: Color.fromARGB(255, 125, 225, 255),
                            fontSize: 14,
                            fontWeight: FontWeight.w500)),
                    SizedBox(
                      height: 10,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        "images/doctors.jpg",
                        width: MediaQuery.of(context).size.width,
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Text("Empowering and connecting doctors",
                              style: GoogleFonts.poppins(
                                  color: Colors.black.withOpacity(0.8),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          ListTile(
            leading: Text("Switch to Patient's Section",
                style: GoogleFonts.poppins(
                  color: Colors.black.withOpacity(0.8),
                  fontSize: 14,
                )),
            onTap: () {
              Get.offAllNamed("/home");
            },
          ),
          SizedBox(height: 20),
          Center(
            child: InkWell(
              onTap: () {
                userController.signOut();
              },
              child: Text('Log Out',
                  style: GoogleFonts.poppins(
                    color: Colors.red.withOpacity(0.8),
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
