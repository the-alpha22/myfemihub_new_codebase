// ignore_for_file: deprecated_member_use

import 'package:bridge_ai/constants/app_constants.dart';
import 'package:bridge_ai/constants/controllers.dart';
import 'package:bridge_ai/controllers/ai_controller.dart';
import 'package:bridge_ai/pages/home/extra_pages/due_date.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

const _rose = Color(0xFFE8567A);
const _roseDark = Color(0xFFC03A5E);
const _roseSoft = Color(0xFFFFF0F4);
const _plum = Color(0xFF3D1A2E);
const _sage = Color(0xFF6BAF92);
const _amber = Color(0xFFFFA726);
const _muted = Color(0xFF9E8892);
const _surface = Color(0xFFFDF7F9);

// Past period: deep solid rose
const _pastPeriodColor = Color(0xFFB5294E);
// Predicted future period: lighter rose
const _futurePeriodColor = Color(0xFFEF8FAB);
// Past fertile: solid sage
const _pastFertileColor = Color(0xFF4A8F72);
// Predicted future fertile: lighter sage
const _futureFertileColor = Color(0xFFA5D4BE);
// Past ovulation: solid amber
const _pastOvulationColor = Color(0xFFE65100);
// Predicted future ovulation: lighter amber
const _futureOvulationColor = Color(0xFFFFCC80);

class PeriodTrackerScreen extends StatefulWidget {
  @override
  _PeriodTrackerScreenState createState() => _PeriodTrackerScreenState();
}

