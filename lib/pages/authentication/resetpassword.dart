import 'package:bridge_ai/constants/app_constants.dart';
import 'package:bridge_ai/constants/controllers.dart';
import 'package:bridge_ai/pages/authentication/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPassword();
}

class _ResetPassword extends State<ResetPassword> {
  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();

  void submit() {
    emailController.clear();
  }

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
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Reset Password",
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
                        "Your Email",
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
                    ],
                  ),
                ),
                SizedBox(height: 24),
                InkWell(
                  onTap: () {
                    if (formKey.currentState!.validate()) {
                      // If the form is valid, display a snackbar. In the real world,
                      // you'd often call a server or save the information in a database.
                      userController.resetpassword(context);

                      submit();
                      Get.back();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Something went wrong, try again'),
                        ),
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
                          "Send Password Reset Link",
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
                SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future resetPassword(email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      showDialog<String>(
        context: context,
        builder:
            (BuildContext context) => AlertDialog(
              title: Text(
                'Hooray!',
                style: GoogleFonts.montserrat(
                  color: Colors.black.withOpacity(0.9),
                  fontSize: 16,
                ),
              ),
              content: Text(
                'You reset password has been sent to your email',
                style: GoogleFonts.montserrat(
                  color: Colors.black87.withOpacity(0.8),
                  fontSize: 13,
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Get.offAll(() => Login());
                  },
                  child: const Text("OKAY"),
                ),
              ],
            ),
      );
    } on FirebaseAuthException catch (e) {
      print(e);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }
}
