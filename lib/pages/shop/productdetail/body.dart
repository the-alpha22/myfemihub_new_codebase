import 'package:bridge_ai/constants/app_constants.dart';
import 'package:bridge_ai/controllers/cart_controller.dart';
import 'package:bridge_ai/models/product.dart';
import 'package:bridge_ai/pages/shop/payment/popover.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

class Body extends StatefulWidget {
  final ProductModel product;

  const Body({Key? key, required this.product}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  void initState() {
    super.initState();
    checkProduct();
    checkReviews();
  }

  checkReviews() async {
    if (widget.product.reviews == null) {
      var snaps = await FirebaseFirestore.instance
          .collection('products')
          .where('id', isEqualTo: widget.product.id)
          .get();

      for (var doc in snaps.docs) {
        doc.reference.update({
          "reviews": [],
        });
      }
    } else {}
  }

  var productSize;
  checkProduct() {
    setState(() {
      if (widget.product.sizes.length == 0) {
        productSize = false;
        setState(() {
          productSize = false;
        });
      } else {
        productSize = true;
        setState(() {
          productSize = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // It provide us total height and width
    Future<void> _makePhoneCall(String phoneNumber) async {
      final Uri launchUri = Uri(
        scheme: 'tel',
        path: phoneNumber,
      );
      await launchUrl(launchUri);
    }

    Future<void> _openLink(String link) async {
      final Uri launchUri = Uri(
        scheme: 'https',
        path: link,
      );
      await launchUrl(launchUri);
    }

    Future<void> _sendEmail(String mail) async {
      final Uri launchUri = Uri(
        scheme: 'mailto',
        path: mail,
      );
      await launchUrl(launchUri);
    }

    @override
    sizes() {
      if (productSize == true) {
        return Column(
          children: [
            SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Available Sizes",
                        style: GoogleFonts.montserrat(
                            color: Colors.black87.withOpacity(0.9),
                            fontSize: 15,
                            fontWeight: FontWeight.w500)),
                    Padding(
                      padding: EdgeInsets.all(3.0),
                      child: Wrap(
                          children: widget.product.sizes
                              .map(
                                (item) => Text("$item, ",
                                    style: GoogleFonts.montserrat(
                                      color: Colors.black87.withOpacity(0.9),
                                      fontSize: 15,
                                    )),
                              )
                              .toList()),
                    ),
                  ],
                ),
                Container()
              ],
            ),
          ],
        );
      } else {
        return SizedBox(
          height: 0,
        );
      }
    }

    setState(() {});

    var selectedSize;
    var selectedQuantity;

    addProductToCart() async {
      checkProduct();
      print(productSize);
      if (productSize == true) {
        return showModalBottomSheet<int>(
          backgroundColor: Colors.transparent,
          context: context,
          builder: (context) {
            return Popover(
              child: Container(
                child: Column(children: [
                  SizedBox(
                    height: 10,
                  ),
                  Text("Select Desired Size",
                      style: GoogleFonts.montserrat(
                          color: Colors.black87.withOpacity(0.9),
                          fontSize: 16,
                          fontWeight: FontWeight.w500)),
                  Divider(),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.95,
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 10.0,
                    ),
                    child: Wrap(
                        children: widget.product.sizes
                            .map(
                              (item) => GestureDetector(
                                onTap: () async {
                                  Get.back();
                                  selectedSize = "$item";
                                  setState(() {
                                    selectedSize = "$item";
                                  });
                                  selectedQuantity = 1;
                                  setState(() {
                                    selectedQuantity = 1;
                                  });
                                  showModalBottomSheet<int>(
                                    backgroundColor: Colors.transparent,
                                    context: context,
                                    builder: (context) {
                                      return StatefulBuilder(
                                          builder: (context, setState) {
                                        return Popover(
                                          child: Container(
                                            child: Column(children: [
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text("Your Desired Quantity",
                                                  style: GoogleFonts.montserrat(
                                                      color: Colors.black87
                                                          .withOpacity(0.9),
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500)),
                                              Divider(),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    IconButton(
                                                        icon: Icon(Icons
                                                            .arrow_back_ios),
                                                        onPressed: () {
                                                          if (selectedQuantity !=
                                                              1) {
                                                            setState(() {
                                                              selectedQuantity =
                                                                  selectedQuantity -
                                                                      1;
                                                            });
                                                          }
                                                        }),
                                                    Text("$selectedQuantity",
                                                        style:
                                                            GoogleFonts.montserrat(
                                                                color: Colors
                                                                    .black87
                                                                    .withOpacity(
                                                                        0.9),
                                                                fontSize: 15)),
                                                    IconButton(
                                                        icon: Icon(Icons
                                                            .arrow_forward_ios),
                                                        onPressed: () {
                                                          setState(() {
                                                            selectedQuantity =
                                                                selectedQuantity +
                                                                    1;
                                                          });
                                                        }),
                                                  ],
                                                ),
                                              ),
                                              ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          textStyle: GoogleFonts
                                                              .montserrat(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 13),),
                                                  onPressed: () async {
                                                    Get.back();
                                                    CartController.instance
                                                        .addProductToCart(
                                                            widget.product,
                                                            "$selectedSize",
                                                            selectedQuantity);
                                                    if (widget.product
                                                            .purchases !=
                                                        null) {
                                                      var collection =
                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'products');
                                                      var snapshot =
                                                          await collection
                                                              .where('id',
                                                                  isEqualTo:
                                                                      widget
                                                                          .product
                                                                          .id)
                                                              .get();
                                                      Map<String, dynamic>
                                                          data = {
                                                        "purchases": widget
                                                                .product
                                                                .purchases +
                                                            1,
                                                      };
                                                      for (var doc
                                                          in snapshot.docs) {
                                                        await doc.reference
                                                            .update(data);
                                                      }
                                                    } else {
                                                      var collection =
                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'products');
                                                      var snapshot =
                                                          await collection
                                                              .where('id',
                                                                  isEqualTo:
                                                                      widget
                                                                          .product
                                                                          .id)
                                                              .get();
                                                      Map<String, dynamic>
                                                          data = {
                                                        "purchases": 1,
                                                      };
                                                      for (var doc
                                                          in snapshot.docs) {
                                                        await doc.reference
                                                            .update(data);
                                                      }
                                                    }
                                                  },
                                                  child: Center(
                                                    child: Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.9,
                                                      margin:
                                                          EdgeInsets.all(15.0),
                                                      padding:
                                                          EdgeInsets.all(3.0),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10)),
                                                      child: Center(
                                                          child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text("Proceed"),
                                                          SizedBox(
                                                            width: 6,
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        8.0),
                                                            child: Icon(
                                                              Icons
                                                                  .shopping_bag,
                                                              color: Colors
                                                                  .white
                                                                  .withOpacity(
                                                                      0.9),
                                                              size: 20,
                                                            ),
                                                          )
                                                        ],
                                                      )),
                                                    ),
                                                  )),
                                            ]),
                                          ),
                                        );
                                      });
                                    },
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(9),
                                    child: Container(
                                      color: Colors.black.withOpacity(0.9),
                                      child: Padding(
                                        padding: const EdgeInsets.all(9),
                                        child: Text("$item",
                                            style: GoogleFonts.montserrat(
                                              color:
                                                  Colors.white.withOpacity(0.9),
                                              fontSize: 15,
                                            )),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                            .toList()),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ]),
              ),
            );
          },
        );
      } else if (productSize == false) {
        selectedQuantity = 1;
        setState(() {
          selectedQuantity = 1;
        });

        showModalBottomSheet<int>(
          backgroundColor: Colors.transparent,
          context: context,
          builder: (context) {
            return StatefulBuilder(builder: (context, setState) {
              return Popover(
                child: Container(
                  child: Column(children: [
                    SizedBox(
                      height: 10,
                    ),
                    Text("Your Desired Quantity",
                        style: GoogleFonts.montserrat(
                            color: Colors.black87.withOpacity(0.9),
                            fontSize: 16,
                            fontWeight: FontWeight.w500)),
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                              icon: Icon(Icons.arrow_back_ios),
                              onPressed: () {
                                if (selectedQuantity != 1) {
                                  setState(() {
                                    selectedQuantity = selectedQuantity - 1;
                                  });
                                }
                              }),
                          Text("$selectedQuantity",
                              style: GoogleFonts.montserrat(
                                  color: Colors.black87.withOpacity(0.9),
                                  fontSize: 15)),
                          IconButton(
                              icon: Icon(Icons.arrow_forward_ios),
                              onPressed: () {
                                setState(() {
                                  selectedQuantity = selectedQuantity + 1;
                                });
                              }),
                        ],
                      ),
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            textStyle: GoogleFonts.montserrat(
                                color: Colors.white, fontSize: 13),),
                        onPressed: () async {
                          CartController.instance.addProductToCart(
                              widget.product, "N/A", selectedQuantity);
                          if (widget.product.purchases != null) {
                            var collection = FirebaseFirestore.instance
                                .collection('products');
                            var snapshot = await collection
                                .where('id', isEqualTo: widget.product.id)
                                .get();
                            Map<String, dynamic> data = {
                              "purchases": widget.product.purchases + 1,
                            };
                            for (var doc in snapshot.docs) {
                              await doc.reference.update(data);
                            }
                          } else if (widget.product.likes == null) {
                            var collection = FirebaseFirestore.instance
                                .collection('products');
                            var snapshot = await collection
                                .where('id', isEqualTo: widget.product.id)
                                .get();
                            Map<String, dynamic> data = {
                              "purchases": 1,
                            };
                            for (var doc in snapshot.docs) {
                              await doc.reference.update(data);
                            }
                          }
                          Get.back();
                        },
                        child: Center(
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            margin: EdgeInsets.all(15.0),
                            padding: EdgeInsets.all(3.0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                                child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Proceed"),
                                SizedBox(
                                  width: 6,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Icon(
                                    Icons.shopping_bag,
                                    color: Colors.white.withOpacity(0.9),
                                    size: 20,
                                  ),
                                )
                              ],
                            )),
                          ),
                        )),
                  ]),
                ),
              );
            });
          },
        );
      }
    }

    Size size = MediaQuery.of(context).size;
    var oCcy = NumberFormat("#,##0", "en_US");
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
            child: imagedisplay(product: widget.product),
          ),
          SizedBox(
            child: Stack(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: size.height / 20),
                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                  // height: 500,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.49,
                            child: Text(
                              widget.product.name,
                              style: GoogleFonts.montserrat(
                                  color: Colors.black.withOpacity(0.9),
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          Container(
                            child: Text(
                              "UGX. ${oCcy.format(widget.product.price)}",
                              style: GoogleFonts.montserrat(
                                  color: Colors.black.withOpacity(0.9),
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                      Divider(),
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Description(product: widget.product),
                                sizes(),
                                SizedBox(height: 4),
                              ]),
                        ),
                      ),
                      SizedBox(height: 15),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            textStyle: GoogleFonts.montserrat(
                                color: Colors.white, fontSize: 13),
                          ),
                          onPressed: () async {
                            addProductToCart();
                          },
                          child: Center(
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              margin: EdgeInsets.all(15.0),
                              padding: EdgeInsets.all(3.0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Center(
                                  child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Add to Cart"),
                                  SizedBox(
                                    width: 6,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Icon(
                                      Icons.shopping_bag,
                                      color: Colors.white.withOpacity(0.9),
                                      size: 20,
                                    ),
                                  )
                                ],
                              )),
                            ),
                          )),
                      SizedBox(
                        height: 8,
                      ),
                      SizedBox(
                        height: 45,
                      ),
                      SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class imagedisplay extends StatefulWidget {
  const imagedisplay({
    Key? key,
    required this.product,
  }) : super(key: key);

  final ProductModel product;

  @override
  State<imagedisplay> createState() => _imagedisplayState();
}

