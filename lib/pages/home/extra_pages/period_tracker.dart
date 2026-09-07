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
const _sky = Color(0xFF42A5F5);
const _muted = Color(0xFF9E8892);
const _surface = Color(0xFFFDF7F9);

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

  String generalInfo = "";
  bool isLoading = true;

  // Daily log state
  final Map<String, Set<String>> _dailyLogs = {};
  String? _selectedLogDay;

  // Symptom & mood options
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
    final currentPeriodStatus = calculateCycleDayType(
      today,
      lastPeriodStartDate,
      periodLength,
      cycleLength,
    );
    String stage = getPeriodStageText(currentPeriodStatus);
    generalInfo = await VertexAIController.suggestGeneralPeriodInfo(stage);
    if (mounted) setState(() => isLoading = false);
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

  bool _hasLog(DateTime day, String item) {
    return _dailyLogs[_dayKey(day)]?.contains(item) ?? false;
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
      backgroundColor: _surface,
      appBar: _buildAppBar(),
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
            .slideY(
              begin: 0.08,
              end: 0,
              duration: 500.ms,
              curve: Curves.easeOut,
            ),
        const SizedBox(height: 20),
        _buildCycleRing(today).animate().fadeIn(
          delay: 100.ms,
          duration: 500.ms,
          curve: Curves.easeOut,
        ),
        const SizedBox(height: 20),
        _buildCalendarCard(),
        const SizedBox(height: 20),
        _buildLegendRow(),
        const SizedBox(height: 20),
        _buildStatsRow(),
        const SizedBox(height: 20),
        _buildUpdateButton(),
      ],
    );
  }

  Widget _buildPhaseHero(CycleDayType currentStatus, DateTime today) {
    final info = _getStatusInfo(currentStatus);
    final Color phaseColor = info['color'];
    final daysUntilNext = _daysUntilNextPeriod(today);
    final cycleDay = _currentCycleDay(today);

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
                const SizedBox(height: 18),
                Text(
                  info['subtitle'],
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    _buildHeroStat("Next period", "$daysUntilNext days"),
                    const SizedBox(width: 24),
                    _buildHeroStat("Cycle day", "$cycleDay / $cycleLength"),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroStat(String label, String value) {
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

  Widget _buildCycleRing(DateTime today) {
    final cycleDay = _currentCycleDay(today);
    final progress = cycleDay / cycleLength;
    final currentStatus = calculateCycleDayType(
      today,
      lastPeriodStartDate,
      periodLength,
      cycleLength,
    );
    final info = _getStatusInfo(currentStatus);
    final Color phaseColor = info['color'];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Row(
          children: [
            SizedBox(
              width: 90,
              height: 90,
              child: CustomPaint(
                painter: _RingPainter(progress: progress, color: phaseColor),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "$cycleDay",
                        style: GoogleFonts.philosopher(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: _plum,
                        ),
                      ),
                      Text(
                        "of $cycleLength",
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          color: _muted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Cycle Progress",
                    style: GoogleFonts.philosopher(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: _plum,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildPhaseBar(),
                  const SizedBox(height: 10),
                  Text(
                    "You're ${(progress * 100).round()}% through your cycle",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: _muted,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 150.ms, duration: 500.ms, curve: Curves.easeOut);
  }

  Widget _buildPhaseBar() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: SizedBox(
        height: 10,
        child: Row(
          children: [
            Flexible(
              flex: periodLength,
              child: Container(color: _rose.withOpacity(0.85)),
            ),
            Flexible(
              flex: (_daysUntilOvulation() - periodLength).clamp(
                0,
                cycleLength,
              ),
              child: Container(color: _sky.withOpacity(0.6)),
            ),
            Flexible(flex: 5, child: Container(color: _sage.withOpacity(0.7))),
            Flexible(
              flex: (cycleLength - periodLength - 5 - _daysUntilOvulation())
                  .clamp(0, cycleLength),
              child: Container(color: _sky.withOpacity(0.3)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Your Cycle",
                  style: GoogleFonts.philosopher(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: _plum,
                  ),
                ),
                Row(
                  children: [
                    _calNavBtn(Icons.chevron_left, _goToPreviousMonth),
                    const SizedBox(width: 4),
                    Text(
                      _getMonthYearLabel(_displayedMonth),
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: _plum,
                      ),
                    ),
                    const SizedBox(width: 4),
                    _calNavBtn(Icons.chevron_right, _goToNextMonth),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildCalendarGrid(),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 200.ms, duration: 500.ms, curve: Curves.easeOut);
  }

  Widget _calNavBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(color: _roseSoft, shape: BoxShape.circle),
        child: Icon(icon, size: 16, color: _rose),
      ),
    );
  }

  Widget _buildCalendarGrid() {
    final daysInMonth = DateUtils.getDaysInMonth(
      _displayedMonth.year,
      _displayedMonth.month,
    );
    final firstWeekday =
        DateTime(_displayedMonth.year, _displayedMonth.month, 1).weekday % 7;

    return Column(
      children: [
        Row(
          children:
              ["S", "M", "T", "W", "T", "F", "S"]
                  .map(
                    (d) => Expanded(
                      child: Center(
                        child: Text(
                          d,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: _muted,
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
        ),
        const SizedBox(height: 10),
        ...List.generate(((daysInMonth + firstWeekday) / 7).ceil(), (week) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              children: List.generate(7, (day) {
                final dayNum = week * 7 + day - firstWeekday + 1;
                if (dayNum < 1 || dayNum > daysInMonth) {
                  return const Expanded(child: SizedBox());
                }
                final date = DateTime(
                  _displayedMonth.year,
                  _displayedMonth.month,
                  dayNum,
                );
                final type = calculateCycleDayType(
                  date,
                  lastPeriodStartDate,
                  periodLength,
                  cycleLength,
                );
                final isToday = DateUtils.isSameDay(date, DateTime.now());
                final hasLog = (_dailyLogs[_dayKey(date)]?.isNotEmpty) ?? false;
                final color = _getDayColor(type);

                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() => _selectedLogDay = _dayKey(date));
                      _tabController.animateTo(1);
                    },
                    child: Container(
                      margin: const EdgeInsets.all(2),
                      height: 34,
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.25),
                        shape: BoxShape.circle,
                        border:
                            isToday ? Border.all(color: _plum, width: 2) : null,
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Text(
                            "$dayNum",
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              fontWeight:
                                  isToday ? FontWeight.w700 : FontWeight.w500,
                              color: isToday ? _plum : Colors.black87,
                            ),
                          ),
                          if (hasLog)
                            Positioned(
                              bottom: 3,
                              child: Container(
                                width: 4,
                                height: 4,
                                decoration: BoxDecoration(
                                  color: _rose,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildLegendRow() {
    return Row(
      children: [
        _legendChip("Period", _rose),
        const SizedBox(width: 8),
        _legendChip("Fertile", _sage),
        const SizedBox(width: 8),
        _legendChip("Ovulation", _amber),
        const SizedBox(width: 8),
        _legendChip("Safe", _sky),
      ],
    ).animate().fadeIn(delay: 250.ms, duration: 500.ms, curve: Curves.easeOut);
  }

  Widget _legendChip(String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 4),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: _plum,
              ),
            ),
          ],
        ),
      ),
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
            _sky,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _statCard(PhosphorIcons.sparkle, "Fertile", "~5 days", _sage),
        ),
      ],
    ).animate().fadeIn(delay: 300.ms, duration: 500.ms, curve: Curves.easeOut);
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
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              color: _muted,
              fontWeight: FontWeight.w400,
            ),
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
    ).animate().fadeIn(delay: 350.ms, duration: 500.ms, curve: Curves.easeOut);
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
    final info = _getStatusInfo(type);

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
            .fadeIn(delay: 80.ms, duration: 400.ms, curve: Curves.easeOut)
            .slideY(begin: 0.06, end: 0, delay: 80.ms, duration: 400.ms),
        const SizedBox(height: 16),
        _buildLogSection("Symptoms", _symptomOptions, logDate)
            .animate()
            .fadeIn(delay: 140.ms, duration: 400.ms, curve: Curves.easeOut)
            .slideY(begin: 0.06, end: 0, delay: 140.ms, duration: 400.ms),
        const SizedBox(height: 16),
        _buildLogSection("Mood", _moodOptions, logDate)
            .animate()
            .fadeIn(delay: 200.ms, duration: 400.ms, curve: Curves.easeOut)
            .slideY(begin: 0.06, end: 0, delay: 200.ms, duration: 400.ms),
        const SizedBox(height: 16),
        _buildLogSection("Energy", _energyOptions, logDate)
            .animate()
            .fadeIn(delay: 260.ms, duration: 400.ms, curve: Curves.easeOut)
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
                  isToday ? "Today · ${_formatDate(date)}" : _formatDate(date),
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
            .fadeIn(duration: 400.ms, curve: Curves.easeOut)
            .slideY(begin: 0.06, end: 0, duration: 400.ms),
        const SizedBox(height: 16),
        SymptomTile(
              title: "Get Recommendations",
              stage: getPeriodStageText(currentStatus),
            )
            .animate()
            .fadeIn(delay: 100.ms, duration: 400.ms, curve: Curves.easeOut)
            .slideY(begin: 0.06, end: 0, delay: 100.ms, duration: 400.ms),
        const SizedBox(height: 12),
        SymptomTile(
              title: "Learn About Your Symptoms",
              stage: getPeriodStageText(currentStatus),
            )
            .animate()
            .fadeIn(delay: 160.ms, duration: 400.ms, curve: Curves.easeOut)
            .slideY(begin: 0.06, end: 0, delay: 160.ms, duration: 400.ms),
        const SizedBox(height: 16),
        _buildTipCard()
            .animate()
            .fadeIn(delay: 220.ms, duration: 400.ms, curve: Curves.easeOut)
            .slideY(begin: 0.06, end: 0, delay: 220.ms, duration: 400.ms),
      ],
    );
  }

  Widget _buildAIInfoCard(CycleDayType currentStatus) {
    final info = _getStatusInfo(currentStatus);
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

  int _currentCycleDay(DateTime today) {
    final daysSince = today.difference(lastPeriodStartDate).inDays;
    if (daysSince < 0) return 1;
    return (daysSince % cycleLength) + 1;
  }

  int _daysUntilNextPeriod(DateTime today) {
    final cycleDay = _currentCycleDay(today);
    return cycleLength - cycleDay + 1;
  }

  int _daysUntilOvulation() => (cycleLength ~/ 2).clamp(10, 18);

  Color _getDayColor(CycleDayType type) {
    switch (type) {
      case CycleDayType.period:
        return _rose;
      case CycleDayType.fertile:
        return _sage;
      case CycleDayType.ovulation:
        return _amber;
      case CycleDayType.safe:
        return _sky;
    }
  }

  Map<String, dynamic> _getStatusInfo(CycleDayType type) {
    switch (type) {
      case CycleDayType.period:
        return {
          'title': 'On Your Period',
          'subtitle': 'Low fertility • Focus on self-care and rest',
          'color': _rose,
          'icon': PhosphorIcons.drop,
        };
      case CycleDayType.ovulation:
        return {
          'title': 'Ovulating Today',
          'subtitle': 'Peak fertility • Best time to conceive',
          'color': _amber,
          'icon': PhosphorIcons.sparkle,
        };
      case CycleDayType.fertile:
        return {
          'title': 'Fertile Window',
          'subtitle': 'High fertility • Good days to conceive',
          'color': _sage,
          'icon': PhosphorIcons.heart,
        };
      case CycleDayType.safe:
        return {
          'title': 'Safe Window',
          'subtitle': 'Low fertility • Unlikely to conceive',
          'color': _sky,
          'icon': PhosphorIcons.checkCircle,
        };
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

  String _formatDate(DateTime d) =>
      "${_getMonthYearLabel(d).split(' ').first} ${d.day}, ${d.year}";

  DateTime _parseDayKey(String key) {
    final parts = key.split('-');
    return DateTime(
      int.parse(parts[0]),
      int.parse(parts[1]),
      int.parse(parts[2]),
    );
  }
}

class _LogOption {
  final String label;
  final IconData icon;
  final Color color;
  const _LogOption(this.label, this.icon, this.color);
}

class _RingPainter extends CustomPainter {
  final double progress;
  final Color color;
  const _RingPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 8;
    final trackPaint =
        Paint()
          ..color = color.withOpacity(0.12)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 10
          ..strokeCap = StrokeCap.round;
    final progressPaint =
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 10
          ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, trackPaint);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.14159 / 2,
      2 * 3.14159 * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(_RingPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.color != color;
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
  if (daysSinceLastPeriod < 0) return CycleDayType.safe;
  final cyclePosition = daysSinceLastPeriod % cycleLength;
  if (cyclePosition < periodLength) return CycleDayType.period;
  final ovulationDay = (cycleLength ~/ 2).clamp(10, 18);
  final fertileWindowStart = (ovulationDay - 5).clamp(0, cycleLength - 1);
  final fertileWindowEnd = (ovulationDay + 1).clamp(0, cycleLength - 1);
  if (cyclePosition == ovulationDay) return CycleDayType.ovulation;
  if (cyclePosition >= fertileWindowStart &&
      cyclePosition <= fertileWindowEnd) {
    return CycleDayType.fertile;
  }
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
                        ? SizedBox(
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
