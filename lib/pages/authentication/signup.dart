// ignore_for_file: deprecated_member_use

import 'package:bridge_ai/constants/app_constants.dart';
import 'package:bridge_ai/constants/controllers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

const _rose = Color(0xFFE8567A);
const _roseDark = Color(0xFFC03A5E);
const _roseSoft = Color(0xFFFFF0F4);
const _plum = Color(0xFF3D1A2E);
const _muted = Color(0xFF9E8892);
const _surface = Color(0xFFFDF7F9);

class Registration extends StatefulWidget {
  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final _formKey = GlobalKey<FormState>();
  String _stage = 'Not Yet Pregnant';
  bool _obscure = true;

  final List<_StageOption> _stages = [
    _StageOption('Not Yet Pregnant', PhosphorIcons.heart, _rose),
    _StageOption('Pregnant', PhosphorIcons.baby, Color(0xFF6BAF92)),
    _StageOption('A Mother', PhosphorIcons.users, Color(0xFF7C5CBF)),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _surface,
      // appBar: _buildAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHero(),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeading(),
                      const SizedBox(height: 28),
                      _buildStageSelector(),
                      const SizedBox(height: 20),
                      _buildField(
                        controller: userController.name,
                        label: "Full name",
                        hint: "Your name",
                        icon: PhosphorIcons.user,
                        keyboard: TextInputType.name,
                        delay: 260,
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Name is required';
                          if (v.length < 2) return 'Enter a valid name';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildField(
                        controller: userController.email,
                        label: "Email address",
                        hint: "you@example.com",
                        icon: PhosphorIcons.envelope,
                        keyboard: TextInputType.emailAddress,
                        delay: 310,
                        validator: (v) {
                          if (v == null || v.isEmpty)
                            return 'Email is required';
                          if (v.length < 5) return 'Enter a valid email';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildPasswordField(),
                      const SizedBox(height: 28),
                      _buildCreateButton(),
                      if (defaultTargetPlatform != TargetPlatform.iOS) ...[
                        const SizedBox(height: 24),
                        _buildDivider(),
                        const SizedBox(height: 20),
                        _buildGoogleButton(),
                      ],
                      if (defaultTargetPlatform == TargetPlatform.iOS) ...[
                        const SizedBox(height: 24),
                        _buildDivider(),
                        const SizedBox(height: 20),
                        _buildAppleButton(),
                      ],
                      const SizedBox(height: 28),
                      _buildPrivacyNote(),
                      const SizedBox(height: 20),
                      _buildLoginRow(),
                      const SizedBox(height: 32),
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

  // AppBar _buildAppBar() {
  //   return AppBar(
  //     elevation: 0,
  //     backgroundColor: _surface,
  //     toolbarHeight: 64,
  //     leading: IconButton(
  //       onPressed: () => Get.back(),
  //       icon: Container(
  //         width: 36,
  //         height: 36,
  //         decoration: BoxDecoration(color: _roseSoft, shape: BoxShape.circle),
  //         child: Icon(Icons.arrow_back_ios_new_rounded, color: _rose, size: 16),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildHero() {
    return Container(
      width: double.infinity,
      height: 180,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [_rose, _roseDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -30,
            top: -30,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.07),
              ),
            ),
          ),
          Positioned(
            left: -20,
            bottom: -20,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(28, 24, 28, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Image.asset("images/logo.png", height: 64)
                    .animate()
                    .fadeIn(duration: 600.ms, curve: Curves.easeOut)
                    .scale(
                      begin: const Offset(0.8, 0.8),
                      end: const Offset(1, 1),
                      duration: 600.ms,
                      curve: Curves.easeOut,
                    ),
                const SizedBox(height: 8),
                Text(
                      "FemiHub",
                      style: GoogleFonts.philosopher(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                      ),
                    )
                    .animate()
                    .fadeIn(duration: 500.ms, curve: Curves.easeOut)
                    .slideX(begin: -0.05, end: 0, duration: 500.ms),
                const SizedBox(height: 4),
                Text(
                  "Join thousands of women on their journey",
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 13,
                  ),
                ).animate().fadeIn(
                  delay: 80.ms,
                  duration: 500.ms,
                  curve: Curves.easeOut,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeading() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
              "Create your account",
              style: GoogleFonts.philosopher(
                color: _plum,
                fontSize: 26,
                fontWeight: FontWeight.w700,
                height: 1.2,
              ),
            )
            .animate()
            .fadeIn(delay: 140.ms, duration: 450.ms, curve: Curves.easeOut)
            .slideY(begin: 0.08, end: 0, delay: 140.ms, duration: 450.ms),
        const SizedBox(height: 6),
        Text(
          "Tell us a bit about yourself to get started",
          style: GoogleFonts.plusJakartaSans(color: _muted, fontSize: 13.5),
        ).animate().fadeIn(
          delay: 180.ms,
          duration: 400.ms,
          curve: Curves.easeOut,
        ),
      ],
    );
  }

