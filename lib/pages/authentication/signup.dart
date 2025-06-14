import 'package:bridge_ai/constants/app_constants.dart';
import 'package:bridge_ai/constants/controllers.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io' show Platform;

class Registration extends StatefulWidget {
  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  String stage = 'Not Yet Pregnant';
  var stages = ['Not Yet Pregnant', 'Pregnant', "A Mother"];
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back_ios, color: Colors.black87, size: 16),
        ),
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Hello! Register to get started",
                        style: GoogleFonts.montserrat(
                          color: Colors.black87,
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 12),
                      Form(
                        key: formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Name",
                              style: GoogleFonts.montserrat(
                                color: Colors.black87,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 8),
                            Container(
                              decoration: BoxDecoration(
                                color: bgcolor,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: TextFormField(
                                controller: userController.name,
                                keyboardType: TextInputType.name,
                                style: GoogleFonts.montserrat(
                                  color: Colors.black87,
                                  fontSize: 12,
                                ),
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'First Name Required';
                                  } else if (value.length < 2) {
                                    return 'Enter a valid name';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(height: 12),
                            Text(
                              "Email Address",
                              style: GoogleFonts.montserrat(
                                color: Colors.black87,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 8),
                            Container(
                              decoration: BoxDecoration(
                                color: bgcolor,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: TextFormField(
                                controller: userController.email,
                                keyboardType: TextInputType.emailAddress,
                                style: GoogleFonts.montserrat(
                                  color: Colors.black87,
                                  fontSize: 12,
                                ),
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Email Required';
                                  } else if (value.length < 5) {
                                    return 'Enter a valid email';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(height: 12),

                            Text(
                              "Password",
                              style: GoogleFonts.montserrat(
                                color: Colors.black87,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 8),
                            Container(
                              decoration: BoxDecoration(
                                color: bgcolor,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: TextFormField(
                                controller: userController.password,
                                keyboardType: TextInputType.text,
                                obscureText: obscureText,
                                style: GoogleFonts.montserrat(
                                  color: Colors.black87,
                                  fontSize: 12,
                                ),
                                decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      Icons.visibility_off,
                                      color:
                                          obscureText == true
                                              ? Colors.black45
                                              : Colors.blueAccent,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        obscureText = !obscureText;
                                      });
                                    },
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your password';
                                  } else if (value.length < 3) {
                                    return 'Please enter a valid password';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(height: 12),
                            InkWell(
                              onTap: () async {
                                // Validate returns true if the form is valid, or false otherwise.
                                if (formKey.currentState!.validate()) {
                                  // If the form is valid, display a snackbar. In the real world,
                                  // you'd often call a server or save the information in a database.

                                  await userController.signUp(context, stage);
                                } else {
                                  Fluttertoast.showToast(
                                    msg: "Something is missing",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.TOP,
                                    timeInSecForIosWeb: 3,
                                    backgroundColor: Colors.black.withOpacity(
                                      0.7,
                                    ),
                                    textColor: Colors.white,
                                    fontSize: 16.0,
                                  );
                                }
                              },
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(color: primaryColor),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text(
                                      "Create Account",
                                      style: GoogleFonts.montserrat(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 12),
                            if (!Platform.isIOS) ...{
                              Center(
                                child: Text(
                                  "Or Sign Up With",
                                  style: GoogleFonts.montserrat(
                                    color: Colors.black87,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              SizedBox(height: 12),
                              InkWell(
                                onTap: () async {
                                  await userController.signInWithGoogle(
                                    context,
                                  );
                                },
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(color: bgcolor),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Image.asset(
                                            "images/google_logo.png",
                                            height: 16,
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            "Google",
                                            style: GoogleFonts.montserrat(
                                              color: Colors.black87,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              if (Platform.isIOS) ...{
                                SizedBox(height: 10),
                                InkWell(
                                  onTap: () async {
                                    await userController.signInWithApple(
                                      context,
                                    );
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: bgcolor,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Image.asset(
                                              "images/apple.png",
                                              height: 16,
                                            ),
                                            SizedBox(width: 10),
                                            Text(
                                              "Apple",
                                              style: GoogleFonts.montserrat(
                                                color: Colors.black87,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              },
                              SizedBox(height: 24),
                            },
                            Center(
                              child: InkWell(
                                onTap: () {
                                  openLink(
                                    "https://bulamubridgeai.com/privacy-policy",
                                  );
                                },
                                child: Text(
                                  "By creating an account, you agree to our Privacy Policy & Terms and Conditions",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.montserrat(
                                    color: Colors.black87,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 80,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(color: Colors.white),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(
                  onPressed: () {
                    Get.toNamed("/login");
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Already have an account? ",
                        style: GoogleFonts.montserrat(
                          color: Colors.black87,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        "Login",
                        style: GoogleFonts.montserrat(
                          color: primaryColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
