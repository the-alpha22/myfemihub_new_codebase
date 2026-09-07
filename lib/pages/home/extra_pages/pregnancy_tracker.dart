// ignore_for_file: deprecated_member_use

import 'package:bridge_ai/constants/controllers.dart';
import 'package:bridge_ai/controllers/ai_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

const _rose = Color(0xFFE8567A);
const _roseDark = Color(0xFFC03A5E);
const _roseSoft = Color(0xFFFFF0F4);
const _plum = Color(0xFF3D1A2E);
const _muted = Color(0xFF9E8892);
const _surface = Color(0xFFFDF7F9);
const _amber = Color(0xFFFFA726);
const _amberSoft = Color(0xFFFFF8EC);
const _sage = Color(0xFF6BAF92);
const _sageSoft = Color(0xFFEDF7F3);
const _violet = Color(0xFF7C5CBF);
const _violetSoft = Color(0xFFF3EEFF);

class PregnancyTrackerPage extends StatefulWidget {
  @override
  _PregnancyTrackerPageState createState() => _PregnancyTrackerPageState();
}

class _PregnancyTrackerPageState extends State<PregnancyTrackerPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  DateTime? conceptionDate;
  final int totalPregnancyDays = 280;
  int currentWeek = 0;
  int currentDay = 0;
  String generalInfo = "";
  bool loadingTip = true;

  final Map<int, _BabyData> babyData = {
    0: _BabyData('Poppy seed', '< 1 mm', PhosphorIcons.circle),
    4: _BabyData('Blueberry', '5 mm', PhosphorIcons.circle),
    8: _BabyData('Kidney bean', '1.6 cm', PhosphorIcons.heart),
    12: _BabyData('Lime', '5.4 cm', PhosphorIcons.smiley),
    16: _BabyData('Avocado', '11.6 cm', PhosphorIcons.leaf),
    20: _BabyData('Banana', '25 cm', PhosphorIcons.star),
    24: _BabyData('Corn', '30 cm', PhosphorIcons.flame),
    28: _BabyData('Eggplant', '37 cm', PhosphorIcons.sparkle),
    32: _BabyData('Jicama', '42 cm', PhosphorIcons.baby),
    36: _BabyData('Squash', '47 cm', PhosphorIcons.baby),
    40: _BabyData('Watermelon', '51 cm', PhosphorIcons.baby),
  };

  final List<_MilestoneData> milestones = [
    _MilestoneData(week: 4, label: 'Implantation', color: _rose),
    _MilestoneData(week: 8, label: 'Heartbeat', color: _rose),
    _MilestoneData(week: 12, label: 'End of 1st Trimester', color: _amber),
    _MilestoneData(week: 20, label: 'Anatomy Scan', color: _amber),
    _MilestoneData(week: 28, label: 'End of 2nd Trimester', color: _sage),
    _MilestoneData(week: 36, label: 'Full Term Soon', color: _sage),
    _MilestoneData(week: 40, label: 'Due Date 🎉', color: _violet),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    loadConceptionDate();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> getInfo() async {
    generalInfo = await VertexAIController.suggestPregnancyTip(getTrimester());
    if (mounted) setState(() => loadingTip = false);
  }

  Future<void> loadConceptionDate() async {
    if (userController.userModel.value!.conceptionDate != null) {
      conceptionDate = userController.userModel.value!.conceptionDate;
      calculateProgress();
    } else {
      await promptForConceptionDate();
    }
  }

  Future<void> promptForConceptionDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 100)),
      firstDate: DateTime.now().subtract(const Duration(days: 300)),
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
    if (picked != null) {
      await userController.updateUserData({"conceptionDate": picked});
      userController.userModel.value!.conceptionDate = picked;
      setState(() => conceptionDate = picked);
      calculateProgress();
    }
  }

  void calculateProgress() async {
    if (conceptionDate == null) return;
    final daysPregnant = DateTime.now().difference(conceptionDate!).inDays;
    setState(() {
      currentWeek = daysPregnant ~/ 7;
      currentDay = daysPregnant % 7;
    });
    await getInfo();
  }

  String getTrimester() {
    if (currentWeek < 13) return '1st Trimester';
    if (currentWeek < 28) return '2nd Trimester';
    return '3rd Trimester';
  }

  Color getTrimesterColor() {
    if (currentWeek < 13) return _rose;
    if (currentWeek < 28) return _amber;
    return _sage;
  }

  Color getTrimesterSoft() {
    if (currentWeek < 13) return _roseSoft;
    if (currentWeek < 28) return _amberSoft;
    return _sageSoft;
  }

  String getDateRange() {
    final start = conceptionDate!.add(Duration(days: currentWeek * 7));
    final end = start.add(const Duration(days: 6));
    return '${DateFormat("d MMM").format(start)} – ${DateFormat("d MMM").format(end)}';
  }

  _BabyData getCurrentBabyData() {
    final keys = babyData.keys.toList()..sort();
    int matchKey = keys.first;
    for (final k in keys) {
      if (currentWeek >= k) matchKey = k;
    }
    return babyData[matchKey]!;
  }

  _MilestoneData? getNextMilestone() {
    for (final m in milestones) {
      if (m.week > currentWeek) return m;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    if (conceptionDate == null) return _buildSetupScreen();

    final daysLeft = totalPregnancyDays - ((currentWeek * 7) + currentDay);
    final totalDaysPassed = (currentWeek * 7) + currentDay;
    final progress = totalDaysPassed / totalPregnancyDays;

    return Scaffold(
      backgroundColor: _surface,
      appBar: _buildAppBar("Pregnancy Tracker"),
      body: Column(
        children: [
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(daysLeft, totalDaysPassed, progress),
                _buildJourneyTab(),
                _buildTipsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar(String title) {
    return AppBar(
      elevation: 0,
      backgroundColor: _surface,
      toolbarHeight: 64,
      centerTitle: false,
      title: Text(
        title,
        style: GoogleFonts.philosopher(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: _plum,
        ),
      ),
      leading: IconButton(
        onPressed: () => Get.back(),
        icon: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(color: _roseSoft, shape: BoxShape.circle),
          child: Icon(Icons.arrow_back_ios_new_rounded, color: _rose, size: 16),
        ),
      ),
      actions: [
        IconButton(
          onPressed: promptForConceptionDate,
          icon: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(color: _roseSoft, shape: BoxShape.circle),
            child: Icon(PhosphorIcons.pencilSimple, color: _rose, size: 17),
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
          Tab(text: "Journey"),
          Tab(text: "Tips"),
        ],
      ),
    );
  }

  Widget _buildOverviewTab(int daysLeft, int totalDaysPassed, double progress) {
    final baby = getCurrentBabyData();
    final tc = getTrimesterColor();
    final ts = getTrimesterSoft();
    final dueDate = conceptionDate!.add(Duration(days: totalPregnancyDays));
    final next = getNextMilestone();

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
      children: [
        _buildHeroCard(tc, ts, totalDaysPassed, daysLeft, progress)
            .animate()
            .fadeIn(duration: 500.ms, curve: Curves.easeOut)
            .slideY(begin: 0.07, end: 0, duration: 500.ms),
        const SizedBox(height: 20),
        _buildBabySizeCard(baby, tc, ts)
            .animate()
            .fadeIn(delay: 100.ms, duration: 450.ms, curve: Curves.easeOut)
            .slideY(begin: 0.06, end: 0, delay: 100.ms, duration: 450.ms),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _statCard(
                    PhosphorIcons.calendar,
                    "Due Date",
                    DateFormat('d MMM yyyy').format(dueDate),
                    _rose,
                  )
                  .animate()
                  .fadeIn(
                    delay: 160.ms,
                    duration: 400.ms,
                    curve: Curves.easeOut,
                  )
                  .slideY(begin: 0.05, end: 0, delay: 160.ms, duration: 400.ms),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _statCard(
                    PhosphorIcons.hourglass,
                    "Current Week",
                    "Week $currentWeek",
                    _amber,
                  )
                  .animate()
                  .fadeIn(
                    delay: 200.ms,
                    duration: 400.ms,
                    curve: Curves.easeOut,
                  )
                  .slideY(begin: 0.05, end: 0, delay: 200.ms, duration: 400.ms),
            ),
          ],
        ),
        if (next != null) ...[
          const SizedBox(height: 12),
          _buildNextMilestoneCard(next)
              .animate()
              .fadeIn(delay: 260.ms, duration: 400.ms, curve: Curves.easeOut)
              .slideY(begin: 0.05, end: 0, delay: 260.ms, duration: 400.ms),
        ],
        const SizedBox(height: 20),
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Lottie.asset(
            'images/pregnancy.json',
            repeat: true,
            frameRate: FrameRate(30),
            height: 180,
          ),
        ).animate().fadeIn(
          delay: 320.ms,
          duration: 500.ms,
          curve: Curves.easeOut,
        ),
      ],
    );
  }

  Widget _buildHeroCard(
    Color tc,
    Color ts,
    int daysPassed,
    int daysLeft,
    double progress,
  ) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [tc, tc.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: tc.withOpacity(0.3),
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      child: Text(
                        getTrimester(),
                        style: GoogleFonts.plusJakartaSans(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Text(
                      getDateRange(),
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  "$currentWeek weeks, $currentDay day${currentDay == 1 ? '' : 's'}",
                  style: GoogleFonts.philosopher(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    backgroundColor: Colors.white.withOpacity(0.25),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _heroStat("$daysPassed", "days in"),
                    _heroStat("$daysLeft", "days left"),
                    _heroStat("${(progress * 100).round()}%", "complete"),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _heroStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.philosopher(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            color: Colors.white.withOpacity(0.75),
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget _buildBabySizeCard(_BabyData baby, Color tc, Color ts) {
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
        child: Row(
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(color: ts, shape: BoxShape.circle),
              child: Icon(baby.icon, color: tc, size: 26),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Baby this week",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11.5,
                      color: _muted,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    "Size of a ${baby.name.toLowerCase()}",
                    style: GoogleFonts.philosopher(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: _plum,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "About ${baby.size} long",
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

  Widget _buildNextMilestoneCard(_MilestoneData next) {
    final weeksAway = next.week - currentWeek;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: next.color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: next.color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(PhosphorIcons.flagCheckered, color: next.color, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Next Milestone",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    color: next.color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  next.label,
                  style: GoogleFonts.philosopher(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: _plum,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: next.color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              weeksAway == 0 ? "This week!" : "$weeksAway wks away",
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: next.color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJourneyTab() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
      children: [
        Text(
          "Your Milestones",
          style: GoogleFonts.philosopher(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: _plum,
          ),
        ).animate().fadeIn(duration: 400.ms, curve: Curves.easeOut),
        const SizedBox(height: 4),
        Text(
          "Track your pregnancy journey week by week",
          style: GoogleFonts.plusJakartaSans(fontSize: 12.5, color: _muted),
        ).animate().fadeIn(
          delay: 60.ms,
          duration: 400.ms,
          curve: Curves.easeOut,
        ),
        const SizedBox(height: 20),
        ...milestones.asMap().entries.map((entry) {
          final i = entry.key;
          final m = entry.value;
          final reached = currentWeek >= m.week;
          final isCurrent =
              currentWeek >= m.week &&
              (i == milestones.length - 1 ||
                  currentWeek < milestones[i + 1].week);
          return _buildMilestoneTile(m, reached, isCurrent, i)
              .animate()
              .fadeIn(
                delay: (80 + 60 * i).ms,
                duration: 400.ms,
                curve: Curves.easeOut,
              )
              .slideX(
                begin: 0.04,
                end: 0,
                delay: (80 + 60 * i).ms,
                duration: 400.ms,
              );
        }).toList(),
      ],
    );
  }

  Widget _buildMilestoneTile(
    _MilestoneData m,
    bool reached,
    bool isCurrent,
    int index,
  ) {
    final isLast = index == milestones.length - 1;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: reached ? m.color : Colors.grey.shade100,
                  shape: BoxShape.circle,
                  border:
                      isCurrent ? Border.all(color: m.color, width: 2.5) : null,
                  boxShadow:
                      reached
                          ? [
                            BoxShadow(
                              color: m.color.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                          : [],
                ),
                child: Icon(
                  reached ? PhosphorIcons.checkCircle : PhosphorIcons.circle,
                  color: reached ? Colors.white : Colors.grey.shade400,
                  size: 18,
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    color:
                        reached
                            ? m.color.withOpacity(0.35)
                            : Colors.grey.shade200,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isCurrent ? m.color.withOpacity(0.08) : Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color:
                        isCurrent
                            ? m.color.withOpacity(0.25)
                            : Colors.grey.shade100,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            m.label,
                            style: GoogleFonts.philosopher(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: reached ? _plum : _muted,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "Week ${m.week}",
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              color: _muted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isCurrent)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: m.color,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "Now",
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    if (!isCurrent && reached)
                      Icon(PhosphorIcons.checkCircle, color: m.color, size: 18),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipsTab() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
      children: [
        _buildTrimesterBadge()
            .animate()
            .fadeIn(duration: 400.ms, curve: Curves.easeOut)
            .slideY(begin: 0.06, end: 0, duration: 400.ms),
        const SizedBox(height: 16),
        _buildTipCard()
            .animate()
            .fadeIn(delay: 100.ms, duration: 420.ms, curve: Curves.easeOut)
            .slideY(begin: 0.06, end: 0, delay: 100.ms, duration: 420.ms),
        const SizedBox(height: 16),
        _buildQuickTips()
            .animate()
            .fadeIn(delay: 180.ms, duration: 420.ms, curve: Curves.easeOut)
            .slideY(begin: 0.06, end: 0, delay: 180.ms, duration: 420.ms),
      ],
    );
  }

  Widget _buildTrimesterBadge() {
    final tc = getTrimesterColor();
    final ts = getTrimesterSoft();
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: ts,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: tc.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: tc.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(PhosphorIcons.baby, color: tc, size: 22),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                getTrimester(),
                style: GoogleFonts.philosopher(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: _plum,
                ),
              ),
              Text(
                "Week $currentWeek · ${getDateRange()}",
                style: GoogleFonts.plusJakartaSans(fontSize: 12, color: _muted),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTipCard() {
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
                    color: _violetSoft,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    PhosphorIcons.lightbulb,
                    color: _violet,
                    size: 17,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  "Weekly Tip",
                  style: GoogleFonts.philosopher(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: _plum,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            loadingTip
                ? const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: CircularProgressIndicator(
                      strokeWidth: 1.5,
                      color: _rose,
                    ),
                  ),
                )
                : Text(
                  generalInfo,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13.5,
                    color: Colors.black87,
                    height: 1.7,
                    fontWeight: FontWeight.w400,
                  ),
                ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickTips() {
    final tips = [
      _QuickTip(
        'Stay hydrated',
        'Aim for 8–10 glasses of water a day',
        PhosphorIcons.drop,
        _rose,
      ),
      _QuickTip(
        'Take prenatal vitamins',
        'Folic acid supports baby\'s development',
        PhosphorIcons.pill,
        _sage,
      ),
      _QuickTip(
        'Rest well',
        'Sleep on your left side to improve circulation',
        PhosphorIcons.moon,
        _violet,
      ),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Self-Care Reminders",
          style: GoogleFonts.philosopher(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: _plum,
          ),
        ),
        const SizedBox(height: 12),
        ...tips.map(
          (t) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: t.color.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(t.icon, color: t.color, size: 18),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          t.title,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: _plum,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          t.subtitle,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11.5,
                            color: _muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSetupScreen() {
    return Scaffold(
      backgroundColor: _surface,
      appBar: _buildAppBar("Pregnancy Tracker"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [_rose, _roseDark],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: _rose.withOpacity(0.28),
                        blurRadius: 18,
                        offset: const Offset(0, 7),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        right: -20,
                        bottom: -20,
                        child: Container(
                          width: 130,
                          height: 130,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.07),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.18),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                "Let's get started",
                                style: GoogleFonts.plusJakartaSans(
                                  color: Colors.white70,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(height: 14),
                            Text(
                              "When did you\nconceive?",
                              style: GoogleFonts.philosopher(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.w700,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "We'll use this to track your baby's growth\nand give you personalised weekly tips.",
                              style: GoogleFonts.plusJakartaSans(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 13,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
                .animate()
                .fadeIn(duration: 500.ms, curve: Curves.easeOut)
                .slideY(begin: 0.07, end: 0, duration: 500.ms),
            const SizedBox(height: 40),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Lottie.asset(
                'images/pregnancy.json',
                repeat: true,
                frameRate: FrameRate(30),
                height: 180,
              ),
            ).animate().fadeIn(
              delay: 120.ms,
              duration: 500.ms,
              curve: Curves.easeOut,
            ),
            const SizedBox(height: 40),
            GestureDetector(
                  onTap: promptForConceptionDate,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 17),
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          PhosphorIcons.calendarBlank,
                          color: Colors.white,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Choose Conception Date",
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .animate()
                .fadeIn(delay: 220.ms, duration: 400.ms, curve: Curves.easeOut)
                .slideY(begin: 0.05, end: 0, delay: 220.ms, duration: 400.ms),
          ],
        ),
      ),
    );
  }
}

class _BabyData {
  final String name;
  final String size;
  final IconData icon;
  const _BabyData(this.name, this.size, this.icon);
}

class _MilestoneData {
  final int week;
  final String label;
  final Color color;
  const _MilestoneData({
    required this.week,
    required this.label,
    required this.color,
  });
}

class _QuickTip {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  const _QuickTip(this.title, this.subtitle, this.icon, this.color);
}
