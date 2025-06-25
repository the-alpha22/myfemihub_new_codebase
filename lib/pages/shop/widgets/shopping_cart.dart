import 'dart:async';
import 'dart:math';
import 'package:bridge_ai/constants/app_constants.dart';
import 'package:bridge_ai/controllers/cart_controller.dart';
import 'package:bridge_ai/pages/shop/widgets/cart_item_widget.dart';
import 'package:bridge_ai/pages/shop/widgets/payment_method.dart';
import 'package:bridge_ai/widgets/helpers/showLoading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bridge_ai/constants/controllers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lottie/lottie.dart';

class ShoppingCartWidget extends StatefulWidget {
  @override
  State<ShoppingCartWidget> createState() => _ShoppingCartWidgetState();
}

class _ShoppingCartWidgetState extends State<ShoppingCartWidget> {
  String location = 'Null, Press Button';
  String Address = 'search';
  double distanceInMeter = 0.0;

  getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar(
          "Unfortunately",
          "You have denied us location permissions",
        );
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }

    // Get the user's current position
    // Position position = await Geolocator.getCurrentPosition(
    //   forceAndroidLocationManager: true,
    //   desiredAccuracy: LocationAccuracy.best,
    //   timeLimit: Duration(seconds: 6),
    // ).timeout(Duration(seconds: 5),
    //     onTimeout: () =>
    //         Geolocator.getLastKnownPosition(forceAndroidLocationManager: true));
    Position? position;
    try {
      position = await Geolocator.getCurrentPosition(
        forceAndroidLocationManager: true,
        desiredAccuracy: LocationAccuracy.best,
        timeLimit: Duration(seconds: 6),
      ).catchError((error) async {
        print("using last known location");
        Position? position2 = await Geolocator.getLastKnownPosition(
          forceAndroidLocationManager: true,
        );
        return Position(
          latitude: position2!.latitude,
          longitude: position2.longitude,
          accuracy: position2.accuracy,
          speed: position2.speed,
          speedAccuracy: position2.speedAccuracy,
          heading: position2.heading,
          altitude: position2.altitude,
          timestamp: position2.timestamp,
          altitudeAccuracy: position2.altitudeAccuracy,
          headingAccuracy: position2.headingAccuracy,
        );
      });
    } catch (e) {
      print('Error: $e');
    }

    if (position != null) {
      print(position);
    } else {
      print('No position found');
    }
    // Print the latitude and longitude
    print('Latitude: ${position!.latitude}');
    print('Longitude: ${position.longitude}');

    return position;
  }

  Random random = new Random();
  int numberTo100s(double number) {
    final hundredsDigit = number ~/ 100;
    return hundredsDigit * 100;
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
                                showLoading(context);
                                print("location acquiring");

                                Position position = await getCurrentLocation();
                                print("location acquired");
                                location =
                                    'Lat: ${position.latitude} , Long: ${position.longitude}';
                                List<Placemark> placemarks =
                                    await placemarkFromCoordinates(
                                      position.latitude,
                                      position.longitude,
                                    );
                                print(placemarks);
                                Placemark place = placemarks[0];
                                Address =
                                    '${place.street}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.thoroughfare}, ${place.country}';
                                if (place.country!.toLowerCase() != "uganda") {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Sorry, but we are currently operating in Uganda only',
                                        style: GoogleFonts.montserrat(
                                          color: Colors.white.withOpacity(0.6),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  );
                                  dismissLoadingWidget();
                                } else {
                                  distanceInMeter =
                                      await Geolocator.distanceBetween(
                                        position.latitude,
                                        position.longitude,
                                        0.313062890385,
                                        32.5774123962,
                                      );
                                  var distance =
                                      distanceInMeter.round().toInt();
                                  var delivery_fee = ((distance / 1000) * 1100);
                                  var tax = ((distance / 1000) * 38);
                                  dismissLoadingWidget();
                                  Get.to(
                                    () => PaymentMethod(
                                      city: "${place.locality}",
                                      street: "${place.street}",
                                      delivery:
                                          numberTo100s(delivery_fee).toDouble(),
                                      tax: numberTo100s(tax).toDouble(),
                                      lat: position.latitude,
                                      long: position.longitude,
                                    ),
                                  );
                                }
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
