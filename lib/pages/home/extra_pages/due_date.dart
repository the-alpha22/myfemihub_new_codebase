// ignore_for_file: deprecated_member_use

import 'package:bridge_ai/services/cycle_notification_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bridge_ai/constants/controllers.dart';
import 'package:bridge_ai/pages/home/extra_pages/period_tracker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

const _rose = Color(0xFFE8567A);
const _roseDark = Color(0xFFC03A5E);
const _roseSoft = Color(0xFFFFF0F4);
const _plum = Color(0xFF3D1A2E);
const _muted = Color(0xFF9E8892);
const _surface = Color(0xFFFDF7F9);

class DueDateCalculatorScreen extends StatefulWidget {
  @override
  _DueDateCalculatorScreenState createState() =>
      _DueDateCalculatorScreenState();
}

class _DueDateCalculatorScreenState extends State<DueDateCalculatorScreen> {
  // FIX 2: Pre-fill from user's saved data, not hardcoded defaults
  late final TextEditingController _periodLengthController =
      TextEditingController(
        text: '${userController.userModel.value?.periodLength ?? 3}',
      );
  late final TextEditingController _cycleLengthController =
      TextEditingController(
        text: '${userController.userModel.value?.periodCycle ?? 28}',
      );

  // FIX 2: Pre-fill saved date
  DateTime? _selectedDate = userController.userModel.value?.perioddate;

  // FIX 1: Track original values to detect any change
  late final int _originalPeriodLength =
      userController.userModel.value?.periodLength ?? 3;
  late final int _originalCycleLength =
      userController.userModel.value?.periodCycle ?? 28;
  late final DateTime? _originalDate =
      userController.userModel.value?.perioddate;

  bool _saving = false;

  int get _periodLength =>
      int.tryParse(_periodLengthController.text) ?? _originalPeriodLength;
  int get _cycleLength =>
      int.tryParse(_cycleLengthController.text) ?? _originalCycleLength;

  bool get _canSave {
    if (_saving) return false;
    if (_selectedDate == null) return false;
    final dateChanged =
        _originalDate == null ||
        _selectedDate!.year != _originalDate.year ||
        _selectedDate!.month != _originalDate.month ||
        _selectedDate!.day != _originalDate.day;
    final periodChanged = _periodLength != _originalPeriodLength;
    final cycleChanged = _cycleLength != _originalCycleLength;
    return dateChanged || periodChanged || cycleChanged;
  }

  void _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
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
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _addPeriodData() async {
    if (!_canSave) return;
    setState(() => _saving = true);
    await userController.updateUserData({
      "perioddate": Timestamp.fromDate(_selectedDate!),
      "periodLength": _periodLength,
      "periodCycle": _cycleLength,
    });
    userController.userModel.value!.perioddate = _selectedDate!;
    userController.userModel.value!.periodCycle = _cycleLength;
    userController.userModel.value!.periodLength = _periodLength;
    await CycleNotificationService.scheduleAll(
      lastPeriodStart: _selectedDate!,
      periodLength: _periodLength,
      cycleLength: _cycleLength,
      userName: userController.userModel.value!.name,
    );
    Get.to(() => PeriodTrackerScreen(), transition: Transition.rightToLeft);
  }

