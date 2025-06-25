import 'package:bridge_ai/constants/app_constants.dart';
import 'package:bridge_ai/constants/controllers.dart';
import 'package:bridge_ai/controllers/ai_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class PregnancyTrackerPage extends StatefulWidget {
  @override
  _PregnancyTrackerPageState createState() => _PregnancyTrackerPageState();
}

class _PregnancyTrackerPageState extends State<PregnancyTrackerPage> {
  DateTime? conceptionDate;
  final int totalPregnancyDays = 280;
  int currentWeek = 0;
  int currentDay = 0;

  @override
  void initState() {
    super.initState();
    loadConceptionDate();
  }

  getInfo() async {
    generalInfo = await suggestPregnancyTip(getTrimester());
    setState(() {});
  }

  Future<void> loadConceptionDate() async {
    if (userController.userModel.value!.conceptionDate != null) {
      setState(() {
        conceptionDate = userController.userModel.value!.conceptionDate;
        calculateProgress();
      });
    } else {
      promptForConceptionDate();
    }
  }

  Future<void> promptForConceptionDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(Duration(days: 100)),
      firstDate: DateTime.now().subtract(Duration(days: 300)),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      await userController.updateUserData({"conceptionDate": pickedDate});
      setState(() {
        userController.userModel.value!.conceptionDate = pickedDate;
        conceptionDate = pickedDate;
        _conceptionDateController.text = DateFormat(
          'MM/dd/yyyy',
        ).format(pickedDate);
        calculateProgress();
      });
    }
  }

  void calculateProgress() async {
    if (conceptionDate == null) return;
    final today = DateTime.now();
    final daysPregnant = today.difference(conceptionDate!).inDays;
    currentWeek = daysPregnant ~/ 7;
    currentDay = daysPregnant % 7;
    await getInfo();
  }

  String getTrimester() {
    if (currentWeek < 13) return '1st Trimester';
    if (currentWeek < 28) return '2nd Trimester';
    return '3rd Trimester';
  }

  String getDateRange() {
    final start = conceptionDate!.add(Duration(days: currentWeek * 7));
    final end = start.add(Duration(days: 6));
    return '${DateFormat("d MMM").format(start)} - ${DateFormat("d MMM").format(end)}';
  }

  String getBabySize() {
    final babySizes = {
      36: 'Squash',
      // Add more weeks and their fruit comparisons here...
    };
    return babySizes[currentWeek] ?? 'Unknown';
  }

  TextEditingController _conceptionDateController = TextEditingController();
  String generalInfo = "Getting daily tip...";

  @override
  Widget build(BuildContext context) {
    if (conceptionDate == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            "Conception Date",
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
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: promptForConceptionDate,
                child: AbsorbPointer(
                  child: _buildInputField(
                    "Choose assumed date of conception",
                    _conceptionDateController,
                    hintText: "MM/DD/YYYY",
                  ),
                ),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  "Upload Your Data",
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final daysLeft = totalPregnancyDays - ((currentWeek * 7) + currentDay);
    final dueDate = conceptionDate!.add(Duration(days: totalPregnancyDays));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Pregnancy Tracker",
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              Text(
                getTrimester(),
                style: GoogleFonts.montserrat(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(getDateRange(), style: GoogleFonts.montserrat(fontSize: 16)),
              SizedBox(height: 20),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Lottie.asset(
                          'images/pregnancy.json',
                          repeat: true,
                          frameRate: FrameRate(30),
                          height: 180,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text(
                              '${(currentWeek * 7) + currentDay}',
                              style: GoogleFonts.montserrat(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Pregnancy\nPeriod",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.montserrat(fontSize: 14),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              '$daysLeft',
                              style: GoogleFonts.montserrat(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Until\nChildbirth",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.montserrat(fontSize: 14),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Text(
                      "$currentWeek weeks $currentDay day left",
                      style: GoogleFonts.montserrat(fontSize: 18),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 12),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: primaryColor),
                ),
                child: Text(
                  "$generalInfo",
                  style: GoogleFonts.montserrat(fontSize: 12),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(
    String label,
    TextEditingController controller, {
    String? hintText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.montserrat(
            fontSize: 14,
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 8),
        TextField(
          controller: controller,
          readOnly: hintText != null,
          style: GoogleFonts.montserrat(fontSize: 12, color: Colors.black87),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: GoogleFonts.montserrat(
              fontSize: 14,
              color: Colors.black54,
            ),
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }
}
