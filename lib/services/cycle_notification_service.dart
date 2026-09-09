// lib/services/cycle_notification_service.dart
//
// Background notification service for Bridge AI period tracker.
//
// DEPENDENCIES (add to pubspec.yaml):
//   flutter_local_notifications: ^17.2.2
//   workmanager: ^0.5.2
//   shared_preferences: ^2.2.2
//   timezone: ^0.9.4
//
// SETUP REQUIRED:
//   1. Android: AndroidManifest.xml — see comments at the bottom of this file.
//   2. iOS: AppDelegate.swift — call FlutterLocalNotificationsPlugin.setPluginRegistrantCallback
//      and add background fetch capability.
//   3. Call CycleNotificationService.init() inside main() before runApp().
//   4. Call CycleNotificationService.scheduleAll(...) after the user logs in / updates period data.

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:workmanager/workmanager.dart';

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

class _PrefKeys {
  static const periodStart = 'notif_period_start_ms';
  static const periodLength = 'notif_period_length';
  static const cycleLength = 'notif_cycle_length';
  static const userName = 'notif_user_name';
  static const notificationsEnabled = 'notif_enabled';
  static const morningHour = 'notif_morning_hour'; // default 8
  static const eveningHour = 'notif_evening_hour'; // default 20
}

/// WorkManager task name
const _bgTaskName = 'bridge_ai.cycle_check';
const _bgTaskTag = 'cycle_notifications';

const _channelId = 'bridge_ai_cycle';
const _channelName = 'Cycle Reminders';
const _channelDesc = 'Daily period & fertility reminders';

const _idPeriodStart = 100;
const _idPeriodOngoing = 101;
const _idFertileStart = 102;
const _idFertileOngoing = 103;
const _idOvulation = 104;
const _idSafe = 105;
const _idPeriodSoon = 106; // 2-day warning
const _idOvulationSoon = 107; // 1-day warning
const _idMorningCheckin = 110;
const _idEveningLog = 111;

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    if (taskName == _bgTaskName) {
      await CycleNotificationService._runBackgroundCheck();
    }
    return Future.value(true);
  });
}

class CycleNotificationService {
  CycleNotificationService._();

  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    tz.initializeTimeZones();

    // Android init
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    // iOS init
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _plugin.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Create Android notification channel
    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(
          const AndroidNotificationChannel(
            _channelId,
            _channelName,
            description: _channelDesc,
            importance: Importance.high,
            playSound: true,
          ),
        );

