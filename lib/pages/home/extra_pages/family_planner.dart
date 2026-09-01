// ignore_for_file: deprecated_member_use

import 'package:bridge_ai/constants/app_constants.dart';
import 'package:bridge_ai/controllers/ai_controller.dart';
import 'package:bridge_ai/pages/home/extra_pages/family_planning_pages/contraceptions.dart';
import 'package:bridge_ai/pages/home/extra_pages/family_planning_pages/fertility.dart';
import 'package:bridge_ai/pages/home/extra_pages/family_planning_pages/preconception_health.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class FamilyPlanningPage extends StatefulWidget {
  const FamilyPlanningPage({super.key});

  @override
  State<FamilyPlanningPage> createState() => _FamilyPlanningPageState();
}

class _FamilyPlanningPageState extends State<FamilyPlanningPage> {
  @override
  void initState() {
    super.initState();
    getInfo();
  }

  Future<void> getInfo() async {
    generalInfo = await VertexAIController.suggestFamilyPlanningInfo();
    setState(() {
      isLoading = false;
    });
  }

  bool isLoading = true;
  String generalInfo = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        toolbarHeight: 70,
        centerTitle: false,
        title: Text(
          "Family Planning",
          style: GoogleFonts.montserrat(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Get.offAllNamed("/home");
          },
          icon: Icon(Icons.arrow_back_ios, color: Colors.black87, size: 18),
        ),
      ),
      backgroundColor: const Color(0xFFFAFAFA),
      body:
          isLoading
              ? Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 60),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Lottie.asset(
                      'images/femihub_loading.json',
                      repeat: true,
                      frameRate: FrameRate(30),
                      height: 160,
                    ),
                  ),
                ),
              )
              : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 4,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeaderSection(),
                      const SizedBox(height: 32),
                      _buildResourceCards(),
                      const SizedBox(height: 40),
                      _buildInfoSection(),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
      bottomNavigationBar: _buildBottomCTA(),
    );
  }

  Widget _buildHeaderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Family Planning Resources',
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w600,
            fontSize: 24,
            color: Colors.black87,
            height: 1.3,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Access free education and resources to make informed decisions about your family planning',
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: Colors.black54,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildResourceCards() {
    return Column(
      children: [
        _buildResourceCard(
          svgLocation: "images/pill-light.svg",
          title: "Contraceptions",
          subtitle:
              "Explore different birth control methods and their effectiveness",
          backgroundColor: primaryColor,
          onTap: () {
            Get.to(
              () => ContraceptionInfoPage(),
              transition: Transition.rightToLeft,
            );
          },
        ),
        const SizedBox(height: 12),
        _buildResourceCard(
          svgLocation: "images/drop-light.svg",
          title: "Fertility",
          subtitle: "Learn about your fertility window and ovulation tracking",
          backgroundColor: const Color(0xFF1A8820),
          onTap: () {
            Get.to(
              () => FertilityInfoPage(),
              transition: Transition.rightToLeft,
            );
          },
        ),
        const SizedBox(height: 12),
        _buildResourceCard(
          svgLocation: "images/face-mask-light.svg",
          title: "Preconception Health",
          subtitle: "Prepare your body and mind for pregnancy",
          backgroundColor: Colors.teal,
          onTap: () {
            Get.to(
              () => PreconceptionHealthPage(),
              transition: Transition.rightToLeft,
            );
          },
        ),
      ],
    );
  }

  Widget _buildResourceCard({
    required String svgLocation,
    required String title,
    required String subtitle,
    required Color backgroundColor,
    required Function() onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade100, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: backgroundColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      svgLocation,
                      height: 32,
                      color: backgroundColor,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        subtitle,
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w400,
                          fontSize: 13,
                          color: Colors.black54,
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey.shade400,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'General Information',
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade100, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 6,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              generalInfo,
              style: GoogleFonts.montserrat(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.black87,
                height: 1.6,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomCTA() {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                makeCall("0800220333");
              },
              borderRadius: BorderRadius.circular(10),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [primaryColor, primaryColor.withOpacity(0.9)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.25),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.phone_outlined, color: Colors.white, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        'Talk to us for more information',
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
