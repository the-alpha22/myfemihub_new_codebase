import 'package:bridge_ai/controllers/notifications_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
import 'package:url_launcher/url_launcher.dart';

Logger logger = Logger();

final bgcolor = Color.fromARGB(255, 248, 247, 251);
final primaryColor = Color.fromARGB(255, 228, 37, 143);
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
  final Uri launchUri = Uri(scheme: 'https', path: link);
  await launch(link);
}

openMail(String mail) async {
  final Uri launchUri = Uri(scheme: 'mailto', path: mail);
  await launchUrl(launchUri, mode: LaunchMode.externalApplication);
}

appCommunication(
  BuildContext context,
  String title,
  String message,
  String route,
) {
  notificationPrompt.showNotification(
    flutterLocalNotificationsPlugin,
    title,
    message,
    "femihub",
    "femihub",
    2,
    route,
  );
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: GoogleFonts.lato(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
  );
}

String timeAgo(DateTime date) {
  final Duration diff = DateTime.now().difference(date);

  if (diff.inSeconds < 60) {
    return 'just now';
  } else if (diff.inMinutes < 60) {
    return '${diff.inMinutes} ${diff.inMinutes == 1 ? 'minute' : 'minutes'} ago';
  } else if (diff.inHours < 24) {
    return '${diff.inHours} ${"h"}';
  } else if (diff.inDays < 7) {
    return '${diff.inDays} ${"d"}';
  } else if (diff.inDays < 30) {
    final int weeks = diff.inDays ~/ 7;
    return '$weeks ${"w"}';
  } else if (diff.inDays < 365) {
    final int months = diff.inDays ~/ 30;
    return '$months ${"m"}';
  } else {
    final int years = diff.inDays ~/ 365;
    return '$years ${"y"}';
  }
}
