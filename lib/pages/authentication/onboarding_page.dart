// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:bridge_ai/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final List<String> imageLocations = [
    "images/image_1.jpg",
    "images/image_2.jpg",
    "images/image_3.jpg",
  ];

  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % imageLocations.length;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 1200),
            child: Container(
              key: ValueKey(_currentIndex),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(imageLocations[_currentIndex]),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.1),
                  Colors.black.withOpacity(0.7),
                  Colors.black.withOpacity(0.92),
                ],
                stops: const [0.0, 0.55, 1.0],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    "images/logo_text.png",
                    height: 44,
                  ).animate().fadeIn(duration: 600.ms, curve: Curves.easeOut),
                  const SizedBox(height: 12),
                  Text(
                        'Where her health\nmeets smart support.',
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          height: 1.2,
                        ),
                      )
                      .animate()
                      .fadeIn(
                        delay: 100.ms,
                        duration: 600.ms,
                        curve: Curves.easeOut,
                      )
                      .slideY(
                        begin: 0.1,
                        end: 0,
                        delay: 100.ms,
                        duration: 600.ms,
                        curve: Curves.easeOut,
                      ),
                  const SizedBox(height: 6),
                  Text(
                    'Track your cycle, plan your family, and get AI-powered answers — all in one place.',
                    style: GoogleFonts.montserrat(
                      color: Colors.white60,
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                    ),
                  ).animate().fadeIn(
                    delay: 180.ms,
                    duration: 600.ms,
                    curve: Curves.easeOut,
                  ),
                  const SizedBox(height: 32),
                  _buildButton(
                        label: 'Log In',
                        filled: true,
                        onTap: () => Get.toNamed("/login"),
                      )
                      .animate()
                      .fadeIn(delay: 260.ms, duration: 500.ms)
                      .slideY(
                        begin: 0.1,
                        end: 0,
                        delay: 260.ms,
                        duration: 500.ms,
                        curve: Curves.easeOut,
                      ),
                  const SizedBox(height: 12),
                  _buildButton(
                        label: 'Create Account',
                        filled: false,
                        onTap: () => Get.toNamed("/signup"),
                      )
                      .animate()
                      .fadeIn(delay: 320.ms, duration: 500.ms)
                      .slideY(
                        begin: 0.1,
                        end: 0,
                        delay: 320.ms,
                        duration: 500.ms,
                        curve: Curves.easeOut,
                      ),
                  const SizedBox(height: 20),
                  Center(
                    child: GestureDetector(
                      onTap:
                          () => openLink(
                            "https://www.freepik.com/search?format=search&last_filter=query&last_value=Black+women+in+comfortable%2C+everyday+settings&query=Black+women+in+comfortable%2C+everyday+settings",
                          ),
                      child: Text(
                        'Photos from Freepik',
                        style: GoogleFonts.montserrat(
                          color: Colors.white30,
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required String label,
    required bool filled,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Ink(
          width: double.infinity,
          decoration: BoxDecoration(
            color: filled ? primaryColor : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border:
                filled ? null : Border.all(color: Colors.white38, width: 1.5),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: Text(
                label,
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