  Widget _buildStageSelector() {
    return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "I am currently",
              style: GoogleFonts.plusJakartaSans(
                color: _plum,
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children:
                  _stages.map((s) {
                    final selected = _stage == s.label;
                    return Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          right: s == _stages.last ? 0 : 8,
                        ),
                        child: GestureDetector(
                          onTap: () => setState(() => _stage = s.label),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color:
                                  selected
                                      ? s.color.withOpacity(0.1)
                                      : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color:
                                    selected
                                        ? s.color
                                        : Colors.black.withOpacity(0.07),
                                width: selected ? 1.5 : 1,
                              ),
                              boxShadow:
                                  selected
                                      ? [
                                        BoxShadow(
                                          color: s.color.withOpacity(0.15),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ]
                                      : [],
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  s.icon,
                                  color: selected ? s.color : _muted,
                                  size: 20,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  s.label,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 10.5,
                                    fontWeight:
                                        selected
                                            ? FontWeight.w700
                                            : FontWeight.w400,
                                    color: selected ? s.color : _muted,
                                    height: 1.3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ],
        )
        .animate()
        .fadeIn(delay: 210.ms, duration: 400.ms, curve: Curves.easeOut)
        .slideY(begin: 0.05, end: 0, delay: 210.ms, duration: 400.ms);
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required TextInputType keyboard,
    required int delay,
    String? Function(String?)? validator,
  }) {
    return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                color: _plum,
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: controller,
              keyboardType: keyboard,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                color: Colors.black87,
              ),
              decoration: _inputDecoration(hint: hint, icon: icon),
              validator: validator,
            ),
          ],
        )
        .animate()
        .fadeIn(delay: delay.ms, duration: 400.ms, curve: Curves.easeOut)
        .slideY(begin: 0.05, end: 0, delay: delay.ms, duration: 400.ms);
  }

  Widget _buildPasswordField() {
    return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Password",
              style: GoogleFonts.plusJakartaSans(
                color: _plum,
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: userController.password,
              obscureText: _obscure,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                color: Colors.black87,
              ),
              decoration: _inputDecoration(
                hint: "••••••••",
                icon: PhosphorIcons.lock,
                suffix: GestureDetector(
                  onTap: () => setState(() => _obscure = !_obscure),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 14),
                    child: Icon(
                      _obscure ? PhosphorIcons.eye : PhosphorIcons.eyeSlash,
                      color: _obscure ? _muted : _rose,
                      size: 19,
                    ),
                  ),
                ),
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Password is required';
                if (v.length < 6)
                  return 'Password must be at least 6 characters';
                return null;
              },
            ),
          ],
        )
        .animate()
        .fadeIn(delay: 360.ms, duration: 400.ms, curve: Curves.easeOut)
        .slideY(begin: 0.05, end: 0, delay: 360.ms, duration: 400.ms);
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
    Widget? suffix,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.plusJakartaSans(color: _muted, fontSize: 13.5),
      prefixIcon: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Icon(icon, color: _muted, size: 19),
      ),
      prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
      suffixIcon: suffix,
      suffixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.black.withOpacity(0.07)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: _rose.withOpacity(0.5), width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.red.shade300, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.red.shade300, width: 1.5),
      ),
    );
  }

  Widget _buildCreateButton() {
    return GestureDetector(
          onTap: () async {
            if (_formKey.currentState!.validate()) {
              await userController.signUp(context, _stage);
            }
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 17),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [_rose, _roseDark],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: _rose.withOpacity(0.35),
                  blurRadius: 14,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Text(
              "Create Account",
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.2,
              ),
            ),
          ),
        )
        .animate()
        .fadeIn(delay: 400.ms, duration: 400.ms, curve: Curves.easeOut)
        .slideY(begin: 0.05, end: 0, delay: 400.ms, duration: 400.ms);
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(
          child: Divider(color: Colors.black.withOpacity(0.08), thickness: 1),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Text(
            "or sign up with",
            style: GoogleFonts.plusJakartaSans(color: _muted, fontSize: 12),
          ),
        ),
        Expanded(
          child: Divider(color: Colors.black.withOpacity(0.08), thickness: 1),
        ),
      ],
    ).animate().fadeIn(delay: 440.ms, duration: 400.ms, curve: Curves.easeOut);
  }

  Widget _buildGoogleButton() {
    return GestureDetector(
          onTap: () async => await userController.signInWithGoogle(context),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.black.withOpacity(0.08)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("images/google_logo.png", height: 20),
                const SizedBox(width: 10),
                Text(
                  "Continue with Google",
                  style: GoogleFonts.plusJakartaSans(
                    color: _plum,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        )
        .animate()
        .fadeIn(delay: 480.ms, duration: 400.ms, curve: Curves.easeOut)
        .slideY(begin: 0.05, end: 0, delay: 480.ms, duration: 400.ms);
  }

  Widget _buildAppleButton() {
    return GestureDetector(
          onTap: () async => await userController.signInWithApple(context),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 15),
            decoration: BoxDecoration(
              color: _plum,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: _plum.withOpacity(0.25),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "images/apple.png",
                  height: 20,
                  color: Colors.white,
                ),
                const SizedBox(width: 10),
                Text(
                  "Continue with Apple",
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        )
        .animate()
        .fadeIn(delay: 480.ms, duration: 400.ms, curve: Curves.easeOut)
        .slideY(begin: 0.05, end: 0, delay: 480.ms, duration: 400.ms);
  }

  Widget _buildPrivacyNote() {
    return GestureDetector(
      onTap: () => openLink("https://bulamubridgeai.com/privacy-policy"),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: GoogleFonts.plusJakartaSans(
            color: _muted,
            fontSize: 12,
            height: 1.5,
          ),
          children: [
            const TextSpan(text: "By creating an account, you agree to our "),
            TextSpan(
              text: "Privacy Policy & Terms",
              style: GoogleFonts.plusJakartaSans(
                color: _rose,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 520.ms, duration: 400.ms, curve: Curves.easeOut);
  }

  Widget _buildLoginRow() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Already have an account? ",
            style: GoogleFonts.plusJakartaSans(color: _muted, fontSize: 13.5),
          ),
          GestureDetector(
            onTap: () => Get.toNamed("/login"),
            child: Text(
              "Log in",
              style: GoogleFonts.plusJakartaSans(
                color: _rose,
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 550.ms, duration: 400.ms, curve: Curves.easeOut);
  }
}

class _StageOption {
  final String label;
  final IconData icon;
  final Color color;
  const _StageOption(this.label, this.icon, this.color);
}
