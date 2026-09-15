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

  final List<String> _selectedSymptoms = [];
  final List<String> _availableSymptoms = [
    'Nausea',
    'Fatigue',
    'Headache',
    'Back pain',
    'Heartburn',
    'Swelling',
    'Mood swings',
    'Frequent urination',
    'Food cravings',
    'Insomnia',
    'Breast tenderness',
    'Spotting',
    'Cramps',
    'Dizziness',
    'Shortness of breath',
  ];

  final Map<int, _BabyData> babyData = {
    1: _BabyData(
      'Poppy seed',
      '< 1 mm',
      PhosphorIcons.circle,
      'A fertilised egg has implanted in your uterus. The neural tube — which becomes the brain and spinal cord — begins forming this week.',
    ),
    4: _BabyData(
      'Blueberry',
      '5 mm',
      PhosphorIcons.circle,
      'Your baby\'s heart is beating about 100–160 times per minute! Tiny arm and leg buds are sprouting, and the face is beginning to take shape.',
    ),
    8: _BabyData(
      'Kidney bean',
      '1.6 cm',
      PhosphorIcons.heart,
      'Fingers and toes are forming and the tail has disappeared. Your baby can now make small movements, though you won\'t feel them yet.',
    ),
    12: _BabyData(
      'Lime',
      '5.4 cm',
      PhosphorIcons.smiley,
      'The first trimester is ending! Your baby can open and close fingers, curl toes, and even suck a thumb. The risk of miscarriage drops significantly now.',
    ),
    16: _BabyData(
      'Avocado',
      '11.6 cm',
      PhosphorIcons.leaf,
      'Your baby can hear sounds from the outside world! Facial muscles are developing and tiny eyebrows and eyelashes are appearing.',
    ),
    20: _BabyData(
      'Banana',
      '25 cm',
      PhosphorIcons.star,
      'Halfway there! Your baby is swallowing amniotic fluid and the digestive system is practising for life outside the womb. This is when most anatomy scans happen.',
    ),
    24: _BabyData(
      'Corn',
      '30 cm',
      PhosphorIcons.flame,
      'Your baby\'s face is fully formed, with eyelashes, eyebrows, and hair. They can hear your voice and may respond to sounds and music.',
    ),
    28: _BabyData(
      'Eggplant',
      '37 cm',
      PhosphorIcons.sparkle,
      'Welcome to the third trimester! Baby\'s eyes can now open and close, and their brain is developing rapidly. They are practising breathing movements.',
    ),
    32: _BabyData(
      'Jicama',
      '42 cm',
      PhosphorIcons.baby,
      'Baby is gaining weight quickly now and building fat stores. The bones are hardening, though the skull remains soft to ease delivery.',
    ),
    36: _BabyData(
      'Squash',
      '47 cm',
      PhosphorIcons.baby,
      'Baby is considered full term soon! Most organs are fully developed. They are likely head-down in preparation for birth.',
    ),
    40: _BabyData(
      'Watermelon',
      '51 cm',
      PhosphorIcons.baby,
      'Your baby is fully developed and ready to meet you! They have a firm grasp and can recognise your voice from weeks of listening.',
    ),
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
    _tabController = TabController(length: 4, vsync: this);
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
    DateTime selectedLastPeriod =
        userController.userModel.value?.lastPeriodDate ??
        DateTime.now().subtract(const Duration(days: 14));
    int cycleLength = userController.userModel.value?.periodCycle ?? 28;

    DateTime calcConception(DateTime lmp) => lmp.add(const Duration(days: 14));
    DateTime calcDueDate(DateTime lmp) => lmp.add(const Duration(days: 280));

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            final conception = calcConception(selectedLastPeriod);
            final due = calcDueDate(selectedLastPeriod);

            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Text(
                'Pregnancy Details',
                style: GoogleFonts.philosopher(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  color: _plum,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Enter the first day of your last period to calculate your pregnancy progress.',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        color: _muted,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'First day of last period',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: _muted,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: ctx,
                          initialDate: selectedLastPeriod,
                          firstDate: DateTime.now().subtract(
                            const Duration(days: 300),
                          ),
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
                          setDialogState(() => selectedLastPeriod = picked);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 13,
                        ),
                        decoration: BoxDecoration(
                          color: _roseSoft,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: _rose.withOpacity(0.3)),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              PhosphorIcons.calendarBlank,
                              color: _rose,
                              size: 18,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              '${selectedLastPeriod.day}/${selectedLastPeriod.month}/${selectedLastPeriod.year}',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13.5,
                                color: _plum,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              'Change',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                color: _rose,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Cycle length: $cycleLength days',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: _muted,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Slider(
                      value: cycleLength.toDouble(),
                      min: 21,
                      max: 35,
                      divisions: 14,
                      activeColor: _rose,
                      inactiveColor: _roseSoft,
                      onChanged:
                          (v) => setDialogState(() => cycleLength = v.round()),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _roseSoft,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          _dialogInfoRow(
                            'Est. Conception',
                            '${conception.day}/${conception.month}/${conception.year}',
                          ),
                          const SizedBox(height: 6),
                          _dialogInfoRow(
                            'Est. Due Date',
                            '${due.day}/${due.month}/${due.year}',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.plusJakartaSans(color: _muted),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final conception = calcConception(selectedLastPeriod);
                    final due = calcDueDate(selectedLastPeriod);

                    await userController.updateUserData({
                      "conceptionDate": conception,
                      "dueDate": due,
                      "lastPeriodDate": selectedLastPeriod,
                      "periodCycle": cycleLength,
                    });

                    userController.userModel.value?.conceptionDate = conception;
                    userController.userModel.value?.dueDate = due;
                    userController.userModel.value?.lastPeriodDate =
                        selectedLastPeriod;
                    userController.userModel.value?.periodCycle = cycleLength;

                    setState(() => conceptionDate = conception);
                    calculateProgress();
                    Navigator.of(ctx).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _rose,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Save',
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _dialogInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(fontSize: 12, color: _muted),
        ),
        Text(
          value,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: _plum,
          ),
        ),
      ],
    );
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

  void _showEditWeekDialog() {
    int tempWeek = currentWeek;
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text(
              'Edit Current Week',
              style: GoogleFonts.philosopher(
                fontWeight: FontWeight.w700,
                color: _plum,
                fontSize: 18,
              ),
            ),
            content: StatefulBuilder(
              builder: (context, setLocal) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Week $tempWeek of 40',
                      style: GoogleFonts.philosopher(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: _amber,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Slider(
                      value: tempWeek.toDouble(),
                      min: 1,
                      max: 40,
                      divisions: 39,
                      activeColor: _amber,
                      inactiveColor: _amberSoft,
                      onChanged: (v) => setLocal(() => tempWeek = v.round()),
                    ),
                    Text(
                      'Drag to adjust your current week',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: _muted,
                      ),
                    ),
                  ],
                );
              },
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(
                  'Cancel',
                  style: GoogleFonts.plusJakartaSans(color: _muted),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _amber,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  final newConception = DateTime.now().subtract(
                    Duration(days: tempWeek * 7),
                  );
                  userController.updateUserData({
                    "conceptionDate": newConception,
                  });
                  userController.userModel.value!.conceptionDate =
                      newConception;
                  setState(() {
                    conceptionDate = newConception;
                    currentWeek = tempWeek;
                    currentDay = 0;
                  });
                  Navigator.pop(ctx);
                },
                child: Text(
                  'Save',
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
    );
  }

  void _showSymptomsBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (ctx) => StatefulBuilder(
            builder: (context, setLocal) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
                  top: 24,
                  left: 20,
                  right: 20,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'How are you feeling today?',
                      style: GoogleFonts.philosopher(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: _plum,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Select all symptoms you\'re experiencing',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        color: _muted,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children:
                          _availableSymptoms.map((s) {
                            final selected = _selectedSymptoms.contains(s);
                            return GestureDetector(
                              onTap: () {
                                setLocal(() {
                                  if (selected) {
                                    _selectedSymptoms.remove(s);
                                  } else {
                                    _selectedSymptoms.add(s);
                                  }
                                });
                                setState(() {});
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: selected ? _rose : _roseSoft,
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(
                                    color:
                                        selected
                                            ? _rose
                                            : _rose.withOpacity(0.2),
                                  ),
                                ),
                                child: Text(
                                  s,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: selected ? Colors.white : _rose,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _rose,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: () => Navigator.pop(ctx),
                        child: Text(
                          'Save Symptoms',
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
    );
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

  DateTime getDueDate() {
    return userController.userModel.value?.dueDate ??
        conceptionDate!.add(const Duration(days: 266));
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
                _buildBabyTab(),
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
          onPressed: _showSymptomsBottomSheet,
          icon: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(color: _roseSoft, shape: BoxShape.circle),
            child: Icon(PhosphorIcons.heartbeat, color: _rose, size: 17),
          ),
        ),
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
          fontSize: 11.5,
        ),
        unselectedLabelStyle: GoogleFonts.plusJakartaSans(
          fontWeight: FontWeight.w500,
          fontSize: 11.5,
        ),
        dividerColor: Colors.transparent,
        tabs: const [
          Tab(text: "Overview"),
          Tab(text: "Baby"),
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
    final next = getNextMilestone();

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
      children: [
        _buildHeroCard(tc, ts, totalDaysPassed, daysLeft, progress)
            .animate()
            .fadeIn(duration: 500.ms, curve: Curves.easeOut)
            .slideY(begin: 0.07, end: 0, duration: 500.ms),
        const SizedBox(height: 16),
        _buildBabySizeCard(baby, tc, ts)
            .animate()
            .fadeIn(delay: 100.ms, duration: 450.ms, curve: Curves.easeOut)
            .slideY(begin: 0.06, end: 0, delay: 100.ms, duration: 450.ms),
        const SizedBox(height: 12),
        if (_selectedSymptoms.isNotEmpty) ...[
          _buildSymptomsCard().animate().fadeIn(
            delay: 140.ms,
            duration: 400.ms,
            curve: Curves.easeOut,
          ),
          const SizedBox(height: 12),
        ],
        Row(
          children: [
            Expanded(
              child: _statCard(
                    PhosphorIcons.calendar,
                    "Due Date",
                    DateFormat('d MMM yyyy').format(getDueDate()),
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
              child: GestureDetector(
                onTap: _showEditWeekDialog,
                child: _statCard(
                      PhosphorIcons.hourglass,
                      "Current Week",
                      "Week $currentWeek",
                      _amber,
                      editable: true,
                    )
                    .animate()
                    .fadeIn(
                      delay: 200.ms,
                      duration: 400.ms,
                      curve: Curves.easeOut,
                    )
                    .slideY(
                      begin: 0.05,
                      end: 0,
                      delay: 200.ms,
                      duration: 400.ms,
                    ),
              ),
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
        const SizedBox(height: 16),
        GestureDetector(
          onTap: _showSymptomsBottomSheet,
          child: _buildAddSymptomsButton().animate().fadeIn(
            delay: 300.ms,
            duration: 400.ms,
            curve: Curves.easeOut,
          ),
        ),
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

  Widget _buildSymptomsCard() {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Today's Symptoms",
                style: GoogleFonts.philosopher(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: _plum,
                ),
              ),
              GestureDetector(
                onTap: _showSymptomsBottomSheet,
                child: Text(
                  'Edit',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: _rose,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children:
                _selectedSymptoms
                    .map(
                      (s) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: _roseSoft,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: _rose.withOpacity(0.25)),
                        ),
                        child: Text(
                          s,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: _rose,
                          ),
                        ),
                      ),
                    )
                    .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildAddSymptomsButton() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _roseSoft,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _rose.withOpacity(0.25)),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(color: _rose, shape: BoxShape.circle),
            child: const Icon(Icons.add, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Log Symptoms',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: _plum,
                  ),
                ),
                Text(
                  'Track how you\'re feeling today',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: _muted,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: _rose),
        ],
      ),
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
            GestureDetector(
              onTap: () => _tabController.animateTo(1),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _roseSoft,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Read more',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: _rose,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statCard(
    IconData icon,
    String label,
    String value,
    Color color, {
    bool editable = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border:
            editable
                ? Border.all(color: color.withOpacity(0.3), width: 1.5)
                : null,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              if (editable)
                Icon(PhosphorIcons.pencilSimple, size: 13, color: color),
            ],
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
          if (editable)
            Text(
              'Tap to edit',
              style: GoogleFonts.plusJakartaSans(fontSize: 10, color: color),
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

  Widget _buildBabyTab() {
    final allWeeks = List.generate(40, (i) => i + 1);
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
      children: [
        Text(
          "Baby's Development",
          style: GoogleFonts.philosopher(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: _plum,
          ),
        ).animate().fadeIn(duration: 400.ms, curve: Curves.easeOut),
        const SizedBox(height: 4),
        Text(
          "See how your baby grows week by week",
          style: GoogleFonts.plusJakartaSans(fontSize: 12.5, color: _muted),
        ).animate().fadeIn(
          delay: 60.ms,
          duration: 400.ms,
          curve: Curves.easeOut,
        ),
        const SizedBox(height: 20),
        _buildCurrentWeekBabyCard()
            .animate()
            .fadeIn(delay: 80.ms, duration: 450.ms, curve: Curves.easeOut)
            .slideY(begin: 0.05, end: 0, delay: 80.ms, duration: 450.ms),
        const SizedBox(height: 20),
        Text(
          "All Stages",
          style: GoogleFonts.philosopher(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: _plum,
          ),
        ).animate().fadeIn(
          delay: 120.ms,
          duration: 400.ms,
          curve: Curves.easeOut,
        ),
        const SizedBox(height: 12),
        ...allWeeks.asMap().entries.map((entry) {
          final i = entry.key;
          final week = entry.value;
          final isCurrentWeek = week == currentWeek;
          final isPast = week < currentWeek;
          return _buildWeekTile(week, isCurrentWeek, isPast).animate().fadeIn(
            delay: (120 + 15 * i).ms,
            duration: 350.ms,
            curve: Curves.easeOut,
          );
        }).toList(),
      ],
    );
  }

  Widget _buildCurrentWeekBabyCard() {
    final baby = getCurrentBabyData();
    final tc = getTrimesterColor();
    final ts = getTrimesterSoft();

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [tc, tc.withOpacity(0.75)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: tc.withOpacity(0.3),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.22),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "Week $currentWeek · Your baby now",
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(baby.icon, color: Colors.white, size: 30),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        baby.name,
                        style: GoogleFonts.philosopher(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        "About ${baby.size} long",
                        style: GoogleFonts.plusJakartaSans(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                baby.description,
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.white,
                  fontSize: 13,
                  height: 1.6,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeekTile(int week, bool isCurrentWeek, bool isPast) {
    final keys = babyData.keys.toList()..sort();
    int matchKey = keys.first;
    for (final k in keys) {
      if (week >= k) matchKey = k;
    }
    final baby = babyData[matchKey]!;

    final tc =
        week < 13
            ? _rose
            : week < 28
            ? _amber
            : _sage;
    final ts =
        week < 13
            ? _roseSoft
            : week < 28
            ? _amberSoft
            : _sageSoft;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isCurrentWeek ? tc.withOpacity(0.08) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isCurrentWeek ? tc.withOpacity(0.3) : Colors.grey.shade100,
          width: isCurrentWeek ? 1.5 : 1,
        ),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isPast || isCurrentWeek ? ts : Colors.grey.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(
              baby.icon,
              color: isPast || isCurrentWeek ? tc : Colors.grey.shade400,
              size: 18,
            ),
          ),
          title: Row(
            children: [
              Text(
                "Week $week",
                style: GoogleFonts.philosopher(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: isPast || isCurrentWeek ? _plum : _muted,
                ),
              ),
              if (isCurrentWeek) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: tc,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "You're here",
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ],
          ),
          subtitle: Text(
            baby.name,
            style: GoogleFonts.plusJakartaSans(fontSize: 12, color: _muted),
          ),
          trailing:
              isPast
                  ? Icon(PhosphorIcons.checkCircle, color: tc, size: 18)
                  : null,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: ts,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                baby.description,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  color: _plum,
                  height: 1.6,
                ),
              ),
            ),
          ],
        ),
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
                              "When did you conceive?",
                              style: GoogleFonts.philosopher(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.w700,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "We'll use this to track your baby's growth and give you personalised weekly tips.",
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
            Center(
              child: ClipRRect(
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
  final String description;
  const _BabyData(this.name, this.size, this.icon, this.description);
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
