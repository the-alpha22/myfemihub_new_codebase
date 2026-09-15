// ignore_for_file: deprecated_member_use

import 'package:bridge_ai/constants/bottom_nav_bar.dart';
import 'package:bridge_ai/constants/controllers.dart';
import 'package:bridge_ai/controllers/product_controller.dart';
import 'package:bridge_ai/models/product.dart';
import 'package:bridge_ai/pages/shop/addproduct.dart';
import 'package:bridge_ai/pages/shop/widgets/shopping_cart.dart';
import 'package:bridge_ai/pages/shop/widgets/single_product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

const _rose = Color(0xFFE8567A);
const _roseSoft = Color(0xFFFFF0F4);
const _plum = Color(0xFF3D1A2E);
const _muted = Color(0xFF9E8892);
const _surface = Color(0xFFFDF7F9);

class ShopPageNew extends StatefulWidget {
  const ShopPageNew({super.key});

  @override
  State<ShopPageNew> createState() => _ShopPageNewState();
}

class _ShopPageNewState extends State<ShopPageNew> {
  final List<_CategoryData> _categories = const [
    _CategoryData(label: "Maternity", icon: PhosphorIcons.baby),
    _CategoryData(label: "Baby", icon: PhosphorIcons.heart),
    _CategoryData(label: "Essentials", icon: PhosphorIcons.sparkle),
    _CategoryData(label: "Skincare", icon: PhosphorIcons.flower),
    _CategoryData(label: "Nutrition", icon: PhosphorIcons.bowlFood),
    _CategoryData(label: "Postpartum", icon: PhosphorIcons.handHeart),
    _CategoryData(label: "Contraceptions", icon: PhosphorIcons.shieldCheck),
  ];

  String selection = "Maternity";
  final Map<String, List<ProductModel>> _productCache = {};
  bool isLoading = true;
  String _searchQuery = "";
  final TextEditingController _searchController = TextEditingController();

  String get _userSegment {
    final stage = userController.userModel.value?.stage ?? '';
    return CustomerSegment.fromStageLabel(stage);
  }

