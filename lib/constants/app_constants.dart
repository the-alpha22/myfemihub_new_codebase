import 'package:bridge_ai/controllers/notifications_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bridge_ai/models/story.dart';
import 'package:bridge_ai/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

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
  var citation,
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
        "citation": citation,
      });
  print("\n=========Conversation Data Added=============\n");
}

addActivityLog(
  String details,
  String userId,
  String type,
  String postId,
  String productId,
) async {
  String id = Uuid().v1().toString();
  await FirebaseFirestore.instance.collection("activity").doc(id).set({
    "details": details,
    "id": id,
    "dateCreated": Timestamp.now(),
    "userId": userId,
    "productId": productId,
    "type": type,
    "postId": postId,
  });
  print("\n=========Activity log Data Added=============\n");
}

addOrderDetails(
  double amount,
  String userId,
  double longtitude,
  double latitude,
  String address,
  List cart,
) async {
  String id = Uuid().v1().toString();
  await FirebaseFirestore.instance.collection("orders").doc(id).set({
    "id": id,
    "dateCreated": Timestamp.now(),
    "userId": userId,
    "cart": cart,
    "amount": amount,
    "status": "pending",
    "address": address,
    "latitude": latitude,
    "longtitude": longtitude,
  });
  print("\n=========Order Data Added=============\n");
}

openLink(String link) async {
  await launchUrl(Uri.parse(link));
}

openMail(String mail) async {
  final Uri launchUri = Uri(scheme: 'mailto', path: mail);
  await launchUrl(launchUri, mode: LaunchMode.externalApplication);
}

makeCall(String phone_number) async {
  final Uri launchUri = Uri(scheme: 'tel', path: phone_number);
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

Future<UserModel?> getUserDetails(String userId) async {
  try {
    print("\n=========Getting User Details=============\n");
    UserModel? user;
    final userSnapshot =
        await FirebaseFirestore.instance
            .collection('users')
            .where("id", isEqualTo: userId)
            .get();
    for (var doc in userSnapshot.docs) {
      user = UserModel.fromMap(doc.data());
      print("\n=========User Data obtained=============\n");
    }
    return user;
  } catch (e) {
    return null;
  }
}

Future<StoryModel?> getPostDetails(String userId) async {
  try {
    print("\n=========Getting Post Details=============\n");
    StoryModel? post;
    final postSnapshot =
        await FirebaseFirestore.instance
            .collection('stories')
            .where("id", isEqualTo: userId)
            .get();
    for (var doc in postSnapshot.docs) {
      post = StoryModel.fromMap(doc.data());
      print("\n=========Post Data obtained=============\n");
    }
    return post;
  } catch (e) {
    return null;
  }
}

updateUserDetails(String userId, Map<String, dynamic> data) async {
  final userSnapshot =
      await FirebaseFirestore.instance
          .collection('users')
          .where("id", isEqualTo: userId)
          .get();
  for (var doc in userSnapshot.docs) {
    doc.reference.update(data);
  }
  print("\n=========User Details Updated=============\n");
}

updatePostDetails(String postId, Map<String, dynamic> data) async {
  final postSnapshot =
      await FirebaseFirestore.instance
          .collection('stories')
          .where("id", isEqualTo: postId)
          .get();
  for (var doc in postSnapshot.docs) {
    doc.reference.update(data);
  }
  print("\n=========Post Details Updated=============\n");
}
