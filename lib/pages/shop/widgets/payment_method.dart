// ignore_for_file: deprecated_member_use

import 'package:bridge_ai/constants/controllers.dart';
import 'package:bridge_ai/controllers/cart_controller.dart';
import 'package:bridge_ai/pages/shop/widgets/paymentpage.dart';
import 'package:cached_network_image/cached_network_image.dart';
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

class PaymentMethod extends StatefulWidget {
  const PaymentMethod({
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
  final oCcy = NumberFormat("#,##0", "en_US");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDeliveryCard()
                .animate()
                .fadeIn(duration: 450.ms, curve: Curves.easeOut)
                .slideY(begin: 0.07, end: 0, duration: 450.ms),
            const SizedBox(height: 16),
            _buildItemsCard()
                .animate()
                .fadeIn(delay: 80.ms, duration: 450.ms, curve: Curves.easeOut)
                .slideY(begin: 0.07, end: 0, delay: 80.ms, duration: 450.ms),
            const SizedBox(height: 16),
            _buildSummaryCard()
                .animate()
                .fadeIn(delay: 160.ms, duration: 450.ms, curve: Curves.easeOut)
                .slideY(begin: 0.07, end: 0, delay: 160.ms, duration: 450.ms),
            const SizedBox(height: 24),
            _buildProceedButton()
                .animate()
                .fadeIn(delay: 240.ms, duration: 450.ms, curve: Curves.easeOut)
                .slideY(begin: 0.07, end: 0, delay: 240.ms, duration: 450.ms),
            const SizedBox(height: 16),
            _buildPaymentNote().animate().fadeIn(
              delay: 300.ms,
              duration: 450.ms,
              curve: Curves.easeOut,
            ),
          ],
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
        "Checkout",
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

  Widget _buildDeliveryCard() {
    final phone = userController.userModel.value?.phone ?? "";
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
                  child: Icon(PhosphorIcons.mapPin, color: _rose, size: 18),
                ),
                const SizedBox(width: 10),
                Text(
                  "Delivery Details",
                  style: GoogleFonts.philosopher(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: _plum,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            _deliveryRow(
              PhosphorIcons.mapPinLine,
              "Delivering to",
              "${widget.city}, ${widget.street}",
              _sage,
            ),
            const SizedBox(height: 10),
            _deliveryRow(
              PhosphorIcons.info,
              "Note",
              "This is your approximate location",
              _muted,
            ),
            const SizedBox(height: 10),
            _deliveryRow(PhosphorIcons.phone, "Contact", phone, _rose),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Text(
                "Please confirm this is correct before placing your order.",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  color: _muted,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _deliveryRow(IconData icon, String label, String value, Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "$label: ",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: _muted,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextSpan(
                  text: value,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12.5,
                    color: _plum,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildItemsCard() {
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
                    PhosphorIcons.shoppingBag,
                    color: _rose,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  "Order Items",
                  style: GoogleFonts.philosopher(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: _plum,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Obx(
              () => Column(
                children:
                    userController.userModel.value!.cart.asMap().entries.map((
                      entry,
                    ) {
                      final i = entry.key;
                      final cartItem = entry.value;
                      return Column(
                        children: [
                          if (i > 0)
                            Divider(height: 16, color: Colors.grey.shade100),
                          _CartItemRow(item: cartItem, oCcy: oCcy),
                        ],
                      );
                    }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Obx(() {
      final subtotal = CartController.instance.totalCartPrice.value;
      final total = subtotal + widget.delivery + widget.tax;

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
                    child: Icon(PhosphorIcons.receipt, color: _rose, size: 18),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "Order Summary",
                    style: GoogleFonts.philosopher(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: _plum,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _summaryRow(
                "Sub Total",
                "shs. ${oCcy.format(subtotal)}",
                isBold: false,
              ),
              const SizedBox(height: 8),
              _summaryRow(
                "Delivery Fee",
                "shs. ${oCcy.format(widget.delivery)}",
                isBold: false,
              ),
              const SizedBox(height: 8),
              _summaryRow(
                "Additional Fees",
                "shs. ${oCcy.format(widget.tax)}",
                isBold: false,
              ),
              const SizedBox(height: 14),
              Container(height: 1, color: Colors.grey.shade100),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Final Total",
                    style: GoogleFonts.philosopher(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: _plum,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _roseSoft,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "shs. ${oCcy.format(total)}",
                      style: GoogleFonts.philosopher(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: _rose,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _summaryRow(String label, String value, {required bool isBold}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            color: _muted,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13.5,
            color: _plum,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildProceedButton() {
    return GestureDetector(
      onTap: () {
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
            Icon(PhosphorIcons.lock, color: Colors.white, size: 16),
            const SizedBox(width: 8),
            Text(
              "Proceed to Payment",
              style: GoogleFonts.plusJakartaSans(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentNote() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(PhosphorIcons.info, color: _muted, size: 15),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              "Only mobile money is accepted (Airtel or MTN)",
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                color: _muted,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CartItemRow extends StatelessWidget {
  final dynamic item;
  final NumberFormat oCcy;

  const _CartItemRow({required this.item, required this.oCcy});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: CachedNetworkImage(
            width: 72,
            height: 72,
            fit: BoxFit.cover,
            imageUrl: item.image,
            placeholder:
                (context, url) => Container(
                  width: 72,
                  height: 72,
                  color: _roseSoft,
                  child: const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 1.5,
                      color: _rose,
                    ),
                  ),
                ),
            errorWidget:
                (context, url, error) => Container(
                  width: 72,
                  height: 72,
                  color: _roseSoft,
                  child: Icon(
                    Icons.image_not_supported_outlined,
                    color: _muted,
                    size: 24,
                  ),
                ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${item.name}".capitalize ?? item.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: _plum,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "shs. ${oCcy.format(item.cost)}",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: _muted,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: _roseSoft,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            "×${item.quantity}",
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: _rose,
            ),
          ),
        ),
      ],
    );
  }
}
