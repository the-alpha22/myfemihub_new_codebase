// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'package:bridge_ai/models/exercise.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

const _rose = Color(0xFFE8567A);
const _plum = Color(0xFF3D1A2E);
const _muted = Color(0xFF9E8892);

class ExerciseDetailPage extends StatefulWidget {
  final ExerciseModel exercise;
  const ExerciseDetailPage({required this.exercise, super.key});

  @override
  State<ExerciseDetailPage> createState() => _ExerciseDetailPageState();
}

class _ExerciseDetailPageState extends State<ExerciseDetailPage>
    with TickerProviderStateMixin {
  int _currentStep = 0;
  int _secondsLeft = 0;
  bool _isRunning = false;
  bool _isDone = false;
  Timer? _timer;
  late AnimationController _progressController;

  ExerciseStep get _step => widget.exercise.steps[_currentStep];
  bool get _isLastStep => _currentStep == widget.exercise.steps.length - 1;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(vsync: this);
    _resetStep();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _progressController.dispose();
    super.dispose();
  }

  void _resetStep() {
    _timer?.cancel();
    _progressController.stop();
    _progressController.reset();
    setState(() {
      _secondsLeft = _step.durationSeconds;
      _isRunning = false;
    });
  }

  void _startTimer() {
    setState(() => _isRunning = true);
    _progressController.duration = Duration(seconds: _step.durationSeconds);
    _progressController.forward(from: 0);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_secondsLeft <= 1) {
        t.cancel();
        _progressController.stop();
        setState(() {
          _secondsLeft = 0;
          _isRunning = false;
        });
        _onStepComplete();
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    _progressController.stop();
    setState(() => _isRunning = false);
  }

  void _onStepComplete() {
    if (_isLastStep) {
      setState(() => _isDone = true);
    } else {
      Future.delayed(const Duration(milliseconds: 600), () {
        if (mounted) {
          setState(() => _currentStep++);
          _resetStep();
        }
      });
    }
  }

  void _goToStep(int index) {
    setState(() => _currentStep = index);
    _resetStep();
  }

  String _formatTime(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return "$m:$s";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _isDone ? _buildDoneScreen() : _buildExerciseScreen(),
    );
  }

  Widget _buildExerciseScreen() {
    return Column(
      children: [
        _buildHeader(),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildIllustration(),
                _buildStepIndicator(),
                _buildStepContent(),
                _buildTimer(),
                _buildControls(),
                _buildStepList(),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      color: Colors.white,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 20, 12),
          child: Row(
            children: [
              IconButton(
                onPressed: () => Get.back(),
                icon: Icon(PhosphorIcons.arrowLeft, color: _plum, size: 22),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.exercise.category,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        color: _muted,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      widget.exercise.title,
                      style: GoogleFonts.philosopher(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: _plum,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: widget.exercise.cardBg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "${widget.exercise.steps.length} steps",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: widget.exercise.accent,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIllustration() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      child: Container(
        key: ValueKey(_currentStep),
        height: 220,
        width: double.infinity,
        margin: const EdgeInsets.fromLTRB(20, 8, 20, 0),
        decoration: BoxDecoration(
          color: widget.exercise.cardBg,
          borderRadius: BorderRadius.circular(24),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Image.asset(
            _step.illustration,
            fit: BoxFit.contain,
            errorBuilder:
                (_, __, ___) => Center(
                  child: Icon(
                    Icons.self_improvement_rounded,
                    size: 80,
                    color: widget.exercise.accent.withOpacity(0.35),
                  ),
                ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Row(
        children:
            widget.exercise.steps.asMap().entries.map((entry) {
              final i = entry.key;
              final isActive = i == _currentStep;
              final isDone = i < _currentStep;
              return Expanded(
                child: GestureDetector(
                  onTap: () => _goToStep(i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    height: 4,
                    margin: EdgeInsets.only(
                      right: i < widget.exercise.steps.length - 1 ? 4 : 0,
                    ),
                    decoration: BoxDecoration(
                      color:
                          isDone
                              ? widget.exercise.accent
                              : isActive
                              ? widget.exercise.accent.withOpacity(0.5)
                              : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }

  Widget _buildStepContent() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 350),
      child: Padding(
        key: ValueKey(_currentStep),
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: widget.exercise.accent,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      "${_currentStep + 1}",
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    _step.title,
                    style: GoogleFonts.philosopher(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: _plum,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              _step.description,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                color: Colors.black87,
                fontWeight: FontWeight.w400,
                height: 1.65,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimer() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
      child: Row(
        children: [
          Expanded(
            child: AnimatedBuilder(
              animation: _progressController,
              builder: (_, __) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value:
                        _isRunning || _secondsLeft == 0
                            ? _progressController.value
                            : 0,
                    minHeight: 8,
                    backgroundColor: Colors.grey.shade100,
                    valueColor: AlwaysStoppedAnimation(widget.exercise.accent),
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 14),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Text(
              _formatTime(_secondsLeft),
              key: ValueKey(_secondsLeft),
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: _secondsLeft <= 5 && _secondsLeft > 0 ? _rose : _plum,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControls() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Row(
        children: [
          if (_currentStep > 0)
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _goToStep(_currentStep - 1),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: BorderSide(color: Colors.grey.shade200),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                icon: Icon(PhosphorIcons.arrowLeft, size: 16, color: _muted),
                label: Text(
                  "Back",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _muted,
                  ),
                ),
              ),
            ),
          if (_currentStep > 0) const SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: ElevatedButton.icon(
              onPressed:
                  _secondsLeft == 0
                      ? (_isLastStep ? null : () => _goToStep(_currentStep + 1))
                      : (_isRunning ? _pauseTimer : _startTimer),
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.exercise.accent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              icon: Icon(
                _secondsLeft == 0
                    ? (_isLastStep
                        ? Icons.check_rounded
                        : PhosphorIcons.arrowRight)
                    : (_isRunning ? PhosphorIcons.pause : PhosphorIcons.play),
                size: 18,
              ),
              label: Text(
                _secondsLeft == 0
                    ? (_isLastStep ? "Done!" : "Next step")
                    : (_isRunning ? "Pause" : "Start"),
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepList() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "All steps",
            style: GoogleFonts.philosopher(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: _plum,
            ),
          ),
          const SizedBox(height: 12),
          ...widget.exercise.steps.asMap().entries.map((entry) {
            final i = entry.key;
            final step = entry.value;
            final isActive = i == _currentStep;
            final isDone = i < _currentStep;
            return GestureDetector(
              onTap: () => _goToStep(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isActive ? widget.exercise.cardBg : Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color:
                        isActive
                            ? widget.exercise.accent.withOpacity(0.35)
                            : Colors.grey.shade100,
                    width: isActive ? 1.5 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color:
                            isDone
                                ? widget.exercise.accent
                                : isActive
                                ? widget.exercise.accent.withOpacity(0.15)
                                : Colors.grey.shade100,
                      ),
                      child: Center(
                        child:
                            isDone
                                ? const Icon(
                                  Icons.check_rounded,
                                  color: Colors.white,
                                  size: 16,
                                )
                                : Text(
                                  "${i + 1}",
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color:
                                        isActive
                                            ? widget.exercise.accent
                                            : _muted,
                                  ),
                                ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            step.title,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w600,
                              color: isActive ? _plum : _muted,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "${step.durationSeconds}s",
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11.5,
                              color: _muted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isActive)
                      Icon(
                        PhosphorIcons.caretRight,
                        color: widget.exercise.accent,
                        size: 16,
                      ),
                  ],
                ),
              ).animate().fadeIn(delay: (40 * i).ms, duration: 300.ms),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildDoneScreen() {
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: widget.exercise.cardBg,
                    ),
                    child: Icon(
                      Icons.check_rounded,
                      size: 52,
                      color: widget.exercise.accent,
                    ),
                  )
                  .animate()
                  .scale(
                    begin: const Offset(0.5, 0.5),
                    end: const Offset(1, 1),
                    duration: 500.ms,
                    curve: Curves.elasticOut,
                  )
                  .fadeIn(duration: 300.ms),
              const SizedBox(height: 28),
              Text(
                "Great work! 🎉",
                style: GoogleFonts.philosopher(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: _plum,
                ),
              ).animate().fadeIn(delay: 300.ms, duration: 400.ms),
              const SizedBox(height: 12),
              Text(
                "You completed\n${widget.exercise.title}",
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 15,
                  color: _muted,
                  height: 1.5,
                ),
              ).animate().fadeIn(delay: 400.ms, duration: 400.ms),
              const SizedBox(height: 8),
              Text(
                "${widget.exercise.steps.length} steps · ${_formatTime(widget.exercise.totalDuration)}",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: widget.exercise.accent,
                ),
              ).animate().fadeIn(delay: 500.ms, duration: 400.ms),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _currentStep = 0;
                      _isDone = false;
                    });
                    _resetStep();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.exercise.accent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    "Do it again",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ).animate().fadeIn(delay: 600.ms, duration: 400.ms),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Get.back(),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: BorderSide(color: Colors.grey.shade200),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    "Back to home",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: _muted,
                    ),
                  ),
                ),
              ).animate().fadeIn(delay: 700.ms, duration: 400.ms),
            ],
          ),
        ),
      ),
    );
  }
}
