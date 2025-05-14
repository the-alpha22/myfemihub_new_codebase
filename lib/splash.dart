import 'package:bridge_ai/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:bridge_ai/constants/asset_paths.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatelessWidget {
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
