import 'package:bridge_ai/models/exercise.dart';
import 'package:flutter/material.dart';

const _yellow = Color(0xFFFFF3C4);
const _yellowAccent = Color(0xFFE8A020);
const _purple = Color(0xFFEDE8FF);
const _purpleAccent = Color(0xFF7C5CBF);

final List<ExerciseCategory> exerciseCategories = [
  ExerciseCategory(
    title: "Menstrual cramps relief",
    exercises: [
      ExerciseModel(
        id: "period_pain_relief",
        title: "Period pain relief",
        category: "Menstrual cramps relief",
        description:
            "Gentle stretches and poses to ease menstrual cramps and lower back pain.",
        cardBg: _yellow,
        accent: _yellowAccent,
        illustration: "images/back_stretch.json",
        steps: [
          ExerciseStep(
            title: "Child's Pose",
            description:
                "Kneel on the floor, sit back on your heels, and stretch your arms forward on the floor. Breathe deeply and let your belly relax.",
            durationSeconds: 30,
            illustration: "images/ex_childs_pose.png",
          ),
          ExerciseStep(
            title: "Supine Twist",
            description:
                "Lie on your back, bring your knees to your chest, then gently drop both knees to one side. Keep your shoulders flat on the floor.",
            durationSeconds: 30,
            illustration: "images/ex_supine_twist.png",
          ),
          ExerciseStep(
            title: "Cat-Cow Stretch",
            description:
                "Get on all fours. Inhale and arch your back downward (cow), then exhale and round your spine upward (cat). Move slowly and breathe.",
            durationSeconds: 45,
            illustration: "images/ex_cat_cow.png",
          ),
          ExerciseStep(
            title: "Supported Bridge",
            description:
                "Lie on your back with knees bent. Press your feet into the floor and lift your hips. Hold the position and breathe steadily.",
            durationSeconds: 30,
            illustration: "images/ex_bridge.png",
          ),
          ExerciseStep(
            title: "Knees to Chest",
            description:
                "Lie flat on your back, hug both knees into your chest and gently rock side to side to massage your lower back.",
            durationSeconds: 30,
            illustration: "images/ex_knees_chest.png",
          ),
        ],
      ),
      ExerciseModel(
        id: "foot_massage_cramps",
        title: "Foot massage for cramps",
        category: "Menstrual cramps relief",
        description:
            "Reflexology-inspired foot massage techniques that target pressure points linked to menstrual pain.",
        cardBg: _yellow,
        accent: _yellowAccent,
        illustration: "images/generic_lottie.json",
        steps: [
          ExerciseStep(
            title: "Warm Up the Foot",
            description:
                "Hold your foot with both hands and gently squeeze from heel to toe, repeating 5 times to warm up the tissue.",
            durationSeconds: 30,
            illustration: "images/ex_foot_warmup.png",
          ),
          ExerciseStep(
            title: "Arch Pressure",
            description:
                "Use both thumbs to apply firm circular pressure along the arch of your foot from heel to ball. This targets the uterus reflex point.",
            durationSeconds: 45,
            illustration: "images/ex_arch_press.png",
          ),
          ExerciseStep(
            title: "Ankle Rotation",
            description:
                "Hold your ankle and slowly rotate your foot in full circles, 5 times clockwise and 5 times counter-clockwise.",
            durationSeconds: 30,
            illustration: "images/ex_ankle_rotation.png",
          ),
          ExerciseStep(
            title: "Heel Press",
            description:
                "Apply firm thumb pressure to the centre of your heel. Hold for 5 seconds, release, and repeat. This targets the lower back reflex.",
            durationSeconds: 40,
            illustration: "images/ex_heel_press.png",
          ),
        ],
      ),
      ExerciseModel(
        id: "heat_and_breathe",
        title: "Heat & breathe",
        category: "Menstrual cramps relief",
        description:
            "A calming breathwork session designed to reduce cramp intensity and promote relaxation during your period.",
        cardBg: _yellow,
        accent: _yellowAccent,
        illustration: "images/generic_lottie.json",
        steps: [
          ExerciseStep(
            title: "Box Breathing",
            description:
                "Sit comfortably upright. Inhale for 4 counts, hold for 4, exhale for 4, hold for 4. Repeat this cycle to calm your nervous system.",
            durationSeconds: 60,
            illustration: "images/ex_box_breathing.png",
          ),
          ExerciseStep(
            title: "Belly Breathing",
            description:
                "Place one hand on your chest and one on your belly. Breathe in slowly so only your belly rises. Exhale fully and feel it fall.",
            durationSeconds: 45,
            illustration: "images/ex_belly_breathing.png",
          ),
          ExerciseStep(
            title: "Extended Exhale",
            description:
                "Inhale for 4 counts and exhale for 8 counts. The longer exhale activates your parasympathetic nervous system, easing tension and pain.",
            durationSeconds: 60,
            illustration: "images/ex_extended_exhale.png",
          ),
          ExerciseStep(
            title: "Humming Breath",
            description:
                "Inhale deeply, then exhale with a slow hum. Feel the vibration in your chest and abdomen. This soothes the vagus nerve and reduces pain signals.",
            durationSeconds: 45,
            illustration: "images/ex_humming_breath.png",
          ),
        ],
      ),
      ExerciseModel(
        id: "lower_back_release",
        title: "Lower back release",
        category: "Menstrual cramps relief",
        description:
            "Targeted stretches that decompress the lower spine and relieve the referred back pain that often accompanies menstrual cramps.",
        cardBg: _yellow,
        accent: _yellowAccent,
        illustration: "images/back_stretch.json",
        steps: [
          ExerciseStep(
            title: "Seated Forward Lean",
            description:
                "Sit on the edge of a chair with feet flat. Lean your upper body forward and rest your elbows on your thighs. Let your back relax and breathe.",
            durationSeconds: 40,
            illustration: "images/ex_seated_lean.png",
          ),
          ExerciseStep(
            title: "Standing Hip Circles",
            description:
                "Stand with feet hip-width apart and hands on your hips. Slowly draw large circles with your hips, 5 in each direction. Keep your upper body still.",
            durationSeconds: 40,
            illustration: "images/ex_hip_circles.png",
          ),
          ExerciseStep(
            title: "Pigeon Stretch",
            description:
                "From all fours, bring one knee forward toward your wrist and extend the other leg back. Lower your hips toward the floor and hold gently.",
            durationSeconds: 35,
            illustration: "images/ex_pigeon.png",
          ),
          ExerciseStep(
            title: "Thread the Needle",
            description:
                "On all fours, slide one arm under your body along the floor until your shoulder and temple rest on the mat. Hold and breathe into the stretch.",
            durationSeconds: 35,
            illustration: "images/ex_thread_needle.png",
          ),
          ExerciseStep(
            title: "Pelvic Tilt",
            description:
                "Lie on your back with knees bent. Gently flatten your lower back against the floor by tightening your abs, hold for 5 seconds, then release.",
            durationSeconds: 40,
            illustration: "images/ex_pelvic_tilt.png",
          ),
        ],
      ),
    ],
  ),
  ExerciseCategory(
    title: "Hormonal balance",
    exercises: [
      ExerciseModel(
        id: "pms_relief_flow",
        title: "PMS relief flow",
        category: "Hormonal balance",
        description:
            "A calming yoga flow to reduce PMS symptoms including mood swings, bloating, and fatigue.",
        cardBg: _purple,
        accent: _purpleAccent,
        illustration: "images/yoga.json",
        steps: [
          ExerciseStep(
            title: "Seated Forward Fold",
            description:
                "Sit on the floor with legs straight. Inhale to lengthen your spine, then exhale and fold forward reaching for your feet. Hold gently.",
            durationSeconds: 45,
            illustration: "images/ex_forward_fold.png",
          ),
          ExerciseStep(
            title: "Legs Up the Wall",
            description:
                "Sit close to a wall, then swing your legs up so they rest against it. Relax your arms by your sides and breathe slowly.",
            durationSeconds: 60,
            illustration: "images/ex_legs_wall.png",
          ),
          ExerciseStep(
            title: "Reclined Butterfly",
            description:
                "Lie on your back, bring the soles of your feet together and let your knees fall open. Place your hands on your belly and breathe deeply.",
            durationSeconds: 45,
            illustration: "images/ex_butterfly.png",
          ),
          ExerciseStep(
            title: "Corpse Pose",
            description:
                "Lie flat on your back with arms at your sides, palms up. Close your eyes, relax every muscle and focus only on your breath.",
            durationSeconds: 60,
            illustration: "images/ex_corpse.png",
          ),
        ],
      ),
      ExerciseModel(
        id: "pcos_workout",
        title: "PCOS workout",
        category: "Hormonal balance",
        description:
            "Low-impact strength and movement exercises designed to support hormone regulation for women with PCOS.",
        cardBg: _purple,
        accent: _purpleAccent,
        illustration: "images/glute_bridges.json",
        steps: [
          ExerciseStep(
            title: "Standing March",
            description:
                "Stand tall and march in place, lifting your knees to hip height. Swing your arms naturally. Keep a steady, comfortable pace.",
            durationSeconds: 40,
            illustration: "images/ex_march.png",
          ),
          ExerciseStep(
            title: "Bodyweight Squat",
            description:
                "Stand with feet shoulder-width apart. Lower your hips back and down as if sitting in a chair, keeping your chest up. Rise slowly.",
            durationSeconds: 40,
            illustration: "images/ex_squat.png",
          ),
          ExerciseStep(
            title: "Glute Bridge",
            description:
                "Lie on your back with knees bent. Drive your hips up by squeezing your glutes, hold for 2 seconds at the top, then lower slowly.",
            durationSeconds: 40,
            illustration: "images/ex_glute_bridge.png",
          ),
          ExerciseStep(
            title: "Side-Lying Leg Raise",
            description:
                "Lie on your side with legs straight. Slowly raise your top leg to about 45 degrees, hold briefly, then lower with control.",
            durationSeconds: 35,
            illustration: "images/ex_leg_raise.png",
          ),
          ExerciseStep(
            title: "Deep Breathing Cool Down",
            description:
                "Sit comfortably, place one hand on your chest and one on your belly. Inhale for 4 counts, hold for 2, exhale for 6. Repeat.",
            durationSeconds: 60,
            illustration: "images/ex_breathing.png",
          ),
        ],
      ),
      ExerciseModel(
        id: "cortisol_reset",
        title: "Cortisol reset",
        category: "Hormonal balance",
        description:
            "A gentle movement and mindfulness routine to lower elevated cortisol, reduce stress hormones, and restore balance.",
        cardBg: _purple,
        accent: _purpleAccent,
        illustration: "images/walk.json",
        steps: [
          ExerciseStep(
            title: "Neck & Shoulder Release",
            description:
                "Sit tall and slowly drop your right ear toward your right shoulder. Hold for 5 counts, return to centre, and repeat on the left side.",
            durationSeconds: 40,
            illustration: "images/ex_neck_release.png",
          ),
          ExerciseStep(
            title: "Slow Walking in Place",
            description:
                "Walk slowly in place with deliberate, mindful steps. Breathe in for 3 steps, breathe out for 3 steps. Keep your jaw and shoulders relaxed.",
            durationSeconds: 50,
            illustration: "images/ex_slow_walk.png",
          ),
          ExerciseStep(
            title: "Heart Opening Stretch",
            description:
                "Sit or stand and interlace your fingers behind your back. Squeeze your shoulder blades together, open your chest, and look gently upward.",
            durationSeconds: 35,
            illustration: "images/ex_heart_open.png",
          ),
          ExerciseStep(
            title: "4-7-8 Breathing",
            description:
                "Inhale through your nose for 4 counts, hold for 7 counts, then exhale through your mouth for 8 counts. Repeat 4 times.",
            durationSeconds: 60,
            illustration: "images/ex_478_breathing.png",
          ),
          ExerciseStep(
            title: "Body Scan Relaxation",
            description:
                "Lie down and close your eyes. Slowly bring awareness from your feet to your head, consciously releasing any tension you find along the way.",
            durationSeconds: 60,
            illustration: "images/ex_body_scan.png",
          ),
        ],
      ),
      ExerciseModel(
        id: "thyroid_support_flow",
        title: "Thyroid support flow",
        category: "Hormonal balance",
        description:
            "Gentle yoga poses and neck stretches that stimulate the thyroid gland, supporting metabolism and hormonal health.",
        cardBg: _purple,
        accent: _purpleAccent,
        illustration: "images/thyroid_support_flow.json",
        steps: [
          ExerciseStep(
            title: "Fish Pose",
            description:
                "Lie on your back, slide your hands under your hips, and arch your chest upward while tilting your head back so the crown rests on the floor.",
            durationSeconds: 30,
            illustration: "images/ex_fish_pose.png",
          ),
          ExerciseStep(
            title: "Shoulder Stand",
            description:
                "Lie on your back and lift your legs and hips toward the ceiling, supporting your lower back with your hands. Keep your chin tucked to your chest.",
            durationSeconds: 40,
            illustration: "images/ex_shoulder_stand.png",
          ),
          ExerciseStep(
            title: "Camel Pose",
            description:
                "Kneel with hips over knees. Place your hands on your lower back, open your chest, and gently arch back. Look up if comfortable.",
            durationSeconds: 30,
            illustration: "images/ex_camel.png",
          ),
          ExerciseStep(
            title: "Lion's Breath",
            description:
                "Sit tall, inhale deeply through your nose, then exhale forcefully through your mouth with your tongue extended and eyes wide. Repeat 5 times.",
            durationSeconds: 35,
            illustration: "images/ex_lions_breath.png",
          ),
          ExerciseStep(
            title: "Neck Rolls",
            description:
                "Drop your chin to your chest and slowly roll your head in a half circle from shoulder to shoulder. Do not roll the head backwards. Repeat 5 times.",
            durationSeconds: 40,
            illustration: "images/ex_neck_rolls.png",
          ),
        ],
      ),
    ],
  ),
];
