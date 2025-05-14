import 'package:bridge_ai/constants/controllers.dart';
import 'package:bridge_ai/screens/authentication/login.dart';
import 'package:bridge_ai/widgets/helpers/showLoading.dart';
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
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();

  void _submit() {
    // you can write your
    // own code according to
    // whatever you want to submit;
    emailController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.black),
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(Icons.close)),
        elevation: 0,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: ListView(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                ),
                Text("Reset Passsword",
                    style: GoogleFonts.poppins(
                        color: Colors.black87.withOpacity(0.9),
                        fontSize: 30,
                        fontWeight: FontWeight.bold)),
                Text(
                    "Please enter your email address to\nrequest a password reset",
                    style: GoogleFonts.poppins(
                        color: Colors.black87.withOpacity(0.6), fontSize: 15)),
                SizedBox(
                  height: 20,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      // Add TextFormFields and ElevatedButton here.
                      Container(
                        height: 60,
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: TextFormField(
                          controller: userController.email,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              labelText: 'Email*',
                              border: OutlineInputBorder()),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            } else if (value.length < 5) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.3,
                ),
                Center(
                  child: Column(
                    children: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              textStyle: GoogleFonts.poppins(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 16),
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)))),
                          onPressed: () {
                            // Validate returns true if the form is valid, or false otherwise.
                            if (_formKey.currentState!.validate()) {
                              // If the form is valid, display a snackbar. In the real world,
                              // you'd often call a server or save the information in a database.
                              userController.resetpassword(context);

                              _submit();
                              Get.back();
                            } else {
                              dismissLoadingWidget();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Something went wrong, try again')),
                              );
                            }
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            margin: EdgeInsets.all(15.0),
                            padding: EdgeInsets.all(3.0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20)),
                            child: Center(child: Text("Reset Password")),
                          )),
                      SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: SizedBox(
                          height: 60,
                          width: MediaQuery.of(context).size.width * 0.95,
                          child: TextButton(
                            onPressed: () {
                              Get.back();
                            },
                            child: Text("Cancel",
                                style: GoogleFonts.poppins(
                                    color: Colors.black87.withOpacity(0.9),
                                    fontSize: 15)),
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                        side:
                                            BorderSide(color: Colors.black)))),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future resetPassword(email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('Hooray!',
              style: GoogleFonts.poppins(
                  color: Colors.black.withOpacity(0.9), fontSize: 16)),
          content: Text('You reset password has been sent to your email',
              style: GoogleFonts.poppins(
                  color: Colors.black87.withOpacity(0.8), fontSize: 13)),
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }
}
