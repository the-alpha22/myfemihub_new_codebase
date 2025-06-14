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
        height: 60,
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  Get.offAllNamed("/home");
                },
                child: Container(
                  decoration: BoxDecoration(
                    color:
                        currentRoute == "/home"
                            ? Color.fromARGB(255, 190, 15, 73)
                            : primaryColor,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          "images/house-line-light.svg",
                          height: 32.0,
                          color: Colors.white,
                        ),
                        if (currentRoute == "/home") ...{
                          SizedBox(width: 8),
                          Text(
                            'Home',
                            style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                        },
                      ],
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Get.offAllNamed("/shop");
                },
                child: Container(
                  decoration: BoxDecoration(
                    color:
                        currentRoute.contains("shop")
                            ? Color.fromARGB(255, 190, 15, 73)
                            : primaryColor,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          "images/shopping-bag-open-light.svg",
                          height: 32.0,
                          color: Colors.white,
                        ),
                        if (currentRoute.contains("shop")) ...{
                          SizedBox(width: 8),
                          Text(
                            'Shop',
                            style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                        },
                      ],
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Get.offAllNamed("/community");
                },
                child: Container(
                  decoration: BoxDecoration(
                    color:
                        currentRoute == "/community"
                            ? Color.fromARGB(255, 190, 15, 73)
                            : primaryColor,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          "images/users-light.svg",
                          height: 32,
                          color: Colors.white,
                        ),
                        if (currentRoute == "/community") ...{
                          SizedBox(width: 8),
                          Text(
                            'Community',
                            style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                        },
                      ],
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Get.offAllNamed("/settings");
                },
                child: Container(
                  decoration: BoxDecoration(
                    color:
                        currentRoute == "/settings"
                            ? Color.fromARGB(255, 190, 15, 73)
                            : primaryColor,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          "images/gear-light.svg",
                          height: 32,
                          color: Colors.white,
                        ),
                        if (currentRoute == "/settings") ...{
                          SizedBox(width: 8),
                          Text(
                            'Settings',
                            style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                        },
                      ],
                    ),
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
