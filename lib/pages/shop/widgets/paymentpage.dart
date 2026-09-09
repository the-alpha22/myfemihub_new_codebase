// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:bridge_ai/constants/app_constants.dart';
import 'package:bridge_ai/constants/controllers.dart';
import 'package:bridge_ai/controllers/cart_controller.dart';
import 'package:bridge_ai/models/sms/sms.dart';
import 'package:bridge_ai/pages/shop/payment/popover.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

const _rose = Color(0xFFE8567A);
const _roseDark = Color(0xFFC03A5E);
const _roseSoft = Color(0xFFFFF0F4);
const _plum = Color(0xFF3D1A2E);
const _sage = Color(0xFF6BAF92);
const _muted = Color(0xFF9E8892);
const _surface = Color(0xFFFDF7F9);

class PaymentFinal extends StatefulWidget {
  const PaymentFinal({
    Key? key,
    required this.street,
    required this.city,
    required this.delivery,
    required this.lat,
    required this.long,
    required this.tax,
  }) : super(key: key);

  final String street;
  final String city;
  final double delivery;
  final double lat;
  final double long;
  final double tax;

  @override
  State<PaymentFinal> createState() => _PaymentFinalState();
}

class _PaymentFinalState extends State<PaymentFinal> {
  final ref = "ref${DateTime.now().microsecondsSinceEpoch.toString()}";
  final TextEditingController phone = TextEditingController(text: "+256");
  final oCcy = NumberFormat("#,##0", "en_US");
  final Random random = Random();
  final _formKey = GlobalKey<FormState>();

  double get _total =>
      CartController.instance.totalCartPrice.value +
      widget.delivery +
      widget.tax;

