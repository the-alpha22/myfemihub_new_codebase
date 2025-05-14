import 'dart:math';

import 'package:bridge_ai/chatpage.dart';
import 'package:bridge_ai/constants/app_constants.dart';
import 'package:bridge_ai/constants/controllers.dart';
import 'package:bridge_ai/screens/home/appointments/connect.dart';
import 'package:bridge_ai/screens/home/subscribe/subscribe.dart';
import 'package:bridge_ai/screens/profile/address.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Select extends StatefulWidget {
  @override
  State<Select> createState() => _SelectState();
}

class _SelectState extends State<Select> {
  Random random = new Random();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Category',
            style: GoogleFonts.poppins(
              color: Colors.white.withOpacity(0.8),
              fontSize: 13,
            )),
        elevation: 0,
        backgroundColor: primaryColor,
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black.withOpacity(0.7),
              size: 18,
            )),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: primaryColor,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                          "You can either schedule an appointment with your assigned nurse or any other specialist. Its your choice to decide",
                          style: GoogleFonts.poppins(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 12,
                          )),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          Get.to(() => Connect(),
                              transition: Transition.rightToLeft);
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.43,
                          height: MediaQuery.of(context).size.width * 0.43,
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.asset(
                                        "images/connect.JPG",
                                        width:
                                            MediaQuery.of(context).size.width *
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
                                          child: Text("Book",
                                              style: GoogleFonts.expletusSans(
                                                  color: Colors.black
                                                      .withOpacity(0.8),
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500)),
                                        ),
                                        Text("one with a specialist",
                                            style: GoogleFonts.poppins(
                                              color:
                                                  Colors.black.withOpacity(0.6),
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
                          if (userController.userModel.value!.paid == false) {
                            Get.back();
                            Get.to(() => Subscribe(),
                                transition: Transition.rightToLeft);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'You have to first subscribe to our services to access this feature',
                                    style: GoogleFonts.poppins(
                                      color: Colors.white.withOpacity(0.6),
                                      fontSize: 12,
                                    )),
                              ),
                            );
                          } else {
                            if (userController.userModel.value!.assignednurse !=
                                    "" &&
                                userController.userModel.value!.assignednurse !=
                                    null) {
                              Get.to(
                                  () => ChatPage(
                                        id: userController
                                            .userModel.value!.assignednurse,
                                        name: 'your assigned nurse',
                                      ),
                                  transition: Transition.rightToLeft);
                            } else {
                              //if at all the client has not been assigned a nurse
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  duration: Duration(seconds: 6),
                                  content: Text(
                                      "Seems like you haven't been assigned a nurse. Request for a nurse in your profile section",
                                      style: GoogleFonts.poppins(
                                        color: Colors.white.withOpacity(0.6),
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
                          width: MediaQuery.of(context).size.width * 0.43,
                          height: MediaQuery.of(context).size.width * 0.43,
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.asset(
                                        "images/nurse.JPG",
                                        width:
                                            MediaQuery.of(context).size.width *
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
                                          child: Text("Book",
                                              style: GoogleFonts.expletusSans(
                                                  color: Colors.black
                                                      .withOpacity(0.8),
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500)),
                                        ),
                                        Text("one with your nurse",
                                            style: GoogleFonts.poppins(
                                              color:
                                                  Colors.black.withOpacity(0.6),
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
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
