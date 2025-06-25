import 'package:bridge_ai/constants/app_constants.dart';
import 'package:bridge_ai/constants/bottom_nav_bar.dart';
import 'package:bridge_ai/constants/controllers.dart';
import 'package:bridge_ai/pages/settings/extra_pages/account_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Account',
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 12),
                SettingsTapWidget(
                  svgLocation: "images/user-circle-light.svg",
                  title: "Account Details",
                  description: "Manage your profile information",
                  onTap: () {
                    Get.to(
                      () => EditProfilePage(),
                      transition: Transition.rightToLeft,
                    );
                  },
                ),
                // SizedBox(height: 12),
                // SettingsTapWidget(
                //   svgLocation: "images/bell-simple-ringing-light.svg",
                //   title: "Notifications",
                //   description: "Manage your notifications",
                //   onTap: () {},
                // ),
                SizedBox(height: 24),
                Text(
                  'Support',
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 12),
                SettingsTapWidget(
                  svgLocation: "images/question-light.svg",
                  title: "Help & Support",
                  description: "Access help & support resources",
                  onTap: () {
                    openLink("https://bulamubridgeai.com/.com");
                  },
                ),
                SizedBox(height: 12),
                SettingsTapWidget(
                  svgLocation: "images/headset-light.svg",
                  title: "Contact Us",
                  description: "Get in touch with our team",
                  onTap: () {
                    openLink("https://wa.me/256772797091");
                  },
                ),
                SizedBox(height: 12),
                SettingsTapWidget(
                  svgLocation: "images/circles-four-light.svg",
                  title: "About",
                  description: "Learn more about Femihub",
                  onTap: () {
                    openLink("https://bulamubridgeai.com/.com");
                  },
                ),
                SizedBox(height: 24),
                SizedBox(height: 24),
                Text(
                  'Danger Zone',
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 12),
                SettingsTapWidget(
                  svgLocation: "images/question-light.svg",
                  title: "Delete Account",
                  description: "Request Account deletion",
                  onTap: () {
                    openLink("https://tally.so/r/mJDYVJ");
                  },
                ),
                SizedBox(height: 12),
                Center(
                  child: InkWell(
                    onTap: () {
                      userController.signOut();
                    },
                    child: Text(
                      'Log Out',
                      style: GoogleFonts.montserrat(
                        color: Colors.red.withOpacity(0.8),
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}

class SettingsTapWidget extends StatelessWidget {
  const SettingsTapWidget({
    super.key,
    required this.svgLocation,
    required this.title,
    required this.description,
    required this.onTap,
  });
  final String svgLocation;
  final String title;
  final String description;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: bgcolor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: SvgPicture.asset(
                  svgLocation,
                  height: 32.0,
                  color: Colors.black87,
                ),
              ),
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.montserrat(
                    color: Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  description,
                  style: GoogleFonts.montserrat(
                    color: Colors.black87,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
