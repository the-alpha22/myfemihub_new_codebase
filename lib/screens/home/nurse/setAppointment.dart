import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class AppointmentScreen extends StatefulWidget {
  @override
  _AppointmentScreenState createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  late DateTime? date;
  String selected = "";
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var today = DateTime.now();
    void getDate(
      CalendarTapDetails details,
    ) {
      setState(selected) {
        selected = DateFormat('EEEE dd, MMMM yyyy').format(date!);
      }

      if (details.targetElement == CalendarElement.calendarCell) {
        date = details.date;
        selected = DateFormat('EEEE dd, MMMM yyyy').format(date!);
        setState(selected);
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text('SELECTED DATE OF APPOINTMENT',
                style: GoogleFonts.poppins(
                    color: Colors.black.withOpacity(0.9), fontSize: 16)),
            content: Text(selected,
                style: GoogleFonts.poppins(
                    color: Colors.black.withOpacity(0.9), fontSize: 16)),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text('OKAY'),
              ),
            ],
          ),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Schedule Appointment',
            style: GoogleFonts.poppins(
              color: Colors.black.withOpacity(0.8),
              fontSize: 13,
            )),
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black.withOpacity(0.7),
              size: 18,
            )),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            SfCalendar(
              minDate: DateTime(today.year, today.month, today.day),
              view: CalendarView.month,
              onTap: getDate,
            ),
            SizedBox(
              height: 16,
            ),
            FormBuilder(
              key: _formKey,
              child: Column(
                children: [
                  FormBuilderTextField(
                    name: 'email',
                    decoration: InputDecoration(
                        labelText: "Patient's Email",
                        labelStyle: GoogleFonts.poppins(
                          color: Colors.black.withOpacity(0.4),
                          fontSize: 14,
                        )),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  FormBuilderDateTimePicker(
                    name: 'time',
                    inputType: InputType.time,
                    decoration: InputDecoration(
                        labelText: 'Appointment Time',
                        labelStyle: GoogleFonts.poppins(
                          color: Colors.black.withOpacity(0.4),
                          fontSize: 14,
                        )),
                    initialTime: TimeOfDay.now(),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 16,
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.saveAndValidate()) {
                  // Add code here to save appointment to database or send to backend
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Schedule Appointment',
                  style: GoogleFonts.poppins(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
