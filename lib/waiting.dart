import 'dart:async';
import 'package:bridge_ai/constants/app_constants.dart';
import 'package:bridge_ai/controllers/dynamicLink.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Waiting extends StatefulWidget {
  @override
  State<Waiting> createState() => _WaitingState();
}

class _WaitingState extends State<Waiting> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Get.offAllNamed("/home");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "My",
                  style: GoogleFonts.poppins(
                      color: Colors.black87.withOpacity(0.9),
                      fontWeight: FontWeight.w500,
                      fontSize: 30),
                  textAlign: TextAlign.center,
                ),
                Text(
                  " FemiHub",
                  style: GoogleFonts.poppins(
                      color: primaryColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 30),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
