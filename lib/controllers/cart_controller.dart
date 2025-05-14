import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bridge_ai/constants/app_constants.dart';
import 'package:bridge_ai/constants/controllers.dart';
import 'package:bridge_ai/models/cart_item.dart';
import 'package:bridge_ai/models/product.dart';
import 'package:bridge_ai/models/user.dart';
import 'package:uuid/uuid.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CartController extends GetxController {
  static CartController instance = Get.find();
  RxDouble totalCartPrice = RxDouble(0.0);
  RxDouble totalCartAdminPrice = 0.0.obs;

  @override
  void onReady() {
    super.onReady();
    ever(userController.userModel, changeCartTotalPrice);
  }

  void addProductToCart(ProductModel product, String size, int quantity) async {
    try {
      if (_isItemAlreadyAdded(product)) {
        Fluttertoast.showToast(
            msg: "${product.name} is already in your cart",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.black.withOpacity(0.7),
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        String itemId = Uuid().toString();
        userController.updateUserData({
          "cart": FieldValue.arrayUnion([
            {
              "id": itemId,
              "productId": product.id,
              "name": product.name,
              "quantity": quantity,
              "price": product.price,
              "bp": product.bp,
              "image": product.image,
              "cost": product.price,
              "cost2": product.bp,
              "size": size,
            }
          ])
        });

        Fluttertoast.showToast(
            msg: "${product.name} was added to your cart",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.black.withOpacity(0.7),
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } catch (e) {
      Get.snackbar("Error", "Cannot add this item");
      debugPrint(e.toString());
    }
  }

  void removeCartItem(CartItemModel cartItem) {
    try {
      userController.updateUserData({
        "cart": FieldValue.arrayRemove([cartItem.toJson()])
      });
    } catch (e) {
      Get.snackbar("Error", "Cannot remove this item");
      debugPrint(e.toString());
    }
  }

  changeCartTotalPrice(UserModel? userModel) {
    totalCartPrice.value = 0.0;
    totalCartAdminPrice.value = 0.0;
    if (userModel!.cart.isNotEmpty) {
      userModel.cart.forEach((cartItem) {
        totalCartPrice.value += cartItem.cost;
        totalCartAdminPrice.value += cartItem.cost2;
      });
    }
  }

  bool _isItemAlreadyAdded(ProductModel product) =>
      userController.userModel.value!.cart
          .where((item) => item.productId == product.id)
          .isNotEmpty;

  void decreaseQuantity(CartItemModel item) {
    if (item.quantity == 1) {
      removeCartItem(item);
    } else {
      removeCartItem(item);
      item.quantity--;
      userController.updateUserData({
        "cart": FieldValue.arrayUnion([item.toJson()])
      });
    }
  }

  void increaseQuantity(CartItemModel item) {
    removeCartItem(item);
    item.quantity++;
    logger.i({"quantity": item.quantity});
    userController.updateUserData({
      "cart": FieldValue.arrayUnion([item.toJson()])
    });
  }
}
