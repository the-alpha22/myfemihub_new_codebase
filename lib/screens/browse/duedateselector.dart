import 'package:bridge_ai/constants/app_constants.dart';
import 'package:bridge_ai/constants/controllers.dart';
import 'package:bridge_ai/controllers/sms.dart';
import 'package:bridge_ai/waiting.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class DueDatePage extends StatefulWidget {
  @override
  _DueDatePageState createState() => _DueDatePageState();
}

class _DueDatePageState extends State<DueDatePage> {
  late DateTime? _selectedDate;
  final trimesterDuration = Duration(days: 91);
  List<DateTime> firstTrimesterDates = [];
  List<DateTime> secondTrimesterDates = [];
  List<DateTime> thirdTrimesterDates = [];

  void initState() {
    super.initState();

    if (userController.userModel.value!.duedate != null) {
      _calculatePossibleTrimester(
          userController.userModel.value!.duedate.toDate());
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
              userController.userModel.value!.duedate == null
                  ? 'Add Your Due Date'
                  : 'Your Pregnancy Calendar',
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
        body: userController.userModel.value!.duedate == null
            ? Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Select your due date:',
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
                          lastDate: DateTime(2040),
                        );
                        setState(() {
                          _selectedDate = selectedDate!;
                          userController
                              .updateUserData({"duedate": _selectedDate});
                          _calculatePossibleTrimester(_selectedDate!);
                          Get.offAll(() => Waiting());
                          userController.sendEmail(
                              "${userController.userModel.value!.name.capitalize}",
                              userController.userModel.value!.email,
                              "We noticed that you recently updated your due date on Bridge Mom. We appreciate you taking the time to keep your information up-to-date.\n\nWe also want to make sure that you're connected with other moms-to-be who are in the same stage of pregnancy as you. We'll update your profile in our community so that you can connect with other moms who are due around the same time.\n\nThank you again for updating your due date. We're here to support you every step of the way!",
                              "Thank you for updating your due date!");
                          SendSms().sendSms(
                              userController.userModel.value!.phone
                                  .substring(1),
                              "Hi ${userController.userModel.value!.name.capitalize},+your+due+date+has+been+updated+successfully...++Message+from+Obtek+on+behalf+of+Bridge+Mom+App");
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 16.0),
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
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                        "Not sure, you can try using our due date calculator function in the browse section",
                        style: GoogleFonts.poppins(
                          color: Colors.black.withOpacity(0.4),
                          fontSize: 12,
                        )),
                    SizedBox(
                      height: 8,
                    ),
                  ],
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                        "Below is a calendar that shows your approximate trimester dates",
                        style: GoogleFonts.poppins(
                          color: Colors.black.withOpacity(0.4),
                          fontSize: 12,
                        )),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                        "You have ${DateTime.now().difference(userController.userModel.value!.duedate.toDate()).inDays * -1} to go",
                        style: GoogleFonts.poppins(
                          color: Colors.black.withOpacity(0.4),
                          fontSize: 12,
                        )),
                    SizedBox(
                      height: 40,
                    ),
                    Expanded(
                      child: SfCalendar(
                        view: CalendarView.month,
                        dataSource: _getCalendarDataSource(),
                        monthViewSettings: MonthViewSettings(showAgenda: true),
                        showNavigationArrow: true,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final selectedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2040),
                        );
                        setState(() {
                          _selectedDate = selectedDate;
                          userController
                              .updateUserData({"duedate": _selectedDate});
                          _calculatePossibleTrimester(_selectedDate!);
                          Get.offAll(() => Waiting());
                          userController.sendEmail(
                              "${userController.userModel.value!.name.capitalize}",
                              userController.userModel.value!.email,
                              "We noticed that you recently updated your due date on Bridge Mom. We appreciate you taking the time to keep your information up-to-date.\n\nWe also want to make sure that you're connected with other moms-to-be who are in the same stage of pregnancy as you. We'll update your profile in our community so that you can connect with other moms who are due around the same time.\n\nThank you again for updating your due date. We're here to support you every step of the way!",
                              "Thank you for updating your due date!");
                          SendSms().sendSms(
                              userController.userModel.value!.phone
                                  .substring(1),
                              "Hi ${userController.userModel.value!.name.capitalize},+your+due+date+has+been+updated+successfully...++Message+from+Obtek+on+behalf+of+Bridge+Mom+App");
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text('Update your Due Date',
                            style: GoogleFonts.poppins(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 14,
                            )),
                      ),
                    ),
                  ],
                ),
              ));
  }

  List<DateTime> _calculatePossibleTrimester(DateTime duedate) {
    final firstTrimesterStart = duedate.subtract(trimesterDuration * 3);

    final secondTrimesterStart = duedate.subtract(trimesterDuration * 2);

    final thirdTrimesterStart = duedate.subtract(trimesterDuration);

    for (int i = 1; i < 91; i++) {
      DateTime possibleDate = firstTrimesterStart.add(Duration(days: i));
      firstTrimesterDates.add(possibleDate);
    }
    for (int i = 1; i < 91; i++) {
      DateTime possibleDate = secondTrimesterStart.add(Duration(days: i));
      secondTrimesterDates.add(possibleDate);
    }
    for (int i = 1; i < 91; i++) {
      DateTime possibleDate = thirdTrimesterStart.add(Duration(days: i));
      thirdTrimesterDates.add(possibleDate);
    }

    return firstTrimesterDates;
  }

  CalendarDataSource _getCalendarDataSource() {
    List<Appointment> appointments = [];

    // Add First Trimester dates as appointments
    for (DateTime date in firstTrimesterDates) {
      appointments.add(Appointment(
        startTime: date,
        endTime: date,
        isAllDay: true,
        subject: 'First Trimester',
        color: Colors.red,
      ));
    }

    // Add possible Second Trimester dates as appointments
    for (DateTime date in secondTrimesterDates) {
      appointments.add(Appointment(
        startTime: date,
        endTime: date,
        isAllDay: true,
        subject: 'Second Trimester',
        color: Colors.orange,
      ));
    }

    // Add possible Third Trimester dates as appointments
    for (DateTime date in thirdTrimesterDates) {
      appointments.add(Appointment(
        startTime: date,
        endTime: date,
        isAllDay: true,
        subject: 'Third Trimester',
        color: Colors.green,
      ));
    }

    return _AppointmentDataSource(appointments);
  }
}

class _AppointmentDataSource extends CalendarDataSource {
  _AppointmentDataSource(List<Appointment> source) {
    appointments = source;
  }
}
