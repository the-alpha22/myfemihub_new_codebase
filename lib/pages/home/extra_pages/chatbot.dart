import 'dart:convert';

import 'package:bridge_ai/constants/app_constants.dart';
import 'package:bridge_ai/constants/controllers.dart';
import 'package:bridge_ai/controllers/ai_controller.dart';
import 'package:bridge_ai/controllers/chatbot_conversations.dart';
import 'package:bridge_ai/models/chatbot_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:lottie/lottie.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:uuid/uuid.dart';

class ChatBotPage extends StatefulWidget {
  const ChatBotPage({Key? key}) : super(key: key);

  @override
  State<ChatBotPage> createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotPage> {
  final user = types.User(
    id: userController.userModel.value!.id,
    firstName: userController.userModel.value!.name,
  );
  final partner = types.User(id: "chatbot", firstName: "Femi AI");

  List messages = [];
  TextEditingController responseMessage = TextEditingController();
  bool isAityping = false;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    getMessages();
  }

  Future<void> getMessages() async {
    List<ChatBotMessageModel> conversation =
        await ChatBotConversationsController.instance.getConversationMessages(
          userController.userModel.value!.id,
        );

    if (conversation.isNotEmpty) {
      setState(() {
        conversation = conversation.reversed.toList();
        messages.clear();
      });
      for (var message in conversation) {
        setState(() {
          messages.insert(0, {
            "id": message.id,
            "userId":
                message.userId == userController.userModel.value!.id
                    ? user.id
                    : partner.id,
            "message": message.message,
            "dateCreated": message.dateCreated,
            "citation": message.citation,
          });
        });
      }
    }

    setState(() => loading = false);
    if (messages.isEmpty) {
      setState(() => isAityping = true);
      getChatBotResponse();
    }
  }

  void addMessage(types.Message message, String text, var citation) async {
    setState(() {
      messages.insert(0, {
        "id": message.id,
        "userId": message.author.id,
        "message": text,
        "dateCreated":
            Timestamp.fromMillisecondsSinceEpoch(message.createdAt!).toDate(),
        "citation": citation,
      });
    });
    await addConversationMessage(
      userController.userModel.value!.id,
      message.id,
      message.author.id,
      text,
      Timestamp.fromMillisecondsSinceEpoch(message.createdAt!).toDate(),
      citation,
    );
  }

  void _handleSendPressed(types.PartialText message) async {
    if (message.text.trim().isEmpty) return;
    setState(() => isAityping = true);
    final textMessage = types.TextMessage(
      author: user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );
    addMessage(textMessage, message.text, null);
    Future.delayed(const Duration(seconds: 2), getChatBotResponse);
  }

