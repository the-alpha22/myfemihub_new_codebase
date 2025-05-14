import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:bridge_ai/constants/controllers.dart';
import 'package:bridge_ai/constants/firebase.dart';
import 'package:bridge_ai/models/message.dart';
import 'package:http/http.dart' as http;

class MessagingController extends GetxController {
  static MessagingController instance = Get.find();
  RxList<MessageChat> messages = RxList<MessageChat>([]);
  String collection = "messages";
  late String ID;

  @override
  onReady() {
    super.onReady();
    messages.bindStream(getMessages(ID));
  }

  Stream<List<MessageChat>> getMessages(String id) => firebaseFirestore
      .collection(collection)
      .doc(id)
      .collection(id)
      .snapshots()
      .map((query) =>
          query.docs.map((item) => MessageChat.fromMap(item.data())).toList());

  UploadTask uploadFile(File image, String fileName) {
    Reference reference = FirebaseStorage.instance.ref().child(fileName);
    UploadTask uploadTask = reference.putFile(image);
    return uploadTask;
  }

  Future<void> updateDataFirestore(String collectionPath, String docPath,
      Map<String, dynamic> dataNeedUpdate) {
    return firebaseFirestore
        .collection(collectionPath)
        .doc(docPath)
        .update(dataNeedUpdate);
  }

  Stream<QuerySnapshot> getChatStream(String groupChatId, int limit) {
    return firebaseFirestore
        .collection(FirestoreConstants.pathMessageCollection)
        .doc(groupChatId)
        .collection(groupChatId)
        .orderBy(FirestoreConstants.timestamp, descending: true)
        .limit(limit)
        .snapshots();
  }

  void sendMessage(String content, String groupChatId, String currentUserId,
      String idto) async {
    DocumentReference documentReference = firebaseFirestore
        .collection(FirestoreConstants.pathMessageCollection)
        .doc(groupChatId)
        .collection(groupChatId)
        .doc(DateTime.now().millisecondsSinceEpoch.toString());

    MessageChat messageChat = MessageChat(
      idfrom: currentUserId,
      idto: idto,
      timestamp: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
    );
    userController.updateUserData({
      "chatids": FieldValue.arrayUnion([idto])
    });
    var snaps = await FirebaseFirestore.instance
        .collection('users')
        .where('id', isEqualTo: idto)
        .get();

    for (var doc in snaps.docs) {
      await doc.reference.update({
        "chatids": FieldValue.arrayUnion([userController.userModel.value!.id]),
      });
    }

    FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.set(
        documentReference,
        messageChat.toJson(),
      );
    });
  }

  void sendNotification(String body, String title, String token) async {
    try {
      await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization':
                'key=AAAAbmfuhTc:APA91bEaaHwSNdBDPwf5kpKIROwDrWQbBs_s45pSnjzjRtD93LNwDVjuMiiIEy5LXAxW61nMn3lricolA_gHc_OvvpiCT0MrdcdHxPkkJP6FbKQrzs0dX0NZM331pWimjAUxjp-B5si7'
          },
          body: jsonEncode(
            <String, dynamic>{
              'notification': <String, dynamic>{
                'body': body,
                'title': title,
              },
              'priority': 'high',
              'data': <String, dynamic>{
                'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                'id': '1',
                'status': 'done'
              },
              "to": token
            },
          ));
      const NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          // "obtek.technologies.bridge_ai",
          "chat",
          "chat",
          importance: Importance.max,
          priority: Priority.high,
        ),
      );
      FlutterLocalNotificationsPlugin().show(
        0,
        "Hello ${userController.userModel.value!.name.capitalize}",
        "Your message was sent",
        notificationDetails,

        //////// In case of DemoScreen //////////////////////////////////////
        // this "id" key and "id" key of passing firebase's data must same
        // payload: message.data["_id"],
        ////////////////////////////////////////////////////////////////////
      );
    } catch (e) {
      print(e);
    }
  }
}

class FirestoreConstants {
  static const pathUserCollection = "users";
  static const pathMessageCollection = "messages";
  static const id = "id";
  static const chattingWith = "chattingWith";
  static const idfrom = "idfrom";
  static const idto = "idto";
  static const timestamp = "timestamp";
  static const content = "content";
}
