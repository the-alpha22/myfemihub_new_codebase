// ignore_for_file: deprecated_member_use

import 'package:bridge_ai/constants/app_constants.dart';
import 'package:bridge_ai/constants/controllers.dart';
import 'package:bridge_ai/controllers/cart_controller.dart';
import 'package:bridge_ai/models/product.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:share_plus/share_plus.dart';

const _rose = Color(0xFFE8567A);
const _roseDark = Color(0xFFC03A5E);
const _roseSoft = Color(0xFFFFF0F4);
const _plum = Color(0xFF3D1A2E);
const _muted = Color(0xFF9E8892);
const _surface = Color(0xFFFDF7F9);

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({Key? key}) : super(key: key);

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final String productId = Get.parameters['productId'] ?? "";
  ProductModel? product;
  bool loading = true;
  String selectedImage = "";
  bool _hasSize = false;

  final _oCcy = NumberFormat("#,##0", "en_US");

  @override
  void initState() {
    super.initState();
    _loadProduct();
  }

  Future<void> _loadProduct() async {
    final snap =
        await FirebaseFirestore.instance
            .collection('products')
            .where("id", isEqualTo: productId)
            .get();
    for (var doc in snap.docs) {
      product = ProductModel.fromSnapshot(doc);
      selectedImage = product!.imageUrls.first;
      _hasSize = product!.sizes.isNotEmpty;
    }
    if (mounted) setState(() => loading = false);
  }

  Future<void> _incrementPurchases() async {
    final snap =
        await FirebaseFirestore.instance
            .collection('products')
            .where('id', isEqualTo: product!.id)
            .get();
    final purchases = product!.purchases;
    for (var doc in snap.docs) {
      await doc.reference.update({"purchases": purchases + 1});
    }
    await addActivityLog(
      "added an item to cart",
      userController.userModel.value!.id,
      "user activity",
      "",
      "",
    );
  }

  void _showAddToCart() {
    if (_hasSize) {
      _showSizeSheet();
    } else {
      _showQuantitySheet("N/A");
    }
  }

  void _showSizeSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder:
          (_) => _StyledSheet(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                  child: Text(
                    "Select Size",
                    style: GoogleFonts.philosopher(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: _plum,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
                  child: Text(
                    "Choose your preferred size",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12.5,
                      color: _muted,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children:
                        product!.sizes.map((size) {
                          return GestureDetector(
                            onTap: () {
                              Get.back();
                              _showQuantitySheet("$size");
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: _plum,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                "$size",
                                style: GoogleFonts.plusJakartaSans(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                ),
                const SizedBox(height: 28),
              ],
            ),
          ),
    );
  }

  void _showQuantitySheet(String size) {
    int qty = 1;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder:
          (_) => StatefulBuilder(
            builder:
                (ctx, setSheetState) => _StyledSheet(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
                        child: Text(
                          "Select Quantity",
                          style: GoogleFonts.philosopher(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: _plum,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                        child: Text(
                          size == "N/A"
                              ? "How many would you like?"
                              : "Size: $size",
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12.5,
                            color: _muted,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _qtyBtn(
                              icon: Icons.remove_rounded,
                              onTap:
                                  qty > 1
                                      ? () => setSheetState(() => qty--)
                                      : null,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 28,
                              ),
                              child: Text(
                                "$qty",
                                style: GoogleFonts.philosopher(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w700,
                                  color: _plum,
                                ),
                              ),
                            ),
                            _qtyBtn(
                              icon: Icons.add_rounded,
                              onTap: () => setSheetState(() => qty++),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: GestureDetector(
                          onTap: () async {
                            Get.back();
                            await CartController.instance.addProductToCart(
                              product!,
                              size,
                              qty,
                            );
                            await _incrementPurchases();
                            Get.snackbar(
                              "Added to Cart",
                              "${product!.name} has been added to your cart",
                              backgroundColor: _roseSoft,
                              colorText: _rose,
                              snackPosition: SnackPosition.BOTTOM,
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
                                  color: _rose.withOpacity(0.3),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
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
                                  "Add to Cart",
                                  style: GoogleFonts.plusJakartaSans(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),
                    ],
                  ),
                ),
          ),
    );
  }

  Widget _qtyBtn({required IconData icon, VoidCallback? onTap}) {
    final active = onTap != null;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: active ? _roseSoft : Colors.grey.shade100,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 20,
          color: active ? _rose : Colors.grey.shade400,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _surface,
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(),
      body:
          loading
              ? Center(
                child: LoadingAnimationWidget.discreteCircle(
                  color: _rose,
                  size: 32,
                ),
              )
              : _buildBody(),
      bottomNavigationBar: loading ? null : _buildBottomBar(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      toolbarHeight: 64,
      leading: IconButton(
        onPressed: () => Get.offAllNamed("/shop"),
        icon: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(Icons.arrow_back_ios_new_rounded, color: _plum, size: 16),
        ),
      ),
      actions: [
        Container(
          width: 38,
          height: 38,
          margin: const EdgeInsets.only(right: 16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            onPressed:
                () => Share.share(
                  'https://app.femihub.com/shop/$productId',
                  subject: 'Check out this product on FemiHub',
                ),
            icon: Icon(PhosphorIcons.shareFat, color: _plum, size: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildImageSection().animate().fadeIn(
            duration: 500.ms,
            curve: Curves.easeOut,
          ),
          _buildDetailSheet()
              .animate()
              .fadeIn(delay: 100.ms, duration: 450.ms, curve: Curves.easeOut)
              .slideY(begin: 0.05, end: 0, delay: 100.ms, duration: 450.ms),
        ],
      ),
    );
  }

  Widget _buildImageSection() {
    return Stack(
      children: [
        Hero(
          tag: 'product_${product!.id}',
          child: CachedNetworkImage(
            imageUrl: selectedImage,
            height: MediaQuery.of(context).size.height * 0.45,
            width: double.infinity,
            fit: BoxFit.cover,
            placeholder:
                (_, __) => Container(
                  height: MediaQuery.of(context).size.height * 0.45,
                  color: _roseSoft,
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 1.5,
                      color: _rose,
                    ),
                  ),
                ),
            errorWidget:
                (_, __, ___) => Container(
                  height: MediaQuery.of(context).size.height * 0.45,
                  color: _roseSoft,
                  child: Icon(PhosphorIcons.image, color: _muted, size: 40),
                ),
          ),
        ),
        if (product!.imageUrls.length > 1)
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.45),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children:
                      product!.imageUrls.map((img) {
                        final active = selectedImage == img;
                        return GestureDetector(
                          onTap: () => setState(() => selectedImage = img),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            width: active ? 20 : 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color:
                                  active
                                      ? Colors.white
                                      : Colors.white.withOpacity(0.45),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        );
                      }).toList(),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildDetailSheet() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    product!.name,
                    style: GoogleFonts.philosopher(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: _plum,
                      height: 1.2,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: _roseSoft,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "UGX ${_oCcy.format(product!.price)}",
                    style: GoogleFonts.philosopher(
                      color: _rose,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Divider(color: _surface, thickness: 1.5),
            const SizedBox(height: 14),
            Text(
              "Description",
              style: GoogleFonts.philosopher(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: _plum,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              product!.description,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13.5,
                color: Colors.black54,
                height: 1.7,
              ),
            ),
            if (_hasSize) ...[
              const SizedBox(height: 20),
              Text(
                "Available Sizes",
                style: GoogleFonts.philosopher(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: _plum,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children:
                    product!.sizes.map((size) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: _surface,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: _rose.withOpacity(0.2)),
                        ),
                        child: Text(
                          "$size",
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: _plum,
                          ),
                        ),
                      );
                    }).toList(),
              ),
            ],
            if (product!.imageUrls.length > 1) ...[
              const SizedBox(height: 20),
              Text(
                "More Images",
                style: GoogleFonts.philosopher(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: _plum,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 72,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: product!.imageUrls.length,
                  itemBuilder: (_, i) {
                    final img = product!.imageUrls[i];
                    final active = selectedImage == img;
                    return GestureDetector(
                      onTap: () => setState(() => selectedImage = img),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(right: 10),
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: active ? _rose : Colors.transparent,
                            width: 2,
                          ),
                          boxShadow:
                              active
                                  ? [
                                    BoxShadow(
                                      color: _rose.withOpacity(0.25),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                  : [],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: CachedNetworkImage(
                            imageUrl: img,
                            fit: BoxFit.cover,
                            placeholder: (_, __) => Container(color: _roseSoft),
                            errorWidget:
                                (_, __, ___) => Icon(
                                  PhosphorIcons.image,
                                  color: _muted,
                                  size: 20,
                                ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      color: Colors.white,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 12),
          child: GestureDetector(
            onTap: _showAddToCart,
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
                    "Add to Cart",
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
        ),
      ),
    );
  }
}

class _StyledSheet extends StatelessWidget {
  final Widget child;
  const _StyledSheet({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: child,
    );
  }
}
