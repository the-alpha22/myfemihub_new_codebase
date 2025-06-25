import 'dart:async';
import 'dart:convert';

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
import 'package:http/http.dart' as http;

class CartController extends GetxController {
  static CartController instance = Get.find();
  RxDouble totalCartPrice = 0.0.obs;

  @override
  void onReady() {
    super.onReady();
    ever(userController.userModel, changeCartTotalPrice);
  }

  addProductToCart(ProductModel product, String size, int quantity) async {
    try {
      if (_isItemAlreadyAdded(product)) {
        Fluttertoast.showToast(
          msg: "${product.name} is already in your cart",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.black.withOpacity(0.7),
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else {
        String itemId = Uuid().v1().toString();
        userController.updateUserData({
          "cart": FieldValue.arrayUnion([
            {
              "id": itemId,
              "productId": product.id,
              "name": product.name,
              "quantity": quantity,
              "price": product.price,
              "image": product.imageUrls.first,
              "cost": product.price,
              "size": size,
            },
          ]),
        });

        Fluttertoast.showToast(
          msg: "${product.name} was added to your cart",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.black.withOpacity(0.7),
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } catch (e) {
      Get.snackbar("Error", "Cannot add this item");
      debugPrint(e.toString());
    }
  }

  void removeCartItem(CartItemModel cartItem) {
    try {
      userController.updateUserData({
        "cart": FieldValue.arrayRemove([cartItem.toJson()]),
      });
    } catch (e) {
      Get.snackbar("Error", "Cannot remove this item");
      debugPrint(e.toString());
    }
  }

  changeCartTotalPrice(UserModel? userModel) {
    totalCartPrice.value = 0.0;
    if (userModel!.cart.isNotEmpty) {
      userModel.cart.forEach((cartItem) {
        totalCartPrice.value += cartItem.cost;
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
        "cart": FieldValue.arrayUnion([item.toJson()]),
      });
    }
  }

  void increaseQuantity(CartItemModel item) {
    removeCartItem(item);
    item.quantity++;
    logger.i({"quantity": item.quantity});
    userController.updateUserData({
      "cart": FieldValue.arrayUnion([item.toJson()]),
    });
  }
}

String zengapayKey =
    "ZPYPUBK-40790ea5614786a175bffbdbb70e6de864bb0f786867b556f204a37f75e45eef";

Future<bool> depositFunds(String contact, double amount, String ref) async {
  try {
    var response = await http.get(
      Uri.parse('https://api.zengapay.com/v1/'),
      headers: {"Authorization": "Bearer $zengapayKey"},
    );

    if (response.statusCode == 200) {
      print("\n=========Initiating Transaction...=========\n");

      var body = jsonEncode({
        "msisdn": contact.replaceAll("+", ""),
        "amount": '${amount}',
        "external_reference": ref,
        "narration": "Payment - $ref",
        "charge_customer": true,
      });

      var response = await http.post(
        Uri.parse('https://api.zengapay.com/v1/collections'),
        headers: {
          "Authorization": "Bearer $zengapayKey",
          'Content-Type': 'application/json',
        },
        body: body,
      );

      if (response.statusCode == 202) {
        var transactionReference =
            jsonDecode(response.body)['transactionReference'];
        print("\n==========Collecting funds...============\n");
        print(transactionReference);

        var counter = 0;
        Completer<bool> completer = Completer<bool>();

        Timer.periodic(Duration(seconds: 2), (timer) async {
          counter++;
          var response = await http.get(
            Uri.parse(
              'https://api.zengapay.com/v1/collections/$transactionReference',
            ),
            headers: {"Authorization": "Bearer $zengapayKey"},
          );

          if (response.statusCode == 200) {
            var transactionStatus =
                jsonDecode(response.body)['data']['transactionStatus'];

            if (transactionStatus == "SUCCEEDED") {
              print("Payment Successful");
              timer.cancel();
              completer.complete(true);
            } else if (transactionStatus == "FAILED") {
              print("Transaction Unsuccessful");
              timer.cancel();
              completer.complete(false);
            } else if (transactionStatus == "PENDING") {
              print("Transaction Pending");
            }
          }

          if (counter == 60) {
            timer.cancel();
            if (response.statusCode == 200) {
              var transactionStatus =
                  jsonDecode(response.body)['data']['transactionStatus'];
              if (transactionStatus == "SUCCEEDED") {
                print("Payment Successful");
                completer.complete(true);
              } else {
                completer.complete(false);
              }
            } else {
              completer.complete(false);
            }
          }
        });

        return completer.future;
      } else {
        print(
          "Transaction initiation failed with status: ${response.statusCode} - ${response.body}",
        );
        return false;
      }
    } else {
      print("Failed to get response with status: ${response.statusCode}");
      return false;
    }
  } catch (e) {
    print("Error depositing funds: $e");
    return false;
  }
}
