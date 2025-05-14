import 'package:bridge_ai/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class DueDateCalculator extends StatefulWidget {
  @override
  _DueDateCalculatorState createState() => _DueDateCalculatorState();
}

class _DueDateCalculatorState extends State<DueDateCalculator> {
  var _selectedDate;
  var _dueDate;

  void _calculateDueDate() {
    if (_selectedDate != null) {
      // Here, you can implement your own logic to calculate the due date based on the selected date.
      // This example calculates the due date as 40 weeks (280 days) from the selected date.
      final dueDate = _selectedDate!.add(Duration(days: 280));
      _dueDate = '${dueDate.day}-${dueDate.month}-${dueDate.year}';
    } else {
      _dueDate = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Due Date Calculator',
            style: GoogleFonts.poppins(
              color: Colors.black.withOpacity(0.8),
              fontSize: 12,
            )),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 19,
            color: Colors.black.withOpacity(0.6),
          ),
          onPressed: () {
            Get.back();
          },
        ),
        elevation: 0,
        backgroundColor: primaryColor,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Select the date of your last menstrual period:',
                style: GoogleFonts.poppins(
                  color: Colors.black.withOpacity(0.8),
                  fontSize: 12,
                )),
            SizedBox(height: 10.0),
            GestureDetector(
              onTap: () async {
                final selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(),
                );
                setState(() {
                  _selectedDate = selectedDate;
                  _calculateDueDate();
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Row(
                  children: [
                    Icon(Icons.calendar_today),
                    SizedBox(width: 10.0),
                    Text(
                        _selectedDate != null
                            ? '${_selectedDate!.day}-${_selectedDate!.month}-${_selectedDate!.year}'
                            : 'Select Date',
                        style: GoogleFonts.poppins(
                          color: Colors.black.withOpacity(0.8),
                          fontSize: 12,
                        )),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.0),
            if (_dueDate != null)
              Text('Your due date is:',
                  style: GoogleFonts.poppins(
                    color: Colors.black.withOpacity(0.8),
                    fontSize: 12,
                  )),
            if (_dueDate != null) SizedBox(height: 10.0),
            if (_dueDate != null)
              Text("$_dueDate",
                  style: GoogleFonts.poppins(
                    color: Colors.black.withOpacity(0.9),
                    fontSize: 16,
                  )),
          ],
        ),
      ),
    );
  }
}
