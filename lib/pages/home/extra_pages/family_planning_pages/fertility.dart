import 'package:bridge_ai/constants/app_constants.dart';
import 'package:bridge_ai/controllers/ai_controller.dart';
import 'package:bridge_ai/pages/home/extra_pages/family_planning_pages/contraceptions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class FertilityInfoPage extends StatefulWidget {
  @override
  State<FertilityInfoPage> createState() => _FertilityInfoPageState();
}

class _FertilityInfoPageState extends State<FertilityInfoPage> {
  @override
  void initState() {
    super.initState();
    getInfo();
  }

  getInfo() async {
    generalInfo = await suggestFamilyPlanningSpecificInfo("fertility");
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
          "Fertility",
          style: GoogleFonts.montserrat(fontSize: 14, color: Colors.black87),
        ),
        centerTitle: false,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Get.back();
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
              : ListView(
                padding: EdgeInsets.all(12),
                children: [
                  FamilyPlanningIndividualWidget(
                    link:
                        "https://www.youtube.com/watch?v=PX0WOfQAA5w&pp=ygURZmVydGlsaXR5IHRlc3RpbmfSBwkJ3gkBhyohjO8%3D",
                    title: "Fertility Testing",
                    details:
                        "Fertility testing involves a series of evaluations that help determine the cause of fertility issues. These tests may include hormone level assessments, ultrasound scans, and semen analysis for partners.",
                  ),
                  SizedBox(height: 12),
                  FamilyPlanningIndividualWidget(
                    link:
                        "https://www.youtube.com/watch?v=EktKDiUVcR8&pp=ygUSb3Z1bGF0aW9uIHRyYWNraW5n",
                    title: "Ovulation Tracking",
                    details:
                        "Tracking ovulation helps identify the most fertile days of the cycle. Methods include basal body temperature monitoring, ovulation prediction kits, and monitoring cervical mucus.",
                  ),
                  SizedBox(height: 12),
                  FamilyPlanningIndividualWidget(
                    link:
                        "https://www.youtube.com/watch?v=sHXYulkc3S4&pp=ygUWSW4gVml0cm8gRmVydGlsaXphdGlvbg%3D%3D",
                    title: "IVF (In Vitro Fertilization)",
                    details:
                        "IVF is a fertility treatment where eggs are retrieved from the ovaries, fertilized with sperm in a lab, and the resulting embryos are implanted in the uterus. It's used when other treatments haven't worked.",
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
