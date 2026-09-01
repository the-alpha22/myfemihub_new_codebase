import 'package:bridge_ai/constants/app_constants.dart';
import 'package:bridge_ai/constants/bottom_nav_bar.dart';
import 'package:bridge_ai/constants/controllers.dart';
import 'package:bridge_ai/pages/settings/extra_pages/account_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        toolbarHeight: 64,
        centerTitle: true,
        title: Text(
          'Settings',
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: Colors.black87,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionLabel('Account'),
              const SizedBox(height: 10),
              _SettingsTile(
                    svgLocation: "images/user-circle-light.svg",
                    title: "Account Details",
                    subtitle: "View and edit your profile",
                    onTap:
                        () => Get.to(
                          () => EditProfilePage(),
                          transition: Transition.rightToLeft,
                        ),
                  )
                  .animate()
                  .fadeIn(duration: 400.ms)
                  .slideY(
                    begin: 0.1,
                    end: 0,
                    duration: 400.ms,
                    curve: Curves.easeOut,
                  ),
              const SizedBox(height: 28),
              _buildSectionLabel('Support'),
              const SizedBox(height: 10),
              _SettingsTile(
                    svgLocation: "images/question-light.svg",
                    title: "Help & Support",
                    subtitle: "FAQs and support resources",
                    onTap: () => openLink("https://bulamubridgeai.com"),
                  )
                  .animate()
                  .fadeIn(delay: 60.ms, duration: 400.ms)
                  .slideY(
                    begin: 0.1,
                    end: 0,
                    delay: 60.ms,
                    duration: 400.ms,
                    curve: Curves.easeOut,
                  ),
              const SizedBox(height: 10),
              _SettingsTile(
                    svgLocation: "images/headset-light.svg",
                    title: "Contact Us",
                    subtitle: "Chat with us on WhatsApp",
                    onTap: () => openLink("https://wa.me/256772797091"),
                  )
                  .animate()
                  .fadeIn(delay: 100.ms, duration: 400.ms)
                  .slideY(
                    begin: 0.1,
                    end: 0,
                    delay: 100.ms,
                    duration: 400.ms,
                    curve: Curves.easeOut,
                  ),
              const SizedBox(height: 10),
              _SettingsTile(
                    svgLocation: "images/circles-four-light.svg",
                    title: "About Bridge AI",
                    subtitle: "Our mission and team",
                    onTap: () => openLink("https://bulamubridgeai.com"),
                  )
                  .animate()
                  .fadeIn(delay: 140.ms, duration: 400.ms)
                  .slideY(
                    begin: 0.1,
                    end: 0,
                    delay: 140.ms,
                    duration: 400.ms,
                    curve: Curves.easeOut,
                  ),
              const SizedBox(height: 28),
              _buildSectionLabel('Danger Zone', isDanger: true),
              const SizedBox(height: 10),
              _SettingsTile(
                    svgLocation: "images/question-light.svg",
                    title: "Delete Account",
                    subtitle: "Permanently delete your account and data",
                    isDanger: true,
                    onTap: () => openLink("https://tally.so/r/mJDYVJ"),
                  )
                  .animate()
                  .fadeIn(delay: 180.ms, duration: 400.ms)
                  .slideY(
                    begin: 0.1,
                    end: 0,
                    delay: 180.ms,
                    duration: 400.ms,
                    curve: Curves.easeOut,
                  ),
              const SizedBox(height: 12),
              _buildLogoutButton().animate().fadeIn(
                delay: 220.ms,
                duration: 400.ms,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }

  Widget _buildSectionLabel(String label, {bool isDanger = false}) {
    return Text(
      label,
      style: GoogleFonts.montserrat(
        fontWeight: FontWeight.w600,
        fontSize: 12,
        color: isDanger ? Colors.red.shade400 : Colors.black38,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _showLogoutDialog,
        borderRadius: BorderRadius.circular(12),
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.red.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.red.shade100, width: 1),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  PhosphorIcons.signOut,
                  color: Colors.red.shade500,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  'Log Out',
                  style: GoogleFonts.montserrat(
                    color: Colors.red.shade500,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            backgroundColor: Colors.white,
            title: Text(
              'Log out?',
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: Colors.black87,
              ),
            ),
            content: Text(
              "You'll need to log in again to access your account.",
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: Text(
                  'Cancel',
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Get.back();
                  userController.signOut();
                },
                child: Text(
                  'Log Out',
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.red.shade500,
                  ),
                ),
              ),
            ],
          ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final String svgLocation;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool isDanger;

  const _SettingsTile({
    required this.svgLocation,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.isDanger = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDanger ? Colors.red.shade400 : primaryColor;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDanger ? Colors.red.shade100 : const Color(0xFFEEEEEE),
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      svgLocation,
                      height: 22,
                      color: color,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color:
                              isDanger ? Colors.red.shade500 : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        subtitle,
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: Colors.black38,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios, size: 14, color: Colors.black26),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