  Future<void> getChatBotResponse() async {
    if (messages.isEmpty) {
      String response = await VertexAIController.generateChatbotResponse(
        userController.userModel.value!,
        [],
        context,
      );
      final result = extractCittionResponse(response);
      final textMessage = types.TextMessage(
        author: partner,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: const Uuid().v4(),
        text: result['message'].toString().replaceAll('!', ""),
      );
      addMessage(textMessage, textMessage.text, result['citation']);
    } else {
      await getMessages();
      String response = await VertexAIController.generateChatbotResponse(
        userController.userModel.value!,
        messages,
        context,
      );
      final result = extractCittionResponse(response);
      final textMessage = types.TextMessage(
        author: partner,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: const Uuid().v4(),
        text: result['message'].toString().replaceAll('!', ""),
      );
      addMessage(textMessage, textMessage.text, result['citation']);
    }
    setState(() => isAityping = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        toolbarHeight: 64,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 18,
            color: Colors.black87,
          ),
          onPressed: () => Get.back(),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: primaryColor.withOpacity(0.2),
                  width: 1.5,
                ),
              ),
              child: ClipOval(
                child: Lottie.asset('images/ai.json', fit: BoxFit.cover),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Femi AI',
                  style: GoogleFonts.montserrat(
                    color: Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  isAityping ? 'Typing...' : 'Online',
                  style: GoogleFonts.montserrat(
                    color: isAityping ? primaryColor : Colors.black38,
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ],
        ),
        centerTitle: false,
      ),
      body: loading ? _buildLoading() : _buildChat(),
      bottomNavigationBar: _buildDisclaimer(),
    );
  }

  Widget _buildLoading() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(strokeWidth: 1.5, color: primaryColor),
          const SizedBox(height: 16),
          Text(
            'Loading conversation...',
            style: GoogleFonts.montserrat(color: Colors.black38, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildChat() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            reverse: true,
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            itemCount: messages.length + (isAityping ? 1 : 0),
            itemBuilder: (context, index) {
              if (isAityping && index == 0) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildTypingBubble(),
                );
              }
              final message = messages[isAityping ? index - 1 : index];
              final bool isMine = message["userId"] == user.id;
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: (isMine
                        ? _buildSentMessage(message)
                        : _buildReceivedMessage(message))
                    .animate()
                    .fadeIn(duration: 300.ms, curve: Curves.easeOut)
                    .slideY(
                      begin: 0.08,
                      end: 0,
                      duration: 300.ms,
                      curve: Curves.easeOut,
                    ),
              );
            },
          ),
        ),
        _buildInputBar(),
      ],
    );
  }

  Widget _buildSentMessage(Map message) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.72,
        ),
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(4),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Text(
          message["message"],
          style: GoogleFonts.montserrat(
            color: Colors.white,
            fontWeight: FontWeight.w400,
            fontSize: 14,
            height: 1.5,
          ),
        ),
      ),
    );
  }

  Widget _buildReceivedMessage(Map message) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.72,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(16),
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: SelectableText(
              message["message"],
              style: GoogleFonts.montserrat(
                color: Colors.black87,
                fontWeight: FontWeight.w400,
                fontSize: 14,
                height: 1.55,
              ),
            ),
          ),
          if (message["citation"] != null) ...[
            const SizedBox(height: 6),
            _buildSourceChip(message["citation"]),
          ],
        ],
      ),
    );
  }

  Widget _buildTypingBubble() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            3,
            (i) => Container(
                  margin: EdgeInsets.only(right: i < 2 ? 5 : 0),
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                )
                .animate(onPlay: (c) => c.repeat())
                .fadeIn(delay: (150 * i).ms, duration: 400.ms)
                .then()
                .fadeOut(duration: 400.ms),
          ),
        ),
      ),
    );
  }

  Widget _buildSourceChip(Map citation) {
    return GestureDetector(
      onTap: () {
        final sources = citation["sources"] ?? [];
        openLink(
          sources.isEmpty ? "https://www.who.int/news" : sources.first["url"],
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: primaryColor.withOpacity(0.06),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: primaryColor.withOpacity(0.2), width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(PhosphorIcons.link, size: 12, color: primaryColor),
            const SizedBox(width: 5),
            Text(
              'View source',
              style: GoogleFonts.montserrat(
                color: primaryColor,
                fontWeight: FontWeight.w600,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: responseMessage,
                onChanged: (_) => setState(() {}),
                keyboardType: TextInputType.multiline,
                minLines: 1,
                maxLines: 4,
                textInputAction: TextInputAction.send,
                onSubmitted: (value) {
                  if (value.trim().isNotEmpty) {
                    _handleSendPressed(types.PartialText(text: value.trim()));
                    responseMessage.clear();
                  }
                },
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  color: Colors.black87,
                ),
                decoration: InputDecoration(
                  hintText: 'Ask Femi AI...',
                  hintStyle: GoogleFonts.montserrat(
                    color: Colors.black26,
                    fontSize: 14,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color:
                  responseMessage.text.trim().isNotEmpty
                      ? primaryColor
                      : const Color(0xFFF5F5F5),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () {
                if (responseMessage.text.trim().isNotEmpty) {
                  _handleSendPressed(
                    types.PartialText(text: responseMessage.text.trim()),
                  );
                  responseMessage.clear();
                }
              },
              icon: Icon(
                Icons.send_rounded,
                size: 18,
                color:
                    responseMessage.text.trim().isNotEmpty
                        ? Colors.white
                        : Colors.black26,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDisclaimer() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Icon(PhosphorIcons.info, size: 13, color: Colors.black26),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                'Not a substitute for professional medical advice. Info sourced from WHO & CDC.',
                style: GoogleFonts.montserrat(
                  color: Colors.black26,
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Map<String, dynamic> extractCittionResponse(String aiOutput) {
  final regex = RegExp(r'```json\s*([\s\S]*?)\s*```', multiLine: true);
  final match = regex.firstMatch(aiOutput);
  if (match != null) {
    final jsonPart = match.group(1)?.trim() ?? '';
    final message = aiOutput.replaceFirst(regex, '').trim();
    try {
      final citation = json.decode(jsonPart);
      return {'message': message, 'citation': citation};
    } catch (e) {
      return {'message': message, 'citation': null};
    }
  }
  return {'message': aiOutput.trim(), 'citation': null};
}
