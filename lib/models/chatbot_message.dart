import 'package:cloud_firestore/cloud_firestore.dart';

class ChatBotMessageModel {
  static const ID = "id";
  static const USERID = "userId";
  static const DATECREATED = "dateCreated";
  static const MESSAGE = "message";

  late String id;
  late String userId;
  late DateTime dateCreated;
  late String message;

  ChatBotMessageModel(
      {required this.id,
      required this.userId,
      required this.dateCreated,
      required this.message,});

  ChatBotMessageModel.fromMap(Map<String, dynamic> data) {
    id = data[ID];
    userId = data[USERID] ?? "";
    dateCreated = data[DATECREATED].toDate();
    message = data[MESSAGE] ?? "";
  }

  static ChatBotMessageModel fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return ChatBotMessageModel.fromMap(data);
  }
}
