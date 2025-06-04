import 'package:bridge_ai/constants/app_constants.dart';
import 'package:bridge_ai/constants/controllers.dart';
import 'package:bridge_ai/pages/home/extra_pages/due_date.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class PeriodTrackerScreen extends StatefulWidget {
  @override
  _PeriodTrackerScreenState createState() => _PeriodTrackerScreenState();
}

class _PeriodTrackerScreenState extends State<PeriodTrackerScreen> {
  final DateTime lastPeriodStartDate =
      userController.userModel.value!.perioddate ?? DateTime.now();
  final int periodLength = userController.userModel.value!.periodLength;
  final int cycleLength = userController.userModel.value!.periodCycle;

  DateTime _displayedMonth = DateTime(
    DateTime.now().year,
    DateTime.now().month,
  );

  void _goToPreviousMonth() {
    setState(() {
      _displayedMonth = DateTime(
        _displayedMonth.year,
        _displayedMonth.month - 1,
      );
    });
  }

  void _goToNextMonth() {
    setState(() {
      _displayedMonth = DateTime(
        _displayedMonth.year,
        _displayedMonth.month + 1,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final currentStatus = getCycleDayType(
      today,
      lastPeriodStartDate,
      periodLength,
      cycleLength,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Period Tracker",
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
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          MonthCalendarView(
            month: getMonthYearLabel(_displayedMonth),
            year: _displayedMonth.year,
            monthNumber: _displayedMonth.month,
            lastPeriodStartDate: lastPeriodStartDate,
            periodLength: periodLength,
            cycleLength: cycleLength,
            onPrevMonth: _goToPreviousMonth,
            onNextMonth: _goToNextMonth,
          ),
          SizedBox(height: 24),
          Text(
            getStatusText(currentStatus),
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: Colors.teal,
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              legendDot("Period", Colors.red[200]!),
              legendDot("Fertile", Colors.green[300]!),
              legendDot("Ovulation", Colors.orange[300]!),
              legendDot("Safe", Colors.grey[200]!),
            ],
          ),
          SizedBox(height: 24),
          Text(
            "Your Cycle Stats",
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w600,
              fontSize: 18,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 16),
          CycleInfoTile(
            label: "Average Cycle Length",
            value: "$cycleLength days",
          ),
          SizedBox(height: 8),
          CycleInfoTile(
            label: "Average Period Length",
            value: "$periodLength days",
          ),
          SizedBox(height: 24),
          Text(
            "Log Symptoms",
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w600,
              fontSize: 18,
              color: Colors.black87,
            ),
          ),
          SymptomTile(title: "Mood"),
          SymptomTile(title: "Flow"),
          SymptomTile(title: "Symptoms"),
          SymptomTile(title: "Notes"),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              Get.to(
                () => DueDateCalculatorScreen(),
                transition: Transition.rightToLeft,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              minimumSize: Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              "Change Period Data",
              style: GoogleFonts.montserrat(fontSize: 14, color: Colors.white),
            ),
          ),
          SizedBox(height: 24),
        ],
      ),
    );
  }
}

String getMonthYearLabel(DateTime date) {
  final monthNames = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December",
  ];
  return "${monthNames[date.month - 1]} ${date.year}";
}

class MonthCalendarView extends StatelessWidget {
  final String month;
  final int year;
  final int monthNumber;
  final DateTime lastPeriodStartDate;
  final int periodLength;
  final int cycleLength;
  final VoidCallback onPrevMonth;
  final VoidCallback onNextMonth;

  const MonthCalendarView({
    required this.month,
    required this.year,
    required this.monthNumber,
    required this.lastPeriodStartDate,
    required this.periodLength,
    required this.cycleLength,
    required this.onPrevMonth,
    required this.onNextMonth,
  });

