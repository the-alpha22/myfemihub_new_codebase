import 'package:bridge_ai/constants/app_constants.dart';
import 'package:bridge_ai/constants/controllers.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationsController {
  Future<void> showNotification(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
      String notificationTitle,
      String notificationMessage,
      String channelName,
      String channelId,
      int notificationId,
      String routeName) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            channelId, // Replace with your channel ID
            channelName, // Replace with your channel name
            importance: Importance.max,
            priority: Priority.high,
            playSound: true);
    NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: DarwinNotificationDetails(
          presentBadge: true,
          presentSound: true,
        ));

    await flutterLocalNotificationsPlugin.show(
        notificationId,
        notificationTitle, // Notification title
        notificationMessage, // Notification body
        platformChannelSpecifics,
        payload: routeName);
  }

  Future<void> scheduleInstantNotification(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
      String notificationTitle,
      String notificationMessage,
      String channelName,
      String channelId,
      int notificationId,
      String routeName,
      int duration) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            channelId, // Replace with your channel ID
            channelName, // Replace with your channel name
            importance: Importance.max,
            priority: Priority.high,
            playSound: true);
    NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: DarwinNotificationDetails(
          presentBadge: true,
          presentSound: true,
        ));
    final scheduledDate =
        tz.TZDateTime.now(tz.local).add(Duration(seconds: duration));

    // await flutterLocalNotificationsPlugin.zonedSchedule(
    //     notificationId,
    //     notificationTitle, // Notification title
    //     notificationMessage,
    //     scheduledDate,
    //     platformChannelSpecifics,
    //     payload: routeName,
    //     uiLocalNotificationDateInterpretation:
    //         UILocalNotificationDateInterpretation.wallClockTime);
  }

  Future<void> onSelectNotification(String? payload) async {
    if (payload != null) {
      // Handle the tapped notification here
      Get.toNamed(payload);
    }
  }

  handleNotificationTap(NotificationResponse response) async {
    if (userController.isLoggedIn) {
      if (response.payload != null) {
        print("payload: ${response.payload}");
        Get.offAllNamed("${response.payload}");
      } else {
        Get.offAllNamed("/home");
      }
    }
  }

  Future<void> scheduleContinuousNotifications() async {
    final prefs = await SharedPreferences.getInstance();

    // Check if the app is launched for the first time
    final isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;

    if (isFirstLaunch) {
      // Schedule initial notification
      await scheduleNotification();
      prefs.setBool('isFirstLaunch', false);
    }

    // Schedule periodic notifications every day
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      "bridge_ai", // Replace with your channel ID
      "bridge_ai", // Replace with your channel name
      importance: Importance.max,
      priority: Priority.high,
    );
    NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: DarwinNotificationDetails(
          presentBadge: true,
          presentSound: true,
        ));
    List<NotificationModel> allNotifications = [];
    var stage = prefs.getString('userStage') ?? "Not Yet Pregnant";
    stage == "Not Yet Pregnant"
        ? allNotifications = womenNotifications
        : stage == "Pregnant"
            ? allNotifications = pregnantWomenNotifications
            : allNotifications = mothersNotifications;

    // Get the list of notifications that have already been shown
    List<String> shownNotifications =
        prefs.getStringList('shownNotifications') ?? [];

    // Schedule notifications for each message in the list
    for (var notification in allNotifications) {
      if (!shownNotifications.contains(notification.title)) {
        final NotificationModel Notification = notification;

        showNotification(
            flutterLocalNotificationsPlugin,
            Notification.title,
            Notification.body,
            "dailyNotification",
            "bridge_ai",
            1,
            Notification.routeName);
        shownNotifications.add(Notification.title);
        await prefs.setStringList('shownNotifications', shownNotifications);
      }
    }
  }

  Future<void> scheduleNotification() async {
    showNotification(
        flutterLocalNotificationsPlugin,
        "Welcome to bridge_ai",
        "Explore a world of resources and support for women of all stages in life. We're here to empower you!",
        "dailyNotification",
        "bridge_ai",
        1,
        "/home");
  }

  // Notifications for Women
  final List<NotificationModel> womenNotifications = [
    NotificationModel(
        'Wellness Reminder',
        'Take time for self-care and prioritize your well-being today.',
        "/home"),
    NotificationModel(
        'Health Checkup Reminder',
        'Don\'t forget to schedule your regular health checkup with your doctor.',
        "/shop"),
    NotificationModel('Exercise Motivation',
        'Stay active and fit with your favorite exercise routine!', "/shop"),
  ];

// Notifications for Pregnant Women
  final List<NotificationModel> pregnantWomenNotifications = [
    NotificationModel('Prenatal Checkup Reminder',
        'Your prenatal checkup is so ensential, schedule one', "/more"),
    NotificationModel(
        'Healthy Eating Tips',
        'Get nutrition advice for a healthy pregnancy diet. Eat well for you and your baby.',
        "/shop"),
    NotificationModel(
        'Baby Kick Count',
        'Track your baby\'s movements and monitor kick counts regularly.',
        "/home"),
  ];

// Notifications for Mothers
  final List<NotificationModel> mothersNotifications = [
    NotificationModel(
        'Feeding Time Reminder',
        'It\'s time to feed your little one. Make sure they get their nourishment.',
        "/home"),
    NotificationModel(
        'Diaper Change Alert',
        'Check if it\'s time for a diaper change. Keep your baby comfortable.',
        "/shop"),
    NotificationModel(
        'Bedtime Routine',
        'Create a calming bedtime routine for a good night\'s sleep for both of you.',
        "/home"),
  ];
}

class NotificationModel {
  final String title;
  final String body;
  final String routeName;

  NotificationModel(this.title, this.body, this.routeName);
}
