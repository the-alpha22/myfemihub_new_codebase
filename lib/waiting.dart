import 'dart:async';
import 'package:bridge_ai/constants/controllers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Waiting extends StatefulWidget {
  @override
  State<Waiting> createState() => _WaitingState();
}

class _WaitingState extends State<Waiting> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      if (userController.userModel.value != null) {
        Get.offAllNamed("/home");
      } else {
        userController.signOut();
        print("\n====User seems null, sigining out from Redirect page======\n");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Center(child: Image.asset("images/logo_text.png", height: 80)),
        ],
      ),
    );
  }
}
