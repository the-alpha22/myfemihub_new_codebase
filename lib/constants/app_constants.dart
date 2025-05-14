import 'package:bridge_ai/controllers/notifications_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logger/logger.dart';
import 'package:url_launcher/url_launcher.dart';

Logger logger = Logger();

final bgcolor = Color.fromARGB(255, 248, 247, 251);
final primaryColor = Color.fromARGB(255, 236, 64, 122);
NotificationsController notificationPrompt = NotificationsController();
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

addConversationMessage(
  String conversationId,
  String id,
  String userId,
  String message,
  DateTime dateCreated,
) async {
  await FirebaseFirestore.instance
      .collection("conversations")
      .doc(conversationId)
      .collection("messages")
      .doc(id)
      .set({
    "userId": userId,
    "id": id,
    "dateCreated": dateCreated,
    "message": message,
  });
  print("\n=========Conversation Data Added=============\n");
}

openLink(String link) async {
  final Uri launchUri = Uri(
    scheme: 'https',
    path: link,
  );
  await launch(link);
}

openMail(String mail) async {
  final Uri launchUri = Uri(
    scheme: 'mailto',
    path: mail,
  );
  await launchUrl(launchUri, mode: LaunchMode.externalApplication);
}
