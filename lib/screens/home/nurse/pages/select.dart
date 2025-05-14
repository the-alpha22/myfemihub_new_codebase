import 'dart:math';
import 'package:bridge_ai/constants/app_constants.dart';
import 'package:bridge_ai/screens/home/appointments/connect.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SelectNurse extends StatefulWidget {
  @override
  State<SelectNurse> createState() => _SelectNurseState();
}

class _SelectNurseState extends State<SelectNurse> {
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
              color: Colors.black.withOpacity(0.8),
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
                          "You can either schedule an appointment with your assigned patient or any other specialist. Its your choice to decide",
                          style: GoogleFonts.poppins(
                            color: Colors.black.withOpacity(0.6),
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
                                          child: Text("Schedule",
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
                          showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.8,
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
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .65,
                                          fit: BoxFit.fill,
                                          imageUrl:
                                              "https://firebasestorage.googleapis.com/v0/b/bridgeai-e6529.appspot.com/o/assets%2Fappointment.jpg?alt=media&token=76109642-685a-49e1-a508-d2717c0ead2d",
                                          placeholder: (context, url) => Center(
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  .65,
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    .65,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    .65,
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
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error),
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Container(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 2),
                                              child: Text(
                                                  "How to schedule one with a patient",
                                                  style: GoogleFonts.poppins(
                                                      color: Colors.black
                                                          .withOpacity(0.8),
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500)),
                                            ),
                                            SizedBox(height: 10),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 2),
                                              child: Text(
                                                  "To schedule an appointment with your patient, you go to your chat with the client and schedule from their by tapping the schedule icon at the top",
                                                  style: GoogleFonts.poppins(
                                                    color: Colors.black
                                                        .withOpacity(0.4),
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
                                        "images/me.JPG",
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
                                          child: Text("Schedule",
                                              style: GoogleFonts.expletusSans(
                                                  color: Colors.black
                                                      .withOpacity(0.8),
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500)),
                                        ),
                                        Text("one with your patient",
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