  @override
  Widget build(BuildContext context) {
    final daysInMonth = DateUtils.getDaysInMonth(year, monthNumber);
    final firstWeekday = DateTime(year, monthNumber, 1).weekday % 7;
    final totalCells = ((daysInMonth + firstWeekday) / 7).ceil() * 7;

    return Container(
      decoration: BoxDecoration(
        color: bgcolor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.chevron_left),
                  onPressed: onPrevMonth,
                ),
                Text(
                  month,
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.chevron_right),
                  onPressed: onNextMonth,
                ),
              ],
            ),
            SizedBox(height: 12),
            Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                TableRow(
                  children:
                      ["S", "M", "T", "W", "T", "F", "S"]
                          .map(
                            (e) => Center(
                              child: Text(
                                e,
                                style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                ),
                ...List.generate((totalCells / 7).ceil(), (week) {
                  return TableRow(
                    children: List.generate(7, (day) {
                      int dayNum = week * 7 + day - firstWeekday + 1;
                      if (dayNum < 1 || dayNum > daysInMonth) return SizedBox();

                      DateTime date = DateTime(year, monthNumber, dayNum);
                      CycleDayType type = getCycleDayType(
                        date,
                        lastPeriodStartDate,
                        periodLength,
                        cycleLength,
                      );

                      Color? bgColor;
                      switch (type) {
                        case CycleDayType.period:
                          bgColor = Colors.red[200];
                          break;
                        case CycleDayType.fertile:
                          bgColor = Colors.green[300];
                          break;
                        case CycleDayType.ovulation:
                          bgColor = Colors.orange[300];
                          break;
                        case CycleDayType.safe:
                          bgColor = Colors.grey[200];
                          break;
                      }

                      return Container(
                        margin: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: bgColor,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            "$dayNum",
                            style: GoogleFonts.montserrat(
                              fontSize: 12,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      );
                    }),
                  );
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

enum CycleDayType { period, fertile, ovulation, safe }

CycleDayType getCycleDayType(
  DateTime currentDate,
  DateTime lastPeriodStartDate,
  int periodLength,
  int cycleLength,
) {
  final daysSinceLastPeriod =
      currentDate.difference(lastPeriodStartDate).inDays % cycleLength;
  if (daysSinceLastPeriod < periodLength) return CycleDayType.period;

  final ovulationDay = 14;
  final fertileStart = ovulationDay - 5;
  final fertileEnd = ovulationDay + 1;

  if (daysSinceLastPeriod == ovulationDay) return CycleDayType.ovulation;
  if (daysSinceLastPeriod >= fertileStart && daysSinceLastPeriod <= fertileEnd)
    return CycleDayType.fertile;

  return CycleDayType.safe;
}

String getStatusText(CycleDayType type) {
  switch (type) {
    case CycleDayType.period:
      return "You are currently on your period.";
    case CycleDayType.ovulation:
      return "You're ovulating today. High chance of pregnancy.";
    case CycleDayType.fertile:
      return "You're in your fertile window.";
    case CycleDayType.safe:
      return "You are less likely to get pregnant.";
  }
}

Widget legendDot(String label, Color color) {
  return Row(
    children: [
      Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
      SizedBox(width: 6),
      Text(
        label,
        style: GoogleFonts.montserrat(fontSize: 12, color: Colors.black87),
      ),
    ],
  );
}

class CycleInfoTile extends StatelessWidget {
  final String label;
  final String value;

  const CycleInfoTile({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: bgcolor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(
          PhosphorIcons.calendar(PhosphorIconsStyle.light),
          color: Colors.black,
        ),
        title: Text(
          label,
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w500,
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
        subtitle: Text(
          value,
          style: GoogleFonts.montserrat(fontSize: 12, color: Colors.black87),
        ),
      ),
    );
  }
}

class SymptomTile extends StatelessWidget {
  final String title;

  const SymptomTile({required this.title});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: GoogleFonts.montserrat(
          fontWeight: FontWeight.w500,
          fontSize: 14,
          color: Colors.black87,
        ),
      ),
      trailing: Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        appCommunication(
          context,
          title,
          "This section is not yet available for you",
          "/home",
        );
      },
    );
  }
}
