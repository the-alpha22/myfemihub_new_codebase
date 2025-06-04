import 'package:bridge_ai/constants/app_constants.dart';
import 'package:bridge_ai/models/product.dart';
import 'package:bridge_ai/pages/shop/productdetail/body.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:share_plus/share_plus.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({Key? key}) : super(key: key);

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  var productId = Get.parameters['productId'];
  @override
  void initState() {
    super.initState();
    getProductDetails();
  }

  getProductDetails() async {
    final productSnapshot = await FirebaseFirestore.instance
        .collection('products')
        .where("id", isEqualTo: productId)
        .get();
    for (var doc in productSnapshot.docs) {
      setState(() {
        product = ProductModel.fromSnapshot(doc);
        loading = false;
      });
    }
  }

  ProductModel? product;
  bool loading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 248, 247, 251),
        appBar: buildAppBar(context),
        body: loading
            ? Center(
                child: LoadingAnimationWidget.discreteCircle(
                  color: primaryColor,
                  size: 35,
                ),
              )
            : Body(product: product!));
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: primaryColor,
      elevation: 0,
      title: Text(
        product != null ? product!.name : "",
        style: GoogleFonts.openSans(
            color: Colors.white.withOpacity(0.7), fontSize: 12),
      ),
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: Colors.white,
        ),
        onPressed: () {
          Get.offAllNamed("/shop");
        },
      ),
      actions: [
        IconButton(
          onPressed: () {
            Share.share('https://app.bridge_ai.com/shop/$productId',
                subject: 'Try out this product on bridge_ai');
          },
          icon: Icon(
            Icons.share,
            color: Colors.white,
            size: 18,
          ),
        )
      ],
    );
  }

  // Future<void> disableCapture() async {
  //   //disable screenshots and record screen in current screen
  //   await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  // }
}
