import 'package:bridge_ai/constants/app_constants.dart';
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

class ShopPageNew extends StatefulWidget {
  const ShopPageNew({super.key});

  @override
  State<ShopPageNew> createState() => _ShopPageNewState();
}

class _ShopPageNewState extends State<ShopPageNew> {
  final List<String> _categoryNames = [
    "Maternity",
    "Baby",
    "Essentials",
    "Contraceptions",
  ];

  String selection = "Maternity";
  List<ProductModel> babyProducts = [];
  List<ProductModel> maternityProducts = [];
  List<ProductModel> essentialProducts = [];
  List<ProductModel> contraceptionProducts = [];
  bool isLoading = true;
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    getProducts();
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
    List<ProductModel> base = switch (selection) {
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        toolbarHeight: 64,
        centerTitle: true,
        title: Text(
          'Shop',
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: Colors.black87,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton(
              onPressed:
                  () => Get.to(
                    () => ShoppingCartWidget(),
                    transition: Transition.rightToLeft,
                  ),
              icon: const Icon(
                Icons.shopping_bag_outlined,
                color: Colors.black87,
                size: 22,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Column(
                children: [
                  _buildSearchBar(),
                  const SizedBox(height: 16),
                  _buildCategoryTabs(),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(child: _buildContent()),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      onChanged: (val) => setState(() => _searchQuery = val),
      style: GoogleFonts.montserrat(fontSize: 14, color: Colors.black87),
      decoration: InputDecoration(
        hintText: "Search products",
        hintStyle: GoogleFonts.montserrat(
          color: Colors.black38,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        prefixIcon: const Icon(Icons.search, color: Colors.black38, size: 20),
        filled: true,
        fillColor: const Color(0xFFF5F5F5),
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryColor, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(_categoryNames.length, (i) {
          final name = _categoryNames[i];
          final isSelected = selection == name;
          return Padding(
            padding: EdgeInsets.only(
              right: i == _categoryNames.length - 1 ? 0 : 8,
            ),
            child: _TabChip(
              label: name,
              isSelected: isSelected,
              onTap: () => setState(() => selection = name),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildContent() {
    if (isLoading) {
      return Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Lottie.asset(
            'images/femihub_loading.json',
            repeat: true,
            frameRate: FrameRate(30),
            height: 160,
          ),
        ),
      );
    }

    final products = _currentProducts;

    if (products.isEmpty) {
      return Center(
        child: Text(
          _searchQuery.isNotEmpty
              ? 'No results for "$_searchQuery"'
              : 'No products available',
          style: GoogleFonts.montserrat(fontSize: 14, color: Colors.black38),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 16,
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
              begin: 0.1,
              end: 0,
              delay: (50 * index).ms,
              duration: 380.ms,
              curve: Curves.easeOut,
            );
      },
    );
  }
}

class _TabChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabChip({
    required this.label,
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
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor : const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w600,
            fontSize: 13,
            color: isSelected ? Colors.white : Colors.black54,
          ),
        ),
      ),
    );
  }
}
