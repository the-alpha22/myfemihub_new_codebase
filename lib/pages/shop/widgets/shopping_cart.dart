import 'dart:async';
import 'package:bridge_ai/constants/app_constants.dart';
import 'package:bridge_ai/controllers/cart_controller.dart';
import 'package:bridge_ai/pages/shop/widgets/cart_item_widget.dart';
import 'package:bridge_ai/pages/shop/widgets/payment_method.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bridge_ai/constants/controllers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';

class ShoppingCartWidget extends StatefulWidget {
  @override
  State<ShoppingCartWidget> createState() => _ShoppingCartWidgetState();
}

class _ShoppingCartWidgetState extends State<ShoppingCartWidget> {
  String location = 'Enter your city';
  String Address = '';
  TextEditingController cityController = TextEditingController();
  TextEditingController streetController = TextEditingController();

  // Predefined delivery rates by city (you can customize these)
  final Map<String, double> cityDeliveryRates = {
    'kampala': 5000,
    'entebbe': 8000,
    'jinja': 12000,
    'fort portal': 15000,
    'mbarara': 14000,
    'kabale': 16000,
    'masaka': 9000,
    'mbale': 13000,
    'soroti': 14000,
    'gulu': 18000,
  };

  int numberTo100s(double number) {
    final hundredsDigit = number ~/ 100;
    return hundredsDigit * 100;
  }

  // Show address entry dialog
  void showAddressDialog() {
    cityController.clear();
    streetController.clear();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Enter Delivery Address',
            style: GoogleFonts.montserrat(fontWeight: FontWeight.w600),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: cityController,
                  decoration: InputDecoration(
                    labelText: 'City *',
                    hintText: 'e.g., Kampala',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 15),
                TextField(
                  controller: streetController,
                  decoration: InputDecoration(
                    labelText: 'Street Address',
                    hintText: 'e.g., Kampala Road',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Supported cities: Kampala, Entebbe, Jinja, Fort Portal, Mbarara, Kabale, Masaka, Mbale, Soroti, Gulu',
                    style: GoogleFonts.montserrat(
                      fontSize: 11,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
              onPressed: () {
                if (cityController.text.isEmpty) {
                  Fluttertoast.showToast(
                    msg: 'Please enter a city',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.TOP,
                    backgroundColor: Colors.red.withOpacity(0.7),
                    textColor: Colors.white,
                  );
                  return;
                }

                String city = cityController.text.toLowerCase().trim();

                // Check if city is supported
                if (!cityDeliveryRates.containsKey(city)) {
                  Fluttertoast.showToast(
                    msg: 'Sorry, we don\'t deliver to $city yet',
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.TOP,
                    backgroundColor: Colors.red.withOpacity(0.7),
                    textColor: Colors.white,
                  );
                  return;
                }

                setState(() {
                  location = '${city[0].toUpperCase()}${city.substring(1)}';
                  Address =
                      '${streetController.text.isNotEmpty ? streetController.text + ', ' : ''}${location}';
                });

                Navigator.pop(context);
              },
              child: Text(
                'Confirm',
                style: GoogleFonts.montserrat(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print(CartController.instance.totalCartPrice.value);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        title: Text(
          "Shopping Cart",
          style: GoogleFonts.montserrat(
            color: Colors.white.withOpacity(0.9),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Get.offAllNamed("/shop");
          },
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
      ),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          ListView(
            children: [
              SizedBox(height: 10),
              userController.userModel.value!.cart.isNotEmpty
                  ? Obx(
                    () => Column(
                      children:
                          userController.userModel.value!.cart
                              .map(
                                (cartItem) => CartItemWidget(
                                  cartItem: cartItem,
                                  press: () {
                                    CartController.instance.removeCartItem(
                                      cartItem,
                                    );
                                  },
                                ),
                              )
                              .toList(),
                    ),
                  )
                  : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.1,
                        ),
                        Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Lottie.asset(
                              'images/femihub_nothing_found.json',
                              repeat: true,
                              frameRate: FrameRate(30),
                              height: 180,
                            ),
                          ),
                        ),
                        Text(
                          "Your Shopping Cart\nis Empty",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(
                            color: Colors.black.withOpacity(0.9),
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
            ],
          ),
          Positioned(
            bottom: 8,
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(8),
              child:
                  userController.userModel.value!.cart.isNotEmpty
                      ? Column(
                        children: [
                          TextButton(
                            onPressed: () {
                              userController.updateUserData({"cart": []});
                            },
                            child: Container(
                              height: 20,
                              child: Text(
                                "Clear Cart",
                                style: GoogleFonts.montserrat(
                                  color: Colors.red,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(color: primaryColor),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text(
                                    "Checkout",
                                    style: GoogleFonts.montserrat(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            onTap: () async {
                              if (userController
                                  .userModel
                                  .value!
                                  .cart
                                  .isNotEmpty) {
                                // Show address entry dialog
                                showAddressDialog();

                                // Wait for user to enter address
                                await Future.delayed(
                                  Duration(milliseconds: 500),
                                );

                                if (Address.isEmpty) {
                                  return;
                                }

                                String city = location.toLowerCase();
                                double baseDeliveryFee =
                                    cityDeliveryRates[city] ?? 5000;
                                double tax = baseDeliveryFee * 0.15; // 15% tax

                                Get.to(
                                  () => PaymentMethod(
                                    city: location,
                                    street:
                                        streetController.text.isEmpty
                                            ? location
                                            : streetController.text,
                                    delivery:
                                        numberTo100s(
                                          baseDeliveryFee,
                                        ).toDouble(),
                                    tax: numberTo100s(tax).toDouble(),
                                    lat: 0.0, // Not using GPS coordinates
                                    long: 0.0,
                                  ),
                                );
                              } else {
                                Fluttertoast.showToast(
                                  msg: "Your Cart is empty",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.TOP,
                                  timeInSecForIosWeb: 3,
                                  backgroundColor: Colors.black.withOpacity(
                                    0.7,
                                  ),
                                  textColor: Colors.white,
                                  fontSize: 16.0,
                                );
                              }
                            },
                          ),
                        ],
                      )
                      : Container(),
            ),
          ),
        ],
      ),
    );
  }
}
