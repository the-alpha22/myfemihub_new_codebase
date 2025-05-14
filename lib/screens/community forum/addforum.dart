import 'dart:math';

import 'package:bridge_ai/constants/app_constants.dart';
import 'package:bridge_ai/constants/controllers.dart';
import 'package:bridge_ai/widgets/helpers/showLoading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AddStory extends StatefulWidget {
  const AddStory({Key? key}) : super(key: key);

  @override
  State<AddStory> createState() => _AddStory();
}

class _AddStory extends State<AddStory> {
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
          icon: Icon(
            Icons.arrow_back_ios,
            size: 18,
          ),
          onPressed: () {
            Get.back();
          },
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
                SizedBox(
                  height: 10,
                ),
                Text("Share your Experience",
                    style: GoogleFonts.poppins(
                        color: Colors.black.withOpacity(0.9),
                        fontSize: 18,
                        fontWeight: FontWeight.w500)),
                SizedBox(
                  height: 10,
                ),
                Text(
                    "Sharing your pregnancy journey, tips or findings to the world can mean alot to women community because they can alot from you",
                    style: GoogleFonts.poppins(
                      color: Colors.black.withOpacity(0.4),
                      fontSize: 13,
                    )),
                SizedBox(
                  height: 20,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // Add TextFormFields and ElevatedButton here.

                      Text("Message",
                          style: GoogleFonts.poppins(
                              color: Colors.black.withOpacity(0.6),
                              fontSize: 13,
                              fontWeight: FontWeight.w500)),
                      SizedBox(
                        height: 10,
                      ),
                      SingleChildScrollView(
                        child: Flexible(
                          child: TextFormField(
                            controller: _issue,
                            keyboardType: TextInputType.text,
                            maxLines: null,
                            decoration: InputDecoration(
                                hintText: 'Your Experience or Question',
                                hintStyle: GoogleFonts.poppins(
                                  color: Colors.black.withOpacity(0.4),
                                  fontSize: 13,
                                ),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7))),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              textStyle: const TextStyle(fontSize: 20),),
                          onPressed: () {
                            // Validate returns true if the form is valid, or false otherwise.
                            if (_formKey.currentState!.validate()) {
                              // If the form is valid, display a snackbar. In the real world,
                              // you'd often call a server or save the information in a database.
                              showLoading(context);
                              bool status;
                              anonymous == "true"
                                  ? status = true
                                  : status = false;
                              final issue = _issue.text;
                              final idNumb = random.nextInt(100000).toString();
                              final idnumb = "story-$idNumb$idNumb";
                              Map<String, dynamic> data = {
                                "id": idnumb,
                                "time": Timestamp.now(),
                                "details": issue,
                                "userId": userController.userModel.value!.id,
                                "views": 0,
                                "anonymous": true,
                                "category":
                                    userController.userModel.value!.stage
                              };
                              FirebaseFirestore.instance
                                  .collection("stories")
                                  .add(data);
                              _submit();
                              Get.snackbar("Successfully Submitted",
                                  "Your story has been sent");
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Successfully Submitted')),
                              );
                              dismissLoadingWidget();
                              Get.offAllNamed("/community-forum");
                            }
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            margin: EdgeInsets.all(15.0),
                            padding: EdgeInsets.all(3.0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                              child: Text("Share Your Experience to the world",
                                  style: GoogleFonts.poppins(
                                      color: Colors.white.withOpacity(0.8),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500)),
                            ),
                          )),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 10,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
