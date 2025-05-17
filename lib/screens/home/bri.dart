// import 'dart:async';
// import 'package:bridge_ai/constants/app_constants.dart';
// import 'package:bridge_ai/constants/controllers.dart';
// import 'package:bridge_ai/screens/home/chatbubble.dart';
// // import 'package:dialogflow_grpc/dialogflow_grpc.dart';
// // import 'package:dialogflow_grpc/generated/google/cloud/dialogflow/v2beta1/session.pb.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:icony/icony_ikonate.dart';

// class ChatBotScreen extends StatefulWidget {
//   const ChatBotScreen({Key? key}) : super(key: key);

//   @override
//   State<ChatBotScreen> createState() => _ChatBotScreenState();
// }

// class _ChatBotScreenState extends State<ChatBotScreen> {
//   // message text controller
//   final TextEditingController _textController = TextEditingController();

//   // list of messages that will be displayed on the screen
//   final List<ChatMessage> _messages = <ChatMessage>[];

//   // for changing recording icon

//   late DialogflowGrpcV2Beta1 dialogflow;

//   @override
//   void initState() {
//     super.initState();
//     initPlugin();
//     ChatMessage botMessage = ChatMessage(
//       text:
//           "Hello ${userController.userModel.value!.name.capitalize}, how can I be of help today ?",
//       name: "Bri",
//       type: false,
//     );
//     setState(() {
//       _messages.insert(0, botMessage);
//     });
//   }

//   Future<void> initPlugin() async {
//     // initializing speech t otext plugin

//     // requiried for setting up dialogflow
//     final serviceAccount = ServiceAccount.fromString(
//       await rootBundle.loadString(
//         'images/bridgeai-e6529-a1067e94e977.json',
//       ),
//     );

//     // dialogflow setup
//     dialogflow = DialogflowGrpcV2Beta1.viaServiceAccount(serviceAccount);
//     setState(() {});
//   }

//   void stopStream() async {}

//   void handleSubmitted(text) async {
//     _textController.clear();

//     ChatMessage message = ChatMessage(
//       text: text,
//       name: "${userController.userModel.value!.name.capitalize}",
//       type: true,
//     );

//     setState(() {
//       _messages.insert(0, message);
//     });

//     // callling dialogflow api
//     DetectIntentResponse data = await dialogflow.detectIntent(text, 'en-US');

//     // getting meaningful response text
//     String fulfillmentText = data.queryResult.fulfillmentText;
//     if (fulfillmentText.isNotEmpty) {
//       ChatMessage botMessage = ChatMessage(
//         text: fulfillmentText,
//         name: "Bri",
//         type: false,
//       );

//       setState(() {
//         _messages.insert(0, botMessage);
//       });

//       if (data.queryResult.action == 'scheduleAppointment') {
//         // Save appointment to Firestore
//         // await appointmentsCollection.add({
//         //   'date': appointmentDate,
//         //   'time': appointmentTime,
//         // });

//         setState(() {
//           _messages.insert(
//               0,
//               ChatMessage(
//                 text: 'Your appointment has been scheduled for ....',
//                 name: "Bri",
//                 type: false,
//               ));
//         });
//       } else if (data.queryResult.action == 'doctorAssignment') {
//         // Save appointment to Firestore
//         // await appointmentsCollection.add({
//         //   'date': appointmentDate,
//         //   'time': appointmentTime,
//         // });

//         setState(() {
//           _messages.insert(
//               0,
//               ChatMessage(
//                 text: 'Your were assigned ....',
//                 name: "Bri",
//                 type: false,
//               ));
//         });
//       } else {}
//     }
//   }

//   // void _onSpeechResult(SpeechRecognitionResult result) async {
//   //   String lastWords = result.recognizedWords;

//   //   // setting textediting controller to the speech value and moving cursor at the end
//   //   _textController.text = lastWords;
//   //   _textController.selection = TextSelection.collapsed(
//   //     offset: _textController.text.length,
//   //   );

//   //   setState(() {
//   //     _isRecording = false;
//   //   });
//   //   await Future.delayed(const Duration(seconds: 5));
//   //   _stopListening();
//   // }

//   // void handleStream() async {
//   //   setState(() {
//   //     _isRecording = true;
//   //   });
//   //   await speechToText.listen(
//   //     onResult: _onSpeechResult,
//   //   );
//   // }

//   // void _stopListening() async {
//   //   await speechToText.stop();
//   // }

//   @override
//   void dispose() {
//     // _recorderStatus.cancel();
//     // _audioStreamSubscription.cancel();
//     // speechToText.stop();
//     super.dispose();
//   }

//   // The chat interface
//   //
//   //------------------------------------------------------------------------------------
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Bri',
//             style: GoogleFonts.poppins(
//               color: Colors.black.withOpacity(0.8),
//               fontSize: 12,
//             )),
//         leading: IconButton(
//           icon: Icon(
//             Icons.arrow_back_ios,
//             size: 19,
//             color: Colors.black.withOpacity(0.6),
//           ),
//           onPressed: () {
//             Get.back();
//           },
//         ),
//         elevation: 0,
//         backgroundColor: primaryColor,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             Flexible(
//               child: ListView.builder(
//                 padding: const EdgeInsets.all(8.0),
//                 reverse: true,
//                 itemBuilder: (ctx, int index) => _messages[index],
//                 itemCount: _messages.length,
//               ),
//             ),
//             Container(
//               height: 75,
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: <Widget>[
//                     Flexible(
//                       child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Container(
//                           child: SingleChildScrollView(
//                             child: TextField(
//                               style: GoogleFonts.poppins(
//                                 color: Colors.black.withOpacity(0.4),
//                                 fontSize: 13,
//                               ),
//                               controller: _textController,
//                               onSubmitted: handleSubmitted,
//                               maxLines: null,
//                               decoration: InputDecoration(
//                                   border: OutlineInputBorder(
//                                     borderSide: BorderSide.none,
//                                   ),
//                                   hintText: 'Type message',
//                                   hintStyle: GoogleFonts.poppins(
//                                     color: Colors.black.withOpacity(0.4),
//                                     fontSize: 12,
//                                   )),
//                               autofocus: false,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       width: 6,
//                     ),
//                     ClipRRect(
//                       borderRadius: BorderRadius.circular(12),
//                       child: Container(
//                         color: Color.fromARGB(255, 0, 150, 255),
//                         child: IconButton(
//                           icon: Ikonate(
//                             Ikonate.send,
//                             color: Colors.white,
//                           ),
//                           onPressed: () =>
//                               handleSubmitted(_textController.text),
//                           color: Colors.black.withOpacity(0.7),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               width: double.infinity,
//               decoration: BoxDecoration(color: Colors.white),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
