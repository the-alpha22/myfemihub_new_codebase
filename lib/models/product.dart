import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  static const ID = "id";
  static const IMAGE = "image";
  static const IMAGE2 = "image2";
  static const IMAGE3 = "image3";
  static const IMAGE4 = "image4";
  static const NAME = "name";
  static const BRAND = "brand";
  static const PRICE = "price";
  static const BP = "bp";
  static const VID = "vid";
  static const SIZES = "sizes";
  static const STORE = "store";
  static const CATEGORY = "category";
  static const SUB_CATEGORY = "sub_category";
  static const DESCRIPTION = "description";
  static const LIKES = "likes";
  static const PURCHASES = "purchases";
  static const REVIEWS = "reviews";
  static const STOCK = "stock";
  static const RATING = "rating";
  static const USERCATEGORY = "usercategory";

  late String id;
  late String image;
  late String image2;
  late List reviews;
  late List sizes;
  late String name;
  late String brand;
  late String store;
  late String description;
  late String category;
  late double price;
  late double bp;
  late int likes;
  late int purchases;
  var rating;
  late String usercategory;

  ProductModel({
    required this.id,
    required this.purchases,
    required this.likes,
    required this.image,
    required this.image2,
    required this.reviews,
    required this.name,
    required this.brand,
    required this.price,
    required this.store,
    required this.sizes,
    required this.description,
    required this.bp,
    required this.category,
    required this.rating,
    required this.usercategory,
  });

  ProductModel.fromMap(Map<String, dynamic> data) {
    id = data[ID];
    image = data[IMAGE];
    image2 = data[IMAGE2];
    sizes = data[SIZES];
    name = data[NAME];
    brand = data[BRAND];
    if (data[BP] == null) {
      bp = data[PRICE].toDouble() * 0.86;
    } else {
      bp = data[BP].toDouble();
    }
    description = data[DESCRIPTION];
    category = data[CATEGORY];
    usercategory = data[USERCATEGORY] ?? "Not Yet Pregnant";
    purchases = data[PURCHASES];
    rating = data[RATING];
    price = data[PRICE].toDouble();
  }
  static ProductModel fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return ProductModel.fromMap(data);
  }
}
