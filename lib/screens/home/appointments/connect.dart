import 'dart:math';
import 'package:bridge_ai/constants/app_constants.dart';
import 'package:bridge_ai/controllers/specialists.dart';
import 'package:bridge_ai/models/user.dart';
import 'package:bridge_ai/screens/home/appointments/SpecialistPage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Connect extends StatefulWidget {
  @override
  State<Connect> createState() => _ConnectState();
}

class _ConnectState extends State<Connect> {
  Random random = new Random();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Connect',
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
                          "Book an appointment or send a message to any doctor or nurse or specialist you find",
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
                  child: StreamBuilder(
                    stream: SpecialistController.instance.getSpecialists(),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<UserModel>> snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: Text(
                            "Oops, nothing here",
                            style: GoogleFonts.poppins(
                              color: Colors.black54,
                              fontSize: 12,
                            ),
                          ),
                        );
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(
                            child: CircularProgressIndicator(
                          color: Colors.black,
                        ));
                      }
                      return Wrap(
                        children: snapshot.data!.map((UserModel user) {
                          return InkWell(
                            onTap: () {
                              Get.to(
                                  () => SpecialistPage(
                                        user: user,
                                      ),
                                  transition: Transition.rightToLeft);
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                child: Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ClipOval(
                                          child: user.pic == "" ||
                                                  user.pic == null
                                              ? Image.asset(
                                                  'images/profile.jpg',
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.09,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.09,
                                                )
                                              : CachedNetworkImage(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.09,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.09,
                                                  fit: BoxFit.fill,
                                                  imageUrl: user.pic,
                                                  placeholder: (context, url) =>
                                                      Center(
                                                    child: Container(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.09,
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.09,
                                                      child: Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                          color: Colors.black,
                                                          strokeWidth: 0,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          Icon(Icons.error),
                                                ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Container(
                                              child: Text(
                                                  "${user.name.capitalize}",
                                                  style: GoogleFonts.poppins(
                                                      color: Colors.black
                                                          .withOpacity(0.65),
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500)),
                                            ),
                                            Container(
                                              child: Text(
                                                  "${user.speciality.capitalize}",
                                                  style: GoogleFonts.poppins(
                                                      color: Colors.black
                                                          .withOpacity(0.4),
                                                      fontSize: 11,
                                                      fontWeight:
                                                          FontWeight.w400)),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Divider()
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    },
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
