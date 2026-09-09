// ignore_for_file: deprecated_member_use

import 'package:bridge_ai/constants/app_constants.dart';
import 'package:bridge_ai/controllers/cart_controller.dart';
import 'package:bridge_ai/pages/shop/widgets/cart_item_widget.dart';
import 'package:bridge_ai/pages/shop/widgets/payment_method.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:bridge_ai/constants/controllers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

const _rose = Color(0xFFE8567A);
const _roseDark = Color(0xFFC03A5E);
const _roseSoft = Color(0xFFFFF0F4);
const _plum = Color(0xFF3D1A2E);
const _muted = Color(0xFF9E8892);
const _surface = Color(0xFFFDF7F9);

class ShoppingCartWidget extends StatefulWidget {
  @override
  State<ShoppingCartWidget> createState() => _ShoppingCartWidgetState();
}

class _ShoppingCartWidgetState extends State<ShoppingCartWidget> {
  String _city = '';
  String _street = '';
  final _cityController = TextEditingController();
  final _streetController = TextEditingController();
  final _oCcy = NumberFormat("#,##0", "en_US");

  final Map<String, double> _deliveryRates = {
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

  @override
  void dispose() {
    _cityController.dispose();
    _streetController.dispose();
    super.dispose();
  }

  int _roundTo100(double n) => (n ~/ 100) * 100;

  double get _deliveryFee {
    if (_city.isEmpty) return 0;
    return _deliveryRates[_city.toLowerCase()] ?? 0;
  }

  double get _tax => _deliveryFee * 0.15;

  void _showAddressSheet() {
    _cityController.clear();
    _streetController.clear();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder:
          (_) => StatefulBuilder(
            builder:
                (ctx, setSheet) => Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(ctx).viewInsets.bottom,
                  ),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: _roseSoft,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                PhosphorIcons.mapPin,
                                color: _rose,
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "Delivery Address",
                              style: GoogleFonts.philosopher(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: _plum,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "Supported: Kampala, Entebbe, Jinja, Fort Portal, Mbarara, Kabale, Masaka, Mbale, Soroti, Gulu",
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11.5,
                            color: _muted,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 20),
                        _sheetField(
                          controller: _cityController,
                          label: "City",
                          hint: "e.g. Kampala",
                          icon: PhosphorIcons.buildings,
                        ),
                        const SizedBox(height: 14),
                        _sheetField(
                          controller: _streetController,
                          label: "Street Address (optional)",
                          hint: "e.g. Kampala Road",
                          icon: PhosphorIcons.roadHorizon,
                        ),
                        const SizedBox(height: 24),
                        GestureDetector(
                          onTap: () {
                            final city =
                                _cityController.text.trim().toLowerCase();
                            if (city.isEmpty) {
                              Get.snackbar(
                                "City required",
                                "Please enter your city to continue",
                                backgroundColor: Colors.red.shade50,
                                colorText: Colors.red.shade500,
                                snackPosition: SnackPosition.BOTTOM,
                                margin: const EdgeInsets.all(16),
                                borderRadius: 12,
                              );
                              return;
                            }
                            if (!_deliveryRates.containsKey(city)) {
                              Get.snackbar(
                                "City not supported",
                                "We don't deliver to $city yet",
                                backgroundColor: Colors.red.shade50,
                                colorText: Colors.red.shade500,
                                snackPosition: SnackPosition.BOTTOM,
                                margin: const EdgeInsets.all(16),
                                borderRadius: 12,
                              );
                              return;
                            }
                            setState(() {
                              _city = city[0].toUpperCase() + city.substring(1);
                              _street = _streetController.text.trim();
                            });
                            Get.back();
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
                                  color: _rose.withOpacity(0.3),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Text(
                              "Confirm Address",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.plusJakartaSans(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
          ),
    );
  }

  Widget _sheetField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            color: _plum,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            color: Colors.black87,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.plusJakartaSans(
              color: _muted,
              fontSize: 13.5,
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Icon(icon, color: _muted, size: 18),
            ),
            prefixIconConstraints: const BoxConstraints(
              minWidth: 0,
              minHeight: 0,
            ),
            filled: true,
            fillColor: _surface,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: _rose.withOpacity(0.4), width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = userController.userModel.value!.cart;
    final isEmpty = cart.isEmpty;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(isEmpty),
      body: isEmpty ? _buildEmptyState() : _buildCartContent(cart),
      bottomNavigationBar: isEmpty ? null : _buildCheckoutBar(),
    );
  }

  AppBar _buildAppBar(bool isEmpty) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      toolbarHeight: 64,
      centerTitle: false,
      title: Text(
        "Cart",
        style: GoogleFonts.philosopher(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: _plum,
        ),
      ),
      leading: IconButton(
        onPressed: () => Get.offAllNamed("/shop"),
        icon: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(color: _roseSoft, shape: BoxShape.circle),
          child: Icon(Icons.arrow_back_ios_new_rounded, color: _rose, size: 16),
        ),
      ),
      actions: [
        if (!isEmpty)
          TextButton(
            onPressed: () => userController.updateUserData({"cart": []}),
            child: Text(
              "Clear",
              style: GoogleFonts.plusJakartaSans(
                color: Colors.red.shade400,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            'images/femihub_nothing_found.json',
            repeat: true,
            frameRate: FrameRate(30),
            height: 140,
          ),
          const SizedBox(height: 16),
          Text(
            "Your cart is empty",
            style: GoogleFonts.philosopher(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: _plum,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "Browse the shop and add items",
            style: GoogleFonts.plusJakartaSans(fontSize: 13, color: _muted),
          ),
          const SizedBox(height: 28),
          GestureDetector(
            onTap: () => Get.offAllNamed("/shop"),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [_rose, _roseDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: _rose.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                "Go Shopping",
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartContent(cart) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 140),
      children: [
        ...cart.asMap().entries.map((entry) {
          final i = entry.key;
          final item = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: CartItemWidget(
                  cartItem: item,
                  press: () => CartController.instance.removeCartItem(item),
                )
                .animate()
                .fadeIn(
                  delay: (50 * i).ms,
                  duration: 380.ms,
                  curve: Curves.easeOut,
                )
                .slideY(
                  begin: 0.05,
                  end: 0,
                  delay: (50 * i).ms,
                  duration: 380.ms,
                ),
          );
        }).toList(),
        const SizedBox(height: 8),
        _buildDeliveryCard().animate().fadeIn(
          delay: (50 * cart.length).ms,
          duration: 380.ms,
          curve: Curves.easeOut,
        ),
      ],
    );
  }

  Widget _buildDeliveryCard() {
    final hasAddress = _city.isNotEmpty;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Delivery",
                  style: GoogleFonts.philosopher(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: _plum,
                  ),
                ),
                GestureDetector(
                  onTap: _showAddressSheet,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _roseSoft,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      hasAddress ? "Change" : "Add address",
                      style: GoogleFonts.plusJakartaSans(
                        color: _rose,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (hasAddress) ...[
              Row(
                children: [
                  Icon(PhosphorIcons.mapPin, color: _rose, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _street.isNotEmpty ? "$_street, $_city" : _city,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Divider(height: 1, color: _surface),
              const SizedBox(height: 12),
              _summaryRow(
                "Delivery fee",
                "UGX ${_oCcy.format(_roundTo100(_deliveryFee))}",
              ),
              const SizedBox(height: 6),
              _summaryRow(
                "Tax (15%)",
                "UGX ${_oCcy.format(_roundTo100(_tax))}",
              ),
            ] else
              Row(
                children: [
                  Icon(PhosphorIcons.mapPin, color: _muted, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    "No address selected",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      color: _muted,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _summaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(fontSize: 13, color: _muted),
        ),
        Text(
          value,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            color: _plum,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildCheckoutBar() {
    return Container(
      color: Colors.white,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_city.isNotEmpty) ...[
                Obx(() {
                  final subtotal = CartController.instance.totalCartPrice.value;
                  final total =
                      subtotal + _roundTo100(_deliveryFee) + _roundTo100(_tax);
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total",
                        style: GoogleFonts.philosopher(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: _plum,
                        ),
                      ),
                      Text(
                        "UGX ${_oCcy.format(total)}",
                        style: GoogleFonts.philosopher(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: _rose,
                        ),
                      ),
                    ],
                  );
                }),
                const SizedBox(height: 12),
              ],
              GestureDetector(
                onTap: () {
                  if (_city.isEmpty) {
                    _showAddressSheet();
                    return;
                  }
                  Get.to(
                    () => PaymentMethod(
                      city: _city,
                      street: _street.isEmpty ? _city : _street,
                      delivery: _roundTo100(_deliveryFee).toDouble(),
                      tax: _roundTo100(_tax).toDouble(),
                      lat: 0.0,
                      long: 0.0,
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 17),
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
                      Icon(
                        PhosphorIcons.shoppingBag,
                        color: Colors.white,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _city.isEmpty
                            ? "Add Address to Checkout"
                            : "Proceed to Payment",
                        style: GoogleFonts.plusJakartaSans(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
