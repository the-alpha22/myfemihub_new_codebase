import 'package:bridge_ai/constants/app_constants.dart';
import 'package:bridge_ai/controllers/ai_controller.dart';
import 'package:bridge_ai/pages/home/extra_pages/family_planning_pages/contraceptions.dart';
import 'package:bridge_ai/pages/home/extra_pages/family_planning_pages/fertility.dart';
import 'package:bridge_ai/pages/home/extra_pages/family_planning_pages/preconception_health.dart';
import 'package:bridge_ai/pages/home/home.dart';
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

  getInfo() async {
    generalInfo = await suggestFamilyPlanningInfo();
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
        title: Text(
          "Family Planning",
          style: GoogleFonts.montserrat(fontSize: 14, color: Colors.black87),
        ),
        centerTitle: false,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Get.offAllNamed("/home");
          },
          icon: Icon(Icons.arrow_back_ios, color: Colors.black87, size: 16),
        ),
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body:
          isLoading
              ? Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Lottie.asset(
                    'images/femihub_loading.json',
                    repeat: true,
                    frameRate: FrameRate(30),
                    height: 180,
                  ),
                ),
              )
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HomeTapWidget(
                      svgLocation: "images/pill-light.svg",
                      title: "Contraceptions",
                      description: "Resources about birth control methods",
                      onTap: () {
                        Get.to(
                          () => ContraceptionInfoPage(),
                          transition: Transition.rightToLeft,
                        );
                      },
                      color: primaryColor,
                    ),
                    SizedBox(height: 12),
                    HomeTapWidget(
                      svgLocation: "images/drop-light.svg",
                      title: "Fertility",
                      description: "Resources about fertility",
                      onTap: () {
                        Get.to(
                          () => FertilityInfoPage(),
                          transition: Transition.rightToLeft,
                        );
                      },
                      color: const Color.fromARGB(255, 26, 136, 29),
                    ),
                    SizedBox(height: 12),
                    HomeTapWidget(
                      svgLocation: "images/face-mask-light.svg",
                      title: "Preconception Health",
                      description: "Resources about preconception health",
                      onTap: () {
                        Get.to(
                          () => PreconceptionHealthPage(),
                          transition: Transition.rightToLeft,
                        );
                      },
                      color: Colors.teal,
                    ),
                    SizedBox(height: 24),
                    Container(
                      decoration: BoxDecoration(
                        color: bgcolor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          generalInfo,
                          style: GoogleFonts.montserrat(
                            fontSize: 12,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                  ],
                ),
              ),
      bottomNavigationBar: Container(
        height: 70,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: InkWell(
            onTap: () {
              makeCall("0800220333");
            },
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(color: primaryColor),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    "For more info, Talk to us",
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
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

class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        title,
        style: GoogleFonts.montserrat(
          fontWeight: FontWeight.w600,
          fontSize: 18,
          color: Colors.black87,
        ),
      ),
    );
  }
}

class ToolCard extends StatelessWidget {
  const ToolCard({
    super.key,
    required this.color,
    required this.textColor,
    required this.onTap,
    required this.name,
    required this.svgLocation,
  });
  final Color color;
  final Color textColor;
  final Function() onTap;
  final String name;
  final String svgLocation;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width * .42,
        decoration: BoxDecoration(
          color: color.withOpacity(.4),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: color.withOpacity(.4),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SvgPicture.asset(
                    svgLocation,
                    height: 32.0,
                    color: color,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                name,
                style: GoogleFonts.lato(
                  color: textColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