class _PeriodTrackerScreenState extends State<PeriodTrackerScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  late final DateTime lastPeriodStartDate =
      userController.userModel.value!.perioddate ?? DateTime.now();
  late final int periodLength = userController.userModel.value!.periodLength;
  late final int cycleLength = userController.userModel.value!.periodCycle;

  DateTime _displayedMonth = DateTime(
    DateTime.now().year,
    DateTime.now().month,
  );
  DateTime _selectedDay = DateTime.now();

  String generalInfo = "";
  bool isLoading = true;

  final Map<String, Set<String>> _dailyLogs = {};
  String? _selectedLogDay;

  final List<_LogOption> _symptomOptions = [
    _LogOption('Cramps', PhosphorIcons.lightning, Color(0xFFE8567A)),
    _LogOption('Headache', PhosphorIcons.brain, Color(0xFF9C27B0)),
    _LogOption('Bloating', PhosphorIcons.smileyMeh, Color(0xFF795548)),
    _LogOption('Fatigue', PhosphorIcons.moon, Color(0xFF3F51B5)),
    _LogOption('Back Pain', PhosphorIcons.arrowDown, Color(0xFFFF7043)),
    _LogOption('Nausea', PhosphorIcons.waveSine, Color(0xFF26A69A)),
    _LogOption('Tender Breasts', PhosphorIcons.heartbeat, Color(0xFFEC407A)),
    _LogOption('Acne', PhosphorIcons.dotsSix, Color(0xFFFF8F00)),
  ];

  final List<_LogOption> _moodOptions = [
    _LogOption('Happy', PhosphorIcons.smiley, Color(0xFFFDD835)),
    _LogOption('Sad', PhosphorIcons.smileySad, Color(0xFF42A5F5)),
    _LogOption('Anxious', PhosphorIcons.warning, Color(0xFFFF7043)),
    _LogOption('Irritable', PhosphorIcons.lightning, Color(0xFFEF5350)),
    _LogOption('Calm', PhosphorIcons.leaf, Color(0xFF66BB6A)),
    _LogOption('Energetic', PhosphorIcons.flame, Color(0xFFFFB300)),
    _LogOption('Sensitive', PhosphorIcons.heart, Color(0xFFEC407A)),
    _LogOption('Tired', PhosphorIcons.moon, Color(0xFF7986CB)),
  ];

  final List<_LogOption> _flowOptions = [
    _LogOption('Spotting', PhosphorIcons.dropHalf, Color(0xFFEF9A9A)),
    _LogOption('Light', PhosphorIcons.drop, Color(0xFFE57373)),
    _LogOption('Medium', PhosphorIcons.dropSlash, Color(0xFFE53935)),
    _LogOption('Heavy', PhosphorIcons.waveform, Color(0xFFB71C1C)),
  ];

  final List<_LogOption> _energyOptions = [
    _LogOption('Very Low', PhosphorIcons.batteryEmpty, Color(0xFFEF5350)),
    _LogOption('Low', PhosphorIcons.batteryLow, Color(0xFFFF7043)),
    _LogOption('Medium', PhosphorIcons.batteryMedium, Color(0xFFFFA726)),
    _LogOption('High', PhosphorIcons.batteryFull, Color(0xFF66BB6A)),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    getInfo();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _goToPreviousMonth() => setState(() {
    _displayedMonth = DateTime(_displayedMonth.year, _displayedMonth.month - 1);
  });

  void _goToNextMonth() => setState(() {
    _displayedMonth = DateTime(_displayedMonth.year, _displayedMonth.month + 1);
  });

  Future<void> getInfo() async {
    final today = DateTime.now();
    final status = calculateCycleDayType(
      today,
      lastPeriodStartDate,
      periodLength,
      cycleLength,
    );
    final stage = getPeriodStageText(status);
    if (mounted) setState(() => isLoading = false);
    generalInfo = await VertexAIController.suggestGeneralPeriodInfo(stage);

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

  String _dayKey(DateTime d) => "${d.year}-${d.month}-${d.day}";

  void _toggleLog(DateTime day, String item) {
    final key = _dayKey(day);
    setState(() {
      _dailyLogs[key] ??= {};
      if (_dailyLogs[key]!.contains(item)) {
        _dailyLogs[key]!.remove(item);
      } else {
        _dailyLogs[key]!.add(item);
      }
    });
  }

  bool _hasLog(DateTime day, String item) =>
      _dailyLogs[_dayKey(day)]?.contains(item) ?? false;

  // Shows popup when tapping a day
  void _onDayTapped(DateTime date) {
    setState(() => _selectedDay = date);
    _showDayPopup(date);
  }

  void _showDayPopup(DateTime date) {
    final isPast = date.isBefore(DateTime.now());
    final isToday = DateUtils.isSameDay(date, DateTime.now());
    final type = calculateCycleDayType(
      date,
      lastPeriodStartDate,
      periodLength,
      cycleLength,
    );
    final info = _getStatusInfo(type, isPast: isPast);
    final cycleDay = _cycleDayFor(date);
    final fertilityLabel = _fertilityLabel(type, isPast: isPast);
    final hasLog = (_dailyLogs[_dayKey(date)]?.isNotEmpty) ?? false;
    final Color phaseColor = info['color'];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder:
          (_) => Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle bar
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                // Date + cycle day
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isToday ? "Today" : _formatFullDate(date),
                          style: GoogleFonts.philosopher(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: _plum,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          isToday
                              ? _formatFullDate(date)
                              : isPast
                              ? "Past date"
                              : "Predicted",
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12.5,
                            color: _muted,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: phaseColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "Day $cycleDay",
                        style: GoogleFonts.philosopher(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: phaseColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Phase info card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: phaseColor.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: phaseColor.withOpacity(0.2)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: phaseColor.withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(info['icon'], color: phaseColor, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              info['title'],
                              style: GoogleFonts.philosopher(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: _plum,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              fertilityLabel,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12.5,
                                color: phaseColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (hasLog) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(PhosphorIcons.checkCircle, color: _sage, size: 15),
                      const SizedBox(width: 6),
                      Text(
                        "You logged symptoms for this day",
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12.5,
                          color: _sage,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 20),
                // CTA button
                GestureDetector(
                  onTap: () {
                    Get.back();
                    setState(() => _selectedLogDay = _dayKey(date));
                    _tabController.animateTo(1);
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [phaseColor, phaseColor.withOpacity(0.75)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: phaseColor.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Text(
                      hasLog ? "Edit Day Log" : "Log This Day",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }

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
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body:
          isLoading
              ? Center(
                child: Lottie.asset(
                  'images/femihub_loading.json',
                  repeat: true,
                  frameRate: FrameRate(30),
                  height: 160,
                ),
              )
              : Column(
                children: [
                  _buildTabBar(),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildOverviewTab(currentStatus, today),
                        _buildLogTab(today),
                        _buildInsightsTab(currentStatus),
                      ],
                    ),
                  ),
                ],
              ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: _surface,
      toolbarHeight: 64,
      centerTitle: false,
      title: Text(
        "Period Tracker",
        style: GoogleFonts.philosopher(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: _plum,
        ),
      ),
      leading: IconButton(
        onPressed: () => Get.offAllNamed("/home"),
        icon: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(color: _roseSoft, shape: BoxShape.circle),
          child: Icon(Icons.arrow_back_ios_new_rounded, color: _rose, size: 16),
        ),
      ),
      actions: [
        IconButton(
          onPressed:
              () => Get.to(
                () => DueDateCalculatorScreen(),
                transition: Transition.rightToLeft,
              ),
          icon: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(color: _roseSoft, shape: BoxShape.circle),
            child: Icon(PhosphorIcons.pencilSimple, color: _rose, size: 18),
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      decoration: BoxDecoration(
        color: _roseSoft,
        borderRadius: BorderRadius.circular(14),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: _rose,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: _rose.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorPadding: const EdgeInsets.all(3),
        labelColor: Colors.white,
        unselectedLabelColor: _muted,
        labelStyle: GoogleFonts.plusJakartaSans(
          fontWeight: FontWeight.w600,
          fontSize: 12.5,
        ),
        unselectedLabelStyle: GoogleFonts.plusJakartaSans(
          fontWeight: FontWeight.w500,
          fontSize: 12.5,
        ),
        dividerColor: Colors.transparent,
        tabs: const [
          Tab(text: "Overview"),
          Tab(text: "Daily Log"),
          Tab(text: "Insights"),
        ],
      ),
    );
  }

  Widget _buildOverviewTab(CycleDayType currentStatus, DateTime today) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
      children: [
        _buildPhaseHero(currentStatus, today)
            .animate()
            .fadeIn(duration: 500.ms, curve: Curves.easeOut)
            .slideY(begin: 0.08, end: 0, duration: 500.ms),
        const SizedBox(height: 20),
        _buildCalendarCard().animate().fadeIn(
          delay: 100.ms,
          duration: 500.ms,
          curve: Curves.easeOut,
        ),
        const SizedBox(height: 20),
        _buildStatsRow().animate().fadeIn(
          delay: 200.ms,
          duration: 500.ms,
          curve: Curves.easeOut,
        ),
        const SizedBox(height: 20),
        _buildUpdateButton().animate().fadeIn(
          delay: 280.ms,
          duration: 500.ms,
          curve: Curves.easeOut,
        ),
      ],
    );
  }

  Widget _buildPhaseHero(CycleDayType currentStatus, DateTime today) {
    final isPast = today.isBefore(DateTime.now());
    final info = _getStatusInfo(currentStatus, isPast: true);
    final Color phaseColor = info['color'];
    final daysUntilNext = _daysUntilNextPeriod(today);
    final cycleDay = _cycleDayFor(today);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [phaseColor, phaseColor.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: phaseColor.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -24,
            bottom: -24,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.07),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(info['icon'], color: Colors.white, size: 13),
                          const SizedBox(width: 5),
                          Text(
                            info['title'],
                            style: GoogleFonts.plusJakartaSans(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Text(
                      "Day $cycleDay",
                      style: GoogleFonts.philosopher(
                        color: Colors.white.withOpacity(0.85),
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  info['subtitle'],
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _heroStat("Next period", "$daysUntilNext days"),
                    const SizedBox(width: 24),
                    _heroStat("Cycle day", "$cycleDay / $cycleLength"),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _heroStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            color: Colors.white.withOpacity(0.7),
            fontSize: 11,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: GoogleFonts.philosopher(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildCalendarCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _calNavBtn(Icons.chevron_left, _goToPreviousMonth),
                Text(
                  _getMonthYearLabel(_displayedMonth),
                  style: GoogleFonts.philosopher(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: _plum,
                  ),
                ),
                _calNavBtn(Icons.chevron_right, _goToNextMonth),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children:
                  ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
                      .map(
                        (d) => Expanded(
                          child: Center(
                            child: Text(
                              d,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: _muted,
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: _buildGrid(),
          ),
          const SizedBox(height: 8),
          _buildLegendStrip(),
          const SizedBox(height: 4),
          // Subtle tap hint
          Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(PhosphorIcons.handTap, color: _muted, size: 13),
                const SizedBox(width: 5),
                Text(
                  "Tap any day for details",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    color: _muted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _calNavBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(color: _roseSoft, shape: BoxShape.circle),
        child: Icon(icon, size: 18, color: _rose),
      ),
    );
  }

  Widget _buildGrid() {
    final daysInMonth = DateUtils.getDaysInMonth(
      _displayedMonth.year,
      _displayedMonth.month,
    );
    final firstWeekday =
        DateTime(_displayedMonth.year, _displayedMonth.month, 1).weekday % 7;
    final weeks = ((daysInMonth + firstWeekday) / 7).ceil();

    return Column(
      children: List.generate(weeks, (week) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Row(
            children: List.generate(7, (col) {
              final dayNum = week * 7 + col - firstWeekday + 1;
              if (dayNum < 1 || dayNum > daysInMonth) {
                return const Expanded(child: SizedBox(height: 48));
              }
              final date = DateTime(
                _displayedMonth.year,
                _displayedMonth.month,
                dayNum,
              );
              final today = DateTime.now();
              final isPast = date.isBefore(
                DateTime(today.year, today.month, today.day),
              );
              final isToday = DateUtils.isSameDay(date, today);
              final isSelected = DateUtils.isSameDay(date, _selectedDay);
              final type = calculateCycleDayType(
                date,
                lastPeriodStartDate,
                periodLength,
                cycleLength,
              );
              final hasLog = (_dailyLogs[_dayKey(date)]?.isNotEmpty) ?? false;

              return Expanded(
                child: GestureDetector(
                  onTap: () => _onDayTapped(date),
                  child: _GridCell(
                    day: dayNum,
                    type: type,
                    isPast: isPast,
                    isToday: isToday,
                    isSelected: isSelected,
                    hasLog: hasLog,
                  ),
                ),
              );
            }),
          ),
        );
      }),
    );
  }

  Widget _buildLegendStrip() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _legendItem(_pastPeriodColor, "Period (past)", _LegendShape.circle),
          _legendItem(
            _futurePeriodColor,
            "Predicted",
            _LegendShape.circleDashed,
          ),
          _legendItem(_sage, "Fertile", _LegendShape.arrow),
          _legendItem(_amber, "Ovulation", _LegendShape.diamond),
        ],
      ),
    );
  }

  Widget _legendItem(Color color, String label, _LegendShape shape) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _LegendDot(color: color, shape: shape),
        const SizedBox(width: 4),
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 9.5,
            fontWeight: FontWeight.w500,
            color: _plum,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        Expanded(
          child: _statCard(
            PhosphorIcons.calendar,
            "Cycle",
            "$cycleLength days",
            _rose,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _statCard(
            PhosphorIcons.drop,
            "Period",
            "$periodLength days",
            const Color(0xFF42A5F5),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _statCard(PhosphorIcons.sparkle, "Fertile", "~5 days", _sage),
        ),
      ],
    );
  }

  Widget _statCard(IconData icon, String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(fontSize: 11, color: _muted),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: GoogleFonts.philosopher(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: _plum,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpdateButton() {
    return GestureDetector(
      onTap:
          () => Get.to(
            () => DueDateCalculatorScreen(),
            transition: Transition.rightToLeft,
          ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [_rose, _roseDark],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: _rose.withOpacity(0.35),
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Text(
          "Update Period Data",
          textAlign: TextAlign.center,
          style: GoogleFonts.plusJakartaSans(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }

  Widget _buildLogTab(DateTime today) {
    final logDate =
        _selectedLogDay != null ? _parseDayKey(_selectedLogDay!) : today;
    final type = calculateCycleDayType(
      logDate,
      lastPeriodStartDate,
      periodLength,
      cycleLength,
    );
    final info = _getStatusInfo(type, isPast: logDate.isBefore(today));

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
      children: [
        _buildLogDateHeader(
          logDate,
          info,
        ).animate().fadeIn(duration: 400.ms, curve: Curves.easeOut),
        const SizedBox(height: 16),
        _buildLogSection("Flow", _flowOptions, logDate)
            .animate()
            .fadeIn(delay: 80.ms, duration: 400.ms)
            .slideY(begin: 0.06, end: 0, delay: 80.ms, duration: 400.ms),
        const SizedBox(height: 16),
        _buildLogSection("Symptoms", _symptomOptions, logDate)
            .animate()
            .fadeIn(delay: 140.ms, duration: 400.ms)
            .slideY(begin: 0.06, end: 0, delay: 140.ms, duration: 400.ms),
        const SizedBox(height: 16),
        _buildLogSection("Mood", _moodOptions, logDate)
            .animate()
            .fadeIn(delay: 200.ms, duration: 400.ms)
            .slideY(begin: 0.06, end: 0, delay: 200.ms, duration: 400.ms),
        const SizedBox(height: 16),
        _buildLogSection("Energy", _energyOptions, logDate)
            .animate()
            .fadeIn(delay: 260.ms, duration: 400.ms)
            .slideY(begin: 0.06, end: 0, delay: 260.ms, duration: 400.ms),
      ],
    );
  }

  Widget _buildLogDateHeader(DateTime date, Map<String, dynamic> info) {
    final isToday = DateUtils.isSameDay(date, DateTime.now());
    final Color phaseColor = info['color'];
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: phaseColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: phaseColor.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(info['icon'], color: phaseColor, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isToday
                      ? "Today · ${_formatFullDate(date)}"
                      : _formatFullDate(date),
                  style: GoogleFonts.philosopher(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: _plum,
                  ),
                ),
                Text(
                  info['title'],
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: phaseColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => _showDatePicker(date),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: phaseColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "Change",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: phaseColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogSection(
    String title,
    List<_LogOption> options,
    DateTime date,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.philosopher(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: _plum,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  options.map((opt) {
                    final selected = _hasLog(date, "${title}_${opt.label}");
                    return GestureDetector(
                      onTap: () => _toggleLog(date, "${title}_${opt.label}"),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color:
                              selected ? opt.color.withOpacity(0.15) : _surface,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: selected ? opt.color : Colors.grey.shade200,
                            width: selected ? 1.5 : 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              opt.icon,
                              size: 14,
                              color: selected ? opt.color : _muted,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              opt.label,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                fontWeight:
                                    selected
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                color: selected ? opt.color : _muted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightsTab(CycleDayType currentStatus) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
      children: [
        _buildAIInfoCard(currentStatus)
            .animate()
            .fadeIn(duration: 400.ms)
            .slideY(begin: 0.06, end: 0, duration: 400.ms),
        const SizedBox(height: 16),
        SymptomTile(
              title: "Get Recommendations",
              stage: getPeriodStageText(currentStatus),
            )
            .animate()
            .fadeIn(delay: 100.ms, duration: 400.ms)
            .slideY(begin: 0.06, end: 0, delay: 100.ms, duration: 400.ms),
        const SizedBox(height: 12),
        SymptomTile(
              title: "Learn About Your Symptoms",
              stage: getPeriodStageText(currentStatus),
            )
            .animate()
            .fadeIn(delay: 160.ms, duration: 400.ms)
            .slideY(begin: 0.06, end: 0, delay: 160.ms, duration: 400.ms),
        const SizedBox(height: 16),
        _buildTipCard()
            .animate()
            .fadeIn(delay: 220.ms, duration: 400.ms)
            .slideY(begin: 0.06, end: 0, delay: 220.ms, duration: 400.ms),
      ],
    );
  }

  Widget _buildAIInfoCard(CycleDayType currentStatus) {
    final info = _getStatusInfo(currentStatus, isPast: true);
    final Color phaseColor = info['color'];
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: phaseColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(PhosphorIcons.brain, color: phaseColor, size: 18),
                ),
                const SizedBox(width: 10),
                Text(
                  "About This Phase",
                  style: GoogleFonts.philosopher(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: _plum,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              generalInfo,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13.5,
                color: Colors.black87,
                height: 1.65,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTipCard() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF7C5CBF), Color(0xFF3D1A2E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(PhosphorIcons.lightbulb, color: Colors.white70, size: 18),
                const SizedBox(width: 8),
                Text(
                  "Self-care Reminder",
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              "Stay hydrated, get enough sleep, and be gentle with yourself throughout your cycle.",
              style: GoogleFonts.philosopher(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w700,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDatePicker(DateTime current) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: current,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder:
          (context, child) => Theme(
            data: ThemeData.light().copyWith(
              colorScheme: const ColorScheme.light(
                primary: _rose,
                onPrimary: Colors.white,
              ),
              dialogBackgroundColor: Colors.white,
            ),
            child: child!,
          ),
    );
    if (picked != null) setState(() => _selectedLogDay = _dayKey(picked));
  }

  int _cycleDayFor(DateTime date) {
    final days = date.difference(lastPeriodStartDate).inDays;
    if (days < 0) return 1;
    return (days % cycleLength) + 1;
  }

  int _daysUntilNextPeriod(DateTime today) {
    final cycleDay = _cycleDayFor(today);
    return cycleLength - cycleDay + 1;
  }

  Map<String, dynamic> _getStatusInfo(
    CycleDayType type, {
    required bool isPast,
  }) {
    switch (type) {
      case CycleDayType.period:
        return {
          'title': isPast ? 'Period' : 'Predicted Period',
          'subtitle':
              isPast
                  ? 'Low fertility • Period phase'
                  : 'Predicted period • Mark as started if it begins',
          'color': isPast ? _pastPeriodColor : _futurePeriodColor,
          'icon': PhosphorIcons.drop,
        };
      case CycleDayType.ovulation:
        return {
          'title': isPast ? 'Ovulation' : 'Predicted Ovulation',
          'subtitle':
              isPast
                  ? 'Peak fertility • Ovulation day'
                  : 'Predicted peak fertility',
          'color': isPast ? _pastOvulationColor : _futureOvulationColor,
          'icon': PhosphorIcons.sparkle,
        };
      case CycleDayType.fertile:
        return {
          'title': isPast ? 'Fertile Window' : 'Predicted Fertile',
          'subtitle':
              isPast ? 'High fertility window' : 'Predicted fertile days',
          'color': isPast ? _pastFertileColor : _futureFertileColor,
          'icon': PhosphorIcons.heart,
        };
      case CycleDayType.safe:
        return {
          'title': 'Safe Window',
          'subtitle': 'Low fertility • Unlikely to conceive',
          'color': _muted,
          'icon': PhosphorIcons.checkCircle,
        };
    }
  }

  String _fertilityLabel(CycleDayType type, {required bool isPast}) {
    switch (type) {
      case CycleDayType.period:
        return isPast
            ? "Low fertility · Period phase"
            : "Predicted period · Not confirmed";
      case CycleDayType.fertile:
        return isPast ? "HIGH · Fertile window" : "Predicted HIGH fertility";
      case CycleDayType.ovulation:
        return isPast ? "PEAK · Ovulation day" : "Predicted PEAK fertility";
      case CycleDayType.safe:
        return "LOW · Unlikely to conceive";
    }
  }

  String _getMonthYearLabel(DateTime date) {
    const months = [
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
    return "${months[date.month - 1]} ${date.year}";
  }

  String _formatFullDate(DateTime d) {
    const months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];
    return "${months[d.month - 1]} ${d.day}, ${d.year}";
  }

  DateTime _parseDayKey(String key) {
    final parts = key.split('-');
    return DateTime(
      int.parse(parts[0]),
      int.parse(parts[1]),
      int.parse(parts[2]),
    );
  }
}

// ─────────────────────────────────────────────
// GRID CELL — past vs future distinction
// ─────────────────────────────────────────────

class _GridCell extends StatelessWidget {
  final int day;
  final CycleDayType type;
  final bool isPast;
  final bool isToday;
  final bool isSelected;
  final bool hasLog;

  const _GridCell({
    required this.day,
    required this.type,
    required this.isPast,
    required this.isToday,
    required this.isSelected,
    required this.hasLog,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: 48, child: Center(child: _buildInner()));
  }

  Widget _buildInner() {
    switch (type) {
      case CycleDayType.period:
        return _buildPeriodCell();
      case CycleDayType.ovulation:
        return _buildOvulationCell();
      case CycleDayType.fertile:
        return _buildFertileCell();
      case CycleDayType.safe:
        return _buildSafeCell();
    }
  }

  // Past period: solid deep rose circle
  // Future period: lighter rose circle with dashed look (lower opacity + border)
  Widget _buildPeriodCell() {
    final bg = isPast ? _pastPeriodColor : _futurePeriodColor;
    return Stack(
      alignment: Alignment.center,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: isPast ? bg : bg.withOpacity(0.5),
            shape: BoxShape.circle,
            border:
                isPast
                    ? (isSelected
                        ? Border.all(color: Colors.white, width: 2.5)
                        : null)
                    : Border.all(
                      color: _futurePeriodColor,
                      width: 1.5,
                      strokeAlign: BorderSide.strokeAlignOutside,
                    ),
            boxShadow:
                isPast
                    ? [
                      BoxShadow(
                        color: bg.withOpacity(0.35),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ]
                    : [],
          ),
          child: Center(
            child: Text(
              "$day",
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: isPast ? Colors.white : _roseDark,
              ),
            ),
          ),
        ),
        if (hasLog)
          Positioned(
            bottom: 0,
            child: Container(
              width: 5,
              height: 5,
              decoration: BoxDecoration(
                color: isPast ? Colors.white : _roseDark,
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
    );
  }

  // Past ovulation: solid dark amber rotated square
  // Future ovulation: lighter amber rotated square
  Widget _buildOvulationCell() {
    final bg = isPast ? _pastOvulationColor : _futureOvulationColor;
    return Stack(
      alignment: Alignment.center,
      children: [
        Transform.rotate(
          angle: 0.785398,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: isPast ? bg : bg.withOpacity(0.6),
              borderRadius: BorderRadius.circular(6),
              border:
                  isPast
                      ? null
                      : Border.all(color: _futureOvulationColor, width: 1.5),
              boxShadow:
                  isPast
                      ? [
                        BoxShadow(
                          color: bg.withOpacity(0.35),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ]
                      : [],
            ),
          ),
        ),
        Text(
          "$day",
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: isPast ? Colors.white : _pastOvulationColor,
          ),
        ),
      ],
    );
  }

  // Past fertile: solid sage rounded rect + up arrow
  // Future fertile: lighter sage + arrow
  Widget _buildFertileCell() {
    final bg = isPast ? _pastFertileColor : _futureFertileColor;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 36,
          height: 26,
          decoration: BoxDecoration(
            color: isPast ? bg : bg.withOpacity(0.6),
            borderRadius: BorderRadius.circular(8),
            border:
                isPast
                    ? null
                    : Border.all(color: _futureFertileColor, width: 1.2),
            boxShadow:
                isPast
                    ? [
                      BoxShadow(
                        color: bg.withOpacity(0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ]
                    : [],
          ),
          child: Center(
            child: Text(
              "$day",
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: isPast ? Colors.white : _pastFertileColor,
              ),
            ),
          ),
        ),
        const SizedBox(height: 1),
        Icon(
          Icons.arrow_drop_up_rounded,
          color: isPast ? _pastFertileColor : _futureFertileColor,
          size: 14,
        ),
      ],
    );
  }

  Widget _buildSafeCell() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: isSelected ? _roseSoft : Colors.transparent,
        shape: BoxShape.circle,
        border:
            isToday
                ? Border.all(color: _plum, width: 2)
                : isSelected
                ? Border.all(color: _rose.withOpacity(0.4), width: 1.5)
                : null,
      ),
      child: Center(
        child: Text(
          "$day",
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            fontWeight: isToday ? FontWeight.w800 : FontWeight.w500,
            color: isToday ? _plum : Colors.black87.withOpacity(0.65),
          ),
        ),
      ),
    );
  }
}

enum _LegendShape { circle, circleDashed, arrow, diamond }

class _LegendDot extends StatelessWidget {
  final Color color;
  final _LegendShape shape;
  const _LegendDot({required this.color, required this.shape});

  @override
  Widget build(BuildContext context) {
    if (shape == _LegendShape.diamond) {
      return Transform.rotate(
        angle: 0.785398,
        child: Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      );
    }
    if (shape == _LegendShape.arrow) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12,
            height: 7,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          Icon(Icons.arrow_drop_up_rounded, color: color, size: 10),
        ],
      );
    }
    if (shape == _LegendShape.circleDashed) {
      return Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(
          color: color.withOpacity(0.4),
          shape: BoxShape.circle,
          border: Border.all(color: color, width: 1.5),
        ),
      );
    }
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _LogOption {
  final String label;
  final IconData icon;
  final Color color;
  const _LogOption(this.label, this.icon, this.color);
}

enum CycleDayType { period, fertile, ovulation, safe }

CycleDayType calculateCycleDayType(
  DateTime currentDate,
  DateTime lastPeriodStartDate,
  int periodLength,
  int cycleLength,
) {
  final daysSince = currentDate.difference(lastPeriodStartDate).inDays;
  if (daysSince < 0) return CycleDayType.safe;
  final pos = daysSince % cycleLength;
  if (pos < periodLength) return CycleDayType.period;
  final ovDay = (cycleLength ~/ 2).clamp(10, 18);
  final fertStart = (ovDay - 5).clamp(0, cycleLength - 1);
  final fertEnd = (ovDay + 1).clamp(0, cycleLength - 1);
  if (pos == ovDay) return CycleDayType.ovulation;
  if (pos >= fertStart && pos <= fertEnd) return CycleDayType.fertile;
  return CycleDayType.safe;
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
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color:
              info.isNotEmpty ? _rose.withOpacity(0.25) : Colors.grey.shade100,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () async {
            if (info.isEmpty && !expanding) {
              setState(() => expanding = true);
              appCommunication(
                context,
                widget.title,
                widget.title == "Get Recommendations"
                    ? "Generating recommendations"
                    : "Generating symptoms",
                "/home",
              );
              if (widget.title == "Get Recommendations") {
                info =
                    await VertexAIController.suggestGeneralPeriodRecommendation(
                      widget.stage,
                    );
              } else {
                info = await VertexAIController.suggestGeneralPeriodSymptoms(
                  widget.stage,
                );
              }
              setState(() => expanding = false);
            } else {
              setState(() => info = "");
            }
          },
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: _roseSoft,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        widget.title == "Get Recommendations"
                            ? PhosphorIcons.star
                            : PhosphorIcons.listBullets,
                        color: _rose,
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        widget.title,
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.w600,
                          fontSize: 13.5,
                          color: _plum,
                        ),
                      ),
                    ),
                    expanding
                        ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 1.5,
                            color: _rose,
                          ),
                        )
                        : Icon(
                          info.isEmpty
                              ? Icons.arrow_forward_ios_rounded
                              : Icons.expand_less_rounded,
                          size: 15,
                          color: _muted,
                        ),
                  ],
                ),
                if (info.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    info,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: Colors.black87,
                      height: 1.65,
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
