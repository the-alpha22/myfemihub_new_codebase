import 'package:bridge_ai/constants/app_constants.dart';
import 'package:bridge_ai/constants/controllers.dart';
import 'package:bridge_ai/screens/authentication/signup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io' show Platform;

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);
  @override
  State<Login> createState() => _Login();
}

class _Login extends State<Login> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  bool obscureText = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "My",
                          style: GoogleFonts.poppins(
                            color: Colors.black87.withOpacity(0.9),
                            fontWeight: FontWeight.w600,
                            fontSize: 30,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          "Femihub",
                          style: GoogleFonts.poppins(
                            color: primaryColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 30,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 49),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Email",
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 5),
                        Container(
                          decoration: BoxDecoration(
                            color: bgcolor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: TextFormField(
                            controller: userController.email,
                            keyboardType: TextInputType.emailAddress,
                            style: GoogleFonts.poppins(
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
                        SizedBox(height: 24),
                        Text(
                          "Password",
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 5),
                        Container(
                          decoration: BoxDecoration(
                            color: bgcolor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: TextFormField(
                            controller: userController.password,
                            keyboardType: TextInputType.text,
                            obscureText: obscureText,
                            style: GoogleFonts.poppins(
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
                                          : primaryColor,
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
                        SizedBox(height: 24),
                        InkWell(
                          onTap: () {
                            // Validate returns true if the form is valid, or false otherwise.
                            if (_formKey.currentState!.validate()) {
                              userController.signIn(context);
                            }
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.95,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: primaryColor,
                            ),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: Text(
                                  "Login",
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24),
                  Center(
                    child: Text(
                      "Or Sign In With",
                      style: GoogleFonts.poppins(
                        color: Colors.black87,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  InkWell(
                    onTap: () async {
                      await userController.signInWithGoogle(context);
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
                              Image.asset("images/google_logo.png", height: 16),
                              SizedBox(width: 10),
                              Text(
                                "Google",
                                style: GoogleFonts.poppins(
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
                  if (Platform.isIOS) ...{
                    SizedBox(height: 10),
                    InkWell(
                      onTap: () async {
                        await userController.signInWithApple(context);
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
                                Image.asset("images/apple.png", height: 16),
                                SizedBox(width: 10),
                                Text(
                                  "Apple",
                                  style: GoogleFonts.poppins(
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
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Container(),
                  //     TextButton(
                  //         onPressed: () {
                  //           Get.to(() => Passwordless(),
                  //               transition: Transition.rightToLeft);
                  //         },
                  //         child: Text("Forgot Password?",
                  //             style: GoogleFonts.poppins(
                  //               color: primaryColor,
                  //               fontSize: 13,
                  //             ))),
                  //   ],
                  // ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(50)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Center(
                    child: SizedBox(
                      height: 60,
                      width: MediaQuery.of(context).size.width * 0.95,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextButton(
                            onPressed: () {
                              Get.to(
                                () => Registration(),
                                transition: Transition.rightToLeft,
                              );
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "Don't have an account? ",
                                  style: GoogleFonts.poppins(
                                    color: Colors.black.withOpacity(0.9),
                                    fontSize: 13,
                                  ),
                                ),
                                Text(
                                  "Sign Up",
                                  style: GoogleFonts.poppins(
                                    color: primaryColor,
                                    fontSize: 13,
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}