class _imagedisplayState extends State<imagedisplay> {
  int _selectedIndex = 0;

  otherImage() {
    List<Widget> _images = <Widget>[
      _image1(context: context, widget: widget),
      _image2(context: context, widget: widget),
    ];
    Widget _image = _image1(context: context, widget: widget);
    return Column(
      children: [
        _images.elementAt(_selectedIndex),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MaterialButton(
                  padding: EdgeInsets.all(0),
                  onPressed: () {
                    setState(() {
                      _image = _image1(context: context, widget: widget);
                      _selectedIndex = 0;
                    });
                  },
                  child: Container(
                    height: 80,
                    width: 80,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: widget.product.image,
                        placeholder: (context, url) => Center(
                            child: CircularProgressIndicator(
                          strokeWidth: 0,
                        )),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                  )),
              MaterialButton(
                  padding: EdgeInsets.all(0),
                  onPressed: () {
                    setState(() {
                      _image = _image1(context: context, widget: widget);
                      _selectedIndex = 1;
                    });
                  },
                  child: Container(
                    height: 80,
                    width: 80,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: widget.product.image2,
                        placeholder: (context, url) => Center(
                            child: CircularProgressIndicator(
                          strokeWidth: 0,
                        )),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return otherImage();
  }
}

class _image1 extends StatelessWidget {
  const _image1({
    Key? key,
    required this.context,
    required this.widget,
  }) : super(key: key);

  final BuildContext context;
  final imagedisplay widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.45,
      child: ClipRRect(
        child: CachedNetworkImage(
          fit: BoxFit.cover,
          imageUrl: widget.product.image,
          placeholder: (context, url) => Center(
              child: CircularProgressIndicator(
            strokeWidth: 0,
            color: Colors.black,
          )),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
      ),
    );
  }
}

class _image2 extends StatelessWidget {
  const _image2({
    Key? key,
    required this.context,
    required this.widget,
  }) : super(key: key);

  final BuildContext context;
  final imagedisplay widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.45,
      child: ClipRRect(
        child: CachedNetworkImage(
          fit: BoxFit.cover,
          imageUrl: widget.product.image2,
          placeholder: (context, url) => Center(
              child: CircularProgressIndicator(
            strokeWidth: 0,
            color: Colors.black,
          )),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
      ),
    );
  }
}

class Description extends StatelessWidget {
  const Description({
    Key? key,
    required this.product,
  }) : super(key: key);

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            product.description,
            style: GoogleFonts.montserrat(
                color: Colors.black87.withOpacity(0.7), fontSize: 13),
          ),
          SizedBox(
            height: 4,
          ),
        ],
      ),
    );
  }
}
