import 'package:bridge_ai/constants/app_constants.dart';
import 'package:bridge_ai/controllers/ai_controller.dart';
import 'package:bridge_ai/pages/home/extra_pages/family_planning_pages/contraceptions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class PreconceptionHealthPage extends StatefulWidget {
  @override
  State<PreconceptionHealthPage> createState() =>
      _PreconceptionHealthPageState();
}

class _PreconceptionHealthPageState extends State<PreconceptionHealthPage> {
  @override
  void initState() {
    super.initState();
    getInfo();
  }

  getInfo() async {
    generalInfo = await VertexAIController.suggestFamilyPlanningSpecificInfo(
      "Preconception Health",
    );
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
          "Preconception Health",
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
                        "https://www.youtube.com/watch?v=_VFpryoUI6g&pp=ygUebnV0aXJpdGlvbiByZXByb2R1Y3RpdmUgaGVhbHRo",
                    title: "Nutrition",
                    details:
                        "A healthy diet rich in folic acid, iron, calcium, and vitamins is essential before conception. Proper nutrition supports reproductive health and prepares the body for pregnancy.",
                  ),
                  SizedBox(height: 12),
                  FamilyPlanningIndividualWidget(
                    link:
                        "https://www.youtube.com/watch?v=yXe2JxzGYxg&pp=ygUcZXhlcmNpc2UgcmVwcm9kdWN0aXZlIGhlYWx0aA%3D%3D",
                    title: "Exercise",
                    details:
                        "Regular physical activity improves overall health, maintains a healthy weight, and can support fertility. Moderate exercise like walking, swimming, or yoga is beneficial.",
                  ),
                  SizedBox(height: 12),
                  FamilyPlanningIndividualWidget(
                    link:
                        "https://www.youtube.com/watch?v=YcxLWhap46k&pp=ygUhbWVudGFsIGhlYWx0aCByZXByb2R1Y3RpdmUgaGVhbHRo0gcJCd4JAYcqIYzv",
                    title: "Mental Health",
                    details:
                        "Mental well-being is important before pregnancy. Managing stress, addressing anxiety or depression, and seeking emotional support can help create a healthy environment for conception.",
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
