import 'dart:math';

import 'package:bridge_ai/constants/app_constants.dart';
import 'package:bridge_ai/constants/controllers.dart';
import 'package:bridge_ai/widgets/helpers/showLoading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';

class AddPostPage extends StatefulWidget {
  const AddPostPage({Key? key}) : super(key: key);

  @override
  State<AddPostPage> createState() => _AddPostPage();
}

class _AddPostPage extends State<AddPostPage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _issue = TextEditingController();

  final Random random = new Random();
  String anonymous = "";

  void _submit() {
    _issue.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: 18),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text(
          'Post Something',
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w500,
            fontSize: 12,
            color: Colors.white,
          ),
        ),
        elevation: 0,
        backgroundColor: primaryColor,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 10),
                Text(
                  "Sharing your pregnancy journey, tips or findings to the world can mean alot to women community because they can alot from you",
                  style: GoogleFonts.montserrat(
                    color: Colors.black.withOpacity(0.4),
                    fontSize: 13,
                  ),
                ),
                SizedBox(height: 20),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // Add TextFormFields and ElevatedButton here.
                      Text(
                        "Message",
                        style: GoogleFonts.montserrat(
                          color: Colors.black.withOpacity(0.6),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _issue,
                        keyboardType: TextInputType.multiline,
                        maxLines: 5,
                        decoration: InputDecoration(
                          hintText: 'Your Experience or Question',
                          hintStyle: GoogleFonts.montserrat(
                            color: Colors.black.withOpacity(0.4),
                            fontSize: 13,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(7),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      InkWell(
                        onTap: () async {
                          // Validate returns true if the form is valid, or false otherwise.
                          if (_formKey.currentState!.validate()) {
                            // If the form is valid, display a snackbar. In the real world,
                            // you'd often call a server or save the information in a database.
                            showLoading(context);
                            bool status = false;
                            anonymous == "true"
                                ? status = true
                                : status = false;
                            final issue = _issue.text;
                            final id = Uuid().v1().toString();
                            Map<String, dynamic> data = {
                              "id": id,
                              "time": Timestamp.now(),
                              "details": issue,
                              "userId": userController.userModel.value!.id,
                              "views": 0,
                              "anonymous": status,
                              "category": userController.userModel.value!.stage,
                              "likes": 0,
                              "comments": 0,
                            };
                            await FirebaseFirestore.instance
                                .collection("stories")
                                .doc(id)
                                .set(data);
                            _submit();
                            Get.snackbar(
                              "Successfully Submitted",
                              "Your story has been sent",
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Successfully Submitted'),
                              ),
                            );
                            dismissLoadingWidget();
                            Get.offAllNamed("/community");
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                "Post",
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
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
