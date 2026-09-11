// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:convert';
import 'dart:math';
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

const _flwClientId = "ec1001e9-787e-447e-b2d9-21e9f7503abf";
const _flwClientSecret =
    "UP9ohZyoAYoG0Mbz9FvT2GaXJEYYCAIYxA4T9n6fY5bh2Kxzefubns0cgXzrThAgwTPTassqVzG794ZbkF08a6";
const _flwTokenUrl =
    "https://idp.flutterwave.com/realms/flutterwave/protocol/openid-connect/token";
const _flwBaseUrl = "https://f4bexperience.flutterwave.com";

class _FlwTokenCache {
  static String? _accessToken;
  static int _expiryEpochMs = 0;

  static bool get isValid =>
      _accessToken != null &&
      DateTime.now().millisecondsSinceEpoch < _expiryEpochMs - 60000;

  static String? get token => _accessToken;

  static void store(String token, int expiresInSeconds) {
    _accessToken = token;
    _expiryEpochMs =
        DateTime.now().millisecondsSinceEpoch + (expiresInSeconds * 1000);
  }

  static void clear() {
    _accessToken = null;
    _expiryEpochMs = 0;
  }
}

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
  final String _reference =
      "femihub-${DateTime.now().microsecondsSinceEpoch}-${Random().nextInt(9999)}";
  final String _traceId =
      "trace-${DateTime.now().microsecondsSinceEpoch}-${Random().nextInt(9999)}";
  final String _idempotencyKey =
      "idem-${DateTime.now().microsecondsSinceEpoch}-${Random().nextInt(9999)}";

  final TextEditingController phone = TextEditingController(text: "+256");
  final oCcy = NumberFormat("#,##0", "en_US");
  final _formKey = GlobalKey<FormState>();
  bool _processing = false;

  double get _total =>
      CartController.instance.totalCartPrice.value +
      widget.delivery +
      widget.tax;

  @override
  void dispose() {
    phone.dispose();
    super.dispose();
  }

  Map<String, String> _authHeaders(String token) => {
    "Authorization": "Bearer $token",
    "Content-Type": "application/json",
    "X-Trace-Id": _traceId,
    "X-Idempotency-Key": _idempotencyKey,
  };

  String _detectNetwork(String msisdn) {
    String local = msisdn.replaceAll(RegExp(r'[^0-9]'), '');
    if (local.startsWith('256')) local = local.substring(3);
    if (local.startsWith('0')) local = local.substring(1);
    // local is now 9 digits e.g. "750322256"
    final prefix = local.length >= 2 ? "0${local.substring(0, 2)}" : "";
    const mtnPrefixes = ["077", "078", "039", "031", "076"];
    return mtnPrefixes.contains(prefix) ? "MTN" : "AIRTEL";
  }

  Future<String?> _getAccessToken() async {
    if (_FlwTokenCache.isValid) return _FlwTokenCache.token;

    try {
      final response = await http.post(
        Uri.parse(_flwTokenUrl),
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: {
          "client_id": _flwClientId,
          "client_secret": _flwClientSecret,
          "grant_type": "client_credentials",
        },
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final token = decoded["access_token"] as String?;
        final expiresIn = decoded["expires_in"] as int? ?? 300;
        if (token != null) {
          _FlwTokenCache.store(token, expiresIn);
          return token;
        }
      }
      debugPrint("[FLW V4] Token fetch failed: ${response.body}");
      return null;
    } catch (e) {
      debugPrint("[FLW V4] Token exception: $e");
      return null;
    }
  }

  Future<String?> _createCustomer(String token) async {
    final user = userController.userModel.value!;
    final nameParts = user.name.trim().split(" ");
    final firstName = nameParts.first;
    final lastName = nameParts.length > 1 ? nameParts.last : firstName;

    // Strip to clean 9-digit local number
    String localPhone = user.phone.replaceAll(RegExp(r'[^0-9]'), '');
    if (localPhone.startsWith('256')) localPhone = localPhone.substring(3);
    if (localPhone.startsWith('0')) localPhone = localPhone.substring(1);

    debugPrint("[FLW V4] Creating customer with phone number: $localPhone");

    try {
      final response = await http.post(
        Uri.parse("$_flwBaseUrl/customers"),
        headers: _authHeaders(token),
        body: jsonEncode({
          "email": user.email,
          "name": {"first": firstName, "last": lastName},
          "phone": {"country_code": "256", "number": localPhone},
        }),
      );

      debugPrint("[FLW V4] Create customer response: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decoded = jsonDecode(response.body);
        return decoded["data"]?["id"] as String?;
      }
      debugPrint("[FLW V4] Create customer failed: ${response.body}");
      return null;
    } catch (e) {
      debugPrint("[FLW V4] Create customer exception: $e");
      return null;
    }
  }

  Future<String?> _createPaymentMethod(String token, String msisdn) async {
    // Strip to clean 9-digit local number
    String localNumber = msisdn.replaceAll(RegExp(r'[^0-9]'), '');
    if (localNumber.startsWith('256')) localNumber = localNumber.substring(3);
    if (localNumber.startsWith('0')) localNumber = localNumber.substring(1);

    final network = _detectNetwork(localNumber);
    debugPrint(
      "[FLW V4] Creating payment method — number: $localNumber, network: $network",
    );

    try {
      final response = await http.post(
        Uri.parse("$_flwBaseUrl/payment-methods"),
        headers: _authHeaders(token),
        body: jsonEncode({
          "type": "mobile_money",
          "mobile_money": {
            "country_code": "256",
            "network": network,
            "phone_number": localNumber,
          },
        }),
      );

      debugPrint("[FLW V4] Create payment method response: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decoded = jsonDecode(response.body);
        return decoded["data"]?["id"] as String?;
      }
      debugPrint("[FLW V4] Create payment method failed: ${response.body}");
      return null;
    } catch (e) {
      debugPrint("[FLW V4] Create payment method exception: $e");
      return null;
    }
  }

  Future<String?> _initiateCharge(
    String token,
    String customerId,
    String paymentMethodId,
  ) async {
    debugPrint(
      "[FLW V4] Initiating charge — amount: ${_total.toInt()}, customer: $customerId, method: $paymentMethodId",
    );

    try {
      final response = await http.post(
        Uri.parse("$_flwBaseUrl/charges"),
        headers: _authHeaders(token),
        body: jsonEncode({
          "reference": _reference,
          "currency": "UGX",
          "customer_id": customerId,
          "payment_method_id": paymentMethodId,
          "amount": _total.toInt(),
        }),
      );

      debugPrint("[FLW V4] Initiate charge response: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decoded = jsonDecode(response.body);
        return decoded["data"]?["id"] as String?;
      }
      debugPrint("[FLW V4] Initiate charge failed: ${response.body}");
      return null;
    } catch (e) {
      debugPrint("[FLW V4] Initiate charge exception: $e");
      return null;
    }
  }

  Future<bool> _pollChargeStatus(String token, String chargeId) async {
    int attempts = 0;
    const maxAttempts = 60;

    debugPrint("[FLW V4] Polling charge $chargeId — max $maxAttempts attempts");

    while (attempts < maxAttempts) {
      await Future.delayed(const Duration(seconds: 2));
      attempts++;

      try {
        final response = await http.get(
          Uri.parse("$_flwBaseUrl/charges/$chargeId"),
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
            "X-Trace-Id": _traceId,
          },
        );

        if (response.statusCode == 200) {
          final decoded = jsonDecode(response.body);
          final status =
              decoded["data"]?["status"]?.toString().toLowerCase() ?? "";

          debugPrint("[FLW V4] Poll attempt $attempts — status: $status");

          if (status == "succeeded" || status == "successful") return true;
          if (status == "failed" || status == "error") return false;
        }

        if (response.statusCode == 401) {
          debugPrint("[FLW V4] Token expired during polling — clearing cache");
          _FlwTokenCache.clear();
          return false;
        }
      } catch (e) {
        debugPrint("[FLW V4] Poll attempt $attempts exception: $e");
      }
    }

    debugPrint("[FLW V4] Polling timed out after $maxAttempts attempts");
    return false;
  }

  Future<bool> _runPaymentFlow(String rawPhone) async {
    // Normalise to 9-digit local number for consistent processing
    String msisdn = rawPhone.replaceAll(RegExp(r'[^0-9]'), '');
    if (msisdn.startsWith('256')) msisdn = msisdn.substring(3);
    if (msisdn.startsWith('0')) msisdn = msisdn.substring(1);

    debugPrint("[FLW V4] Starting payment flow for: $msisdn");

    final token = await _getAccessToken();
    if (token == null) {
      debugPrint("[FLW V4] Could not obtain access token.");
      return false;
    }

    final customerId = await _createCustomer(token);
    if (customerId == null) {
      debugPrint("[FLW V4] Customer creation failed.");
      return false;
    }

    final paymentMethodId = await _createPaymentMethod(token, msisdn);
    if (paymentMethodId == null) {
      debugPrint("[FLW V4] Payment method creation failed.");
      return false;
    }

    final chargeId = await _initiateCharge(token, customerId, paymentMethodId);
    if (chargeId == null) {
      debugPrint("[FLW V4] Charge initiation failed.");
      return false;
    }

    return await _pollChargeStatus(token, chargeId);
  }

  Future<void> _saveOrder() async {
    final oCcyFmt = NumberFormat("#,##0", "en_US");
    final now = DateTime.now();
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

    final data = {
      "address": widget.city,
      "streetAddress": widget.street,
      "lat": widget.lat,
      "long": widget.long,
      "phone": userController.userModel.value!.phone,
      "name": userController.userModel.value!.name,
      "mop": "paid",
      "amount": "${_total.toInt().toStringAsFixed(1)}",
      "cart": userController.userModel.value!.cartItemsToJson(),
      "remaining": userController.userModel.value!.cart.length,
      "id": _reference,
      "ref": _reference,
      "status": "PENDING",
      "ordertime": DateTime.now().microsecondsSinceEpoch,
      "time": Timestamp.now(),
      "createdAt": '$currentTime',
      "userId": userController.userModel.value!.id,
      "filled": 'not',
      "ondelivery": 'not',
    };

    _sendCustomerEmail(
      userController.userModel.value!.name.capitalize ?? "",
      userController.userModel.value!.email,
      widget.city.capitalize ?? "",
      "UGX ${oCcyFmt.format(_total)}",
      _reference,
    );

    userController.sendEmail(
      "FemiHub Team",
      "patricksseremba787@gmail.com, joviakisaakye@gmail.com",
      '''Hello Team,

This is an order email placed by ${userController.userModel.value!.name.capitalize} and below are the order details.

Details:
Customer's Contact: ${userController.userModel.value!.phone},
Customer Name: ${userController.userModel.value!.name},
Amount Paid: UGX ${oCcyFmt.format(_total)},
Items: ${userController.userModel.value!.cartItemsToJson()},
Address: ${widget.city},
Street Address: ${widget.street},
User Location Coordinates: ${widget.lat}, ${widget.long},
      ''',
      "Order Placed By ${userController.userModel.value!.name.capitalize}",
    );

    await FirebaseFirestore.instance.collection("orders").add(data);
    await FirebaseFirestore.instance.collection("logs").add({
      'name': userController.userModel.value!.name.capitalize,
      'id': userController.userModel.value!.id,
      'message': 'Has placed an order',
      'time': Timestamp.now(),
    });
    await userController.updateUserData({"cart": []});
  }

  Future<void> _handlePay() async {
    if (!_formKey.currentState!.validate()) return;
    if (_processing) return;

    setState(() => _processing = true);
    _showLoadingSheet("Initiating transaction of UGX ${oCcy.format(_total)}");

    final rawPhone = phone.text.trim();
    final success = await _runPaymentFlow(rawPhone);

    if (!mounted) return;
    Get.back();

    if (success) {
      await _saveOrder();
      Fluttertoast.showToast(
        msg: "Order successfully placed",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: _sage.withOpacity(0.9),
        textColor: Colors.white,
        fontSize: 14.0,
      );
      Get.offAllNamed("/home");
    } else {
      setState(() => _processing = false);
      _showFailureSheet();
    }
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
        image: const DecorationImage(
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
                if (value == null || value.trim().isEmpty) {
                  return 'Phone number is required';
                }
                final digits = value.replaceAll(RegExp(r'[^0-9]'), '');
                if (digits.length < 10) {
                  return 'Enter a valid Ugandan mobile number';
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
        onTap: _processing ? null : _handlePay,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            gradient:
                _processing
                    ? null
                    : const LinearGradient(
                      colors: [_rose, _roseDark],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
            color: _processing ? Colors.grey.shade200 : null,
            borderRadius: BorderRadius.circular(14),
            boxShadow:
                _processing
                    ? []
                    : [
                      BoxShadow(
                        color: _rose.withOpacity(0.35),
                        blurRadius: 14,
                        offset: const Offset(0, 5),
                      ),
                    ],
          ),
          child:
              _processing
                  ? const Center(
                    child: SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: _rose,
                      ),
                    ),
                  )
                  : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        PhosphorIcons.creditCard,
                        color: Colors.white,
                        size: 18,
                      ),
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
    showModalBottomSheet<void>(
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

  void _showFailureSheet() {
    showModalBottomSheet<void>(
      backgroundColor: Colors.transparent,
      context: context,
      builder:
          (context) => Popover(
            child: SizedBox(
              height: 220,
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
                        "Transaction unsuccessful. Please check your number and try again.",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.plusJakartaSans(
                          color: _plum,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 28,
                            vertical: 11,
                          ),
                          decoration: BoxDecoration(
                            color: _roseSoft,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            "Try Again",
                            style: GoogleFonts.plusJakartaSans(
                              color: _rose,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
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

  void _sendCustomerEmail(
    String name,
    String email,
    String address,
    String amount,
    String orderNumber,
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
              "Thank you for shopping with FemiHub. We are pleased to confirm that we have received your order and it is currently being processed.\n\nOrder Details:\nOrder Number: $orderNumber\nOrder Date: ${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}\nShipping Address: $address\n\nTotal Amount: $amount\n\nEstimated Delivery Date: ${DateFormat.yMd().format(DateTime.now().add(const Duration(days: 3)))}\n\nShould you have any questions, please contact our support team.",
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