    // Register WorkManager for background checks
    await Workmanager().initialize(callbackDispatcher, isInDebugMode: false);
  }

  static void _onNotificationTapped(NotificationResponse response) {
    final payload = response.payload ?? '/home';
    Future.delayed(const Duration(milliseconds: 300), () {
      Get.toNamed(payload);
    });
  }

  static Future<void> saveUserData({
    required DateTime lastPeriodStart,
    required int periodLength,
    required int cycleLength,
    required String userName,
    int morningHour = 8,
    int eveningHour = 20,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(
      _PrefKeys.periodStart,
      lastPeriodStart.millisecondsSinceEpoch,
    );
    await prefs.setInt(_PrefKeys.periodLength, periodLength);
    await prefs.setInt(_PrefKeys.cycleLength, cycleLength);
    await prefs.setString(_PrefKeys.userName, userName);
    await prefs.setInt(_PrefKeys.morningHour, morningHour);
    await prefs.setInt(_PrefKeys.eveningHour, eveningHour);
  }

  // ── Master function: cancel all old, schedule fresh set ───────────────────
  static Future<void> scheduleAll({
    required DateTime lastPeriodStart,
    required int periodLength,
    required int cycleLength,
    required String userName,
    int morningHour = 8,
    int eveningHour = 20,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final enabled = prefs.getBool(_PrefKeys.notificationsEnabled) ?? true;
    if (!enabled) return;

    await saveUserData(
      lastPeriodStart: lastPeriodStart,
      periodLength: periodLength,
      cycleLength: cycleLength,
      userName: userName,
      morningHour: morningHour,
      eveningHour: eveningHour,
    );

    await _plugin.cancelAll();

    await _scheduleDailyCheckins(morningHour, eveningHour, userName);
    await _schedulePhaseTransitionAlerts(
      lastPeriodStart: lastPeriodStart,
      periodLength: periodLength,
      cycleLength: cycleLength,
      userName: userName,
    );

    // Register periodic WorkManager task (every 12 hours)
    // This fires even when the app is fully closed.
    await Workmanager().cancelByTag(_bgTaskTag);
    await Workmanager().registerPeriodicTask(
      _bgTaskName,
      _bgTaskName,
      tag: _bgTaskTag,
      frequency: const Duration(hours: 12),
      constraints: Constraints(networkType: NetworkType.notRequired),
      existingWorkPolicy: ExistingPeriodicWorkPolicy.replace,
    );

    debugPrint('[CycleNotificationService] All notifications scheduled.');
  }

  static Future<void> disableAll() async {
    await _plugin.cancelAll();
    await Workmanager().cancelByTag(_bgTaskTag);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_PrefKeys.notificationsEnabled, false);
  }

  static Future<void> enableAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_PrefKeys.notificationsEnabled, true);
  }

  static Future<void> _scheduleDailyCheckins(
    int morningHour,
    int eveningHour,
    String userName,
  ) async {
    final firstName = userName.isNotEmpty ? userName.split(' ').first : 'there';

    // Morning check-in — daily at morningHour
    await _scheduleDailyAt(
      id: _idMorningCheckin,
      hour: morningHour,
      minute: 0,
      title: 'Good morning, $firstName 🌸',
      body: _morningBodyForToday(),
      payload: '/period-tracker',
    );

    // Evening log reminder — daily at eveningHour
    await _scheduleDailyAt(
      id: _idEveningLog,
      hour: eveningHour,
      minute: 0,
      title: 'Log your day 📝',
      body: 'Take 30 seconds to track your symptoms & mood today.',
      payload: '/period-tracker?tab=log',
    );
  }

  static String _morningBodyForToday() {
    // Generic morning message — the WorkManager background check
    // will send phase-specific messages when the app is closed.
    final messages = [
      'Check your cycle overview and stay on top of your health.',
      'Your daily cycle update is ready. Stay informed, stay empowered.',
      'Know your body better — open your tracker for today\'s insights.',
    ];
    return messages[DateTime.now().day % messages.length];
  }

  static Future<void> _schedulePhaseTransitionAlerts({
    required DateTime lastPeriodStart,
    required int periodLength,
    required int cycleLength,
    required String userName,
  }) async {
    final firstName = userName.isNotEmpty ? userName.split(' ').first : 'there';
    final now = DateTime.now();

    // Calculate key dates for the current + next cycle
    final daysSince = now.difference(lastPeriodStart).inDays;
    final currentCycleStart = lastPeriodStart.add(
      Duration(days: (daysSince ~/ cycleLength) * cycleLength),
    );

    for (int cycle = 0; cycle <= 1; cycle++) {
      final cycleStart = currentCycleStart.add(
        Duration(days: cycle * cycleLength),
      );

      final ovDay = (cycleLength ~/ 2).clamp(10, 18);
      final fertStart = (ovDay - 5).clamp(0, cycleLength - 1);

      // 1. Next period start
      final nextPeriodDate = _atMorning(cycleStart);
      if (nextPeriodDate.isAfter(now)) {
        await _scheduleOnce(
          id: _idPeriodStart + cycle * 10,
          scheduledDate: nextPeriodDate,
          title: '🔴 Your period may be starting',
          body:
              'Hey $firstName, your period is predicted to start today. Stay comfortable — you\'ve got this.',
          payload: '/period-tracker',
        );
      }

      // 2. 2-day period warning
      final periodSoonDate = _atMorning(
        cycleStart.subtract(const Duration(days: 2)),
      );
      if (periodSoonDate.isAfter(now)) {
        await _scheduleOnce(
          id: _idPeriodSoon + cycle * 10,
          scheduledDate: periodSoonDate,
          title: '📅 Period arriving in ~2 days',
          body:
              'Stock up on supplies and take care of yourself, $firstName. Your cycle is almost complete.',
          payload: '/period-tracker',
        );
      }

      // 3. Fertile window starts
      final fertileDate = _atMorning(cycleStart.add(Duration(days: fertStart)));
      if (fertileDate.isAfter(now)) {
        await _scheduleOnce(
          id: _idFertileStart + cycle * 10,
          scheduledDate: fertileDate,
          title: '🌿 Fertile window begins',
          body:
              cycle == 0
                  ? 'Your fertile window starts today, $firstName. High fertility days ahead.'
                  : 'Heads up, $firstName — next cycle\'s fertile window opens today.',
          payload: '/period-tracker',
        );
      }

      // 4. Ovulation day
      final ovulationDate = _atMorning(cycleStart.add(Duration(days: ovDay)));
      if (ovulationDate.isAfter(now)) {
        await _scheduleOnce(
          id: _idOvulation + cycle * 10,
          scheduledDate: ovulationDate,
          title: '✨ Ovulation day',
          body:
              'Today is your predicted ovulation day, $firstName. This is your peak fertility window.',
          payload: '/period-tracker',
        );
      }

      // 5. 1-day ovulation warning
      final ovSoonDate = _atMorning(cycleStart.add(Duration(days: ovDay - 1)));
      if (ovSoonDate.isAfter(now)) {
        await _scheduleOnce(
          id: _idOvulationSoon + cycle * 10,
          scheduledDate: ovSoonDate,
          title: '🌸 Ovulation tomorrow',
          body:
              'Peak fertility is predicted tomorrow, $firstName. Plan accordingly.',
          payload: '/period-tracker',
        );
      }
    }
  }

  static Future<void> _runBackgroundCheck() async {
    final prefs = await SharedPreferences.getInstance();
    final enabled = prefs.getBool(_PrefKeys.notificationsEnabled) ?? true;
    if (!enabled) return;

    final startMs = prefs.getInt(_PrefKeys.periodStart);
    final periodLength = prefs.getInt(_PrefKeys.periodLength) ?? 5;
    final cycleLength = prefs.getInt(_PrefKeys.cycleLength) ?? 28;
    final userName = prefs.getString(_PrefKeys.userName) ?? '';
    final morningHour = prefs.getInt(_PrefKeys.morningHour) ?? 8;

    if (startMs == null) return; // No data saved yet

    final lastPeriodStart = DateTime.fromMillisecondsSinceEpoch(startMs);
    final now = DateTime.now();
    final hour = now.hour;

    // Only fire once per day, in the morning window (±1 h of morningHour)
    if ((hour - morningHour).abs() > 1) return;

    final type = calculateCycleDayType(
      now,
      lastPeriodStart,
      periodLength,
      cycleLength,
    );
    final firstName = userName.isNotEmpty ? userName.split(' ').first : 'there';

    final daysSince = now.difference(lastPeriodStart).inDays;
    final cyclePos = daysSince % cycleLength;
    final ovDay = (cycleLength ~/ 2).clamp(10, 18);
    final daysUntilNextPeriod = cycleLength - cyclePos;

    final payload = _buildPhasePayload(
      type: type,
      firstName: firstName,
      cycleDay: cyclePos + 1,
      cycleLength: cycleLength,
      daysUntilNext: daysUntilNextPeriod,
      ovDay: ovDay,
      cyclePos: cyclePos,
    );

    await _showImmediateNotification(
      id: 200,
      title: payload['title']!,
      body: payload['body']!,
      payload: '/period-tracker',
    );
  }

  static Map<String, String> _buildPhasePayload({
    required CycleDayType type,
    required String firstName,
    required int cycleDay,
    required int cycleLength,
    required int daysUntilNext,
    required int ovDay,
    required int cyclePos,
  }) {
    switch (type) {
      case CycleDayType.period:
        final dayOfPeriod = cyclePos + 1;
        return {
          'title': '🔴 Period day $dayOfPeriod, $firstName',
          'body': _periodMessages(dayOfPeriod, firstName),
        };
      case CycleDayType.ovulation:
        return {
          'title': '✨ Ovulation day!',
          'body':
              'Today is your peak fertility day, $firstName. Your body is at its most fertile right now.',
        };
      case CycleDayType.fertile:
        final daysToOv = ovDay - cyclePos;
        return {
          'title': '🌿 Fertile window — Day $cycleDay',
          'body':
              daysToOv > 0
                  ? 'You\'re in your fertile window, $firstName. Ovulation is ~$daysToOv day${daysToOv == 1 ? '' : 's'} away.'
                  : 'Post-ovulation fertile days, $firstName. Fertility is declining.',
        };
      case CycleDayType.safe:
        return {
          'title': '📅 Cycle day $cycleDay',
          'body':
              daysUntilNext <= 5
                  ? 'Your next period is ~$daysUntilNext days away, $firstName. Consider preparing.'
                  : 'You\'re in the safe phase, $firstName. $daysUntilNext days until your next period.',
        };
    }
  }

  static String _periodMessages(int day, String name) {
    switch (day) {
      case 1:
        return 'Day 1 of your period, $name. Rest and warmth can help with cramps. Log your flow in the tracker.';
      case 2:
        return 'Flow is often heaviest on day 2, $name. Stay hydrated and be kind to yourself today.';
      case 3:
        return 'You\'re halfway through, $name. Energy levels may start to lift soon.';
      default:
        return 'Period day $day, $name. Almost there — log your symptoms to track patterns.';
    }
  }

  static NotificationDetails get _details => const NotificationDetails(
    android: AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDesc,
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/launcher_icon',
      color: Color(0xFFE8567A),
      styleInformation: BigTextStyleInformation(''),
    ),
    iOS: DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    ),
  );

  static Future<void> _scheduleDailyAt({
    required int id,
    required int hour,
    required int minute,
    required String title,
    required String body,
    String? payload,
  }) async {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    await _plugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: scheduled,
      notificationDetails: _details,
      payload: payload,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  static Future<void> _scheduleOnce({
    required int id,
    required DateTime scheduledDate,
    required String title,
    required String body,
    String? payload,
  }) async {
    final tzDate = tz.TZDateTime.from(scheduledDate, tz.local);
    if (tzDate.isBefore(tz.TZDateTime.now(tz.local))) return;

    await _plugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: tzDate,
      notificationDetails: _details,
      payload: payload,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  static Future<void> _showImmediateNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    await _plugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: _details,
      payload: payload,
    );
  }

  static DateTime _atMorning(DateTime date) =>
      DateTime(date.year, date.month, date.day, 8, 0);
}

