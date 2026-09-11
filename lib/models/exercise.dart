import 'package:flutter/material.dart';

class ExerciseStep {
  final String title;
  final String description;
  final int durationSeconds;
  final String illustration;

  const ExerciseStep({
    required this.title,
    required this.description,
    required this.durationSeconds,
    required this.illustration,
  });
}

class ExerciseModel {
  final String id;
  final String title;
  final String category;
  final String description;
  final Color cardBg;
  final Color accent;
  final String illustration;
  final List<ExerciseStep> steps;

  const ExerciseModel({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.cardBg,
    required this.accent,
    required this.illustration,
    required this.steps,
  });

  int get totalDuration => steps.fold(0, (sum, s) => sum + s.durationSeconds);
}

class ExerciseCategory {
  final String title;
  final List<ExerciseModel> exercises;
  const ExerciseCategory({required this.title, required this.exercises});
}
