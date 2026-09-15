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
  static const SEGMENTS = "customerSegments";

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
  late List<String> customerSegments;

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
    this.customerSegments = const ['all'],
  });

  ProductModel.fromMap(Map<String, dynamic> data) {
    id = data[ID] ?? "";
    imageUrls = data[IMAGEURLS] ?? [];
    sizes = data[SIZES] ?? [];
    name = data[NAME] ?? "";
    brand = data[BRAND] ?? "";
    description = data[DESCRIPTION] ?? "";
    category = data[CATEGORY] ?? "essential";
    purchases = data[PURCHASES] ?? 0;
    rating = data[RATING] ?? 4.0;
    price = (data[PRICE] ?? 0).toDouble();
    dateCreated =
        data["dateCreated"] != null
            ? (data["dateCreated"] as Timestamp).toDate()
            : DateTime.now();
    customerSegments =
        data[SEGMENTS] != null ? List<String>.from(data[SEGMENTS]) : ['all'];
  }

  static ProductModel fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return ProductModel.fromMap(data);
  }

  Map<String, dynamic> toMap() {
    return {
      ID: id,
      IMAGEURLS: imageUrls,
      SIZES: sizes,
      NAME: name,
      BRAND: brand,
      DESCRIPTION: description,
      CATEGORY: category,
      PURCHASES: purchases,
      RATING: rating,
      PRICE: price,
      SEGMENTS: customerSegments,
      "dateCreated": Timestamp.fromDate(dateCreated),
    };
  }

  bool isVisibleToSegment(String userSegment) {
    if (customerSegments.contains('all')) return true;
    return customerSegments.contains(userSegment);
  }
}

class CustomerSegment {
  static const String all = 'all';
  static const String notYetPregnant = 'not_yet_pregnant';
  static const String pregnant = 'pregnant';
  static const String mother = 'mother';

  static const List<String> values = [all, notYetPregnant, pregnant, mother];

  static String label(String segment) {
    return switch (segment) {
      notYetPregnant => 'Not Yet Pregnant',
      pregnant => 'Pregnant',
      mother => 'A Mother',
      _ => 'Everyone',
    };
  }

  static String fromStageLabel(String stageLabel) {
    return switch (stageLabel) {
      'Not Yet Pregnant' => notYetPregnant,
      'Pregnant' => pregnant,
      'A Mother' => mother,
      _ => all,
    };
  }
}
