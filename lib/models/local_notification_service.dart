import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialize(BuildContext context) {
    // initializationSettings for Android

    /// TODO initialize method
    // _notificationsPlugin.initialize(initializationSettings,
    //     onSelectNotification: (String route) async {
    //   print("onSelectNotification");
    //   Get.to(()=> HomeScreen());
    // });
  }

  static void createAndDisplayNotification(RemoteMessage message) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      const NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          // "obtek.technologies.bridge_ai",
          "bridge_ai",
          "bridge_ai",
          importance: Importance.max,
          priority: Priority.high,
        ),
      );

      /// pop up show
      await _notificationsPlugin.show(
        id: id,
        title: message.notification!.title,
        body: message.notification!.body,
        notificationDetails: notificationDetails,
        payload: message.data["route"],

        //////// In case of DemoScreen //////////////////////////////////////
        // this "id" key and "id" key of passing firebase's data must same
        // payload: message.data["_id"],
        ////////////////////////////////////////////////////////////////////
      );
    } on Exception catch (e) {
      print(e);
    }
  }
}
