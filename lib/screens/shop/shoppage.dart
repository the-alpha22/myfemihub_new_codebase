import 'package:bridge_ai/bottomnav.dart';
import 'package:bridge_ai/constants/app_constants.dart';
import 'package:bridge_ai/constants/controllers.dart';
import 'package:bridge_ai/screens/home/homescreen.dart';
import 'package:bridge_ai/screens/shop/pages/body_products.dart';
import 'package:bridge_ai/screens/shop/pages/for_baby.dart';
import 'package:bridge_ai/screens/shop/pages/hair_products.dart';
import 'package:bridge_ai/screens/shop/pages/pregnancy_wear.dart';
import 'package:bridge_ai/screens/shop/pages/tabs_suplemments.dart';
import 'package:bridge_ai/screens/shop/widgets/shopping_cart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bridge_ai/controllers/product_controller.dart';
import 'package:bridge_ai/models/product.dart';
import 'package:bridge_ai/screens/shop/widgets/single_product.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({Key? key}) : super(key: key);

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  @override
  void initState() {
    super.initState();
    shopAd();
  }

  List shopAds = [
    "Don't miss out on your fav essentials ${userController.userModel.value!.name.capitalize}",
    "Items crafted 🖍 for you, ${userController.userModel.value!.name.capitalize}",
    "Feel free to try out bridge_ai Shop 👀 ${userController.userModel.value!.name.capitalize}"
  ];
  Future<void> shopAd() async {
    if (userController.userModel.value!.stage == "Not Yet Pregnant") {
      shopAds.shuffle();
      shopAds.shuffle();
      shopAds.shuffle();
      notificationPrompt.scheduleInstantNotification(
          flutterLocalNotificationsPlugin,
          "bridge_ai",
          shopAds.first,
          "shop",
          "shopChannel",
          0,
          "/shop",
          200);
    }
    notificationPrompt.scheduleContinuousNotifications();
  }

  @override
  Widget build(BuildContext context) {
    String usercategory =
        userController.userModel.value!.stage == "Not Yet Pregnant"
            ? "${userController.userModel.value!.name.capitalize}"
            : userController.userModel.value!.stage == "Pregnant"
                ? "Upcoming mothers"
                : "Mothers";
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 245, 245, 245),
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text('Shop',
            style: GoogleFonts.expletusSans(
              color: Colors.black.withOpacity(0.8),
              fontSize: 14,
            )),
        actions: [
          IconButton(
              onPressed: () {
                Get.to(
                  () => ShoppingCartWidget(),
                );
              },
              icon: Icon(
                Icons.shopping_basket,
                color: Colors.black54,
              )),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 24,
                ),
                Text('Top Categories for $usercategory',
                    style: GoogleFonts.expletusSans(
                      color: Colors.black.withOpacity(0.8),
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    )),
                SizedBox(
                  height: 24,
                ),
                if (userController.userModel.value!.stage ==
                    "Not Yet Pregnant") ...{
                  NonPregnantWomen(),
                },
                if (userController.userModel.value!.stage == "Pregnant") ...{
                  PregnantWomen(),
                },
                if (userController.userModel.value!.stage == "A Mother") ...{
                  MotherProducts(),
                },
                SizedBox(
                  height: 24,
                ),
                Text('Most Purchased',
                    style: GoogleFonts.expletusSans(
                      color: Colors.black.withOpacity(0.8),
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    )),
                SizedBox(
                  height: 24,
                ),
                MostPurchased(),
                SizedBox(
                  height: 24,
                ),
                Text('Essentials',
                    style: GoogleFonts.expletusSans(
                      color: Colors.black.withOpacity(0.8),
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    )),
                SizedBox(
                  height: 24,
                ),
                Essential(),
                SizedBox(
                  height: 24,
                ),
                Text('Food Stuffs',
                    style: GoogleFonts.expletusSans(
                      color: Colors.black.withOpacity(0.8),
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    )),
                SizedBox(
                  height: 24,
                ),
                Food(),
                SizedBox(
                  height: 24,
                ),
                Text(
                    'Recommended For You ${userController.userModel.value!.name}',
                    style: GoogleFonts.expletusSans(
                      color: Colors.black.withOpacity(0.8),
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    )),
                SizedBox(
                  height: 24,
                ),
                RecommendedProducts(),
                SizedBox(
                  height: 24,
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNav(),
    );
  }
}

