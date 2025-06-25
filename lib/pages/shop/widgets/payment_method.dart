import 'dart:math';
import 'package:bridge_ai/constants/app_constants.dart';
import 'package:bridge_ai/constants/controllers.dart';
import 'package:bridge_ai/controllers/cart_controller.dart';
import 'package:bridge_ai/pages/shop/widgets/paymentpage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class PaymentMethod extends StatefulWidget {
  PaymentMethod({
    Key? key,
    required this.street,
    required this.city,
    required this.lat,
    required this.long,
    required this.delivery,
    required this.tax,
  }) : super(key: key);
  final String street;
  final String city;
  final double lat;
  final double long;
  final double delivery;
  final double tax;

  @override
  State<PaymentMethod> createState() => _PaymentMethodState();
}

class _PaymentMethodState extends State<PaymentMethod> {
  void initState() {
    super.initState();
  }

  final ref = "ref${DateTime.now().microsecondsSinceEpoch.toString()}";

  final Random random = new Random();

  @override
  Widget build(BuildContext context) {
    var oCcy = NumberFormat("#,##0", "en_US");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Checkout",
          style: GoogleFonts.montserrat(color: Colors.white, fontSize: 14),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Get.back();
          },
        ),
        elevation: 0,
      ),
      body: Center(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Divider(),
                  SizedBox(height: 20),
                  Text(
                    "Delivering to ${widget.city}, ${widget.street}",
                    style: GoogleFonts.montserrat(
                      color: Colors.black.withOpacity(0.7),
                      fontSize: 13,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "This is your approximate location",
                    style: GoogleFonts.montserrat(
                      color: Colors.black.withOpacity(0.6),
                      fontSize: 11,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Your contact is ${userController.userModel.value!.phone}. Please make sure it is correct before placing an order.",
                    style: GoogleFonts.montserrat(
                      fontSize: 11,
                      color: Colors.black.withOpacity(0.7),
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 20),
                  Divider(),
                  Obx(
                    () => Column(
                      children:
                          userController.userModel.value!.cart.map((cartItem) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                          10.0,
                                        ),
                                        child: CachedNetworkImage(
                                          width: 80,
                                          fit: BoxFit.fill,
                                          imageUrl: cartItem.image,
                                          placeholder:
                                              (context, url) => Center(
                                                child:
                                                    new CircularProgressIndicator(
                                                      strokeWidth: 0,
                                                      color: Colors.black,
                                                    ),
                                              ),
                                          errorWidget:
                                              (context, url, error) =>
                                                  new Icon(Icons.error),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Wrap(
                                        direction: Axis.vertical,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 2,
                                            ),
                                            child: Container(
                                              width:
                                                  MediaQuery.of(
                                                    context,
                                                  ).size.width *
                                                  0.45,
                                              child: Text(
                                                "${cartItem.name.capitalize}",
                                                maxLines: 1,
                                                style: GoogleFonts.montserrat(
                                                  color: Colors.black87
                                                      .withOpacity(0.9),
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 2,
                                            ),
                                            child: Text(
                                              "\shs. ${oCcy.format(cartItem.cost)}",
                                              style: GoogleFonts.montserrat(
                                                color: Colors.black87
                                                    .withOpacity(0.8),
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(cartItem.quantity.toString()),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                    ),
                  ),
                  SizedBox(height: 20),
                  Divider(),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Sub Total:",
                        style: GoogleFonts.montserrat(
                          color: Colors.black.withOpacity(0.7),
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        "shs. ${oCcy.format(CartController.instance.totalCartPrice.value)}",
                        style: GoogleFonts.montserrat(
                          color: Colors.black.withOpacity(0.8),
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Delivery Fee:",
                        style: GoogleFonts.montserrat(
                          color: Colors.black.withOpacity(0.7),
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        "shs. ${oCcy.format(widget.delivery)}",
                        style: GoogleFonts.montserrat(
                          color: Colors.black.withOpacity(0.8),
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Additional Fees:",
                        style: GoogleFonts.montserrat(
                          color: Colors.black.withOpacity(0.7),
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        "shs. ${oCcy.format(widget.tax)}",
                        style: GoogleFonts.montserrat(
                          color: Colors.black.withOpacity(0.8),
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Final Total:",
                        style: GoogleFonts.montserrat(
                          color: Colors.black.withOpacity(0.7),
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        "shs. ${oCcy.format(CartController.instance.totalCartPrice.value + widget.delivery + widget.tax)}",
                        style: GoogleFonts.montserrat(
                          color: Colors.black.withOpacity(0.8),
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Divider(),
                  SizedBox(height: 20),
                  Center(
                    child: SizedBox(
                      height: 55,
                      width: MediaQuery.of(context).size.width * 0.95,
                      child: TextButton(
                        onPressed: () {
                          Get.to(
                            () => PaymentFinal(
                              street: widget.street,
                              city: widget.city,
                              delivery: widget.delivery,
                              tax: widget.tax,
                              lat: widget.lat,
                              long: widget.long,
                            ),
                            transition: Transition.rightToLeft,
                          );
                        },
                        child: Text(
                          "PROCEED TO PAYMENT",
                          style: GoogleFonts.montserrat(
                            color: Colors.black87.withOpacity(0.9),
                            fontSize: 15,
                          ),
                        ),
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              side: BorderSide(color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Divider(),
                  SizedBox(height: 40),
                  Center(
                    child: Text(
                      "The only available payment option is mobile money(Airtel or Mtn)",
                      style: GoogleFonts.montserrat(
                        fontSize: 11,
                        color: Colors.black.withOpacity(0.7),
                        height: 1.5,
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
