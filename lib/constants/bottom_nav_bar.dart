import 'package:bridge_ai/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final currentRoute = Get.currentRoute;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 20),
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  Get.offAllNamed("/home");
                },
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Column(
                    children: [
                      SvgPicture.asset(
                        "images/house-line-light.svg",
                        height: 32.0,
                        color:
                            currentRoute == "/home"
                                ? Colors.white
                                : Colors.white54,
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Home',
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w500,
                          fontSize: 10,
                          color:
                              currentRoute == "/home"
                                  ? Colors.white
                                  : Colors.white54,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Get.offAllNamed("/shop");
                },
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Column(
                    children: [
                      SvgPicture.asset(
                        "images/shopping-bag-open-light.svg",
                        height: 32.0,
                        color:
                            currentRoute.contains("shop")
                                ? Colors.white
                                : Colors.white54,
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Shop',
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w500,
                          fontSize: 10,
                          color:
                              currentRoute.contains("shop")
                                  ? Colors.white
                                  : Colors.white54,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Get.offAllNamed("/community");
                },
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Column(
                    children: [
                      SvgPicture.asset(
                        "images/users-light.svg",
                        height: 32,
                        color:
                            currentRoute == "/community"
                                ? Colors.white
                                : Colors.white54,
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Community',
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w500,
                          fontSize: 10,
                          color:
                              currentRoute == "/community"
                                  ? Colors.white
                                  : Colors.white54,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Get.offAllNamed("/settings");
                },
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Column(
                    children: [
                      SvgPicture.asset(
                        "images/gear-light.svg",
                        height: 32,
                        color:
                            currentRoute == "/settings"
                                ? Colors.white
                                : Colors.white54,
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Settings',
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w500,
                          fontSize: 10,
                          color:
                              currentRoute == "/settings"
                                  ? Colors.white
                                  : Colors.white54,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
