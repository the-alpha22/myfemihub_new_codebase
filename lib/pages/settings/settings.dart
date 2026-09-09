// ignore_for_file: deprecated_member_use

import 'package:bridge_ai/constants/app_constants.dart';
import 'package:bridge_ai/constants/bottom_nav_bar.dart';
import 'package:bridge_ai/constants/controllers.dart';
import 'package:bridge_ai/pages/settings/extra_pages/account_details.dart';
import 'package:bridge_ai/services/cycle_notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

const _rose = Color(0xFFE8567A);
const _roseDark = Color(0xFFC03A5E);
const _roseSoft = Color(0xFFFFF0F4);
const _plum = Color(0xFF3D1A2E);
const _muted = Color(0xFF9E8892);
const _surface = Color(0xFFFDF7F9);
const _violet = Color(0xFF7C5CBF);
const _violetSoft = Color(0xFFF3EEFF);
const _sage = Color(0xFF6BAF92);
const _sageSoft = Color(0xFFEDF7F3);

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final user = userController.userModel.value!;

    return Scaffold(
      backgroundColor: _surface,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: _surface,
        toolbarHeight: 64,
        centerTitle: false,
        title: Text(
          'Settings',
          style: GoogleFonts.philosopher(
            fontWeight: FontWeight.w700,
            fontSize: 22,
            color: _plum,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildUserCard(user)
                  .animate()
                  .fadeIn(duration: 500.ms, curve: Curves.easeOut)
                  .slideY(begin: 0.07, end: 0, duration: 500.ms),
              const SizedBox(height: 28),
              _buildSectionLabel('Account'),
              const SizedBox(height: 10),
              _buildGroup([
                    _SettingsTile(
                      icon: PhosphorIcons.userCircle,
                      title: "Account Details",
                      subtitle: "View and edit your profile",
                      color: _rose,
                      soft: _roseSoft,
                      onTap:
                          () => Get.to(
                            () => EditProfilePage(),
                            transition: Transition.rightToLeft,
                          ),
                    ),
                  ])
                  .animate()
                  .fadeIn(
                    delay: 100.ms,
                    duration: 400.ms,
                    curve: Curves.easeOut,
                  )
                  .slideY(begin: 0.06, end: 0, delay: 100.ms, duration: 400.ms),
              const SizedBox(height: 24),

              _buildSectionLabel('Notifications'),
              const SizedBox(height: 10),
              Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const CycleNotificationSettings(),
                  )
                  .animate()
                  .fadeIn(
                    delay: 160.ms,
                    duration: 400.ms,
                    curve: Curves.easeOut,
                  )
                  .slideY(begin: 0.06, end: 0, delay: 160.ms, duration: 400.ms),
              const SizedBox(height: 24),
              _buildSectionLabel('Support'),
              const SizedBox(height: 10),
              _buildGroup([
                    _SettingsTile(
                      icon: PhosphorIcons.question,
                      title: "Help & Support",
                      subtitle: "FAQs and support resources",
                      color: _violet,
                      soft: _violetSoft,
                      onTap: () => openLink("https://bulamubridgeai.com"),
                    ),
                    _SettingsTile(
                      icon: PhosphorIcons.headset,
                      title: "Contact Us",
                      subtitle: "Chat with us on WhatsApp",
                      color: _sage,
                      soft: _sageSoft,
                      onTap: () => openLink("https://wa.me/256772797091"),
                      isLast: true,
                    ),
                  ])
                  .animate()
                  .fadeIn(
                    delay: 160.ms,
                    duration: 400.ms,
                    curve: Curves.easeOut,
                  )
                  .slideY(begin: 0.06, end: 0, delay: 160.ms, duration: 400.ms),
              const SizedBox(height: 24),
              _buildSectionLabel('Legal'),
              const SizedBox(height: 10),
              _buildGroup([
                    _SettingsTile(
                      icon: PhosphorIcons.info,
                      title: "About FemiHub",
                      subtitle: "Our mission and team",
                      color: _violet,
                      soft: _violetSoft,
                      onTap: () => openLink("https://bulamubridgeai.com"),
                      isLast: true,
                    ),
                  ])
                  .animate()
                  .fadeIn(
                    delay: 220.ms,
                    duration: 400.ms,
                    curve: Curves.easeOut,
                  )
                  .slideY(begin: 0.06, end: 0, delay: 220.ms, duration: 400.ms),
              const SizedBox(height: 24),
              _buildSectionLabel('Danger Zone', isDanger: true),
              const SizedBox(height: 10),
              _buildGroup([
                    _SettingsTile(
                      icon: PhosphorIcons.trash,
                      title: "Delete Account",
                      subtitle: "Permanently delete your account and data",
                      color: Colors.red.shade400,
                      soft: Colors.red.shade50,
                      onTap: () => openLink("https://tally.so/r/mJDYVJ"),
                      isDanger: true,
                      isLast: true,
                    ),
                  ])
                  .animate()
                  .fadeIn(
                    delay: 280.ms,
                    duration: 400.ms,
                    curve: Curves.easeOut,
                  )
                  .slideY(begin: 0.06, end: 0, delay: 280.ms, duration: 400.ms),
              const SizedBox(height: 16),
              _buildLogoutButton().animate().fadeIn(
                delay: 330.ms,
                duration: 400.ms,
                curve: Curves.easeOut,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }

  Widget _buildUserCard(user) {
    final stage = user.stage ?? "Not Yet Pregnant";
    final hasPeriod = user.perioddate != null;
    final isPregnant = stage == "Pregnant";

    Color stageBg = _roseSoft;
    Color stageColor = _rose;
    IconData stageIcon = PhosphorIcons.drop;
    if (isPregnant) {
      stageBg = _sageSoft;
      stageColor = _sage;
      stageIcon = PhosphorIcons.baby;
    }

    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [_rose, _roseDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _rose.withOpacity(0.28),
            blurRadius: 18,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -28,
            bottom: -28,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.07),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(22),
            child: Row(
              children: [
                Container(
                  width: 62,
                  height: 62,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.2),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.35),
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      user.name.isNotEmpty ? user.name[0].toUpperCase() : "U",
                      style: GoogleFonts.philosopher(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name,
                        style: GoogleFonts.philosopher(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        user.email,
                        style: GoogleFonts.plusJakartaSans(
                          color: Colors.white.withOpacity(0.75),
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.18),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(stageIcon, color: Colors.white, size: 12),
                                const SizedBox(width: 5),
                                Text(
                                  stage,
                                  style: GoogleFonts.plusJakartaSans(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (hasPeriod) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.18),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    PhosphorIcons.checkCircle,
                                    color: Colors.white,
                                    size: 12,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    "Tracking",
                                    style: GoogleFonts.plusJakartaSans(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap:
                      () => Get.to(
                        () => EditProfilePage(),
                        transition: Transition.rightToLeft,
                      ),
                  child: Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.18),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      PhosphorIcons.pencilSimple,
                      color: Colors.white,
                      size: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String label, {bool isDanger = false}) {
    return Text(
      label.toUpperCase(),
      style: GoogleFonts.plusJakartaSans(
        fontWeight: FontWeight.w600,
        fontSize: 11,
        color: isDanger ? Colors.red.shade400 : _muted,
        letterSpacing: 0.8,
      ),
    );
  }

  Widget _buildGroup(List<_SettingsTile> tiles) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(children: tiles),
    );
  }

  Widget _buildLogoutButton() {
    return GestureDetector(
      onTap: _showLogoutDialog,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.red.shade100),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(PhosphorIcons.signOut, color: Colors.red.shade500, size: 18),
            const SizedBox(width: 8),
            Text(
              'Log Out',
              style: GoogleFonts.plusJakartaSans(
                color: Colors.red.shade500,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            backgroundColor: Colors.white,
            title: Text(
              'Log out?',
              style: GoogleFonts.philosopher(
                fontWeight: FontWeight.w700,
                fontSize: 20,
                color: _plum,
              ),
            ),
            content: Text(
              "You'll need to sign in again to access your account.",
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13.5,
                color: _muted,
                height: 1.5,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: Text(
                  'Cancel',
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: _muted,
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
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w700,
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
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final Color soft;
  final VoidCallback onTap;
  final bool isDanger;
  final bool isLast;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.soft,
    required this.onTap,
    this.isDanger = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: soft,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(icon, color: color, size: 19),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.w600,
                            fontSize: 13.5,
                            color: isDanger ? Colors.red.shade500 : _plum,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          subtitle,
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            color: _muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 13,
                    color: _muted,
                  ),
                ],
              ),
            ),
          ),
        ),
        if (!isLast)
          Divider(
            height: 1,
            thickness: 1,
            indent: 70,
            endIndent: 0,
            color: _surface,
          ),
      ],
    );
  }
}
