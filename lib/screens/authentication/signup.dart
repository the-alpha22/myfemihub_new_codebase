import 'package:bridge_ai/constants/app_constants.dart';
import 'package:bridge_ai/constants/controllers.dart';
import 'package:bridge_ai/screens/authentication/login.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Registration extends StatefulWidget {
  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  String? stage;
  var stages = ['Not Yet Pregnant', 'Pregnant', "A Mother"];
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
            child: Center(
          child: SingleChildScrollView(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
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
                        Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "My",
                                style: GoogleFonts.poppins(
                                    color: Colors.black87.withOpacity(0.9),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 30),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                "Femihub",
                                style: GoogleFonts.poppins(
                                    color: primaryColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 30),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 49,
                        ),
                        Text(
                          "Create Account.",
                          style: GoogleFonts.poppins(
                              color: Colors.black.withOpacity(0.7),
                              fontSize: 30,
                              fontWeight: FontWeight.w700),
                        ),
                        TextButton(
                            onPressed: () {
                              Get.to(() => Login(),
                                  transition: Transition.rightToLeft);
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("Already have an account? ",
                                    style: GoogleFonts.poppins(
                                        color: Colors.black.withOpacity(0.9),
                                        fontSize: 13)),
                                Text("Login",
                                    style: GoogleFonts.poppins(
                                        color: primaryColor, fontSize: 13)),
                              ],
                            )),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Form(
                            key: formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("Name",
                                    style: GoogleFonts.poppins(
                                        color: Colors.black.withOpacity(0.9),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600)),
                                SizedBox(height: 8),
                                Container(
                                  decoration: BoxDecoration(
                                      color: bgcolor,
                                      borderRadius: BorderRadius.circular(4)),
                                  child: TextFormField(
                                    controller: userController.name,
                                    keyboardType: TextInputType.name,
                                    style: GoogleFonts.poppins(
                                        color: Colors.black87, fontSize: 12),
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide.none),
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
                                SizedBox(
                                  height: 12,
                                ),
                                Text("Email Address",
                                    style: GoogleFonts.poppins(
                                        color: Colors.black.withOpacity(0.9),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600)),
                                SizedBox(height: 8),
                                Container(
                                  decoration: BoxDecoration(
                                      color: bgcolor,
                                      borderRadius: BorderRadius.circular(4)),
                                  child: TextFormField(
                                    controller: userController.email,
                                    keyboardType: TextInputType.emailAddress,
                                    style: GoogleFonts.poppins(
                                        color: Colors.black87, fontSize: 12),
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide.none),
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
                                SizedBox(
                                  height: 12,
                                ),
                                Text("Phone Number(+256xxxxxxxxx)",
                                    style: GoogleFonts.poppins(
                                        color: Colors.black.withOpacity(0.9),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600)),
                                SizedBox(height: 8),
                                Container(
                                  decoration: BoxDecoration(
                                      color: bgcolor,
                                      borderRadius: BorderRadius.circular(4)),
                                  child: TextFormField(
                                    controller: userController.phone,
                                    keyboardType: TextInputType.number,
                                    style: GoogleFonts.poppins(
                                        color: Colors.black87, fontSize: 12),
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide.none),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Phone number Required';
                                      } else if (value.length < 11) {
                                        return 'Enter a valid phone number';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                                Text("Stage",
                                    style: GoogleFonts.poppins(
                                        color: Colors.black.withOpacity(0.9),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600)),
                                SizedBox(
                                  height: 8,
                                ),
                                FormField(
                                  builder: (FormFieldState state) {
                                    return InputDecorator(
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 20.0, vertical: 15.0),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color:
                                                  Colors.grey.withOpacity(0.3)),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color:
                                                  Colors.blue.withOpacity(0.4)),
                                        ),
                                      ),
                                      child: DropdownButtonHideUnderline(
                                        child: SingleChildScrollView(
                                          child: DropdownButton<String>(
                                              value: stage,
                                              isDense: true,
                                              onChanged: (value) {
                                                setState(() {
                                                  stage = value;
                                                });
                                              },
                                              items: [
                                                DropdownMenuItem(
                                                  value:
                                                      null, // Set the value to null for the hint
                                                  child: Text(
                                                    'Choose Current Stage',
                                                    style:
                                                        GoogleFonts.montserrat(
                                                            color: Colors
                                                                .black
                                                                .withOpacity(
                                                                    0.6),
                                                            fontSize: 14),
                                                  ), // Your hint text
                                                ),
                                                ...stages.map((value) {
                                                  return DropdownMenuItem(
                                                    onTap: () {
                                                      setState(() {
                                                        stage = value;
                                                      });
                                                    },
                                                    value: value,
                                                    child: Text(
                                                      value,
                                                      style: GoogleFonts
                                                          .montserrat(
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.9),
                                                              fontSize: 14),
                                                    ),
                                                  );
                                                }).toList(),
                                              ]),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                                Text("Password",
                                    style: GoogleFonts.poppins(
                                        color: Colors.black.withOpacity(0.9),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600)),
                                SizedBox(
                                  height: 8,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      color: bgcolor,
                                      borderRadius: BorderRadius.circular(4)),
                                  child: TextFormField(
                                    controller: userController.password,
                                    keyboardType: TextInputType.text,
                                    obscureText: obscureText,
                                    style: GoogleFonts.poppins(
                                        color: Colors.black87, fontSize: 12),
                                    decoration: InputDecoration(
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          Icons.visibility_off,
                                          color: obscureText == true
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
                                          borderSide: BorderSide.none),
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
                                SizedBox(
                                  height: 12,
                                ),
                                InkWell(
                                    onTap: () async {
                                      // Validate returns true if the form is valid, or false otherwise.
                                      if (formKey.currentState!.validate() &&
                                          stage != null) {
                                        // If the form is valid, display a snackbar. In the real world,
                                        // you'd often call a server or save the information in a database.

                                        await userController.signUp(
                                            context, stage!);
                                      } else {
                                        Fluttertoast.showToast(
                                            msg: "Something is missing",
                                            toastLength: Toast.LENGTH_LONG,
                                            gravity: ToastGravity.TOP,
                                            timeInSecForIosWeb: 3,
                                            backgroundColor:
                                                Colors.black.withOpacity(0.7),
                                            textColor: Colors.white,
                                            fontSize: 16.0);
                                      }
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.95,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10), color: primaryColor),
                                      child: Center(
                                          child: Padding(
                                        padding: const EdgeInsets.all(18.0),
                                        child: Text(
                                          "Create Account",
                                          style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontSize: 14,
                                          ),
                                        ),
                                      )),
                                    )),
                                SizedBox(
                                  height: 12,
                                ),
                                Center(
                                  child: Text("Or Sign Up With",
                                      style: GoogleFonts.poppins(
                                        color: Colors.black87,
                                        fontSize: 12,
                                      )),
                                ),
                                SizedBox(height: 24),
                                InkWell(
                                  onTap: () async {
                                    // await userController.signInWithGoogle(context);
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
                                              "images/google_logo.png",
                                              height: 16,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text("Google",
                                                style: GoogleFonts.poppins(
                                                    color: Colors.black87,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w600)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 24),
                                Center(
                                  child: Text(
                                      "By creating an account, you agree to our Privacy Policy & Terms and Conditions",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.poppins(
                                        color: Colors.black87,
                                        fontSize: 12,
                                      )),
                                ),
                                SizedBox(height: 24),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ]),
          )),
        )));
  }
}
