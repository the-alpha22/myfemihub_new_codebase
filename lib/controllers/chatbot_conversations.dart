import 'dart:async';
import 'package:bridge_ai/models/chatbot_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ChatBotConversationsController extends GetxController {
  static ChatBotConversationsController instance = Get.find();
  String collection = "conversations";

  @override
  onReady() {
    super.onReady();
  }

  Future<List<ChatBotMessageModel>> getConversationMessages(String userId) async {
    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection(collection)
          .doc(userId)
          .collection("messages")
          .orderBy("dateCreated", descending: true)
          .get();

      List<ChatBotMessageModel> messages = querySnapshot.docs
          .map((documentSnapshot) =>
              ChatBotMessageModel.fromMap(documentSnapshot.data()))
          .toList();

      return messages;
    } catch (e) {
      // Handle any errors that might occur during the database query
      print("\n===========Error fetching chatbot messages: $e============\n");
      return [];
    }
  }

  Future<void> deleteConversationMessage(String userId, String messageId) async {
  try {
    await FirebaseFirestore.instance
        .collection(collection)
        .doc(userId)
        .collection("messages")
        .doc(messageId)
        .delete();
  } catch (e) {
    print("\n===========Error deleting chatbot message: $e============\n");
  }
}

Future<void> clearEntireConversation(String userId) async {
  try {
    final snapshot = await FirebaseFirestore.instance
        .collection(collection)
        .doc(userId)
        .collection("messages")
        .get();

    final batch = FirebaseFirestore.instance.batch();
    for (final doc in snapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  } catch (e) {
    print("\n===========Error clearing conversation: $e============\n");
  }
}
}
