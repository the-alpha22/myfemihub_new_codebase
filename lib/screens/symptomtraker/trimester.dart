import 'package:bridge_ai/constants/controllers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Trimester extends StatelessWidget {
  const Trimester({Key? key, @required this.trimester}) : super(key: key);
  final trimester;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Possible Trimester',
            style: GoogleFonts.poppins(
              color: Colors.black.withOpacity(0.8),
              fontSize: 12,
            )),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 19,
            color: Colors.black.withOpacity(0.6),
          ),
          onPressed: () {
            Get.back();
          },
        ),
        elevation: 0,
        backgroundColor: Color.fromARGB(255, 224, 241, 255),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.fill,
                imageUrl:
                    "https://firebasestorage.googleapis.com/v0/b/bridgeai-e6529.appspot.com/o/assets%2Ftrimester.jpg?alt=media&token=b3914837-49ad-4853-b870-47f1dd6eff0c",
                placeholder: (context, url) => Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.width,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Colors.black,
                          strokeWidth: 0,
                        ),
                      ),
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width,
                    child: Icon(Icons.error)),
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: Text(
                  trimester == 1
                      ? "From the symptoms provided, you are probably in your first trimester of pregnancy"
                      : trimester == 2
                          ? "From the symptoms provided, you are probably in your second trimester of pregnancy"
                          : "From the symptoms provided, you are probably in your third trimester of pregnancy",
                  style: GoogleFonts.poppins(
                    color: Colors.black.withOpacity(0.6),
                    fontSize: 12,
                  )),
            ),
            SizedBox(height: 10),
            Center(
              child: Text(
                  "But do not worry ${userController.userModel.value!.name.capitalize}, because we are here to guide you throught he whole journey.",
                  style: GoogleFonts.poppins(
                    color: Colors.black.withOpacity(0.6),
                    fontSize: 12,
                  )),
            ),
            SizedBox(height: 20),
            Center(
              child:
                  Text("The predicated trimester may not be accurate at times",
                      style: GoogleFonts.poppins(
                        color: Colors.black.withOpacity(0.4),
                        fontSize: 12,
                      )),
            ),
          ],
        ),
      ),
    );
  }
}
