import 'dart:async';
import 'package:get/get.dart';
import 'package:bridge_ai/constants/firebase.dart';
import 'package:bridge_ai/models/product.dart';

class ProducsController extends GetxController {
  static ProducsController instance = Get.find();
  RxList<ProductModel> products = RxList<ProductModel>([]);
  String collection = "products";

  @override
  onReady() {
    super.onReady();
    products.bindStream(getAllProducts());
  }

  Stream<List<ProductModel>> getAllProducts() => firebaseFirestore
      .collection(collection)
      .snapshots()
      .map(
        (query) =>
            query.docs
                .map((item) => ProductModel.fromMap(item.data()))
                .toList(),
      );
  Future<List<ProductModel>> getRecommendedProducts(String usercategory) async {
    try {
      var querySnapshot =
          await firebaseFirestore
              .collection(collection)
              .where("usercategory", isEqualTo: usercategory)
              .orderBy("purchases", descending: true)
              .get();

      List<ProductModel> products =
          querySnapshot.docs
              .map(
                (documentSnapshot) =>
                    ProductModel.fromMap(documentSnapshot.data()),
              )
              .toList();

      return products;
    } catch (e) {
      // Handle any errors that might occur during the database query
      print("Error fetching recommended products: $e");
      return [];
    }
  }

  Future<List<ProductModel>> getMostPurchasedProducts() async {
    try {
      var querySnapshot =
          await firebaseFirestore
              .collection(collection)
              .orderBy("purchases", descending: true)
              .limit(4)
              .get();

      List<ProductModel> products =
          querySnapshot.docs
              .map(
                (documentSnapshot) =>
                    ProductModel.fromMap(documentSnapshot.data()),
              )
              .toList();

      return products;
    } catch (e) {
      // Handle any errors that might occur during the database query
      print("Error fetching most purchased products: $e");
      return [];
    }
  }

  Future<List<ProductModel>> getProductsByCategory(String category) async {
    try {
      var querySnapshot =
          await firebaseFirestore
              .collection(collection)
              .where("category", isEqualTo: category)
              .get();

      List<ProductModel> products =
          querySnapshot.docs
              .map(
                (documentSnapshot) =>
                    ProductModel.fromMap(documentSnapshot.data()),
              )
              .toList();

      return products;
    } catch (e) {
      // Handle any errors that might occur during the database query
      print("Error fetching products by category: $e");
      return [];
    }
  }
}