class NonPregnantWomen extends StatelessWidget {
  const NonPregnantWomen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            InkWell(
              onTap: () {
                Get.to(() => BodyProducts(),
                    transition: Transition.rightToLeft);
              },
              child: Container(
                height: 200,
                width: 160,
                decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(4),
                    image: DecorationImage(
                        image: AssetImage("images/body_women.png"),
                        fit: BoxFit.cover)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(),
                      Text("Body Products",
                          style: GoogleFonts.expletusSans(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            InkWell(
              onTap: () {
                Get.to(() => HairProducts(),
                    transition: Transition.rightToLeft);
              },
              child: Container(
                height: 200,
                width: 160,
                decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(4),
                    image: DecorationImage(
                        image: AssetImage("images/hair.png"),
                        fit: BoxFit.cover)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(),
                      Text("Hair Products",
                          style: GoogleFonts.expletusSans(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            InkWell(
              onTap: () {
                Get.to(() => TabsProducts(),
                    transition: Transition.rightToLeft);
              },
              child: Container(
                height: 200,
                width: 160,
                decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(4),
                    image: DecorationImage(
                        image: AssetImage("images/tablets.png"),
                        fit: BoxFit.cover)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(),
                      Text("Tabs & Supplements",
                          style: GoogleFonts.expletusSans(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
          ],
        ),
      ),
    );
  }
}

class PregnantWomen extends StatelessWidget {
  const PregnantWomen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            InkWell(
              onTap: () {
                Get.to(() => PregnancyWear(),
                    transition: Transition.rightToLeft);
              },
              child: Container(
                height: 200,
                width: 160,
                decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(4),
                    image: DecorationImage(
                        image: AssetImage("images/pregnacy_wear.png"),
                        fit: BoxFit.cover)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(),
                      Text("Pregnancy Wear",
                          style: GoogleFonts.expletusSans(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            InkWell(
              onTap: () {
                Get.to(() => BodyProducts(),
                    transition: Transition.rightToLeft);
              },
              child: Container(
                height: 200,
                width: 160,
                decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(4),
                    image: DecorationImage(
                        image: AssetImage("images/body_women.png"),
                        fit: BoxFit.cover)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(),
                      Text("Body Products",
                          style: GoogleFonts.expletusSans(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            InkWell(
              onTap: () {
                Get.to(() => HairProducts(),
                    transition: Transition.rightToLeft);
              },
              child: Container(
                height: 200,
                width: 160,
                decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(4),
                    image: DecorationImage(
                        image: AssetImage("images/hair.png"),
                        fit: BoxFit.cover)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(),
                      Text("Hair Products",
                          style: GoogleFonts.expletusSans(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            InkWell(
              onTap: () {
                Get.to(() => TabsProducts(),
                    transition: Transition.rightToLeft);
              },
              child: Container(
                height: 200,
                width: 160,
                decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(4),
                    image: DecorationImage(
                        image: AssetImage("images/tablets.png"),
                        fit: BoxFit.cover)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(),
                      Text("Tabs & Supplements",
                          style: GoogleFonts.expletusSans(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
          ],
        ),
      ),
    );
  }
}

class MotherProducts extends StatelessWidget {
  const MotherProducts({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            InkWell(
              onTap: () {
                Get.to(() => BabyProducts(),
                    transition: Transition.rightToLeft);
              },
              child: Container(
                height: 200,
                width: 160,
                decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(4),
                    image: DecorationImage(
                        image: AssetImage("images/for_baby.png"),
                        fit: BoxFit.cover)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(),
                      Text("For Your Baby",
                          style: GoogleFonts.expletusSans(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            InkWell(
              onTap: () {
                Get.to(() => BodyProducts(),
                    transition: Transition.rightToLeft);
              },
              child: Container(
                height: 200,
                width: 160,
                decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(4),
                    image: DecorationImage(
                        image: AssetImage("images/body_women.png"),
                        fit: BoxFit.cover)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(),
                      Text("Body Products",
                          style: GoogleFonts.expletusSans(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            InkWell(
              onTap: () {
                Get.to(() => HairProducts(),
                    transition: Transition.rightToLeft);
              },
              child: Container(
                height: 200,
                width: 160,
                decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(4),
                    image: DecorationImage(
                        image: AssetImage("images/hair.png"),
                        fit: BoxFit.cover)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(),
                      Text("Hair Products",
                          style: GoogleFonts.expletusSans(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            InkWell(
              onTap: () {
                Get.to(() => TabsProducts(),
                    transition: Transition.rightToLeft);
              },
              child: Container(
                height: 200,
                width: 160,
                decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(4),
                    image: DecorationImage(
                        image: AssetImage("images/tablets.png"),
                        fit: BoxFit.cover)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(),
                      Text("Tabs & Supplements",
                          style: GoogleFonts.expletusSans(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
          ],
        ),
      ),
    );
  }
}

class MostPurchased extends StatefulWidget {
  const MostPurchased({Key? key}) : super(key: key);

  @override
  State<MostPurchased> createState() => _MostPurchasedState();
}

class _MostPurchasedState extends State<MostPurchased> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: FutureBuilder<List<ProductModel>>(
          future: ProducsController.instance
              .getMostPurchasedProducts(userController.userModel.value!.stage),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: LoadingAnimationWidget.discreteCircle(
                  color: primaryColor,
                  size: 35,
                ),
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              List<ProductModel>? products = snapshot.data;
              if (products!.isEmpty) {
                return Center(
                    child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Lottie.asset('images/nothingfoundhere.json',
                            height: 120),
                      ),
                      Text(
                        "No Product found",
                        style: GoogleFonts.montserrat(
                            color: Colors.black.withOpacity(0.6),
                            fontWeight: FontWeight.w500,
                            fontSize: 15),
                      ),
                    ],
                  ),
                ));
              }
              return Row(
                children: products.map((ProductModel product) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SingleProductWidget2(
                        product: product,
                      ),
                      SizedBox(
                        width: 5,
                      )
                    ],
                  );
                }).toList(),
              );
            }
          },
        ),
      ),
    );
  }
}

class Food extends StatefulWidget {
  const Food({Key? key}) : super(key: key);

  State<Food> createState() => _FoodState();
}

class _FoodState extends State<Food> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: FutureBuilder<List<ProductModel>>(
          future: ProducsController.instance.getProductsByCategory(
              "food", userController.userModel.value!.stage),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: LoadingAnimationWidget.discreteCircle(
                  color: primaryColor,
                  size: 35,
                ),
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              List<ProductModel>? products = snapshot.data;
              if (products!.isEmpty) {
                return Center(
                    child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Lottie.asset('images/nothingfoundhere.json',
                            height: 120),
                      ),
                      Text(
                        "No Product found",
                        style: GoogleFonts.montserrat(
                            color: Colors.black.withOpacity(0.6),
                            fontWeight: FontWeight.w500,
                            fontSize: 15),
                      ),
                    ],
                  ),
                ));
              }
              return Row(
                children: products.map((ProductModel product) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SingleProductWidget2(
                        product: product,
                      ),
                      SizedBox(
                        width: 5,
                      )
                    ],
                  );
                }).toList(),
              );
            }
          },
        ),
      ),
    );
  }
}

class Essential extends StatefulWidget {
  const Essential({Key? key}) : super(key: key);

  State<Essential> createState() => _EssentialState();
}

class _EssentialState extends State<Essential> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: FutureBuilder<List<ProductModel>>(
          future: ProducsController.instance.getProductsByCategory(
              "essential", userController.userModel.value!.stage),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                height: 220,
                width: 500,
                child: const Center(
                    child: CircularProgressIndicator(
                  strokeWidth: 0,
                )),
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              List<ProductModel>? products = snapshot.data;
              if (products!.isEmpty) {
                return Center(
                    child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Lottie.asset('images/nothingfoundhere.json',
                            height: 120),
                      ),
                      Text(
                        "No Product found",
                        style: GoogleFonts.montserrat(
                            color: Colors.black.withOpacity(0.6),
                            fontWeight: FontWeight.w500,
                            fontSize: 15),
                      ),
                    ],
                  ),
                ));
              }
              return Row(
                children: products.map((ProductModel product) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SingleProductWidget2(
                        product: product,
                      ),
                      SizedBox(
                        width: 5,
                      )
                    ],
                  );
                }).toList(),
              );
            }
          },
        ),
      ),
    );
  }
}
