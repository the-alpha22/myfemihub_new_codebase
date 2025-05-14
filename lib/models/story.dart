import 'package:cloud_firestore/cloud_firestore.dart';

class StoryModel {
  static const ID = "id";
  static const DETAILS = "details";
  static const TIME = "time";
  static const VIEWS = "views";
  static const USERID = "userid";
  static const ANONYMOUS = "anonymous";

  late String id;
  late String details;
  late DateTime time;
  var views;
  late String userid;
  late bool anonymous;
  late String usercategory;

  StoryModel({
    required this.id,
    required this.details,
    required this.time,
    required this.userid,
    required this.views,
    required this.anonymous,
    required this.usercategory,
  });

  StoryModel.fromMap(Map<String, dynamic> data) {
    id = data[ID] ?? "";
    time = data[TIME].toDate();
    views = data[VIEWS] ?? "";
    details = data[DETAILS] ?? "";
    userid = data[USERID] ?? "";
    anonymous = data[ANONYMOUS] ?? true;
    usercategory = data["usercategory"] ?? "Not Yet Pregnant";
  }
  static StoryModel fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return StoryModel.fromMap(data);
  }
}