  @override
  void dispose() {
    phone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAmountHero()
                  .animate()
                  .fadeIn(duration: 450.ms, curve: Curves.easeOut)
                  .slideY(begin: 0.07, end: 0, duration: 450.ms),
              const SizedBox(height: 16),
              _buildPhoneCard()
                  .animate()
                  .fadeIn(delay: 80.ms, duration: 450.ms, curve: Curves.easeOut)
                  .slideY(begin: 0.07, end: 0, delay: 80.ms, duration: 450.ms),
              const SizedBox(height: 24),
              _buildPayButton()
                  .animate()
                  .fadeIn(
                    delay: 160.ms,
                    duration: 450.ms,
                    curve: Curves.easeOut,
                  )
                  .slideY(begin: 0.07, end: 0, delay: 160.ms, duration: 450.ms),
              const SizedBox(height: 16),
              _buildNotesCard().animate().fadeIn(
                delay: 240.ms,
                duration: 450.ms,
                curve: Curves.easeOut,
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      toolbarHeight: 64,
      centerTitle: false,
      title: Text(
        "Payment",
        style: GoogleFonts.philosopher(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: _plum,
        ),
      ),
      leading: IconButton(
        onPressed: () => Get.back(),
        icon: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(color: _roseSoft, shape: BoxShape.circle),
          child: Icon(Icons.arrow_back_ios_new_rounded, color: _rose, size: 16),
        ),
      ),
    );
  }

  Widget _buildAmountHero() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("images/payment.jpg"),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _rose.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -24,
            bottom: -24,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.07),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(PhosphorIcons.lock, color: Colors.white, size: 13),
                      const SizedBox(width: 5),
                      Text(
                        "Secure Payment",
                        style: GoogleFonts.plusJakartaSans(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Amount Due",
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.white.withOpacity(0.75),
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 4),
                Obx(
                  () => Text(
                    "UGX ${oCcy.format(_total)}",
                    style: GoogleFonts.philosopher(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Includes delivery & additional fees",
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.white.withOpacity(0.65),
                    fontSize: 11.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhoneCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: _roseSoft,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    PhosphorIcons.deviceMobile,
                    color: _rose,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  "Mobile Money Number",
                  style: GoogleFonts.philosopher(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: _plum,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.only(left: 46),
              child: Text(
                "Enter the number to charge (e.g. +256750322256)",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11.5,
                  color: _muted,
                  height: 1.4,
                ),
              ),
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: phone,
              keyboardType: TextInputType.phone,
              style: GoogleFonts.plusJakartaSans(
                color: _plum,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                prefixIcon: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Icon(PhosphorIcons.phone, color: _rose, size: 18),
                ),
                prefixIconConstraints: const BoxConstraints(
                  minWidth: 0,
                  minHeight: 0,
                ),
                filled: true,
                fillColor: _surface,
                hintText: "+256XXXXXXXXX",
                hintStyle: GoogleFonts.plusJakartaSans(
                  color: _muted,
                  fontSize: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: _rose.withOpacity(0.5),
                    width: 1.5,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: _rose, width: 1.5),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: _rose, width: 1.5),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Phone number is required';
                } else if (value.length < 5) {
                  return 'Enter a valid phone number';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPayButton() {
    return Obx(
      () => GestureDetector(
        onTap: () async {
          if (_formKey.currentState!.validate()) {
            _showLoadingSheet(
              "Initiating Transaction of UGX ${oCcy.format(_total)}",
            );
            bool success = await depositFunds(
              phone.text.trim().substring(1),
              _total,
              ref,
            );
            if (success) {
              await addOrderDetails(
                _total,
                userController.userModel.value!.id,
                widget.long,
                widget.lat,
                widget.city,
                userController.userModel.value!.cartItemsToJson(),
              );
              Get.back();
              Get.offAllNamed("/home");
            } else {
              Get.back();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: _plum,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  content: Text(
                    "Transaction not successful. Please try again.",
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            }
          }
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [_rose, _roseDark],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: _rose.withOpacity(0.35),
                blurRadius: 14,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(PhosphorIcons.creditCard, color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Text(
                "Pay UGX ${oCcy.format(_total)}",
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotesCard() {
    final notes = [
      _NoteItem(
        PhosphorIcons.info,
        "Additional charges from your mobile network are not reflected above.",
      ),
      _NoteItem(
        PhosphorIcons.deviceMobile,
        "Enter your PIN when prompted on your phone to complete the payment.",
      ),
      _NoteItem(
        PhosphorIcons.checkCircle,
        "Only Airtel Money and MTN Mobile Money are accepted.",
      ),
      _NoteItem(
        PhosphorIcons.warning,
        "Double-check your cart before confirming your order.",
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children:
              notes
                  .asMap()
                  .entries
                  .map(
                    (entry) => Padding(
                      padding: EdgeInsets.only(
                        bottom: entry.key < notes.length - 1 ? 12 : 0,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(entry.value.icon, color: _muted, size: 15),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              entry.value.text,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                color: _muted,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
        ),
      ),
    );
  }

  void _showLoadingSheet(String message) {
    showModalBottomSheet<int>(
      backgroundColor: Colors.transparent,
      context: context,
      isDismissible: false,
      builder:
          (context) => Popover(
            child: SizedBox(
              height: 200,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(
                        strokeWidth: 2,
                        color: _rose,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        message,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.plusJakartaSans(
                          color: _plum,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
    );
  }

  void requestToPay(
    BuildContext context,
    String contact,
    double amount,
    int counter,
  ) async {
    final idNumb = random.nextInt(300).toString();
    var time = DateTime.now().toString().substring(0, 6);
    final idnumb = "ON-$time$idNumb";

    _showLoadingSheet("Initiating transaction of UGX ${oCcy.format(amount)}");

    try {
      var response = await http.get(
        Uri.parse('https://api.zengapay.com/v1/'),
        headers: {
          "Authorization":
              "Bearer ZPYPUBK-40790ea5614786a175bffbdbb70e6de864bb0f786867b556f204a37f75e45eef",
        },
      );
      if (response.statusCode == 200) {
        try {
          var body = jsonEncode({
            "msisdn": contact,
            "amount": '${(amount + 450)}',
            "external_reference": idnumb,
            "narration": "Payment - $idnumb",
            "charge_customer": true,
          });
          var response = await http.post(
            Uri.parse('https://api.zengapay.com/v1/collections'),
            headers: {
              "Authorization":
                  "Bearer ZPYPUBK-40790ea5614786a175bffbdbb70e6de864bb0f786867b556f204a37f75e45eef",
              'Content-Type': 'application/json',
            },
            body: body,
          );
          var transactionReference =
              jsonDecode(response.body)['transactionReference'];
          if (response.statusCode == 202) {
            var counter = 0;
            try {
              Get.back();
              _showLoadingSheet(
                "Please enter your mobile PIN when prompted to complete your order.",
              );
              Timer.periodic(const Duration(seconds: 2), ((timer) async {
                counter = counter + 1;
                var response = await http.get(
                  Uri.parse(
                    'https://api.zengapay.com/v1/collections/$transactionReference',
                  ),
                  headers: {
                    "Authorization":
                        "Bearer ZPYPUBK-40790ea5614786a175bffbdbb70e6de864bb0f786867b556f204a37f75e45eef",
                  },
                );
                if (counter == 60 || response.statusCode == 200) {
                  var transactionStatus =
                      jsonDecode(response.body)['data']['transactionStatus'];
                  if (transactionStatus == "SUCCEEDED") {
                    timer.cancel();
                    Get.back();
                    Get.offAllNamed("/home");
                    _handleSuccess(context, idnumb, amount);
                  } else if (transactionStatus == "FAILED") {
                    timer.cancel();
                    Get.back();
                    _handleFailure(context);
                  }
                }
              }));
            } catch (e) {
              Get.back();
              _handleError(context, "Something went wrong. Please try again.");
            }
          }
        } catch (e) {
          print(e);
        }
      }
    } catch (e) {
      print(e);
      if (e.toString().contains("SocketException")) {
        Fluttertoast.showToast(
          msg: "No internet connection. Please check your network.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          backgroundColor: _plum.withOpacity(0.9),
          textColor: Colors.white,
          fontSize: 14.0,
        );
        Get.back();
        _handleError(context, "No stable internet connection detected.");
      }
    }
  }

  void _handleSuccess(BuildContext context, String idnumb, double amount) {
    DateTime now = DateTime.now();
    final currentTime = DateTime(
      now.year,
      now.month,
      now.day,
      now.hour,
      now.minute,
    );

    SendSms().sendSms(
      "256700734139",
      "${userController.userModel.value!.name.toString().capitalize}+made+an+order.+Contact:+${userController.userModel.value!.phone}.+bridge_ai",
    );

    Map<String, dynamic> data = {
      "address": widget.city,
      "streetAddress": widget.street,
      "lat": widget.lat,
      "long": widget.long,
      "phone": userController.userModel.value!.phone,
      "name": userController.userModel.value!.name,
      "mop": "paid",
      "amount": "${(amount).toInt().toStringAsFixed(1)}",
      "cart": userController.userModel.value!.cartItemsToJson(),
      "remaining": userController.userModel.value!.cart.length,
      "id": idnumb,
      "ref": idnumb,
      "status": "PENDING",
      "ordertime": DateTime.now().microsecondsSinceEpoch,
      "time": Timestamp.now(),
      "createdAt": '$currentTime',
      "userId": userController.userModel.value!.id,
      "filled": 'not',
      "ondelivery": 'not',
    };

    sendEmail(
      "${userController.userModel.value!.name.capitalize}",
      userController.userModel.value!.email,
      "${widget.city.capitalize}",
      "UGX ${oCcy.format(amount)}",
      idnumb,
    );

    userController.sendEmail(
      "bridge_ai Team",
      "patricksseremba787@gmail.com, joviakisaakye@gmail.com",
      '''Hello Team,
           
           This is an order email placed by ${userController.userModel.value!.name.capitalize} and below are the order details.

           Details:
           Customer's Contact: ${userController.userModel.value!.phone},
           Customer Name: ${userController.userModel.value!.name},
           Amount Paid: UGX ${oCcy.format(amount)},
           Items:
              ${userController.userModel.value!.cartItemsToJson()},
           Address: ${widget.city},
           Street Address: ${widget.street},
           User Location Coordinates: ${widget.lat}, ${widget.long},
        ''',
      "Order Placed By ${userController.userModel.value!.name.capitalize}",
    );

    FirebaseFirestore.instance.collection("orders").add(data);
    FirebaseFirestore.instance.collection("logs").add({
      'name': userController.userModel.value!.name.capitalize,
      'id': userController.userModel.value!.id,
      'message': 'Has placed an order',
      'time': Timestamp.now(),
    });
    userController.updateUserData({"cart": []});

    Fluttertoast.showToast(
      msg: "Order successfully placed",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      backgroundColor: _sage.withOpacity(0.9),
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }

  void _handleFailure(BuildContext context) {
    showModalBottomSheet<int>(
      backgroundColor: Colors.transparent,
      context: context,
      builder:
          (context) => Popover(
            child: SizedBox(
              height: 200,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: _roseSoft,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          PhosphorIcons.warning,
                          color: _rose,
                          size: 24,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        "Transaction unsuccessful. Please try a different network.",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.plusJakartaSans(
                          color: _plum,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
    );
  }

  void _handleError(BuildContext context, String message) {
    showModalBottomSheet<int>(
      backgroundColor: Colors.transparent,
      context: context,
      builder:
          (context) => Popover(
            child: SizedBox(
              height: 200,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: _roseSoft,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          PhosphorIcons.wifiX,
                          color: _rose,
                          size: 24,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        message,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.plusJakartaSans(
                          color: _plum,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
    );
  }

  void sendEmail(
    String name,
    String email,
    String address,
    String amount,
    String ordernumber,
  ) async {
    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'service_id': "service_hhthruv",
        'template_id': "template_7qe3535",
        'user_id': "XUOcEJp3cEew5NNai",
        'accessToken': "LyMrwY7O8bovubs4_ztTU",
        'template_params': {
          'to_name': name,
          'to_email': email,
          'reply_to': "NO REPLY",
          'message':
              "Thank you for shopping with Bridge Mom App. We are pleased to confirm that we have received your order and it is currently being processed with great attention to detail.\n\nOrder Details:\nOrder Number: $ordernumber \nOrder Date: ${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}\nShipping Address: $address \n\nTotal Amount: $amount \n\nWe would like to assure you that we are committed to delivering high-quality products and excellent service. Our team is working diligently to prepare your order for shipment.\n\nEstimated Delivery Date: ${DateFormat.yMd().format(DateTime.now())}\n\nShould you have any questions or require further assistance, please do not hesitate to contact our customer service team",
        },
      }),
    );
  }
}

class _NoteItem {
  final IconData icon;
  final String text;
  const _NoteItem(this.icon, this.text);
}
