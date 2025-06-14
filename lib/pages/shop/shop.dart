import 'package:bridge_ai/constants/app_constants.dart';
import 'package:bridge_ai/constants/bottom_nav_bar.dart';
import 'package:bridge_ai/controllers/product_controller.dart';
import 'package:bridge_ai/models/product.dart';
import 'package:bridge_ai/pages/shop/widgets/shopping_cart.dart';
import 'package:bridge_ai/pages/shop/widgets/single_product.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:google_fonts/google_fonts.dart';

class ShopPageNew extends StatefulWidget {
  const ShopPageNew({super.key});

  @override
  State<ShopPageNew> createState() => _ShopPageNewState();
}

class _ShopPageNewState extends State<ShopPageNew> {
  @override
  void initState() {
    super.initState();
    getProducts();
  }

  getProducts() async {
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
  }

  String selection = Get.parameters["section"] ?? "Featured";
  List<ProductModel> babyProducts = [];
  List<ProductModel> maternityProducts = [];
  List<ProductModel> essentialProducts = [];
  List<ProductModel> contraceptionProducts = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Shop',
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              Get.to(
                () => ShoppingCartWidget(),
                transition: Transition.rightToLeft,
              );
            },
            icon: Icon(Icons.shopping_bag, color: Colors.black87, size: 18),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SearchBar(),
            SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        selection = "Featured";
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: selection == "Featured" ? primaryColor : bgcolor,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Featured',
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            color:
                                selection == "Featured"
                                    ? Colors.white
                                    : Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  InkWell(
                    onTap: () {
                      setState(() {
                        selection = "Maternity";
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color:
                            selection == "Maternity" ? primaryColor : bgcolor,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Maternity',
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            color:
                                selection == "Maternity"
                                    ? Colors.white
                                    : Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  InkWell(
                    onTap: () {
                      setState(() {
                        selection = "Baby";
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: selection == "Baby" ? primaryColor : bgcolor,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Baby',
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            color:
                                selection == "Baby"
                                    ? Colors.white
                                    : Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  InkWell(
                    onTap: () {
                      setState(() {
                        selection = "Essentials";
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color:
                            selection == "Essentials" ? primaryColor : bgcolor,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Essentials',
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            color:
                                selection == "Essentials"
                                    ? Colors.white
                                    : Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  InkWell(
                    onTap: () {
                      setState(() {
                        selection = "Contraceptions";
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color:
                            selection == "Contraceptions"
                                ? primaryColor
                                : bgcolor,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Contraceptions',
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            color:
                                selection == "Contraceptions"
                                    ? Colors.white
                                    : Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12),
            if (selection == "Featured") ...{
              Expanded(
                child: ListView.builder(
                  itemCount: categories.length,
                  itemBuilder:
                      (context, index) => CategoryCard(
                        category: categories[index],
                        onTap: () {
                          Get.offAllNamed("/shop/${categories[index].title}");
                        },
                      ),
                ),
              ),
            },
            if (selection == "Maternity") ...{
              Expanded(
                child: ListView.builder(
                  itemCount: maternityProducts.length,
                  itemBuilder:
                      (context, index) => SingleProductWidget2(
                        product: maternityProducts[index],
                      ),
                ),
              ),
            },
            if (selection == "Baby") ...{
              Expanded(
                child: ListView.builder(
                  itemCount: babyProducts.length,
                  itemBuilder:
                      (context, index) =>
                          SingleProductWidget2(product: babyProducts[index]),
                ),
              ),
            },
            if (selection == "Essentials") ...{
              Expanded(
                child: ListView.builder(
                  itemCount: essentialProducts.length,
                  itemBuilder:
                      (context, index) => SingleProductWidget2(
                        product: essentialProducts[index],
                      ),
                ),
              ),
            },
            if (selection == "Contraceptions") ...{
              Expanded(
                child: ListView.builder(
                  itemCount: contraceptionProducts.length,
                  itemBuilder:
                      (context, index) => SingleProductWidget2(
                        product: contraceptionProducts[index],
                      ),
                ),
              ),
            },
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}

class SearchBar extends StatelessWidget {
  const SearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: "Search",
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: const Color(0xFFF2F6F4),
        contentPadding: const EdgeInsets.symmetric(vertical: 0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class Category {
  final String title;
  final String subtitle;
  final String items;
  final String image;

  Category({
    required this.title,
    required this.subtitle,
    required this.items,
    required this.image,
  });
}

class CategoryCard extends StatelessWidget {
  final Category category;
  final Function() onTap;

  const CategoryCard({required this.category, super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(category.image),
            ),
            const SizedBox(height: 8),
            Text(
              category.title,
              style: GoogleFonts.montserrat(
                color: Colors.black87,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              category.subtitle,
              style: GoogleFonts.montserrat(
                color: primaryColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              category.items,
              style: GoogleFonts.montserrat(
                color: Colors.black87,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final List<Category> categories = [
  Category(
    title: "Maternity",
    subtitle: "Shop maternity clothes",
    items: "100+ items",
    image: "images/pregnant_lady.jfif",
  ),
  Category(
    title: "Baby",
    subtitle: "Shop baby clothes",
    items: "100+ items",
    image: "images/baby.png",
  ),
  Category(
    title: "Essentials",
    subtitle: "Shop essentials",
    items: "100+ items",
    image: "images/essentials.jfif",
  ),
  Category(
    title: "Contraceptions",
    subtitle: "Shop contraceptions",
    items: "100+ items",
    image: "images/Contraceptions.jfif",
  ),
];
