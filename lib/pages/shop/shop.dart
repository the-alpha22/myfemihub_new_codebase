import 'package:bridge_ai/constants/bottom_nav_bar.dart';
import 'package:bridge_ai/controllers/product_controller.dart';
import 'package:bridge_ai/models/product.dart';
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
    _CategoryData(label: "Contraceptions", icon: PhosphorIcons.shieldCheck),
  ];

  String selection = "Maternity";
  List<ProductModel> babyProducts = [];
  List<ProductModel> maternityProducts = [];
  List<ProductModel> essentialProducts = [];
  List<ProductModel> contraceptionProducts = [];
  bool isLoading = true;
  String _searchQuery = "";
  final TextEditingController _searchController = TextEditingController();

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
    babyProducts = await ProducsController.instance.getProductsByCategory(
      "baby",
    );
    maternityProducts = await ProducsController.instance.getProductsByCategory(
      "maternity",
    );
    essentialProducts = await ProducsController.instance.getProductsByCategory(
      "essential",
    );
    contraceptionProducts = await ProducsController.instance
        .getProductsByCategory("contraceptions");
    setState(() => isLoading = false);
  }

  List<ProductModel> get _currentProducts {
    final base = switch (selection) {
      "Maternity" => maternityProducts,
      "Baby" => babyProducts,
      "Essentials" => essentialProducts,
      "Contraceptions" => contraceptionProducts,
      _ => maternityProducts,
    };
    if (_searchQuery.isEmpty) return base;
    return base
        .where((p) => p.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _surface,
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
            const SizedBox(height: 16),
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
      backgroundColor: _surface,
      toolbarHeight: 64,
      centerTitle: false,
      title: Text(
        'Shop',
        style: GoogleFonts.philosopher(
          fontWeight: FontWeight.w700,
          fontSize: 22,
          color: _plum,
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
                  : 'No products available',
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