class CycleNotificationSettings extends StatefulWidget {
  const CycleNotificationSettings({super.key});

  @override
  State<CycleNotificationSettings> createState() =>
      _CycleNotificationSettingsState();
}

class _CycleNotificationSettingsState extends State<CycleNotificationSettings> {
  bool _enabled = true;
  int _morningHour = 8;
  int _eveningHour = 20;
  bool _loading = true;

  static const _rose = Color(0xFFE8567A);
  static const _roseSoft = Color(0xFFFFF0F4);
  static const _plum = Color(0xFF3D1A2E);
  static const _muted = Color(0xFF9E8892);
  static const _surface = Color(0xFFFDF7F9);

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _enabled = prefs.getBool(_PrefKeys.notificationsEnabled) ?? true;
        _morningHour = prefs.getInt(_PrefKeys.morningHour) ?? 8;
        _eveningHour = prefs.getInt(_PrefKeys.eveningHour) ?? 20;
        _loading = false;
      });
    }
  }

  String _fmt(int h) => TimeOfDay(hour: h, minute: 0).format(context);

  Future<void> _reschedule(SharedPreferences prefs) async {
    final startMs = prefs.getInt(_PrefKeys.periodStart);
    if (startMs == null) return;
    await CycleNotificationService.scheduleAll(
      lastPeriodStart: DateTime.fromMillisecondsSinceEpoch(startMs),
      periodLength: prefs.getInt(_PrefKeys.periodLength) ?? 5,
      cycleLength: prefs.getInt(_PrefKeys.cycleLength) ?? 28,
      userName: prefs.getString(_PrefKeys.userName) ?? '',
      morningHour: _morningHour,
      eveningHour: _eveningHour,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Padding(
        padding: EdgeInsets.all(20),
        child: Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 1.5, color: _rose),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Master toggle row
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _enabled ? _roseSoft : const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  PhosphorIcons.bell,
                  color: _enabled ? _rose : _muted,
                  size: 19,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Cycle Notifications',
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w600,
                        fontSize: 13.5,
                        color: _plum,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Period, fertility & daily check-ins',
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        color: _muted,
                      ),
                    ),
                  ],
                ),
              ),
              Switch.adaptive(
                value: _enabled,
                activeColor: _rose,
                onChanged: (v) async {
                  setState(() => _enabled = v);
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setBool(_PrefKeys.notificationsEnabled, v);
                  if (v) {
                    await CycleNotificationService.enableAll();
                  } else {
                    await CycleNotificationService.disableAll();
                  }
                },
              ),
            ],
          ),
        ),

        // Expanded time pickers when enabled
        if (_enabled) ...[
          Divider(height: 1, thickness: 1, indent: 70, color: _surface),
          _buildTimeTile(
            icon: PhosphorIcons.sun,
            title: 'Morning check-in',
            hour: _morningHour,
            onTap: () async {
              final picked = await showTimePicker(
                context: context,
                initialTime: TimeOfDay(hour: _morningHour, minute: 0),
                builder:
                    (ctx, child) => Theme(
                      data: ThemeData.light().copyWith(
                        colorScheme: const ColorScheme.light(primary: _rose),
                      ),
                      child: child!,
                    ),
              );
              if (picked != null) {
                setState(() => _morningHour = picked.hour);
                final prefs = await SharedPreferences.getInstance();
                await prefs.setInt(_PrefKeys.morningHour, picked.hour);
                await _reschedule(prefs);
              }
            },
          ),
          Divider(height: 1, thickness: 1, indent: 70, color: _surface),
          _buildTimeTile(
            icon: PhosphorIcons.moon,
            title: 'Evening log reminder',
            hour: _eveningHour,
            onTap: () async {
              final picked = await showTimePicker(
                context: context,
                initialTime: TimeOfDay(hour: _eveningHour, minute: 0),
                builder:
                    (ctx, child) => Theme(
                      data: ThemeData.light().copyWith(
                        colorScheme: const ColorScheme.light(primary: _rose),
                      ),
                      child: child!,
                    ),
              );
              if (picked != null) {
                setState(() => _eveningHour = picked.hour);
                final prefs = await SharedPreferences.getInstance();
                await prefs.setInt(_PrefKeys.eveningHour, picked.hour);
                await _reschedule(prefs);
              }
            },
          ),
        ],
      ],
    );
  }

  Widget _buildTimeTile({
    required IconData icon,
    required String title,
    required int hour,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _roseSoft,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: _rose, size: 19),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w600,
                    fontSize: 13.5,
                    color: _plum,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: _roseSoft,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _fmt(hour),
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: _rose,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 13,
                color: _muted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
