// ignore_for_file: deprecated_member_use
import 'package:bridge_ai/constants/controllers.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _formKey = GlobalKey<FormState>();
  bool _sending = false;
  bool _sent = false;

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _sending = true);
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: userController.email.text.trim(),
      );
      if (mounted)
        setState(() {
          _sending = false;
          _sent = true;
        });
    } on FirebaseAuthException catch (e) {
      if (mounted) setState(() => _sending = false);
      Get.snackbar(
        "Something went wrong",
        e.message ?? "Please try again",
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade500,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _surface,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 40),
          child: _sent ? _buildSuccessState() : _buildFormState(),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: _surface,
      toolbarHeight: 64,
      leading: IconButton(
        onPressed: () => Get.back(),
        icon: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(color: _roseSoft, shape: BoxShape.circle),
          child: Icon(Icons.arrow_back_ios_new_rounded, color: _rose, size: 16),
        ),
      ),
    );
  }

  Widget _buildFormState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildIllustration()
            .animate()
            .fadeIn(duration: 500.ms, curve: Curves.easeOut)
            .scale(
              begin: const Offset(0.9, 0.9),
              end: const Offset(1, 1),
              duration: 500.ms,
              curve: Curves.easeOut,
            ),
        const SizedBox(height: 32),
        Text(
              "Forgot your\npassword?",
              style: GoogleFonts.philosopher(
                color: _plum,
                fontSize: 30,
                fontWeight: FontWeight.w700,
                height: 1.2,
              ),
            )
            .animate()
            .fadeIn(delay: 100.ms, duration: 450.ms, curve: Curves.easeOut)
            .slideY(begin: 0.08, end: 0, delay: 100.ms, duration: 450.ms),
        const SizedBox(height: 8),
        Text(
          "Enter your email and we'll send you a link to reset it.",
          style: GoogleFonts.plusJakartaSans(
            color: _muted,
            fontSize: 13.5,
            height: 1.5,
          ),
        ).animate().fadeIn(
          delay: 150.ms,
          duration: 400.ms,
          curve: Curves.easeOut,
        ),
        const SizedBox(height: 32),
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Email address",
                style: GoogleFonts.plusJakartaSans(
                  color: _plum,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                    controller: userController.email,
                    keyboardType: TextInputType.emailAddress,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                    decoration: InputDecoration(
                      hintText: "you@example.com",
                      hintStyle: GoogleFonts.plusJakartaSans(
                        color: _muted,
                        fontSize: 13.5,
                      ),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        child: Icon(
                          PhosphorIcons.envelope,
                          color: _muted,
                          size: 19,
                        ),
                      ),
                      prefixIconConstraints: const BoxConstraints(
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
                        borderSide: BorderSide(
                          color: Colors.black.withOpacity(0.07),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(
                          color: _rose.withOpacity(0.5),
                          width: 1.5,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(
                          color: Colors.red.shade300,
                          width: 1,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(
                          color: Colors.red.shade300,
                          width: 1.5,
                        ),
                      ),
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Email is required';
                      if (v.length < 5) return 'Enter a valid email';
                      return null;
                    },
                  )
                  .animate()
                  .fadeIn(
                    delay: 220.ms,
                    duration: 400.ms,
                    curve: Curves.easeOut,
                  )
                  .slideY(begin: 0.05, end: 0, delay: 220.ms, duration: 400.ms),
              const SizedBox(height: 24),
              GestureDetector(
                    onTap: _sending ? null : _submit,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 17),
                      decoration: BoxDecoration(
                        gradient:
                            _sending
                                ? null
                                : const LinearGradient(
                                  colors: [_rose, _roseDark],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                        color: _sending ? Colors.grey.shade200 : null,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow:
                            _sending
                                ? []
                                : [
                                  BoxShadow(
                                    color: _rose.withOpacity(0.35),
                                    blurRadius: 14,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                      ),
                      child:
                          _sending
                              ? const Center(
                                child: SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                              : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    PhosphorIcons.paperPlaneTilt,
                                    color: Colors.white,
                                    size: 17,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "Send Reset Link",
                                    style: GoogleFonts.plusJakartaSans(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.2,
                                    ),
                                  ),
                                ],
                              ),
                    ),
                  )
                  .animate()
                  .fadeIn(
                    delay: 280.ms,
                    duration: 400.ms,
                    curve: Curves.easeOut,
                  )
                  .slideY(begin: 0.05, end: 0, delay: 280.ms, duration: 400.ms),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Center(
          child: GestureDetector(
            onTap: () => Get.back(),
            child: Text(
              "Back to login",
              style: GoogleFonts.plusJakartaSans(
                color: _rose,
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ).animate().fadeIn(
          delay: 330.ms,
          duration: 400.ms,
          curve: Curves.easeOut,
        ),
      ],
    );
  }

  Widget _buildSuccessState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 40),
        Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [_rose, _roseDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: _rose.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: const Icon(
                Icons.check_rounded,
                color: Colors.white,
                size: 44,
              ),
            )
            .animate()
            .fadeIn(duration: 500.ms, curve: Curves.easeOut)
            .scale(
              begin: const Offset(0.7, 0.7),
              end: const Offset(1, 1),
              duration: 500.ms,
              curve: Curves.elasticOut,
            ),
        const SizedBox(height: 28),
        Text(
          "Check your inbox",
          style: GoogleFonts.philosopher(
            fontSize: 26,
            fontWeight: FontWeight.w700,
            color: _plum,
          ),
        ).animate().fadeIn(
          delay: 200.ms,
          duration: 400.ms,
          curve: Curves.easeOut,
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            "We've sent a password reset link to\n${userController.email.text.trim()}",
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13.5,
              color: _muted,
              height: 1.6,
            ),
          ),
        ).animate().fadeIn(
          delay: 270.ms,
          duration: 400.ms,
          curve: Curves.easeOut,
        ),
        const SizedBox(height: 40),
        GestureDetector(
              onTap: () => Get.offAllNamed("/login"),
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
                  "Back to Login",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            )
            .animate()
            .fadeIn(delay: 340.ms, duration: 400.ms, curve: Curves.easeOut)
            .slideY(begin: 0.05, end: 0, delay: 340.ms, duration: 400.ms),
      ],
    );
  }

  Widget _buildIllustration() {
    return Center(
      child: Container(
        width: 110,
        height: 110,
        decoration: BoxDecoration(color: _roseSoft, shape: BoxShape.circle),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: _rose.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
            ),
            Icon(PhosphorIcons.lock, color: _rose, size: 38),
          ],
        ),
      ),
    );
  }
}
