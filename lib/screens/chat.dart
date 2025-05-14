// import 'package:bridge_ai/models/model.dart';
// import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:intl/intl.dart';
// import 'package:google_fonts/google_fonts.dart';

// class ChatPage2 extends StatefulWidget {
//   final String character;

//   const ChatPage2({
//     Key key,
//     @required this.character,
//   });

//   @override
//   State<StatefulWidget> createState() {
//     return _ChatPage2State();
//   }
// }

// class _ChatPage2State extends State<ChatPage2> {
//   OpenAI _openAI;
//   bool _isLoading;

//   final TextEditingController _textController = TextEditingController();
//   List<ChatMessage> _messages;

//   @override
//   void initState() {
//     _messages = [];
//     _isLoading = false;

//     // Initialize ChatGPT SDK
//     _openAI = OpenAI.instance.build(
//       token: dotenv.env['OPENAI_API_KEY'],
//       baseOption: HttpSetup(
//         receiveTimeout: const Duration(seconds: 30),
//       ),
//     );

//     // This tells ChatGPT what his role is
//     _handleInitialMessage(
//       'You are a ${widget.character.toLowerCase()} chatbot and have a wide knowledge about anything concerning pregnancy and please do not make it obvious that you are a chatbot. Seem and answer with experience but know we already put a disclaimer that you do not have answers to all. Please send a super short intro message. Your name is Bri. You are a chatbot that can provide medical advice and some personal opinions but only in the field concerning health and pregnancy but in case of tough situations, you can recommend the patient to a nurse under Bridge Mom because are integrated in an app called Bridge Mom. Bridge Mom is a mobile application that empowers and guides pregnant women throught their pregnancy journey',
//     );
//     super.initState();
//   }

//   Future<void> _handleInitialMessage(String character) async {
//     setState(() {
//       _isLoading = true;
//     });

//     final request = ChatCompleteText(
//       messages: [
//         Map.of({"role": "assistant", "content": character})
//       ],
//       maxToken: 180,
//       model: ChatModel.chatGptTurbo0301Model,
//     );

//     final response = await _openAI.onChatCompletion(request: request);

//     ChatMessage message = ChatMessage(
//       text: response.choices.first.message.content.trim().replaceAll('"', ''),
//       isSentByMe: false,
//       timestamp: DateTime.now(),
//     );

//     setState(() {
//       _messages.insert(0, message);
//       _isLoading = false;
//     });
//   }

//   Future<void> _handleSubmit(String text) async {
//     setState(() {
//       _isLoading = true;
//     });
//     _textController.clear();

//     // Add the user sent message to the thread
//     ChatMessage prompt = ChatMessage(
//       text: text,
//       isSentByMe: true,
//       timestamp: DateTime.now(),
//     );

//     setState(() {
//       _messages.insert(0, prompt);
//     });

//     // Handle ChatGPT request and response
//     final request = ChatCompleteText(
//       messages: [
//         Map.of({"role": "user", "content": text})
//       ],
//       maxToken: 180,
//       model: ChatModel.chatGptTurbo0301Model,
//     );
//     final response = await _openAI.onChatCompletion(request: request);

//     // Add the user received message to the thread
//     ChatMessage message = ChatMessage(
//       text: response.choices.first.message.content.trim(),
//       isSentByMe: false,
//       timestamp: DateTime.now(),
//     );

//     setState(() {
//       _messages.insert(0, message);
//       _isLoading = false;
//     });
//   }

//   Widget _buildChatList() {
//     return Flexible(
//       child: ListView.builder(
//         padding: const EdgeInsets.all(8.0),
//         reverse: true,
//         itemCount: _messages.length,
//         itemBuilder: (_, int index) {
//           ChatMessage message = _messages[index];
//           return _buildChatBubble(message);
//         },
//       ),
//     );
//   }

//   Widget _buildChatComposer() {
//     return Container(
//       margin: const EdgeInsets.symmetric(
//         horizontal: 8,
//         vertical: 12,
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: TextField(
//               controller: _textController,
//               decoration: InputDecoration.collapsed(
//                 hintText: 'Type a message',
//                 enabled: !_isLoading,
//               ),
//               // Add this to handle submission when user presses done
//               onSubmitted: _isLoading ? null : _handleSubmit,
//             ),
//           ),
//           IconButton(
//             icon: const Icon(Icons.send),
//             // Add this to handle submission when user presses the send icon
//             onPressed: _isLoading
//                 ? null
//                 : () => _handleSubmit(
//                       _textController.text,
//                     ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildChatBubble(ChatMessage message) {
//     final isSentByMe = message.isSentByMe;
//     final dateFormat = DateFormat('MMM d, yyyy');
//     final timeFormat = DateFormat('h:mm a');

//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 10.0),
//       child: Row(
//         mainAxisAlignment:
//             isSentByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Flexible(
//             child: Container(
//               margin: isSentByMe
//                   ? const EdgeInsets.only(left: 100)
//                   : const EdgeInsets.only(right: 100),
//               decoration: BoxDecoration(
//                 color: isSentByMe ? Colors.blue : Colors.grey[300],
//                 borderRadius: BorderRadius.only(
//                   topLeft: const Radius.circular(12.0),
//                   topRight: const Radius.circular(12.0),
//                   bottomLeft: isSentByMe
//                       ? const Radius.circular(12.0)
//                       : const Radius.circular(0.0),
//                   bottomRight: isSentByMe
//                       ? const Radius.circular(0.0)
//                       : const Radius.circular(12.0),
//                 ),
//               ),
//               padding: const EdgeInsets.symmetric(
//                 horizontal: 16,
//                 vertical: 10,
//               ),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     isSentByMe ? 'You' : 'Bri',
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       color: isSentByMe ? Colors.white : Colors.black,
//                     ),
//                   ),
//                   const SizedBox(height: 12),
//                   Text(
//                     message.text,
//                     style: TextStyle(
//                       color: isSentByMe ? Colors.white : Colors.black,
//                     ),
//                   ),
//                   const SizedBox(height: 12),
//                   Text(
//                     '${dateFormat.format(message.timestamp)} at ${timeFormat.format(message.timestamp)}',
//                     style: TextStyle(
//                       color: isSentByMe ? Colors.white : Colors.black87,
//                       fontSize: 8,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: GestureDetector(
//           onTap: () {
//             Navigator.of(context).pop();
//           },
//           child: const Icon(
//             Icons.arrow_back_ios,
//             color: Colors.black87,
//           ),
//         ),
//         title: Text('Bri',
//             style: GoogleFonts.poppins(
//               color: Colors.black.withOpacity(0.6),
//               fontSize: 12,
//             )),
//         backgroundColor: Colors.white,
//         elevation: 0,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.only(bottom: 32),
//         child: Stack(
//           children: [
//             Column(
//               children: [
//                 _buildChatList(),
//                 const Divider(height: 1.0),
//                 Container(
//                   decoration: BoxDecoration(
//                     color: Theme.of(context).cardColor,
//                   ),
//                   child: _buildChatComposer(),
//                 ),
//               ],
//             ),
//             if (_isLoading)
//               Center(
//                 child: Container(
//                   margin: const EdgeInsets.all(20),
//                   child: const CircularProgressIndicator(
//                     color: Colors.blue,
//                     strokeWidth: 0,
//                   ),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
