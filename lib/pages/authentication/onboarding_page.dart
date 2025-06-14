import 'dart:async';

import 'package:bridge_ai/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  @override
  void initState() {
    super.initState();
    shuffleImages();
  }

  shuffleImages() {
    Timer.periodic(Duration(seconds: 10), (duration) {
      imageLocations.shuffle();
      setState(() {});
    });
  }

  void dispose() {
    super.dispose();
  }

  List<String> imageLocations = [
    "images/image_1.jpg",
    "images/image_2.jpg",
    "images/image_3.jpg",
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          color: primaryColor.withOpacity(.6),
          image: DecorationImage(
            image: AssetImage(imageLocations.first),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("images/logo_text.png", height: 60),
                  SizedBox(height: 12),
                  Text(
                    "Where Her Health Meets Smart Support.",
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 12),
                  InkWell(
                    onTap: () {
                      Get.toNamed("/login");
                    },
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(color: primaryColor),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            "Login",
                            style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 12),
                  InkWell(
                    onTap: () {
                      Get.toNamed("/signup");
                    },
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(color: primaryColor),
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            "Register",
                            style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  TextButton(
                    onPressed: () {
                      openLink(
                        "https://www.freepik.com/search?format=search&last_filter=query&last_value=Black+women+in+comfortable%2C+everyday+settings&query=Black+women+in+comfortable%2C+everyday+settings",
                      );
                    },
                    child: Text(
                      "Image from Freepik",
                      style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
