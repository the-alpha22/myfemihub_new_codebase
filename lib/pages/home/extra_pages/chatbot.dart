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

const _rose = Color(0xFFE8567A);
const _roseDark = Color(0xFFC03A5E);
const _roseSoft = Color(0xFFFFF0F4);
const _plum = Color(0xFF3D1A2E);
const _muted = Color(0xFF9E8892);
const _surface = Color(0xFFFDF7F9);

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
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool isAiTyping = false;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _inputController.addListener(() => setState(() {}));
    getMessages();
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> getMessages() async {
    List<ChatBotMessageModel> conversation =
        await ChatBotConversationsController.instance.getConversationMessages(
          userController.userModel.value!.id,
        );

    if (conversation.isNotEmpty) {
      conversation = conversation.reversed.toList();
      setState(() => messages.clear());
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
      setState(() => isAiTyping = true);
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

  void _handleSendPressed() async {
    final text = _inputController.text.trim();
    if (text.isEmpty) return;
    _inputController.clear();
    setState(() => isAiTyping = true);
    final textMessage = types.TextMessage(
      author: user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: text,
    );
    addMessage(textMessage, text, null);
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
    setState(() => isAiTyping = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _surface,
      appBar: _buildAppBar(),
      body: loading ? _buildLoading() : _buildChat(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      toolbarHeight: 68,
      leading: IconButton(
        onPressed: () => Get.back(),
        icon: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(color: _roseSoft, shape: BoxShape.circle),
          child: Icon(Icons.arrow_back_ios_new_rounded, color: _rose, size: 16),
        ),
      ),
      title: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [_rose, _roseDark],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: _rose.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
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
                style: GoogleFonts.philosopher(
                  color: _plum,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: isAiTyping ? _amber : _sage,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    isAiTyping ? 'Typing...' : 'Online',
                    style: GoogleFonts.plusJakartaSans(
                      color: isAiTyping ? _amber : _sage,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      centerTitle: false,
    );
  }

  Widget _buildLoading() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(strokeWidth: 1.5, color: _rose),
          const SizedBox(height: 16),
          Text(
            'Loading conversation...',
            style: GoogleFonts.plusJakartaSans(color: _muted, fontSize: 13),
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
            controller: _scrollController,
            reverse: true,
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            itemCount: messages.length + (isAiTyping ? 1 : 0),
            itemBuilder: (context, index) {
              if (isAiTyping && index == 0) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildTypingBubble(),
                );
              }
              final message = messages[isAiTyping ? index - 1 : index];
              final bool isMine = message["userId"] == user.id;
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: (isMine
                        ? _buildSentMessage(message)
                        : _buildReceivedMessage(message))
                    .animate()
                    .fadeIn(duration: 300.ms, curve: Curves.easeOut)
                    .slideY(
                      begin: 0.06,
                      end: 0,
                      duration: 300.ms,
                      curve: Curves.easeOut,
                    ),
              );
            },
          ),
        ),
        _buildInputBar(),
        _buildDisclaimer(),
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
          gradient: const LinearGradient(
            colors: [_rose, _roseDark],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(18),
            bottomLeft: Radius.circular(18),
            bottomRight: Radius.circular(4),
          ),
          boxShadow: [
            BoxShadow(
              color: _rose.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 11),
        child: Text(
          message["message"],
          style: GoogleFonts.plusJakartaSans(
            color: Colors.white,
            fontWeight: FontWeight.w400,
            fontSize: 13.5,
            height: 1.55,
          ),
        ),
      ),
    );
  }

  Widget _buildReceivedMessage(Map message) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            width: 28,
            height: 28,
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [_rose, _roseDark],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: ClipOval(
              child: Lottie.asset('images/ai.json', fit: BoxFit.cover),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.68,
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(4),
                    topRight: Radius.circular(18),
                    bottomLeft: Radius.circular(18),
                    bottomRight: Radius.circular(18),
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 11,
                ),
                child: SelectableText(
                  message["message"],
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.black87,
                    fontWeight: FontWeight.w400,
                    fontSize: 13.5,
                    height: 1.6,
                  ),
                ),
              ),
              if (message["citation"] != null) ...[
                const SizedBox(height: 6),
                _buildSourceChip(message["citation"]),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTypingBubble() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            width: 28,
            height: 28,
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [_rose, _roseDark],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: ClipOval(
              child: Lottie.asset('images/ai.json', fit: BoxFit.cover),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(18),
                bottomLeft: Radius.circular(18),
                bottomRight: Radius.circular(18),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                3,
                (i) => Container(
                      margin: EdgeInsets.only(right: i < 2 ? 5 : 0),
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: _rose.withOpacity(0.5),
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
        ],
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
          color: _roseSoft,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: _rose.withOpacity(0.2)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(PhosphorIcons.link, size: 12, color: _rose),
            const SizedBox(width: 5),
            Text(
              'View source',
              style: GoogleFonts.plusJakartaSans(
                color: _rose,
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
    final hasText = _inputController.text.trim().isNotEmpty;
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: _surface,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: _rose.withOpacity(0.15)),
              ),
              child: TextField(
                controller: _inputController,
                keyboardType: TextInputType.multiline,
                minLines: 1,
                maxLines: 4,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _handleSendPressed(),
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13.5,
                  color: Colors.black87,
                ),
                decoration: InputDecoration(
                  hintText: 'Ask Femi AI anything...',
                  hintStyle: GoogleFonts.plusJakartaSans(
                    color: _muted,
                    fontSize: 13.5,
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
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              gradient:
                  hasText
                      ? const LinearGradient(
                        colors: [_rose, _roseDark],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                      : null,
              color: hasText ? null : const Color(0xFFEEE8EC),
              shape: BoxShape.circle,
              boxShadow:
                  hasText
                      ? [
                        BoxShadow(
                          color: _rose.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ]
                      : [],
            ),
            child: IconButton(
              onPressed: hasText ? _handleSendPressed : null,
              icon: Icon(
                Icons.send_rounded,
                size: 18,
                color: hasText ? Colors.white : _muted,
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
      padding: const EdgeInsets.fromLTRB(16, 2, 16, 16),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Icon(PhosphorIcons.info, size: 12, color: _muted),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                'Not a substitute for professional medical advice. Info sourced from WHO & CDC.',
                style: GoogleFonts.plusJakartaSans(
                  color: _muted,
                  fontSize: 10.5,
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

const _sage = Color(0xFF6BAF92);
const _amber = Color(0xFFFFA726);

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
