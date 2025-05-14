import 'package:bridge_ai/constants/app_constants.dart';
import 'package:bridge_ai/constants/controllers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class PeriodTrackerPage extends StatefulWidget {
  @override
  _PeriodTrackerPageState createState() => _PeriodTrackerPageState();
}

class _PeriodTrackerPageState extends State<PeriodTrackerPage> {
  List<DateTime> periodDates = [];
  List<DateTime> possiblePeriodDates = [];
  bool _isLoading = true;

  var selectedDate;

  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 1), () {
      if (userController.userModel.value!.perioddate != null) {
        DateTime perioddate =
            userController.userModel.value!.perioddate.toDate();
        periodDates.add(perioddate);
        possiblePeriodDates = _calculatePossiblePeriodDates(perioddate);
        print(perioddate);
      } else {}
      // Data loading complete
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Period Tracker',
              style: GoogleFonts.poppins(
                color: Colors.white.withOpacity(0.8),
                fontSize: 12,
              )),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              size: 19,
              color: Colors.white.withOpacity(0.6),
            ),
            onPressed: () {
              Get.back();
            },
          ),
          elevation: 0,
          backgroundColor: primaryColor,
        ),
        body: _isLoading == false
            ? Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    if (periodDates.isEmpty ||
                        userController.userModel.value!.perioddate == null) ...[
                      InkWell(
                        onTap: () {},
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.withOpacity(.1),
                                    blurRadius: 2)
                              ]),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  topRight: Radius.circular(8),
                                ),
                                child: CachedNetworkImage(
                                  width: MediaQuery.of(context).size.width,
                                  fit: BoxFit.fill,
                                  imageUrl:
                                      "https://firebasestorage.googleapis.com/v0/b/bridgeai-e6529.appspot.com/o/assets%2Fperiod.jpg?alt=media&token=49a992e8-9e90-4a47-a558-9cef7cc3ec15",
                                  placeholder: (context, url) => Center(
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height:
                                            MediaQuery.of(context).size.width,
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            color: Colors.black,
                                            strokeWidth: 0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                ),
                              ),
                              SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: Text("Keep track of your periods",
                                          style: GoogleFonts.poppins(
                                              color:
                                                  Colors.black.withOpacity(0.8),
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500)),
                                    ),
                                    Text("Don't be caught off guard",
                                        style: GoogleFonts.poppins(
                                          color: Color.fromARGB(
                                              255, 125, 225, 255),
                                          fontSize: 12,
                                        )),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      InkWell(
                        onTap: _selectDate,
                        child: Container(
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(4)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Text('Set up period tracker',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 12,
                                )),
                          ),
                        ),
                      ),
                    ],
                    SizedBox(height: 16),
                    if (periodDates.isNotEmpty) ...[
                      Text(
                          'Your Previous Period Date: ${DateFormat('yyyy-MM-dd').format(periodDates.last)}',
                          style: GoogleFonts.poppins(
                            color: Colors.black.withOpacity(0.8),
                            fontSize: 14,
                          )),
                      SizedBox(height: 16),
                      Expanded(
                        child: SfCalendar(
                          view: CalendarView.month,
                          dataSource: _getCalendarDataSource(),
                          monthViewSettings:
                              MonthViewSettings(showAgenda: true),
                          showNavigationArrow: true,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: _selectDate,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text('Update your Period Date',
                              style: GoogleFonts.poppins(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 14,
                              )),
                        ),
                      ),
                    ],
                  ],
                ),
              )
            : Center(
                child: LoadingAnimationWidget.discreteCircle(
                  color: primaryColor,
                  size: 35,
                ),
              ));
  }

  void _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        userController.updateUserData({"perioddate": pickedDate});
        print(pickedDate);
        periodDates.add(pickedDate);
        possiblePeriodDates = _calculatePossiblePeriodDates(pickedDate);
      });
    }
  }

  List<DateTime> _calculatePossiblePeriodDates(DateTime previousDate) {
    List<DateTime> possibleDates = [];

    for (int i = 1; i <= 12; i++) {
      DateTime possibleDate = previousDate.add(Duration(days: 28 * i));
      possibleDates.add(possibleDate.add(Duration(days: -1)));
      possibleDates.add(possibleDate.add(Duration(days: -2)));
      possibleDates.add(possibleDate);
      possibleDates.add(possibleDate.add(Duration(days: 1)));
      possibleDates.add(possibleDate.add(Duration(days: 2)));
    }

    return possibleDates;
  }

  CalendarDataSource _getCalendarDataSource() {
    List<Appointment> appointments = [];

    // Add period dates as appointments
    for (DateTime date in periodDates) {
      appointments.add(Appointment(
        startTime: date,
        endTime: date,
        isAllDay: true,
        subject: 'Period',
        color: Colors.red,
      ));
    }

    // Add possible period dates as appointments
    for (DateTime date in possiblePeriodDates) {
      appointments.add(Appointment(
        startTime: date,
        endTime: date,
        isAllDay: true,
        subject: 'Possible Period Date',
        color: Colors.pink,
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
