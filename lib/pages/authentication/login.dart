// ignore_for_file: deprecated_member_use

import 'package:bridge_ai/constants/controllers.dart';
import 'package:bridge_ai/pages/authentication/resetpassword.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

const _rose = Color(0xFFE8567A);
const _roseDark = Color(0xFFC03A5E);
const _plum = Color(0xFF3D1A2E);
const _muted = Color(0xFF9E8892);
const _surface = Color(0xFFFDF7F9);

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _surface,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHero(),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeading(),
                      const SizedBox(height: 32),
                      _buildEmailField(),
                      const SizedBox(height: 16),
                      _buildPasswordField(),
                      const SizedBox(height: 6),
                      _buildForgotPassword(),
                      const SizedBox(height: 24),
                      _buildLoginButton(),
                      if (defaultTargetPlatform != TargetPlatform.iOS) ...[
                        const SizedBox(height: 24),
                        _buildDivider(),
                        const SizedBox(height: 20),
                        _buildGoogleButton(),
                      ],
                      const SizedBox(height: 32),
                      _buildSignupRow(),
                      const SizedBox(height: 24),
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

  Widget _buildHero() {
    return Container(
      width: double.infinity,
      height: 220,
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
              width: 180,
              height: 180,
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
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(28, 32, 28, 28),
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
                const SizedBox(height: 14),
                Text(
                      "FemiHub",
                      style: GoogleFonts.philosopher(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                      ),
                    )
                    .animate()
                    .fadeIn(
                      delay: 100.ms,
                      duration: 500.ms,
                      curve: Curves.easeOut,
                    )
                    .slideX(
                      begin: -0.05,
                      end: 0,
                      delay: 100.ms,
                      duration: 500.ms,
                    ),
                const SizedBox(height: 4),
                Text(
                  "Your women's health companion",
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 13.5,
                  ),
                ).animate().fadeIn(
                  delay: 160.ms,
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
              "Welcome back",
              style: GoogleFonts.philosopher(
                color: _plum,
                fontSize: 28,
                fontWeight: FontWeight.w700,
                height: 1.2,
              ),
            )
            .animate()
            .fadeIn(delay: 200.ms, duration: 500.ms, curve: Curves.easeOut)
            .slideY(begin: 0.1, end: 0, delay: 200.ms, duration: 500.ms),
        const SizedBox(height: 6),
        Text(
          "Sign in to continue your journey",
          style: GoogleFonts.plusJakartaSans(color: _muted, fontSize: 13.5),
        ).animate().fadeIn(
          delay: 250.ms,
          duration: 500.ms,
          curve: Curves.easeOut,
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return _InputField(
          controller: userController.email,
          label: "Email address",
          hint: "you@example.com",
          icon: PhosphorIcons.envelope,
          keyboard: TextInputType.emailAddress,
          validator: (v) {
            if (v == null || v.isEmpty) return 'Email is required';
            if (v.length < 5) return 'Enter a valid email';
            return null;
          },
        )
        .animate()
        .fadeIn(delay: 300.ms, duration: 450.ms, curve: Curves.easeOut)
        .slideY(begin: 0.06, end: 0, delay: 300.ms, duration: 450.ms);
  }

  Widget _buildPasswordField() {
    return _InputField(
          controller: userController.password,
          label: "Password",
          hint: "••••••••",
          icon: PhosphorIcons.lock,
          obscure: _obscure,
          suffix: GestureDetector(
            onTap: () => setState(() => _obscure = !_obscure),
            child: Icon(
              _obscure ? PhosphorIcons.eye : PhosphorIcons.eyeSlash,
              color: _obscure ? _muted : _rose,
              size: 19,
            ),
          ),
          validator: (v) {
            if (v == null || v.isEmpty) return 'Password is required';
            if (v.length < 3) return 'Enter a valid password';
            return null;
          },
        )
        .animate()
        .fadeIn(delay: 350.ms, duration: 450.ms, curve: Curves.easeOut)
        .slideY(begin: 0.06, end: 0, delay: 350.ms, duration: 450.ms);
  }

  Widget _buildForgotPassword() {
    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap:
            () => Get.to(
              () => ResetPassword(),
              transition: Transition.rightToLeft,
            ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            "Forgot password?",
            style: GoogleFonts.plusJakartaSans(
              color: _rose,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    ).animate().fadeIn(delay: 390.ms, duration: 400.ms, curve: Curves.easeOut);
  }

  Widget _buildLoginButton() {
    return GestureDetector(
          onTap: () {
            if (_formKey.currentState!.validate()) {
              userController.signIn(context);
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
              "Log In",
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
        .fadeIn(delay: 420.ms, duration: 400.ms, curve: Curves.easeOut)
        .slideY(begin: 0.05, end: 0, delay: 420.ms, duration: 400.ms);
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
            "or continue with",
            style: GoogleFonts.plusJakartaSans(color: _muted, fontSize: 12),
          ),
        ),
        Expanded(
          child: Divider(color: Colors.black.withOpacity(0.08), thickness: 1),
        ),
      ],
    ).animate().fadeIn(delay: 460.ms, duration: 400.ms, curve: Curves.easeOut);
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
        .fadeIn(delay: 500.ms, duration: 400.ms, curve: Curves.easeOut)
        .slideY(begin: 0.05, end: 0, delay: 500.ms, duration: 400.ms);
  }

  Widget _buildSignupRow() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Don't have an account? ",
            style: GoogleFonts.plusJakartaSans(color: _muted, fontSize: 13.5),
          ),
          GestureDetector(
            onTap: () => Get.toNamed("/signup"),
            child: Text(
              "Sign up",
              style: GoogleFonts.plusJakartaSans(
                color: _rose,
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 540.ms, duration: 400.ms, curve: Curves.easeOut);
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final TextInputType keyboard;
  final bool obscure;
  final Widget? suffix;
  final String? Function(String?)? validator;

  const _InputField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.keyboard = TextInputType.text,
    this.obscure = false,
    this.suffix,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
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
          obscureText: obscure,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            color: Colors.black87,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.plusJakartaSans(
              color: _muted,
              fontSize: 13.5,
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Icon(icon, color: _muted, size: 19),
            ),
            prefixIconConstraints: const BoxConstraints(
              minWidth: 0,
              minHeight: 0,
            ),
            suffixIcon:
                suffix != null
                    ? Padding(
                      padding: const EdgeInsets.only(right: 14),
                      child: suffix,
                    )
                    : null,
            suffixIconConstraints: const BoxConstraints(
              minWidth: 0,
              minHeight: 0,
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 15,
            ),
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
          ),
          validator: validator,
        ),
      ],
    );
  }
}
