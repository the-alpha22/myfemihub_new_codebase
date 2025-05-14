import 'package:bridge_ai/models/user.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

final geminiToken = "AIzaSyCxZZPGNqS-vWlQdNEM38k9We1vsmFUrAQ";

final generationConfig = GenerationConfig(
  maxOutputTokens: 280,
  temperature: 0.9,
  topP: 0.1,
  topK: 16,
);

final model = GenerativeModel(
    model: 'gemini-1.5-flash',
    apiKey: geminiToken,
    generationConfig: generationConfig);
    
generateChatbotResponse(UserModel user, List messages, BuildContext context)async{
  String aiResponse = "";
  List history = [];

  messages = messages.reversed.toList();

      for (var message in messages) {
        if (message["userId"] != "chatbot") {
          // if (message is types.TextMessage) {
          //   history.add("Vendor: ${message.text}");
          // }
          history.add("Chatbot: ${message["message"]}");
        } else {
          // if (message is types.TextMessage) {
          //   history.add("Cuvend AI: ${message.text}");
          // }
          history.add("${user.name}: ${message["message"]}");
        }
      }

      if (history.isEmpty) {
        final content = [
          Content.text(
              '''You are a health assistant called Femi AI, integrated into the FemiHub app, We provide information on pregnancy and sexual and reproductive health, virtual consultation services, period and pregnancy tracking and emotional support via community groups on our app.Our digital platforms: our app and website offer a one-stop-shop for maternal and child care products empowering pregnant women, young people, and teenagers in Uganda and across Africa to access essential healthcare services and commodities. Your role is to answer questions related to women health, pregnancy, menestration, while guiding users through their health-related concerns. Always provide informative, concise responses under 150 characters.
    Generate an introductory message informing the patient about you
''')
        ];
        final response = await model.generateContentStream(content);
        await for (final chunk in response) {
          if (chunk.text != null) {
            aiResponse = aiResponse + chunk.text!;
          }
        }
      } else {
        print("${history.last}");
        final content = [
          Content.multi([
//////////////////////////////////
//////////Assigning AI Segment
            TextPart('''
You are a health assistant called Femi AI, integrated into the FemiHub app, We provide information on pregnancy and sexual and reproductive health, virtual consultation services, period and pregnancy tracking and emotional support via community groups on our app.Our digital platforms: our app and website offer a one-stop-shop for maternal and child care products empowering pregnant women, young people, and teenagers in Uganda and across Africa to access essential healthcare services and commodities. Your role is to answer questions related to women health, pregnancy, menestration, while guiding users through their health-related concerns. Always provide informative, concise responses under 150 characters.
Current date is ${DateTime.now()}
'''),

//////////////////////////
//////////User Data Segment
            TextPart('''
Here are some details about ${user.name}
Name: ${user.name}
'''),
//////////////////////////
//////////Chat Data
            TextPart('''
This is your recent chat with ${user.name}: 
${history.join(" ")}
The message your are replying to is ${history.last}
NB only use what is available in the context provided
'''),
//////////////////////////
//////////MyMedikoz Data
            TextPart('''
About FemiHub
FemiHub Website: https://www.femihub.com
Email: info@femihub.com
'''),
          ])
        ];
        final response = await model.generateContentStream(content);
        await for (final chunk in response) {
          if (chunk.text != null) {
            aiResponse = aiResponse + chunk.text!;
          }
        }
      }

  return aiResponse;
}
