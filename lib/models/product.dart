import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  static const ID = "id";
  static const IMAGEURLS = "imageUrls";
  static const NAME = "name";
  static const BRAND = "brand";
  static const PRICE = "price";
  static const SIZES = "sizes";
  static const CATEGORY = "category";
  static const DESCRIPTION = "description";
  static const LIKES = "likes";
  static const PURCHASES = "purchases";
  static const RATING = "rating";

  late String id;
  late List imageUrls;
  late List sizes;
  late String name;
  late String brand;
  late String description;
  late String category;
  late double price;
  late int likes;
  late int purchases;
  var rating;
  late DateTime dateCreated;

  ProductModel({
    required this.id,
    required this.purchases,
    required this.likes,
    required this.imageUrls,
    required this.name,
    required this.brand,
    required this.price,
    required this.sizes,
    required this.description,
    required this.category,
    required this.rating,
    required this.dateCreated,
  });

  ProductModel.fromMap(Map<String, dynamic> data) {
    id = data[ID] ?? "";
    imageUrls = data["imageUrls"] ?? [];
    sizes = data[SIZES] ?? [];
    name = data[NAME] ?? "";
    brand = data[BRAND] ?? "";
    description = data[DESCRIPTION] ?? "";
    category = data[CATEGORY] ?? "essential";
    purchases = data[PURCHASES] ?? 0;
    rating = data[RATING] ?? 4.0;
    price = data[PRICE].toDouble();
    dateCreated =
        data["dateCreated"] != null
            ? data["dateCreated"].toDate()
            : DateTime.now();
  }
  static ProductModel fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return ProductModel.fromMap(data);
  }
}
