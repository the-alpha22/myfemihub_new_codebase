import 'package:bridge_ai/constants/app_constants.dart';
import 'package:bridge_ai/controllers/ai_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class ContraceptionInfoPage extends StatefulWidget {
  @override
  State<ContraceptionInfoPage> createState() => _ContraceptionInfoPageState();
}

class _ContraceptionInfoPageState extends State<ContraceptionInfoPage> {
  @override
  void initState() {
    super.initState();
    getInfo();
  }

  getInfo() async {
    generalInfo = await suggestFamilyPlanningSpecificInfo("contaceptions");
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
          "Contaceptions",
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
                        "https://www.youtube.com/watch?v=7-7ZgVpUQWM&pp=ygUSY29udHJhY2VwdGl2ZSBwaWxs",
                    title: "Birth control pills",
                    details:
                        "Birth control pills are a hormonal method of contraception that prevents pregnancy by stopping ovulation. They are taken daily and require a prescription from a healthcare provider.",
                  ),
                  SizedBox(height: 12),
                  FamilyPlanningIndividualWidget(
                    link:
                        "https://www.youtube.com/watch?v=h6WGm-O3Fco&pp=ygUESVVEcw%3D%3D",
                    title: "IUDs",
                    details:
                        "IUDs (intrauterine devices) are small T-shaped devices inserted into the uterus to prevent pregnancy. They can be hormonal or non-hormonal and last between 3 to 10 years.",
                  ),
                  SizedBox(height: 12),
                  FamilyPlanningIndividualWidget(
                    link:
                        "https://www.youtube.com/watch?v=4MnsqQwpiwc&pp=ygUHY29uZG9tcw%3D%3D",
                    title: "Condoms",
                    details:
                        "Condoms are barrier methods of contraception that prevent sperm from reaching the egg. They are also effective at preventing sexually transmitted infections (STIs).",
                  ),
                  SizedBox(height: 12),
                  FamilyPlanningIndividualWidget(
                    link:
                        "https://www.youtube.com/watch?v=zaWtI5ljmQs&pp=ygUXZGlhcGhyYWdtIGNvbnRyYWNlcHRpdmU%3D",
                    title: "Diaphragm",
                    details:
                        "A diaphragm is a shallow, dome-shaped cup inserted into the vagina before sex to cover the cervix and block sperm. It must be used with spermicide.",
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

class FamilyPlanningIndividualWidget extends StatefulWidget {
  const FamilyPlanningIndividualWidget({
    super.key,
    required this.title,
    required this.details,
    required this.link,
  });
  final String title;
  final String details;
  final String link;

  @override
  State<FamilyPlanningIndividualWidget> createState() =>
      _FamilyPlanningIndividualWidgetState();
}

class _FamilyPlanningIndividualWidgetState
    extends State<FamilyPlanningIndividualWidget> {
  bool isOpen = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          isOpen = !isOpen;
        });
      },
      child: Container(
        decoration: BoxDecoration(color: isOpen ? Colors.white : bgcolor),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              if (isOpen) ...{
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Container(
                    decoration: BoxDecoration(color: bgcolor),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.details,
                            style: GoogleFonts.montserrat(
                              fontSize: 12,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 8),
                          InkWell(
                            onTap: () {
                              openLink(widget.link);
                            },
                            child: Text(
                              "Learn More",
                              style: GoogleFonts.montserrat(
                                fontSize: 12,
                                color: primaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              },
            ],
          ),
        ),
      ),
    );
  }
}
