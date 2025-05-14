import 'package:cloud_firestore/cloud_firestore.dart';

class ArticleModel {
  static const ID = "id";
  static const NAME = "name";
  static const DETAILS = "details";
  static const SUBTITLE = "subtitle";
  static const IMAGE = "image";

  late String id;
  late String image;
  late String details;
  late String subtitle;
  late String name;

  ArticleModel({
    required this.id,
    required this.subtitle,
    required this.name,
    required this.image,
    required this.details,
  });

  ArticleModel.fromMap(Map<String, dynamic> data) {
    id = data[ID];
    image = data[IMAGE];
    name = data[NAME];
    subtitle = data[SUBTITLE];
    details = data[DETAILS];
  }
  static ArticleModel fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return ArticleModel.fromMap(data);
  }
}
