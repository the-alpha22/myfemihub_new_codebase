// import 'package:bridge_ai/constants/controllers.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

// class VideoScreen extends StatefulWidget {
//   const VideoScreen({Key? key, required this.callId});
//   final String callId;

//   @override
//   State<VideoScreen> createState() => VideoScreenState();
// }

// class VideoScreenState extends State<VideoScreen> {
//   static const _appId = 1538568175; // Your app ID here
//   static const _appSign =
//       'dad5c7ac04c7b7aa6965e0b9c684d4a0198e7ee7d0b3cd494c88073ba7454599'; // Your app sign here

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) => ZegoUIKitPrebuiltCall(
//         appID: _appId,
//         appSign: _appSign,
//         userID: userController.userModel.value!.id,
//         userName: "${userController.userModel.value!.name.capitalize}",
//         callID: widget.callId,
//         config: ZegoUIKitPrebuiltCallConfig(onHangUp: () {
//           Get.back();
//         }),
//       );
// }
