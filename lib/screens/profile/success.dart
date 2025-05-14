import 'package:bridge_ai/constants/controllers.dart';
import 'package:bridge_ai/screens/authentication/first3.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SuccessPage extends StatelessWidget {
  const SuccessPage(
      {Key? key, required this.name, required this.email, required this.phone})
      : super(key: key);
  final String name;
  final String email;
  final String phone;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
              child: Image.asset(
                "images/waiting.jpg",
                width: MediaQuery.of(context).size.width * 0.65,
              ),
            ),
            SizedBox(height: 10),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                    child: Text("Successful Match",
                        style: GoogleFonts.poppins(
                            color: Colors.black.withOpacity(0.8),
                            fontSize: 16,
                            fontWeight: FontWeight.w500)),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                    child: Text(
                        "Horray, we successfully matched you with a qualified doctor known as ${name.capitalize}. We hope is the one for you ${userController.userModel.value!.name.capitalize}",
                        style: GoogleFonts.poppins(
                          color: Colors.black.withOpacity(0.4),
                          fontSize: 12,
                        )),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                    child: Center(
                        child: SizedBox(
                            height: 60,
                            width: MediaQuery.of(context).size.width * 0.95,
                            child: TextButton(
                              onPressed: () {
                                Get.offAll(() => First3(),
                                    transition: Transition.rightToLeft);
                              },
                              child: Text("Go to Home",
                                  style: GoogleFonts.poppins(
                                      color: Colors.black.withOpacity(0.55),
                                      fontSize: 13)),
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                          side: BorderSide(
                                              color: Colors.black
                                                  .withOpacity(0.55))))),
                            ))),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
