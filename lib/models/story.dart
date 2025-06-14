import 'package:cloud_firestore/cloud_firestore.dart';

class StoryModel {
  static const ID = "id";
  static const DETAILS = "details";
  static const TIME = "time";
  static const VIEWS = "views";
  static const USERID = "userId";
  static const ANONYMOUS = "anonymous";

  late String id;
  late String details;
  late DateTime time;
  var views;
  late String userId;
  late bool anonymous;
  late String usercategory;
  late int bookmarks;
  late int likes;
  late int comments;
  late List likedUserIds;

  StoryModel({
    required this.id,
    required this.details,
    required this.time,
    required this.userId,
    required this.views,
    required this.anonymous,
    required this.usercategory,
    required this.bookmarks,
    required this.likes,
    required this.comments,
    required this.likedUserIds,
  });

  StoryModel.fromMap(Map<String, dynamic> data) {
    id = data[ID] ?? "";
    time = data[TIME].toDate();
    views = data[VIEWS] ?? "";
    details = data[DETAILS] ?? "";
    userId = data["userId"] ?? "";
    anonymous = data[ANONYMOUS] ?? true;
    usercategory = data["usercategory"] ?? "Not Yet Pregnant";
    bookmarks = data["bookmarks"] ?? 0;
    likes = data["likes"] ?? 0;
    comments = data["comments"] ?? 0;
    likedUserIds = data["likedUserIds"] ?? [];
  }
  static StoryModel fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return StoryModel.fromMap(data);
  }
}
