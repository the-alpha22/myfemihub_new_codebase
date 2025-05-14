import 'package:bridge_ai/controllers/messagingController.dart';

class MessageChat {
  static const IDTO = "idto";
  static const IDFROM = "idfrom";
  static const CONTENT = "content";
  static const TIMESTAMP = "timestamp";

  late String idfrom;
  late String idto;
  late String timestamp;
  late String content;

  MessageChat(
      {required this.content,
      required this.idfrom,
      required this.idto,
      required this.timestamp});

  MessageChat.fromMap(Map<String, dynamic> data) {
    idfrom = data[IDFROM];
    timestamp = data[TIMESTAMP];
    idto = data[IDTO];
    content = data[CONTENT];
  }

  Map<String, dynamic> toJson() {
    return {
      FirestoreConstants.idfrom: this.idfrom,
      FirestoreConstants.idto: this.idto,
      FirestoreConstants.timestamp: this.timestamp,
      FirestoreConstants.content: this.content,
    };
  }
}
