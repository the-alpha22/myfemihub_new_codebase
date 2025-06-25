import 'package:bridge_ai/constants/app_constants.dart';
import 'package:bridge_ai/constants/controllers.dart';
import 'package:bridge_ai/pages/authentication/resetpassword.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/foundation.dart'
    show kIsWeb, defaultTargetPlatform, TargetPlatform;

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
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  "Welcome back! Glad to see you again",
                  style: GoogleFonts.montserrat(
                    color: Colors.black87,
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 12),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Email",
                        style: GoogleFonts.montserrat(
                          color: Colors.black,
                          fontSize: 12,
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
                      SizedBox(height: 24),
                      Text(
                        "Password",
                        style: GoogleFonts.montserrat(
                          color: Colors.black,
                          fontSize: 12,
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
                      SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(),
                          TextButton(
                            onPressed: () {
                              Get.to(
                                () => ResetPassword(),
                                transition: Transition.rightToLeft,
                              );
                            },
                            child: Text(
                              "Forgot Password?",
                              style: GoogleFonts.montserrat(
                                color: primaryColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 12),
                      InkWell(
                        onTap: () {
                          // Validate returns true if the form is valid, or false otherwise.
                          if (_formKey.currentState!.validate()) {
                            userController.signIn(context);
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(color: primaryColor),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                "Login",
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
                    ],
                  ),
                ),
                SizedBox(height: 24),
                if (defaultTargetPlatform != TargetPlatform.iOS) ...{
                  Center(
                    child: Text(
                      "Or Sign In With",
                      style: GoogleFonts.montserrat(
                        color: Colors.black87,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  InkWell(
                    onTap: () async {
                      await userController.signInWithGoogle(context);
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
                              Image.asset("images/google_logo.png", height: 16),
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
                  if (defaultTargetPlatform == TargetPlatform.iOS) ...{
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
                    Get.toNamed("/signup");
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: GoogleFonts.montserrat(
                          color: Colors.black.withOpacity(0.9),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        "Create One",
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
