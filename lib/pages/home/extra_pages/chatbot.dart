import 'package:bridge_ai/constants/app_constants.dart';
import 'package:bridge_ai/constants/controllers.dart';
import 'package:bridge_ai/controllers/ai_controller.dart';
import 'package:bridge_ai/controllers/chatbot_conversations.dart';
import 'package:bridge_ai/models/chatbot_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:lottie/lottie.dart';
import 'package:uuid/uuid.dart';

class ChatBotPage extends StatefulWidget {
  const ChatBotPage({Key? key}) : super(key: key);

  @override
  State<ChatBotPage> createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotPage> {
  @override
  void initState() {
    super.initState();
    getMessages();
  }

  getMessages() async {
    List<ChatBotMessageModel> conversation =
        await ChatBotConversationsController.instance
            .getConversationMessages(userController.userModel.value!.id);

    if (conversation.isNotEmpty) {
      setState(() {
        conversation = conversation.reversed.toList();
        messages.clear();
      });
      for (var message in conversation) {
        if (message.userId == userController.userModel.value!.id) {
          setState(() {
            messages.insert(0, {
              "id": message.id,
              "userId": user.id,
              "message": message.message,
              "dateCreated": message.dateCreated
            });
          });
        } else {
          setState(() {
            messages.insert(0, {
              "id": message.id,
              "userId": partner.id,
              "message": message.message,
              "dateCreated": message.dateCreated
            });
          });
        }
      }
    }

    setState(() {
      loading = false;
    });
    if (messages.isEmpty) {
      setState(() {
        isAityping = true;
      });
      getChatBotResponse();
    }
  }

  // List<types.Message> _messages = [];
  final user = types.User(
      id: userController.userModel.value!.id,
      firstName: userController.userModel.value!.name);
  final partner = types.User(id: "chatbot", firstName: "Femi AI");

  void addMessage(types.Message message, String text) async {
    setState(() {
      messages.insert(0, {
        "id": message.id,
        "userId": message.author.id,
        "message": text,
        "dateCreated":
            Timestamp.fromMillisecondsSinceEpoch(message.createdAt!).toDate()
      });
    });
    await addConversationMessage(
        userController.userModel.value!.id,
        message.id,
        message.author.id,
        text,
        Timestamp.fromMillisecondsSinceEpoch(message.createdAt!).toDate());
    setState(() {});
  }

  void _handleSendPressed(types.PartialText message) async {
    setState(() {
      isAityping = true;
    });
    final textMessage = types.TextMessage(
      author: user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );

    // _addMessage(textMessage);
    addMessage(textMessage, message.text);
    setState(() {});
    Future.delayed(Duration(seconds: 2), () {
      getChatBotResponse();
    });
  }

  getChatBotResponse() async {
    if (messages.isEmpty) {
      String response = await generateChatbotResponse(
        userController.userModel.value!,
        [],
        context,
      );
      final textMessage = types.TextMessage(
        author: partner,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: const Uuid().v4(),
        text: response.replaceAll('''!''', ""),
      );
      addMessage(textMessage, textMessage.text);
    } else {
      await getMessages();

      String response = await generateChatbotResponse(
        userController.userModel.value!,
        messages,
        context,
      );
      final textMessage = types.TextMessage(
          author: partner,
          createdAt: DateTime.now().millisecondsSinceEpoch,
          id: const Uuid().v4(),
          text: response.replaceAll('''!''', ""));
      addMessage(textMessage, textMessage.text);
    }
    setState(() {
      isAityping = false;
    });
  }

  List messages = [];

  TextEditingController responseMessage = TextEditingController();
  bool isAityping = false;
  bool loading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Lottie.asset('images/ai.json', height: 80),
            ),
            Text("Femi AI",
                style: GoogleFonts.montserrat(
                    color: Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.w600)),
          ],
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 19,
            color: Colors.black87,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: loading
          ? Container(
              height: 220,
              width: 500,
              child: const Center(
                  child: CircularProgressIndicator(
                strokeWidth: 0,
              )),
            )
          : Padding(
              padding: const EdgeInsets.all(12.0),
              child: Stack(
                children: [
                  ListView.builder(
                    reverse: true, // Display messages from bottom to top
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      final bool isSentByMe =
                          message["userId"] == user.id ? true : false;

                      return isSentByMe
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                MessageSentByMe(message: message),
                                SizedBox(
                                  height: 8,
                                ),
                                if (index == 0) ...{
                                  SizedBox(
                                    height: 160,
                                  ),
                                },
                              ],
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                MessageRecievedByUser(message: message),
                                SizedBox(
                                  height: 8,
                                ),
                                if (index == 0) ...{
                                  SizedBox(
                                    height: 110,
                                  ),
                                },
                              ],
                            );
                    },
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (isAityping) ...{
                          Padding(
                            padding: const EdgeInsets.only(right: 80),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      color: bgcolor,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10),
                                          bottomRight: Radius.circular(10))),
                                  child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Text("Femi AI is typing...",
                                          style: GoogleFonts.montserrat(
                                            color:
                                                Colors.black.withOpacity(0.8),
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                          ))),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                              ],
                            ),
                          ),
                        },
                        Container(
                          padding: EdgeInsets.only(left: 5, bottom: 5, top: 5),
                          height: 80,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: bgcolor,
                              borderRadius: BorderRadius.circular(8)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: TextFormField(
                                    controller: responseMessage,
                                    onChanged: (value) {
                                      setState(() {});
                                    },
                                    keyboardType: TextInputType.multiline,
                                    minLines:
                                        1, // Set the minimum number of lines to 1
                                    maxLines: null,
                                    decoration: InputDecoration(
                                        hintText: "Chat with Femi AI...",
                                        hintStyle: GoogleFonts.montserrat(
                                            color:
                                                Colors.black.withOpacity(0.3),
                                            fontSize: 12),
                                        border: InputBorder.none),
                                  ),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                FloatingActionButton(
                                  onPressed: () async {
                                    _handleSendPressed(types.PartialText(
                                        text: responseMessage.text.trim()));
                                    setState(() {
                                      responseMessage.clear();
                                    });
                                  },
                                  child: Icon(
                                    Icons.send,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                  backgroundColor:
                                      responseMessage.text.trim().isNotEmpty
                                          ? primaryColor
                                          : primaryColor.withOpacity(.7),
                                  elevation: 0,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class MessageSentByMe extends StatefulWidget {
  const MessageSentByMe({Key? key, required this.message}) : super(key: key);
  final message;

  @override
  State<MessageSentByMe> createState() => _MessageSentByMeState();
}

class _MessageSentByMeState extends State<MessageSentByMe> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 80),
      child: Container(
        decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(10))),
        child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text("${widget.message["message"]}",
                textAlign: TextAlign.start,
                style: GoogleFonts.montserrat(
                  color: Colors.white.withOpacity(0.8),
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ))),
      ),
    );
  }
}

class MessageRecievedByUser extends StatefulWidget {
  const MessageRecievedByUser({Key? key, required this.message})
      : super(key: key);
  final message;

  @override
  State<MessageRecievedByUser> createState() => _MessageRecievedByUserState();
}

class _MessageRecievedByUserState extends State<MessageRecievedByUser> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 80),
      child: Container(
        decoration: BoxDecoration(
            color: bgcolor,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomRight: Radius.circular(10))),
        child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: SelectableText("${widget.message["message"]}",
                style: GoogleFonts.montserrat(
                  color: Colors.black.withOpacity(0.8),
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ))),
      ),
    );
  }
}
