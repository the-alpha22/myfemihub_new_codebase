// ignore_for_file: deprecated_member_use

import 'package:bridge_ai/constants/app_constants.dart';
import 'package:bridge_ai/constants/controllers.dart';
import 'package:bridge_ai/controllers/ai_controller.dart';
import 'package:bridge_ai/pages/home/extra_pages/due_date.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

class PeriodTrackerScreen extends StatefulWidget {
  @override
  _PeriodTrackerScreenState createState() => _PeriodTrackerScreenState();
}

class _PeriodTrackerScreenState extends State<PeriodTrackerScreen> {
  @override
  void initState() {
    super.initState();
    getInfo();
  }

  late final DateTime lastPeriodStartDate =
      userController.userModel.value!.perioddate ?? DateTime.now();
  late final int periodLength = userController.userModel.value!.periodLength;
  late final int cycleLength = userController.userModel.value!.periodCycle;

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

  String generalInfo = "";

  Future<void> getInfo() async {
    final today = DateTime.now();
    final currentPeriodStatus = calculateCycleDayType(
      today,
      lastPeriodStartDate,
      periodLength,
      cycleLength,
    );
    String stage = getPeriodStageText(currentPeriodStatus);
    generalInfo = await VertexAIController.suggestGeneralPeriodInfo(stage);
    setState(() {
      isLoading = false;
    });
    notificationPrompt.showNotification(
      flutterLocalNotificationsPlugin,
      "Hi ${userController.userModel.value!.name.capitalize}",
      "Learn more about your current period stage",
      "firebase",
      "femihub",
      1,
      "/home",
    );
  }

  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final currentStatus = calculateCycleDayType(
      today,
      lastPeriodStartDate,
      periodLength,
      cycleLength,
    );

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        toolbarHeight: 70,
        centerTitle: false,
        title: Text(
          "Period Tracker",
          style: GoogleFonts.montserrat(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Get.offAllNamed("/home");
          },
          icon: Icon(Icons.arrow_back_ios, color: Colors.black87, size: 18),
        ),
      ),
      backgroundColor: const Color(0xFFFAFAFA),
      body:
          isLoading
              ? Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 60),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Lottie.asset(
                      'images/femihub_loading.json',
                      repeat: true,
                      frameRate: FrameRate(30),
                      height: 160,
                    ),
                  ),
                ),
              )
              : ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                children: [
                  const SizedBox(height: 8),
                  _buildStatusCard(currentStatus),
                  const SizedBox(height: 32),
                  _buildCalendarSection(),
                  const SizedBox(height: 32),
                  _buildLegendSection(),
                  const SizedBox(height: 32),
                  _buildInfoSection(),
                  const SizedBox(height: 32),
                  _buildCycleStatsSection(),
                  const SizedBox(height: 32),
                  _buildToolsSection(currentStatus),
                  const SizedBox(height: 20),
                ],
              ),
    );
  }

  Widget _buildStatusCard(CycleDayType currentStatus) {
    final statusInfo = _getStatusInfo(currentStatus);
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            statusInfo['color'].withOpacity(0.15),
            statusInfo['color'].withOpacity(0.08),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: statusInfo['color'].withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: statusInfo['color'].withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Icon(
                  statusInfo['icon'],
                  color: statusInfo['color'],
                  size: 24,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    statusInfo['title'],
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    statusInfo['subtitle'],
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w400,
                      fontSize: 13,
                      color: Colors.black54,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Map<String, dynamic> _getStatusInfo(CycleDayType type) {
    switch (type) {
      case CycleDayType.period:
        return {
          'title': 'On Your Period',
          'subtitle': 'Low fertility - Focus on self-care',
          'color': const Color(0xFFE91E63),
          'icon': PhosphorIcons.drop,
        };
      case CycleDayType.ovulation:
        return {
          'title': 'Ovulating Today',
          'subtitle': 'Highest fertility - Best time to conceive',
          'color': const Color(0xFFFFA726),
          'icon': PhosphorIcons.sparkle,
        };
      case CycleDayType.fertile:
        return {
          'title': 'Fertile Window',
          'subtitle': 'High fertility - Best days to conceive',
          'color': const Color(0xFF66BB6A),
          'icon': PhosphorIcons.heart,
        };
      case CycleDayType.safe:
        return {
          'title': 'Safe Window',
          'subtitle': 'Low fertility - Unlikely to conceive',
          'color': const Color(0xFF42A5F5),
          'icon': PhosphorIcons.checkCircle,
        };
    }
  }

  Widget _buildCalendarSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Cycle',
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
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
      ],
    );
  }

  Widget _buildLegendSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Cycle Phases',
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _buildLegendChip('Period', const Color(0xFFE91E63)),
            _buildLegendChip('Fertile', const Color(0xFF66BB6A)),
            _buildLegendChip('Ovulation', const Color(0xFFFFA726)),
            _buildLegendChip('Safe', const Color(0xFF42A5F5)),
          ],
        ),
      ],
    );
  }

  Widget _buildLegendChip(String label, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade100, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w500,
                fontSize: 12,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'About This Phase',
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade100, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 6,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              generalInfo,
              style: GoogleFonts.montserrat(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.black87,
                height: 1.6,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCycleStatsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Cycle Stats',
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                icon: PhosphorIcons.calendar,
                label: 'Cycle Length',
                value: '$cycleLength days',
                color: primaryColor,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                icon: PhosphorIcons.drop,
                label: 'Period Length',
                value: '$periodLength days',
                color: const Color(0xFFE91E63),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(child: Icon(icon, color: color, size: 20)),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w500,
                fontSize: 12,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToolsSection(CycleDayType currentStatus) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Explore More',
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        SymptomTile(
          title: 'Get Recommendations',
          stage: getPeriodStageText(currentStatus),
        ),
        const SizedBox(height: 12),
        SymptomTile(
          title: 'Learn About Your Symptoms',
          stage: getPeriodStageText(currentStatus),
        ),
        const SizedBox(height: 16),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              Get.to(
                () => DueDateCalculatorScreen(),
                transition: Transition.rightToLeft,
              );
            },
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [primaryColor, primaryColor.withOpacity(0.9)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.25),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  'Update Period Data',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.chevron_left, color: Colors.black87),
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
                  icon: Icon(Icons.chevron_right, color: Colors.black87),
                  onPressed: onNextMonth,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                TableRow(
                  children:
                      ["S", "M", "T", "W", "T", "F", "S"]
                          .map(
                            (e) => Center(
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Text(
                                  e,
                                  style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: Colors.black54,
                                  ),
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
                      if (dayNum < 1 || dayNum > daysInMonth) {
                        return const SizedBox();
                      }

                      DateTime date = DateTime(year, monthNumber, dayNum);
                      CycleDayType type = calculateCycleDayType(
                        date,
                        lastPeriodStartDate,
                        periodLength,
                        cycleLength,
                      );

                      Color bgColor = _getDayColor(type);
                      bool isToday =
                          date.year == DateTime.now().year &&
                          date.month == DateTime.now().month &&
                          date.day == DateTime.now().day;

                      return Padding(
                        padding: const EdgeInsets.all(4),
                        child: Container(
                          decoration: BoxDecoration(
                            color: bgColor,
                            shape: BoxShape.circle,
                            border:
                                isToday
                                    ? Border.all(
                                      color: Colors.black87,
                                      width: 2,
                                    )
                                    : null,
                          ),
                          child: Center(
                            child: Text(
                              "$dayNum",
                              style: GoogleFonts.montserrat(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
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

  Color _getDayColor(CycleDayType type) {
    switch (type) {
      case CycleDayType.period:
        return const Color(0xFFE91E63).withOpacity(0.2);
      case CycleDayType.fertile:
        return const Color(0xFF66BB6A).withOpacity(0.2);
      case CycleDayType.ovulation:
        return const Color(0xFFFFA726).withOpacity(0.2);
      case CycleDayType.safe:
        return const Color(0xFF42A5F5).withOpacity(0.2);
    }
  }
}

enum CycleDayType { period, fertile, ovulation, safe }

CycleDayType calculateCycleDayType(
  DateTime currentDate,
  DateTime lastPeriodStartDate,
  int periodLength,
  int cycleLength,
) {
  final daysSinceLastPeriod =
      currentDate.difference(lastPeriodStartDate).inDays;

  if (daysSinceLastPeriod < 0) {
    return CycleDayType.safe;
  }

  final cyclePosition = daysSinceLastPeriod % cycleLength;

  if (cyclePosition < periodLength) {
    return CycleDayType.period;
  }

  final ovulationDay = (cycleLength ~/ 2).clamp(10, 18);
  final fertileWindowStart = (ovulationDay - 5).clamp(0, cycleLength - 1);
  final fertileWindowEnd = (ovulationDay + 1).clamp(0, cycleLength - 1);

  if (cyclePosition == ovulationDay) {
    return CycleDayType.ovulation;
  }

  if (cyclePosition >= fertileWindowStart &&
      cyclePosition <= fertileWindowEnd) {
    return CycleDayType.fertile;
  }

  return CycleDayType.safe;
}

String getStatusText(CycleDayType type) {
  switch (type) {
    case CycleDayType.period:
      return "You are currently on your period.";
    case CycleDayType.ovulation:
      return "You're ovulating today. Highest fertility.";
    case CycleDayType.fertile:
      return "You're in your fertile window.";
    case CycleDayType.safe:
      return "You are in your safe window.";
  }
}

String getPeriodStageText(CycleDayType type) {
  switch (type) {
    case CycleDayType.period:
      return "period stage";
    case CycleDayType.ovulation:
      return "ovulation";
    case CycleDayType.fertile:
      return "fertile window";
    case CycleDayType.safe:
      return "safe window";
  }
}

class SymptomTile extends StatefulWidget {
  final String title;
  final String stage;

  const SymptomTile({required this.title, required this.stage});

  @override
  State<SymptomTile> createState() => _SymptomTileState();
}

class _SymptomTileState extends State<SymptomTile> {
  bool expanding = false;
  String info = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () async {
            if (info.isEmpty && !expanding) {
              setState(() {
                expanding = true;
              });

              if (widget.title == "Get Recommendations") {
                appCommunication(
                  context,
                  widget.title,
                  "Generating recommendations",
                  "/home",
                );
                info =
                    await VertexAIController.suggestGeneralPeriodRecommendation(
                      widget.stage,
                    );
              } else {
                appCommunication(
                  context,
                  widget.title,
                  "Generating symptoms",
                  "/home",
                );
                info = await VertexAIController.suggestGeneralPeriodSymptoms(
                  widget.stage,
                );
              }

              setState(() {
                expanding = false;
              });
            } else {
              setState(() {
                info = "";
              });
            }
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.title,
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: Colors.black87,
                      ),
                    ),
                    Icon(
                      info.isEmpty
                          ? Icons.arrow_forward_ios
                          : Icons.expand_less,
                      size: 16,
                      color: Colors.grey.shade400,
                    ),
                  ],
                ),
                if (info.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    info,
                    style: GoogleFonts.montserrat(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: Colors.black87,
                      height: 1.6,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
