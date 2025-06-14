
import 'package:bridge_ai/constants/app_constants.dart';
import 'package:bridge_ai/pages/shop/addproduct.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AddEssentailPopupWidget extends StatefulWidget {
  const AddEssentailPopupWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<AddEssentailPopupWidget> createState() => _AddEssentailPopupWidgetState();
}

class _AddEssentailPopupWidgetState extends State<AddEssentailPopupWidget> {

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.center,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width * .75,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        Get.back();
                        Get.to(() => AddProduct(), transition: Transition.rightToLeft);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            border:
                                Border.all(color: Colors.black12, width: .2)),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            "Add Product",
                            style: GoogleFonts.plusJakartaSans(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 14),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: () {
                        Get.back();
                        ///////////////////
                        ///add article
                        Get.to(() => AddProduct(), transition: Transition.rightToLeft);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            border:
                                Border.all(color: Colors.black12, width: .2)),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            "Add Article",
                            style: GoogleFonts.plusJakartaSans(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 14),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 12,),
                    Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(),
                                Row(
                                  children: [
                                    Container(),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Material(
                                      borderRadius: BorderRadius.circular(9),
                                      color: primaryColor,
                                      child: InkWell(
                                        onTap: () async {
                                          Get.back();
                                        },
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 18.0, vertical: 12),
                                            child: Text(
                                              'Back',
                                              style: GoogleFonts.montserrat(
                                                  color: Colors.white
                                                      .withOpacity(0.9),
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 14),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 24,
                            ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
 
}

 addEssentialsPopup(BuildContext context) {
    showModalBottomSheet<void>(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return AddEssentailPopupWidget();
      },
    );
  }
