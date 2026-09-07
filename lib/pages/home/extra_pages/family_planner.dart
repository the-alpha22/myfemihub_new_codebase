// ignore_for_file: deprecated_member_use

import 'package:bridge_ai/constants/app_constants.dart';
import 'package:bridge_ai/controllers/ai_controller.dart';
import 'package:bridge_ai/pages/home/extra_pages/family_planning_pages/contraceptions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

const _rose = Color(0xFFE8567A);
const _roseDark = Color(0xFFC03A5E);
const _roseSoft = Color(0xFFFFF0F4);
const _plum = Color(0xFF3D1A2E);
const _muted = Color(0xFF9E8892);
const _surface = Color(0xFFFDF7F9);

const _violet = Color(0xFF7C5CBF);
const _violetSoft = Color(0xFFF3EEFF);
const _emerald = Color(0xFF1A8820);
const _emeraldSoft = Color(0xFFEAF7EA);
const _teal = Color(0xFF00897B);
const _tealSoft = Color(0xFFE0F2F1);

class FamilyPlanningPage extends StatefulWidget {
  const FamilyPlanningPage({super.key});

  @override
  State<FamilyPlanningPage> createState() => _FamilyPlanningPageState();
}

class _FamilyPlanningPageState extends State<FamilyPlanningPage> {
  bool isLoading = true;
  String generalInfo = "";

  @override
  void initState() {
    super.initState();
    getInfo();
  }

  Future<void> getInfo() async {
    generalInfo = await VertexAIController.suggestFamilyPlanningInfo();
    if (mounted) setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _surface,
      appBar: _buildAppBar(),
      bottomNavigationBar: _buildBottomCTA(),
      body:
          isLoading
              ? Center(
                child: Lottie.asset(
                  'images/femihub_loading.json',
                  repeat: true,
                  frameRate: FrameRate(30),
                  height: 160,
                ),
              )
              : SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeroBanner()
                        .animate()
                        .fadeIn(duration: 500.ms, curve: Curves.easeOut)
                        .slideY(
                          begin: 0.07,
                          end: 0,
                          duration: 500.ms,
                          curve: Curves.easeOut,
                        ),
                    const SizedBox(height: 28),
                    Text(
                      "Explore Topics",
                      style: GoogleFonts.philosopher(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: _plum,
                      ),
                    ).animate().fadeIn(
                      delay: 120.ms,
                      duration: 400.ms,
                      curve: Curves.easeOut,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Tap a card to learn more",
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12.5,
                        color: _muted,
                      ),
                    ).animate().fadeIn(
                      delay: 160.ms,
                      duration: 400.ms,
                      curve: Curves.easeOut,
                    ),
                    const SizedBox(height: 16),
                    _buildTopicCards(),
                    const SizedBox(height: 28),
                    _buildAICard(),
                  ],
                ),
              ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: _surface,
      toolbarHeight: 64,
      centerTitle: false,
      title: Text(
        "Family Planning",
        style: GoogleFonts.philosopher(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: _plum,
        ),
      ),
      leading: IconButton(
        onPressed: () => Get.offAllNamed("/home"),
        icon: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(color: _roseSoft, shape: BoxShape.circle),
          child: Icon(Icons.arrow_back_ios_new_rounded, color: _rose, size: 16),
        ),
      ),
    );
  }

  Widget _buildHeroBanner() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [_violet, _plum],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _violet.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -28,
            bottom: -28,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.06),
              ),
            ),
          ),
          Positioned(
            right: 30,
            top: -12,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.04),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "Personalized for you",
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.white70,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  "Plan Your\nFamily Journey",
                  style: GoogleFonts.philosopher(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Free resources to help you make\ninformed decisions",
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.white.withOpacity(0.75),
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopicCards() {
    final topics = [
      _TopicData(
        svgLocation: "images/pill-light.svg",
        title: "Contraception",
        tag: "Birth control",
        color: _rose,
        soft: _roseSoft,
        onTap:
            () => Get.to(
              () => ContraceptionInfoPage(),
              transition: Transition.rightToLeft,
            ),
      ),
      _TopicData(
        svgLocation: "images/drop-light.svg",
        title: "Fertility",
        tag: "Ovulation & windows",
        color: _emerald,
        soft: _emeraldSoft,
        onTap:
            () => Get.to(
              () => FertilityInfoPage(),
              transition: Transition.rightToLeft,
            ),
      ),
      _TopicData(
        svgLocation: "images/face-mask-light.svg",
        title: "Preconception",
        tag: "Prepare for pregnancy",
        color: _teal,
        soft: _tealSoft,
        onTap:
            () => Get.to(
              () => PreconceptionHealthPage(),
              transition: Transition.rightToLeft,
            ),
      ),
    ];

    return Column(
      children:
          topics.asMap().entries.map((entry) {
            final i = entry.key;
            final t = entry.value;
            return Padding(
              padding: EdgeInsets.only(bottom: i < topics.length - 1 ? 12 : 0),
              child: _TopicCard(data: t)
                  .animate()
                  .fadeIn(
                    delay: (200 + 80 * i).ms,
                    duration: 420.ms,
                    curve: Curves.easeOut,
                  )
                  .slideX(
                    begin: 0.04,
                    end: 0,
                    delay: (200 + 80 * i).ms,
                    duration: 420.ms,
                    curve: Curves.easeOut,
                  ),
            );
          }).toList(),
    );
  }

  Widget _buildAICard() {
    return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _violetSoft,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        PhosphorIcons.brain,
                        color: _violet,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "AI Overview",
                      style: GoogleFonts.philosopher(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: _plum,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  generalInfo,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13.5,
                    color: Colors.black87,
                    height: 1.7,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        )
        .animate()
        .fadeIn(delay: 480.ms, duration: 450.ms, curve: Curves.easeOut)
        .slideY(
          begin: 0.06,
          end: 0,
          delay: 480.ms,
          duration: 450.ms,
          curve: Curves.easeOut,
        );
  }

  Widget _buildBottomCTA() {
    return Container(
      color: _surface,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 12),
          child: GestureDetector(
            onTap: () => makeCall("0800220333"),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(PhosphorIcons.phone, color: Colors.white, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    "Talk to a specialist",
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TopicData {
  final String svgLocation;
  final String title;
  final String tag;
  final Color color;
  final Color soft;
  final VoidCallback onTap;
  const _TopicData({
    required this.svgLocation,
    required this.title,
    required this.tag,
    required this.color,
    required this.soft,
    required this.onTap,
  });
}

class _TopicCard extends StatelessWidget {
  final _TopicData data;
  const _TopicCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: data.onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
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
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: data.soft,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      data.svgLocation,
                      height: 26,
                      color: data.color,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.title,
                        style: GoogleFonts.philosopher(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: _plum,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: data.soft,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          data.tag,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: data.color,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: data.soft,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 13,
                    color: data.color,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