  @override
  void initState() {
    super.initState();
    getProducts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> getProducts() async {
    setState(() => isLoading = true);

    final categoryKeys = {
      "Maternity": "maternity",
      "Baby": "baby",
      "Essentials": "essential",
      "Skincare": "skincare",
      "Nutrition": "nutrition",
      "Postpartum": "postpartum",
      "Contraceptions": "contraceptions",
    };

    for (final entry in categoryKeys.entries) {
      _productCache[entry.key] = await ProducsController.instance
          .getProductsByCategory(entry.value);
    }

    setState(() => isLoading = false);
  }

  List<ProductModel> get _currentProducts {
    final base = _productCache[selection] ?? [];
    final segment = _userSegment;

    final segmentFiltered =
        base.where((p) => p.isVisibleToSegment(segment)).toList();

    if (_searchQuery.isEmpty) return segmentFiltered;
    return segmentFiltered
        .where((p) => p.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  int get _hiddenCount {
    final base = _productCache[selection] ?? [];
    final segment = _userSegment;
    return base.where((p) => !p.isVisibleToSegment(segment)).length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
              child: Column(
                children: [
                  _buildSearchBar().animate().fadeIn(
                    duration: 400.ms,
                    curve: Curves.easeOut,
                  ),
                  const SizedBox(height: 14),
                  _buildCategoryTabs().animate().fadeIn(
                    delay: 80.ms,
                    duration: 400.ms,
                    curve: Curves.easeOut,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            if (!isLoading && _hiddenCount > 0)
              _buildSegmentBanner().animate().fadeIn(
                delay: 120.ms,
                duration: 350.ms,
              ),
            const SizedBox(height: 4),
            Expanded(child: _buildContent()),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      toolbarHeight: 64,
      centerTitle: false,
      title: GestureDetector(
        onDoubleTap: () => _showPasswordDialog(),
        child: Text(
          'Shop',
          style: GoogleFonts.philosopher(
            fontWeight: FontWeight.w700,
            fontSize: 22,
            color: _plum,
          ),
        ),
      ),
      actions: [
        GestureDetector(
          onTap:
              () => Get.to(
                () => ShoppingCartWidget(),
                transition: Transition.rightToLeft,
              ),
          child: Container(
            width: 38,
            height: 38,
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(color: _roseSoft, shape: BoxShape.circle),
            child: Icon(PhosphorIcons.shoppingBag, color: _rose, size: 18),
          ),
        ),
      ],
    );
  }

  void _showPasswordDialog() {
    final TextEditingController _passController = TextEditingController();
    bool _obscure = true;
    String? _error;

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Text(
                'Admin Access',
                style: GoogleFonts.philosopher(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: _plum,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Enter the admin password to continue.',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      color: _muted,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _passController,
                    obscureText: _obscure,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13.5,
                      color: Colors.black87,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Password',
                      hintStyle: GoogleFonts.plusJakartaSans(
                        color: _muted,
                        fontSize: 13.5,
                      ),
                      errorText: _error,
                      suffixIcon: GestureDetector(
                        onTap: () => setDialogState(() => _obscure = !_obscure),
                        child: Icon(
                          _obscure ? PhosphorIcons.eye : PhosphorIcons.eyeSlash,
                          color: _muted,
                          size: 18,
                        ),
                      ),
                      filled: true,
                      fillColor: _roseSoft,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 14,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: _rose.withOpacity(0.4),
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.plusJakartaSans(
                      color: _muted,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_passController.text == 'baker44') {
                      Navigator.of(ctx).pop();
                      Get.to(
                        () => AddProduct(),
                        transition: Transition.rightToLeft,
                      );
                    } else {
                      setDialogState(() => _error = 'Incorrect password');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _rose,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Continue',
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildSegmentBanner() {
    final stageName = userController.userModel.value?.stage ?? 'Everyone';
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: _roseSoft,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _rose.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Icon(PhosphorIcons.sparkle, color: _rose, size: 15),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Showing products curated for ${stageName.toLowerCase() == "pregnant" ? "Pregnant Women" : stageName}',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  color: _rose,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      onChanged: (val) => setState(() => _searchQuery = val),
      style: GoogleFonts.plusJakartaSans(fontSize: 13.5, color: Colors.black87),
      decoration: InputDecoration(
        hintText: "Search products...",
        hintStyle: GoogleFonts.plusJakartaSans(color: _muted, fontSize: 13.5),
        prefixIcon: Icon(
          PhosphorIcons.magnifyingGlass,
          color: _muted,
          size: 18,
        ),
        suffixIcon:
            _searchQuery.isNotEmpty
                ? GestureDetector(
                  onTap: () {
                    _searchController.clear();
                    setState(() => _searchQuery = "");
                  },
                  child: Icon(Icons.close_rounded, color: _muted, size: 18),
                )
                : null,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: _rose.withOpacity(0.4), width: 1.5),
        ),
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children:
            _categories.asMap().entries.map((entry) {
              final i = entry.key;
              final cat = entry.value;
              final isSelected = selection == cat.label;
              return Padding(
                padding: EdgeInsets.only(
                  right: i == _categories.length - 1 ? 0 : 10,
                ),
                child: _CategoryChip(
                  data: cat,
                  isSelected: isSelected,
                  onTap: () => setState(() => selection = cat.label),
                ),
              );
            }).toList(),
      ),
    );
  }

  Widget _buildContent() {
    if (isLoading) {
      return Center(
        child: Lottie.asset(
          'images/femihub_loading.json',
          repeat: true,
          frameRate: FrameRate(30),
          height: 160,
        ),
      );
    }

    final products = _currentProducts;

    if (products.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'images/femihub_nothing_found.json',
              repeat: true,
              frameRate: FrameRate(30),
              height: 130,
            ),
            const SizedBox(height: 14),
            Text(
              _searchQuery.isNotEmpty
                  ? 'No results for "$_searchQuery"'
                  : 'No products here yet',
              style: GoogleFonts.philosopher(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: _plum,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _searchQuery.isNotEmpty
                  ? 'Try a different search term'
                  : 'Check back soon',
              style: GoogleFonts.plusJakartaSans(fontSize: 13, color: _muted),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 14,
        childAspectRatio: 0.65,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        return SingleProductWidget2(product: products[index])
            .animate()
            .fadeIn(
              delay: (50 * index).ms,
              duration: 380.ms,
              curve: Curves.easeOut,
            )
            .slideY(
              begin: 0.08,
              end: 0,
              delay: (50 * index).ms,
              duration: 380.ms,
              curve: Curves.easeOut,
            );
      },
    );
  }
}

class _CategoryData {
  final String label;
  final IconData icon;
  const _CategoryData({required this.label, required this.icon});
}

class _CategoryChip extends StatelessWidget {
  final _CategoryData data;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.data,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: isSelected ? _rose : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow:
              isSelected
                  ? [
                    BoxShadow(
                      color: _rose.withOpacity(0.25),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ]
                  : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              data.icon,
              size: 14,
              color: isSelected ? Colors.white : _muted,
            ),
            const SizedBox(width: 6),
            Text(
              data.label,
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: isSelected ? Colors.white : _muted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
