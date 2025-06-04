import 'package:bridge_ai/constants/app_constants.dart';
import 'package:bridge_ai/constants/controllers.dart';
import 'package:bridge_ai/pages/authentication/resetpassword.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Passwordless extends StatefulWidget {
  const Passwordless({Key? key}) : super(key: key);

  @override
  State<Passwordless> createState() => _PasswordlessState();
}

class _PasswordlessState extends State<Passwordless>
    with WidgetsBindingObserver {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future signInWithEmailandLink(userEmail) async {
    var _userEmail = userEmail;
    return await _auth
        .sendSignInLinkToEmail(
            email: _userEmail,
            actionCodeSettings: ActionCodeSettings(
              url: "https://bridgeai.page.link/",
              handleCodeInApp: true,
              androidPackageName: "obtek.technologies.bridge_ai",
              androidMinimumVersion: "1",
            ))
        .catchError(
            (onError) => print('Error sending email verification $onError'))
        .then((value) => showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return Container(
                  height: MediaQuery.of(context).size.height * 0.8,
                  color: Colors.white,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            "images/me.JPG",
                            width: MediaQuery.of(context).size.width * 0.55,
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 2),
                                child: Text("Hello there",
                                    style: GoogleFonts.expletusSans(
                                        color: Colors.black.withOpacity(0.8),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500)),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 2),
                                child: Text(
                                    "A passwordless sign in link has been sent to your email address. This link will allow you to sign in to your account without having to enter your password.",
                                    style: GoogleFonts.montserrat(
                                      color: Colors.black.withOpacity(0.6),
                                      fontSize: 12,
                                    )),
                              ),
                              SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 2),
                                child: Text("Check your email",
                                    style: GoogleFonts.montserrat(
                                      color: Colors.black.withOpacity(0.4),
                                      fontSize: 12,
                                    )),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    try {
      FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) {
        handleLink(dynamicLinkData.link, userController.email.text.trim());
      }).onError((error) {
        // Handle errors
        print("something went wrong");
      });
    } catch (e) {
      print("the error: $e");
    }
  }

  Future<void> retrieveEmailLink() async {
    final PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink();

    final Uri? deepLink = data!.link;

    if (deepLink != null) {
      final String emailLink = deepLink.toString();
      print('Email link received: $emailLink');
      // Use the emailLink for further processing, such as signing in the user
    }
  }

  void handleLink(Uri? link, userEmail) async {
    if (link != null) {
      print(userEmail);
      final UserCredential? user =
          await FirebaseAuth.instance.signInWithEmailLink(
        email: userEmail,
        emailLink: link.toString(),
      );
      if (user != null) {
        print(user.credential);
        userController.email.clear();
      }
    } else {
      print("link is null");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Passwordless Sign In',
            style: GoogleFonts.montserrat(
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
        backgroundColor: primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: ListView(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 20,
                ),
                Text(
                    "Remember, this action is only possible if your email is logged in in the device's mail app, otherwise, reset your password",
                    style: GoogleFonts.montserrat(
                      color: Colors.black.withOpacity(0.4),
                      fontSize: 12,
                    )),
                SizedBox(
                  height: 40,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      // Add TextFormFields and ElevatedButton here.
                      Container(
                        color: Color.fromARGB(255, 249, 253, 255),
                        child: TextFormField(
                          controller: userController.email,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              labelText: 'Email Address',
                              labelStyle: GoogleFonts.montserrat(
                                  color: Colors.black.withOpacity(0.3),
                                  fontSize: 13),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none)),
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
                        height: 10,
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              textStyle: GoogleFonts.montserrat(
                                  color: Colors.white, fontSize: 13),),
                          onPressed: () {
                            // Validate returns true if the form is valid, or false otherwise.
                            if (_formKey.currentState!.validate()) {
                              signInWithEmailandLink(
                                  userController.email.text.trim());
                            }
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.95,
                            margin: EdgeInsets.all(15.0),
                            padding: EdgeInsets.all(3.0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                                child: Text(
                              "Submit",
                              style: GoogleFonts.montserrat(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500),
                            )),
                          )),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                        onPressed: () {
                          Get.to(() => ResetPassword(),
                              transition: Transition.rightToLeft);
                        },
                        child: Text("Reset Password",
                            style: GoogleFonts.montserrat(
                                color: Colors.black.withOpacity(0.5),
                                fontSize: 14,
                                fontWeight: FontWeight.bold))),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