  @override
  void dispose() {
    _periodLengthController.dispose();
    _cycleLengthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _surface,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildIntroCard()
                .animate()
                .fadeIn(duration: 500.ms, curve: Curves.easeOut)
                .slideY(begin: 0.07, end: 0, duration: 500.ms),
            const SizedBox(height: 28),
            Text(
              "Your Cycle Details",
              style: GoogleFonts.philosopher(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: _plum,
              ),
            ).animate().fadeIn(delay: 120.ms, duration: 400.ms),
            const SizedBox(height: 4),
            Text(
              "Tap +/− to adjust, then save",
              style: GoogleFonts.plusJakartaSans(fontSize: 12.5, color: _muted),
            ).animate().fadeIn(delay: 150.ms, duration: 400.ms),
            const SizedBox(height: 16),
            _buildStepperField(
                  index: 1,
                  label: "Period Length",
                  sublabel: "How many days does your period last?",
                  controller: _periodLengthController,
                  min: 1,
                  max: 10,
                )
                .animate()
                .fadeIn(delay: 180.ms, duration: 400.ms)
                .slideY(begin: 0.05, end: 0, delay: 180.ms, duration: 400.ms),
            const SizedBox(height: 12),
            _buildStepperField(
                  index: 2,
                  label: "Cycle Length",
                  sublabel: "Days from period start to next period start",
                  controller: _cycleLengthController,
                  min: 21,
                  max: 45,
                )
                .animate()
                .fadeIn(delay: 240.ms, duration: 400.ms)
                .slideY(begin: 0.05, end: 0, delay: 240.ms, duration: 400.ms),
            const SizedBox(height: 12),
            _buildDateField()
                .animate()
                .fadeIn(delay: 300.ms, duration: 400.ms)
                .slideY(begin: 0.05, end: 0, delay: 300.ms, duration: 400.ms),
            const SizedBox(height: 8),
            // FIX 1: Show what changed as a hint
            if (_selectedDate != null)
              _buildChangeSummary().animate().fadeIn(
                delay: 340.ms,
                duration: 350.ms,
              ),
            const SizedBox(height: 24),
            _buildSaveButton()
                .animate()
                .fadeIn(delay: 380.ms, duration: 400.ms)
                .slideY(begin: 0.05, end: 0, delay: 380.ms, duration: 400.ms),
          ],
        ),
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
        "Period Data",
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
    );
  }

  Widget _buildIntroCard() {
    return Container(
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
            padding: const EdgeInsets.all(22),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.18),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    PhosphorIcons.drop,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Update Your Cycle",
                        style: GoogleFonts.philosopher(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Your current data is pre-filled.\nChange any field and tap Save.",
                        style: GoogleFonts.plusJakartaSans(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 12.5,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepperField({
    required int index,
    required String label,
    required String sublabel,
    required TextEditingController controller,
    required int min,
    required int max,
  }) {
    final value = int.tryParse(controller.text) ?? min;

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
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: _roseSoft,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  "$index",
                  style: GoogleFonts.philosopher(
                    color: _rose,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.philosopher(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: _plum,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    sublabel,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11.5,
                      color: _muted,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Row(
              children: [
                _stepBtn(
                  icon: Icons.remove_rounded,
                  onTap:
                      value > min
                          ? () =>
                              setState(() => controller.text = "${value - 1}")
                          : null,
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 32,
                  child: Text(
                    "$value",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.philosopher(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: _plum,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                _stepBtn(
                  icon: Icons.add_rounded,
                  onTap:
                      value < max
                          ? () =>
                              setState(() => controller.text = "${value + 1}")
                          : null,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _stepBtn({required IconData icon, VoidCallback? onTap}) {
    final active = onTap != null;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: active ? _roseSoft : Colors.grey.shade100,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 16,
          color: active ? _rose : Colors.grey.shade400,
        ),
      ),
    );
  }

  Widget _buildDateField() {
    final hasDate = _selectedDate != null;
    return GestureDetector(
      onTap: _pickDate,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: hasDate ? _rose.withOpacity(0.4) : Colors.transparent,
            width: 1.5,
          ),
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
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: _roseSoft,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    "3",
                    style: GoogleFonts.philosopher(
                      color: _rose,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Last Period Start",
                      style: GoogleFonts.philosopher(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: _plum,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      hasDate
                          ? DateFormat('MMMM d, yyyy').format(_selectedDate!)
                          : "Tap to select date",
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: hasDate ? 13 : 11.5,
                        color: hasDate ? _rose : _muted,
                        fontWeight: hasDate ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                PhosphorIcons.calendarBlank,
                color: hasDate ? _rose : _muted,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChangeSummary() {
    final changes = <String>[];
    if (_periodLength != _originalPeriodLength) {
      changes.add("Period: $_originalPeriodLength → $_periodLength days");
    }
    if (_cycleLength != _originalCycleLength) {
      changes.add("Cycle: $_originalCycleLength → $_cycleLength days");
    }
    if (_originalDate != null && _selectedDate != null) {
      final orig = DateFormat('d MMM').format(_originalDate);
      final sel = DateFormat('d MMM').format(_selectedDate!);
      if (orig != sel) changes.add("Start date: $orig → $sel");
    }

    if (changes.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: _roseSoft,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _rose.withOpacity(0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(PhosphorIcons.arrowsClockwise, color: _rose, size: 14),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              changes.join("  •  "),
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11.5,
                color: _rose,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return GestureDetector(
      onTap: _canSave ? _addPeriodData : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 17),
        decoration: BoxDecoration(
          gradient:
              _canSave
                  ? const LinearGradient(
                    colors: [_rose, _roseDark],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                  : null,
          color: _canSave ? null : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(14),
          boxShadow:
              _canSave
                  ? [
                    BoxShadow(
                      color: _rose.withOpacity(0.35),
                      blurRadius: 14,
                      offset: const Offset(0, 5),
                    ),
                  ]
                  : [],
        ),
        child:
            _saving
                ? const Center(
                  child: SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  ),
                )
                : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _canSave ? PhosphorIcons.floppyDisk : PhosphorIcons.lock,
                      color: _canSave ? Colors.white : Colors.grey.shade400,
                      size: 17,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _canSave ? "Save & Update" : "No changes detected",
                      style: GoogleFonts.plusJakartaSans(
                        color: _canSave ? Colors.white : Colors.grey.shade400,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
      ),
    );
  }
}
