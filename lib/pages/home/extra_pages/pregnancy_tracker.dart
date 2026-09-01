import 'package:bridge_ai/constants/app_constants.dart';
import 'package:bridge_ai/constants/controllers.dart';
import 'package:bridge_ai/controllers/ai_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

class PregnancyTrackerPage extends StatefulWidget {
  @override
  _PregnancyTrackerPageState createState() => _PregnancyTrackerPageState();
}

class _PregnancyTrackerPageState extends State<PregnancyTrackerPage> {
  DateTime? conceptionDate;
  final int totalPregnancyDays = 280;
  int currentWeek = 0;
  int currentDay = 0;
  String generalInfo = "Loading your personalized tip...";
  late TextEditingController _conceptionDateController;

  final Map<int, String> babySizeComparisons = {
    0: 'Poppy seed',
    4: 'Blueberry',
    8: 'Kidney bean',
    12: 'Lime',
    16: 'Avocado',
    20: 'Banana',
    24: 'Corn',
    28: 'Eggplant',
    32: 'Jicama',
    36: 'Squash',
    40: 'Watermelon',
  };

  @override
  void initState() {
    super.initState();
    _conceptionDateController = TextEditingController();
    loadConceptionDate();
  }

  @override
  void dispose() {
    _conceptionDateController.dispose();
    super.dispose();
  }

  Future<void> getInfo() async {
    generalInfo = await VertexAIController.suggestPregnancyTip(getTrimester());
    setState(() {});
  }

  Future<void> loadConceptionDate() async {
    if (userController.userModel.value!.conceptionDate != null) {
      setState(() {
        conceptionDate = userController.userModel.value!.conceptionDate;
        calculateProgress();
      });
    } else {
      promptForConceptionDate();
    }
  }

  Future<void> promptForConceptionDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 100)),
      firstDate: DateTime.now().subtract(const Duration(days: 300)),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      await userController.updateUserData({"conceptionDate": pickedDate});
      setState(() {
        userController.userModel.value!.conceptionDate = pickedDate;
        conceptionDate = pickedDate;
        _conceptionDateController.text = DateFormat(
          'MM/dd/yyyy',
        ).format(pickedDate);
        calculateProgress();
      });
    }
  }

  void calculateProgress() async {
    if (conceptionDate == null) return;
    final today = DateTime.now();
    final daysPregnant = today.difference(conceptionDate!).inDays;
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

  String getDateRange() {
    final start = conceptionDate!.add(Duration(days: currentWeek * 7));
    final end = start.add(const Duration(days: 6));
    return '${DateFormat("d MMM").format(start)} - ${DateFormat("d MMM").format(end)}';
  }

  String getBabySize() {
    return babySizeComparisons[currentWeek] ?? 'Growing baby';
  }

  @override
  Widget build(BuildContext context) {
    if (conceptionDate == null) {
      return _buildConceptionDateScreen();
    }

    final daysLeft = totalPregnancyDays - ((currentWeek * 7) + currentDay);
    return _buildPregnancyTrackerScreen(daysLeft);
  }

  Widget _buildConceptionDateScreen() {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        toolbarHeight: 70,
        centerTitle: false,
        title: Text(
          "Set Conception Date",
          style: GoogleFonts.montserrat(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back_ios, color: Colors.black87, size: 18),
        ),
      ),
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                _buildDateSetupHeader(),
                const SizedBox(height: 40),
                _buildDateInputSection(),
                const SizedBox(height: 40),
                _buildDatePickerCTA(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDateSetupHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'When did you conceive?',
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w600,
            fontSize: 24,
            color: Colors.black87,
            height: 1.3,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'This helps us track your pregnancy progress and provide personalized weekly insights about your baby\'s development.',
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: Colors.black54,
            height: 1.6,
          ),
        ),
      ],
    );
  }

  Widget _buildDateInputSection() {
    return GestureDetector(
      onTap: promptForConceptionDate,
      child: Container(
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
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Icon(
                        PhosphorIcons.calendar,
                        color: primaryColor,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Conception Date',
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              AbsorbPointer(
                child: TextField(
                  controller: _conceptionDateController,
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    hintText: "MM/DD/YYYY",
                    hintStyle: GoogleFonts.montserrat(
                      fontSize: 14,
                      color: Colors.black45,
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 14,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey.shade100),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey.shade100),
                    ),
                    suffixIcon: Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDatePickerCTA() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: promptForConceptionDate,
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.date_range, color: Colors.white, size: 18),
                const SizedBox(width: 8),
                Text(
                  'Choose Date',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPregnancyTrackerScreen(int daysLeft) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        toolbarHeight: 70,
        centerTitle: false,
        title: Text(
          "Pregnancy Tracker",
          style: GoogleFonts.montserrat(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back_ios, color: Colors.black87, size: 18),
        ),
      ),
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                _buildTrimesterHeader(),
                const SizedBox(height: 32),
                _buildProgressCard(daysLeft),
                const SizedBox(height: 32),
                _buildWeeklyStatsGrid(daysLeft),
                const SizedBox(height: 32),
                _buildBabySizeCard(),
                const SizedBox(height: 32),
                _buildTipSection(),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTrimesterHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          getTrimester(),
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w600,
            fontSize: 28,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          getDateRange(),
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressCard(int daysLeft) {
    final totalDaysPassed = (currentWeek * 7) + currentDay;
    final progressPercent = totalDaysPassed / totalPregnancyDays;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            primaryColor.withOpacity(0.1),
            primaryColor.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primaryColor.withOpacity(0.15), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Lottie.asset(
                'images/pregnancy.json',
                repeat: true,
                frameRate: FrameRate(30),
                height: 160,
              ),
            ),
            const SizedBox(height: 24),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progressPercent,
                minHeight: 8,
                backgroundColor: Colors.white.withOpacity(0.5),
                valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$totalDaysPassed',
                      style: GoogleFonts.montserrat(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Days Pregnant',
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '$daysLeft',
                      style: GoogleFonts.montserrat(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Days Left',
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              '$currentWeek weeks and $currentDay day${currentDay == 1 ? '' : 's'}',
              style: GoogleFonts.montserrat(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklyStatsGrid(int daysLeft) {
    final dueDate = conceptionDate!.add(Duration(days: totalPregnancyDays));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Key Dates',
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
                label: 'Due Date',
                value: DateFormat('d MMM').format(dueDate),
                color: primaryColor,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                icon: PhosphorIcons.hourglass,
                label: 'Current Week',
                value: 'Week $currentWeek',
                color: const Color(0xFFFFA726),
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
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(child: Icon(icon, color: color, size: 18)),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w500,
                fontSize: 11,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBabySizeCard() {
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
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Icon(
                  PhosphorIcons.baby,
                  color: const Color(0xFF66BB6A),
                  size: 28,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Baby Size This Week',
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'About the size of a ${getBabySize().toLowerCase()}',
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w400,
                      fontSize: 13,
                      color: Colors.black54,
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

  Widget _buildTipSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Weekly Tip',
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
}
