import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bridge_ai/constants/app_constants.dart';
import 'package:bridge_ai/constants/controllers.dart';
import 'package:bridge_ai/pages/home/extra_pages/period_tracker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class DueDateCalculatorScreen extends StatefulWidget {
  @override
  _DueDateCalculatorScreenState createState() =>
      _DueDateCalculatorScreenState();
}

class _DueDateCalculatorScreenState extends State<DueDateCalculatorScreen> {
  final TextEditingController _periodLengthController = TextEditingController(
    text: '3',
  );
  final TextEditingController _cycleLengthController = TextEditingController(
    text: '28',
  );
  final TextEditingController _lastPeriodController = TextEditingController();
  DateTime? _selectedDate;

  void _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _lastPeriodController.text = DateFormat('MM/dd/yyyy').format(picked);
      });
    }
  }

  void _addPeriodData() async {
    if (_selectedDate == null) return;
    int cycleLength = int.tryParse(_cycleLengthController.text) ?? 28;
    int periodLength = int.tryParse(_periodLengthController.text) ?? 5;

    await userController.updateUserData({
      "perioddate": Timestamp.fromDate(_selectedDate!),
      "periodLength": periodLength,
      "periodCycle": cycleLength,
    });

    setState(() {
      userController.userModel.value!.perioddate = _selectedDate!;
      userController.userModel.value!.periodCycle = cycleLength;
      userController.userModel.value!.periodLength = periodLength;
    });
    Get.to(() => PeriodTrackerScreen(), transition: Transition.rightToLeft);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Period Data",
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
            _buildInputField("Period length", _periodLengthController),
            SizedBox(height: 16),
            _buildInputField("Cycle length", _cycleLengthController),
            SizedBox(height: 16),
            GestureDetector(
              onTap: _pickDate,
              child: AbsorbPointer(
                child: _buildInputField(
                  "Start date of last period",
                  _lastPeriodController,
                  hintText: "MM/DD/YYYY",
                ),
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _addPeriodData,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                "Add Period Data",
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 80,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            "Please provide us with your period data to start using FemiHub's period tracker",
            style: GoogleFonts.montserrat(fontSize: 12, color: Colors.black87),
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
