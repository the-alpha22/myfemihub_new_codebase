import 'package:bridge_ai/bottomnav.dart';
import 'package:bridge_ai/chatpage.dart';
import 'package:bridge_ai/constants/app_constants.dart';
import 'package:bridge_ai/constants/controllers.dart';
import 'package:bridge_ai/screens/home/appointments/connect.dart';
import 'package:bridge_ai/screens/home/bri.dart';
import 'package:bridge_ai/screens/home/subscribe/subscribe.dart';
import 'package:bridge_ai/screens/home/userAppointments.dart';
import 'package:bridge_ai/screens/profile/address.dart';
import 'package:bridge_ai/screens/profile/profile.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';

class BrowseScreen extends StatefulWidget {
  const BrowseScreen({Key? key});

  @override
  State<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 245, 245, 245),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primaryColor,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                color: primaryColor,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("bridge_ai Essentials",
                          style: GoogleFonts.expletusSans(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 25,
                              fontWeight: FontWeight.w600)),
                      Container()
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 24,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.person,
                          size: 16,
                          color: Colors.black87,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text("Personal Details",
                            style: GoogleFonts.expletusSans(
                                color: primaryColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    InkWell(
                      onTap: () {
                        Get.to(
                            () => ProfileScreen(
                                  title: 'Home',
                                ),
                            transition: Transition.rightToLeft);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Your Profile",
                                style: GoogleFonts.poppins(
                                    color: Colors.black87,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500)),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 14,
                              color: Colors.black87,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    // InkWell(
                    //   onTap: (){},
                    //   child: Padding(
                    //     padding: const EdgeInsets.symmetric(vertical: 5),
                    //     child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //       children: [
                    //         Text("Secure Pass",
                    //             style: GoogleFonts.poppins(
                    //                 color: Colors.black87,
                    //                 fontSize: 14,
                    //                 fontWeight: FontWeight.w500)),
                    //         Icon(
                    //           Icons.arrow_forward_ios,
                    //           size: 14,
                    //           color: Colors.black87,
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    // SizedBox(
                    //   height: 10,
                    // ),
                  ],
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.all(16.0),
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Row(
              //         children: [
              //           Icon(
              //             Icons.notifications,
              //             size: 16,
              //             color: Colors.black87,
              //           ),
              //           SizedBox(
              //             width: 10,
              //           ),
              //           Text("Reminders",
              //               style: GoogleFonts.expletusSans(
              //                   color: primaryColor,
              //                   fontSize: 16,
              //                   fontWeight: FontWeight.w600)),
              //         ],
              //       ),
              //       SizedBox(
              //         height: 12,
              //       ),
              //       Padding(
              //         padding: const EdgeInsets.symmetric(vertical: 5),
              //         child: Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //           children: [
              //             Text("Cycle Reminders",
              //                 style: GoogleFonts.poppins(
              //                     color: Colors.black87,
              //                     fontSize: 14,
              //                     fontWeight: FontWeight.w500)),
              //             Icon(
              //               Icons.arrow_forward_ios,
              //               size: 14,
              //               color: Colors.black87,
              //             ),
              //           ],
              //         ),
              //       ),
              //       SizedBox(
              //         height: 10,
              //       ),
              //       Padding(
              //         padding: const EdgeInsets.symmetric(vertical: 5),
              //         child: Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //           children: [
              //             Text("Medicine Reminders",
              //                 style: GoogleFonts.poppins(
              //                     color: Colors.black87,
              //                     fontSize: 14,
              //                     fontWeight: FontWeight.w500)),
              //             Icon(
              //               Icons.arrow_forward_ios,
              //               size: 14,
              //               color: Colors.black87,
              //             ),
              //           ],
              //         ),
              //       ),
              //       SizedBox(
              //         height: 10,
              //       ),
              //       Padding(
              //         padding: const EdgeInsets.symmetric(vertical: 5),
              //         child: Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //           children: [
              //             Text("Daily Tips Reminders",
              //                 style: GoogleFonts.poppins(
              //                     color: Colors.black87,
              //                     fontSize: 14,
              //                     fontWeight: FontWeight.w500)),
              //             Icon(
              //               Icons.arrow_forward_ios,
              //               size: 14,
              //               color: Colors.black87,
              //             ),
              //           ],
              //         ),
              //       ),
              //     ],
              //   ),
              // ),

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.more_horiz,
                          size: 16,
                          color: Colors.black87,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text("More",
                            style: GoogleFonts.expletusSans(
                                color: primaryColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    InkWell(
                      onTap: () {
                        Share.share('https://femihub.com', subject: 'Femihub');
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Share My App",
                                style: GoogleFonts.poppins(
                                    color: Colors.black87,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500)),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 14,
                              color: Colors.black87,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: () {
                        openMail("info@femihub.com");
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Help and Feedback",
                                style: GoogleFonts.poppins(
                                    color: Colors.black87,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500)),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 14,
                              color: Colors.black87,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: () {
                        openLink(
                            "https://play.google.com/store/apps/details?id=obtek.technologies.bridge_ai");
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Rate App",
                                style: GoogleFonts.poppins(
                                    color: Colors.black87,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500)),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 14,
                              color: Colors.black87,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
              userController.userModel.value!.paid
                  ? Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () {
                                  Get.to(() => ChatBotScreen(),
                                      transition: Transition.rightToLeft);
                                },
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.43,
                                  height:
                                      MediaQuery.of(context).size.width * 0.43,
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(4)),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.grey.withOpacity(.1),
                                            blurRadius: 2)
                                      ]),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(),
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: Image.asset(
                                                "images/chatbot.jpg",
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.15,
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.25,
                                                  child: Text("Chat",
                                                      style: GoogleFonts
                                                          .expletusSans(
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.8),
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500)),
                                                ),
                                                Text("with Bri",
                                                    style: GoogleFonts.poppins(
                                                      color: Colors.black
                                                          .withOpacity(0.6),
                                                      fontSize: 12,
                                                    )),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  //if at all the client has not yet paid for any subscription
                                  if (userController.userModel.value!.paid ==
                                      false) {
                                    Get.back();
                                    Get.to(() => Subscribe(),
                                        transition: Transition.rightToLeft);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            'You have to first subscribe to our services to access this feature',
                                            style: GoogleFonts.poppins(
                                              color:
                                                  Colors.white.withOpacity(0.6),
                                              fontSize: 12,
                                            )),
                                      ),
                                    );
                                  } else {
                                    if (userController.userModel.value!
                                                .assignednurse !=
                                            "" &&
                                        userController.userModel.value!
                                                .assignednurse !=
                                            null) {
                                      Get.to(
                                          () => ChatPage(
                                                id: userController.userModel
                                                    .value!.assignednurse,
                                                name: 'your assigned nurse',
                                              ),
                                          transition: Transition.rightToLeft);
                                    } else {
                                      //if at all the client has not been assigned a nurse
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          duration: Duration(seconds: 6),
                                          content: Text(
                                              "Seems like you haven't been assigned a nurse. Request for a nurse in your profile section",
                                              style: GoogleFonts.poppins(
                                                color: Colors.white
                                                    .withOpacity(0.6),
                                                fontSize: 12,
                                              )),
                                        ),
                                      );
                                      Get.to(() => AddressDetails(),
                                          transition: Transition.rightToLeft);
                                    }
                                  }
                                },
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.43,
                                  height:
                                      MediaQuery.of(context).size.width * 0.43,
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(4)),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.grey.withOpacity(.1),
                                            blurRadius: 2)
                                      ]),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(),
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: Image.asset(
                                                "images/nurse.JPG",
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.15,
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.25,
                                                  child: Text("Contact",
                                                      style: GoogleFonts
                                                          .expletusSans(
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.8),
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500)),
                                                ),
                                                Text("your nurse",
                                                    style: GoogleFonts.poppins(
                                                      color: Colors.black
                                                          .withOpacity(0.6),
                                                      fontSize: 12,
                                                    )),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () {
                                  Get.to(() => Connect(),
                                      transition: Transition.rightToLeft);
                                },
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.43,
                                  height:
                                      MediaQuery.of(context).size.width * 0.43,
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(4)),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.grey.withOpacity(.1),
                                            blurRadius: 2)
                                      ]),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(),
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: Image.asset(
                                                "images/connect.JPG",
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.15,
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.25,
                                                  child: Text("Connect",
                                                      style: GoogleFonts
                                                          .expletusSans(
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.8),
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500)),
                                                ),
                                                Text("with a specialist",
                                                    style: GoogleFonts.poppins(
                                                      color: Colors.black
                                                          .withOpacity(0.6),
                                                      fontSize: 12,
                                                    )),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Get.to(() => ScheduledAppointmentsPage(),
                                      transition: Transition.rightToLeft);
                                },
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.43,
                                  height:
                                      MediaQuery.of(context).size.width * 0.43,
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(4)),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.grey.withOpacity(.1),
                                            blurRadius: 2)
                                      ]),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(),
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: CachedNetworkImage(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    .15,
                                                fit: BoxFit.fill,
                                                imageUrl:
                                                    "https://firebasestorage.googleapis.com/v0/b/bridgeai-e6529.appspot.com/o/assets%2Fappointment.jpg?alt=media&token=76109642-685a-49e1-a508-d2717c0ead2d",
                                                placeholder: (context, url) =>
                                                    Center(
                                                  child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            .15,
                                                    child: Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              .15,
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              .15,
                                                      child: Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                          color: Colors.black,
                                                          strokeWidth: 0,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Icon(Icons.error),
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.25,
                                                  child: Text("Schedule",
                                                      style: GoogleFonts
                                                          .expletusSans(
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.8),
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500)),
                                                ),
                                                Text("an appointment",
                                                    style: GoogleFonts.poppins(
                                                      color: Colors.black
                                                          .withOpacity(0.6),
                                                      fontSize: 12,
                                                    )),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  : Padding(
                      padding: EdgeInsets.all(12),
                      child: Container(
                        child: Column(
                          children: [
                            InkWell(
                              onTap: () {
                                Get.to(() => Subscribe());
                              },
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.3,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: primaryColor.withOpacity(0.5),
                                    image: DecorationImage(
                                        image: AssetImage("images/premium.png"),
                                        fit: BoxFit.cover)),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text("Your Wellness Deserves More",
                                            style: GoogleFonts.poppins(
                                                color: primaryColor
                                                    .withOpacity(0.8),
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600)),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text("Try bridge_ai Premium",
                                            style: GoogleFonts.expletusSans(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500)),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                            "We connect you to any service you need for your wellness",
                                            style: GoogleFonts.poppins(
                                                color: Colors.white,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500)),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      )),
              SizedBox(
                height: 12,
              ),
              Center(
                child: InkWell(
                  onTap: () {
                    userController.signOut();
                  },
                  child: Text('Log Out',
                      style: GoogleFonts.poppins(
                        color: Colors.red.withOpacity(0.8),
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      )),
                ),
              ),
              SizedBox(
                height: 12,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNav(),
    );
  }
}
