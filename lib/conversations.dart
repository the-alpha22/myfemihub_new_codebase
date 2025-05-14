import 'dart:math';

import 'package:bridge_ai/chatpage.dart';
import 'package:bridge_ai/constants/controllers.dart';
import 'package:bridge_ai/controllers/messageusers.dart';
import 'package:bridge_ai/models/user.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Conversations extends StatefulWidget {
  @override
  State<Conversations> createState() => _ConversationsState();
}

class _ConversationsState extends State<Conversations> {
  Random random = new Random();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Conversations',
            style: GoogleFonts.poppins(
              color: Colors.black.withOpacity(0.8),
              fontSize: 13,
            )),
        elevation: 0,
        backgroundColor: Color.fromARGB(255, 224, 241, 255),
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black.withOpacity(0.7),
              size: 18,
            )),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                if (userController.userModel.value!.chatids == null ||
                    userController.userModel.value!.chatids == []) ...[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(.25),
                              blurRadius: 16)
                        ]),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8),
                          ),
                          child: Image.asset(
                            "images/chat.jpg",
                            width: MediaQuery.of(context).size.width,
                          ),
                        ),
                        SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 2),
                          child: Text(
                              "Your messages or conversations will appear here",
                              style: GoogleFonts.poppins(
                                  color: Colors.black.withOpacity(0.8),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500)),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 2),
                          child: Text("This is a safe space for health",
                              style: GoogleFonts.poppins(
                                color: Colors.black.withOpacity(0.8),
                                fontSize: 12,
                              )),
                        ),
                        SizedBox(height: 10)
                      ],
                    ),
                  ),
                ],
                if (userController.userModel.value!.chatids != null &&
                    userController.userModel.value!.chatids != []) ...[
                  StreamBuilder(
                    stream: UserMessageController.instance
                        .getUserChat(userController.userModel.value!.id),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<UserModel>> snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: Text(
                            "Oops, nothing here",
                            style: GoogleFonts.poppins(
                              color: Colors.black54,
                              fontSize: 12,
                            ),
                          ),
                        );
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(
                            child: CircularProgressIndicator(
                          color: Colors.black,
                        ));
                      }
                      return Wrap(
                        children: snapshot.data!.map((UserModel user) {
                          return InkWell(
                            onTap: () {
                              Get.to(
                                  () => ChatPage(
                                        id: user.id,
                                        name: "${user.name.capitalize}",
                                      ),
                                  transition: Transition.rightToLeft);
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                child: Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: Image.asset(
                                            "images/request.jpg",
                                            height: 45,
                                            width: 45,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Container(
                                              child: Text(
                                                  "${user.name.capitalize}",
                                                  style: GoogleFonts.poppins(
                                                      color: Colors.black
                                                          .withOpacity(0.65),
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500)),
                                            ),
                                            Container(
                                              child: Text("Tap to chat",
                                                  style: GoogleFonts.poppins(
                                                      color: Colors.black
                                                          .withOpacity(0.4),
                                                      fontSize: 11,
                                                      fontWeight:
                                                          FontWeight.w400)),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Divider()
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ],
                SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
