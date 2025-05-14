import 'package:bridge_ai/constants/app_constants.dart';
import 'package:bridge_ai/screens/authentication/first3.dart';
import 'package:bridge_ai/screens/authentication/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Firstt extends StatefulWidget {
  @override
  State<Firstt> createState() => _FirsttState();
}

class _FirsttState extends State<Firstt> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Tracking",
                          style: GoogleFonts.poppins(
                              color: Colors.black87.withOpacity(0.9),
                              fontWeight: FontWeight.w500,
                              fontSize: 30),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          " Tools",
                          style: GoogleFonts.poppins(
                              color: primaryColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 30),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 49,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: SvgPicture.asset(
                      "images/2.svg",
                      width: MediaQuery.of(context).size.width * 0.7,
                    ),
                  ),
                  SizedBox(
                    height: 49,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Center(
                      child: Text(
                        "The app will provide tracking tools to help users monitor their pregnancy and postpartum progress, including due date tracking, period tracking, and medical report keeping.",
                        style: GoogleFonts.poppins(
                            color: Colors.black87.withOpacity(0.4),
                            fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                    )),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Center(
                      child: SizedBox(
                          height: 60,
                          width: MediaQuery.of(context).size.width * 0.95,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Get.to(() => Login(),
                                      transition: Transition.rightToLeft);
                                },
                                child: Text("SKIP",
                                    style: GoogleFonts.poppins(
                                        color: Colors.black.withOpacity(0.9),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700)),
                              ),
                              TextButton(
                                onPressed: () {
                                  Get.to(() => First3(),
                                      transition: Transition.rightToLeft);
                                },
                                child: Text("NEXT",
                                    style: GoogleFonts.poppins(
                                        color: primaryColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700)),
                              ),
                            ],
                          ))),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
