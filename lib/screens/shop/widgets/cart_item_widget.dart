import 'package:flutter/material.dart';
import 'package:bridge_ai/models/cart_item.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class CartItemWidget extends StatelessWidget {
  final CartItemModel cartItem;
  final Function press;

  const CartItemWidget({Key? key, required this.cartItem, required this.press})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    var oCcy = NumberFormat("#,##0", "en_US");
    return Padding(
      padding: const EdgeInsets.all(13),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Color.fromARGB(255, 248, 248, 248),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onLongPress: () => press,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: CachedNetworkImage(
                      width: 80,
                      fit: BoxFit.fill,
                      imageUrl: cartItem.image,
                      placeholder: (context, url) => Center(
                          child: new CircularProgressIndicator(
                              strokeWidth: 0, color: Colors.black)),
                      errorWidget: (context, url, error) =>
                          new Icon(Icons.error),
                    ),
                  ),
                ),
                Expanded(
                    child: Wrap(
                  direction: Axis.vertical,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.45,
                        child: Text(
                          "${cartItem.name}",
                          maxLines: 1,
                          style: GoogleFonts.openSans(
                              color: Colors.black87.withOpacity(0.9),
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      child: Text(
                        "from Bridge Mom",
                        style: GoogleFonts.openSans(
                            fontSize: 12,
                            color: Colors.black87.withOpacity(0.6)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      child: Text(
                        "\shs. ${oCcy.format(cartItem.cost)}",
                        style: GoogleFonts.openSans(
                            color: Colors.black87.withOpacity(0.8),
                            fontSize: 12,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                )),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Quantity",
                        style: GoogleFonts.openSans(
                            fontSize: 12,
                            color: Colors.black87.withOpacity(0.6)),
                      ),
                      Text(
                        cartItem.quantity.toString(),
                        style: GoogleFonts.openSans(
                            fontSize: 11,
                            color: Colors.black87.withOpacity(0.8)),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
