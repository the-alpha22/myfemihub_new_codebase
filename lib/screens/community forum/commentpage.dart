import 'dart:math';

import 'package:bridge_ai/constants/app_constants.dart';
import 'package:bridge_ai/constants/controllers.dart';
import 'package:bridge_ai/models/story.dart';
import 'package:bridge_ai/widgets/helpers/showLoading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AddComment extends StatefulWidget {
  const AddComment({Key? key, required this.story}) : super(key: key);
  final StoryModel story;

  @override
  State<AddComment> createState() => _AddComment();
}

class _AddComment extends State<AddComment> {
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
        iconTheme: IconThemeData(color: Colors.black),
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
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        'images/profile.jpg',
                        height: 40,
                        width: 40,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Anonymous",
                            style: GoogleFonts.poppins(
                              color: Colors.black.withOpacity(0.8),
                              fontSize: 13,
                            )),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.45,
                          child: Text(
                            "What is your say ${userController.userModel.value!.name.capitalize}",
                            style: GoogleFonts.poppins(
                              color: Colors.black.withOpacity(0.6),
                              fontSize: 11,
                            ),
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 10,
                ),
                Divider(),
                SizedBox(
                  height: 10,
                ),
                Text(widget.story.details,
                    style: GoogleFonts.poppins(
                      color: Colors.black.withOpacity(0.4),
                      fontSize: 13,
                    )),
                SizedBox(
                  height: 10,
                ),
                Divider(),
                SizedBox(
                  height: 10,
                ),
                Text(
                    "What's your say ${userController.userModel.value!.name.capitalize}",
                    style: GoogleFonts.poppins(
                      color: Colors.black.withOpacity(0.8),
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
                      Text("Comment",
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
                            autofocus: true,
                            decoration: InputDecoration(
                                hintText: 'Write your comment',
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
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              showLoading(context);
                              await FirebaseFirestore.instance
                                  .collection('comments')
                                  .add({
                                "storyId": widget.story.id,
                                "comment": _issue.text.trim(),
                                "time": Timestamp.now(),
                                "id": DateTime.now().toIso8601String(),
                                "userId": userController.userModel.value!.id
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Your say was added')),
                              );
                              dismissLoadingWidget();
                              Get.back();
                            }
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            margin: EdgeInsets.all(15.0),
                            padding: EdgeInsets.all(3.0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                              child: Text("Share Comment",
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
                  height: 10,
                ),
                Text(
                    "Don't worry, non of your personal details will be displayed",
                    style: GoogleFonts.poppins(
                      color: Colors.black.withOpacity(0.5),
                      fontSize: 13,
                    )),
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
