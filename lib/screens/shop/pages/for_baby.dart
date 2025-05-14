import 'package:bridge_ai/constants/app_constants.dart';
import 'package:bridge_ai/constants/controllers.dart';
import 'package:bridge_ai/controllers/product_controller.dart';
import 'package:bridge_ai/models/product.dart';
import 'package:bridge_ai/screens/shop/widgets/single_product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class BabyProducts extends StatefulWidget {
  const BabyProducts({Key? key}) : super(key: key);

  @override
  State<BabyProducts> createState() => _BabyProductsState();
}

class _BabyProductsState extends State<BabyProducts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text("For Your Baby",
            style: GoogleFonts.openSans(
                color: Colors.white.withOpacity(0.9), fontSize: 14)),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        elevation: 0,
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
              Container(
                child: FutureBuilder<List<ProductModel>>(
                  future: ProducsController.instance.getProductsByCategory(
                      "baby products", userController.userModel.value!.stage),
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
                                child: Lottie.asset(
                                    'images/nothingfoundhere.json',
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
                      return GridView(
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 2,
                          crossAxisSpacing: 2,
                          childAspectRatio: 0.6,
                        ),
                        children: products.map((ProductModel product) {
                          return SingleProductWidget2(
                            product: product,
                          );
                        }).toList(),
                      );
                    }
                  },
                ),
              )
            ],
          ),
        ),
      )),
    );
  }
}
