import 'package:bridge_ai/constants/controllers.dart';
import 'package:bridge_ai/widgets/helpers/showLoading.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bridge_ai/models/product.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class SingleProductWidget extends StatefulWidget {
  final ProductModel product;
  const SingleProductWidget({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  State<SingleProductWidget> createState() => _SingleProductWidgetState();
}

class _SingleProductWidgetState extends State<SingleProductWidget> {
  void initState() {
    super.initState();
    checkRating();
  }

  checkRating() async {
    if (widget.product.rating == null) {
      var collection = FirebaseFirestore.instance.collection('products');
      var snapshot =
          await collection.where('id', isEqualTo: widget.product.id).get();
      Map<String, dynamic> data = {
        "rating": 4.9,
      };
      for (var doc in snapshot.docs) {
        await doc.reference.update(data);
      }
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    var oCcy = NumberFormat("#,##0", "en_US");
    return GestureDetector(
      onTap: () {
        Get.toNamed("/shop/${widget.product.id}");
      },
      onLongPress: () async {
        if (userController.userModel.value!.admin) {
          showLoading(context);
          var productDetail = await FirebaseFirestore.instance
              .collection("products")
              .where("id", isEqualTo: widget.product.id)
              .get();
          for (var doc in productDetail.docs) {
            doc.reference.delete();
          }
          setState(() {});
        }
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Container(
          color: Color.fromARGB(255, 248, 248, 248),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: CachedNetworkImage(
                    height: MediaQuery.of(context).size.height * 0.2,
                    width: MediaQuery.of(context).size.height * 0.2,
                    fit: BoxFit.fill,
                    imageUrl: widget.product.image,
                    placeholder: (context, url) => Center(
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.2,
                        width: MediaQuery.of(context).size.height * 0.2,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Colors.black,
                            strokeWidth: 0,
                          ),
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Icon(
                      Icons.error,
                      color: Colors.black38,
                    ),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Container(
                  width: MediaQuery.of(context).size.height * 0.2,
                  child: Text(
                    widget.product.name,
                    maxLines: 1,
                    style: GoogleFonts.montserrat(
                        color: Colors.black87.withOpacity(0.9),
                        fontWeight: FontWeight.w600,
                        fontSize: 13),
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                Container(
                  width: MediaQuery.of(context).size.height * 0.2,
                  child: Text(
                    widget.product.description,
                    maxLines: 2,
                    style: GoogleFonts.montserrat(
                      color: Colors.black87.withOpacity(0.4),
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.height * 0.2,
                      child: Text(
                        "UGX${oCcy.format(widget.product.price)}",
                        style: GoogleFonts.montserrat(
                            color: Colors.black87.withOpacity(0.9),
                            fontWeight: FontWeight.w600,
                            fontSize: 12),
                      ),
                    ),
                    Container()
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.height * 0.18,
                        child: Center(
                          child: TextButton(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("More details",
                                    style: GoogleFonts.montserrat(
                                        color: Colors.black.withOpacity(0.9),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(4)),
                                        side: BorderSide(
                                            color: Colors.black
                                                .withOpacity(0.9))))),
                            onPressed: () {
                              Get.toNamed("/shop/${widget.product.id}");
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SingleProductWidget2 extends StatefulWidget {
  final ProductModel product;
  const SingleProductWidget2({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  State<SingleProductWidget2> createState() => _SingleProductWidget2State();
}

class _SingleProductWidget2State extends State<SingleProductWidget2> {
  void initState() {
    super.initState();
    checkRating();
  }

  checkRating() async {
    if (widget.product.rating == null) {
      var collection = FirebaseFirestore.instance.collection('products');
      var snapshot =
          await collection.where('id', isEqualTo: widget.product.id).get();
      Map<String, dynamic> data = {
        "rating": 4.9,
      };
      for (var doc in snapshot.docs) {
        await doc.reference.update(data);
      }
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    var oCcy = NumberFormat("#,##0", "en_US");
    return GestureDetector(
      onTap: () {
        Get.toNamed("/shop/${widget.product.id}");
      },
      onLongPress: () async {
        if (userController.userModel.value!.admin) {
          showLoading(context);
          var productDetail = await FirebaseFirestore.instance
              .collection("products")
              .where("id", isEqualTo: widget.product.id)
              .get();
          for (var doc in productDetail.docs) {
            doc.reference.delete();
          }
          setState(() {});
        }
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Container(
          color: Color.fromARGB(255, 248, 248, 248),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: CachedNetworkImage(
                    height: MediaQuery.of(context).size.height * 0.25,
                    width: MediaQuery.of(context).size.height * 0.25,
                    fit: BoxFit.fill,
                    imageUrl: widget.product.image,
                    placeholder: (context, url) => Center(
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.25,
                        width: MediaQuery.of(context).size.height * 0.25,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Colors.black,
                            strokeWidth: 0,
                          ),
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Icon(
                      Icons.error,
                      color: Colors.black38,
                    ),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Container(
                  width: MediaQuery.of(context).size.height * 0.25,
                  child: Text(
                    widget.product.name,
                    maxLines: 1,
                    style: GoogleFonts.montserrat(
                        color: Colors.black87.withOpacity(0.9),
                        fontWeight: FontWeight.w600,
                        fontSize: 13),
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                Container(
                  width: MediaQuery.of(context).size.height * 0.25,
                  child: Text(
                    widget.product.description,
                    maxLines: 2,
                    style: GoogleFonts.montserrat(
                      color: Colors.black87.withOpacity(0.4),
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.height * 0.2,
                      child: Text(
                        "UGX${oCcy.format(widget.product.price)}",
                        style: GoogleFonts.montserrat(
                            color: Colors.black87.withOpacity(0.9),
                            fontWeight: FontWeight.w600,
                            fontSize: 12),
                      ),
                    ),
                    Container()
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
