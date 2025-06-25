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
  model: 'gemini-1.5-flash-latest',
  apiKey: geminiToken,
  generationConfig: generationConfig,
);

generateChatbotResponse(
  UserModel user,
  List messages,
  BuildContext context,
) async {
  String aiResponse = "";
  List history = [];

  messages = messages.reversed.toList();

  for (var message in messages) {
    if (message["userId"] == "chatbot") {
      // if (message is types.TextMessage) {
      //   history.add("Vendor: ${message.text}");
      // }
      history.add("Femi AI: ${message["message"]}");
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
''',
      ),
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

Always base your response on credible sources such as the WHO, CDC, Mayo Clinic, and MedlinePlus. At the end of every reply, include a JSON object that contains the citation metadata in the following format:

{
  "sources": [
    {
      "title": "Article or Page Title",
      "url": "https://source-link.com",
      "provider": "WHO" // or CDC, Mayo Clinic, MedlinePlus
    }
  ]
}

If you do not have enough information or context to answer accurately, say so and encourage the user to consult a doctor.
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
      ]),
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

suggestGeneralPeriodInfo(String stage) async {
  String aiResponse = "";
  final content = [
    Content.multi([
      TextPart('''
As a helpful and informative assistant for the FemiHub app, provide comprehensive information for a user currently in their PERIOD STAGE - $stage of their menstrual cycle. Include details about:

Physiological changes: What is happening in their body at this time?
Things to look out for: Any red flags or unusual symptoms they should be aware of.
Please present the information in a clear, concise, and empathetic tone, suitable for a women's health app. Avoid medical jargon where simpler terms suffice.
Return only the information, with no additional text or formatting
'''),
    ]),
  ];
  final response = await model.generateContentStream(content);
  await for (final chunk in response) {
    if (chunk.text != null) {
      aiResponse = aiResponse + chunk.text!;
    }
  }

  return aiResponse;
}

suggestGeneralPeriodRecommendation(String stage) async {
  String aiResponse = "";
  final content = [
    Content.multi([
      TextPart('''
As a helpful and empathetic assistant for the FemiHub app, generate a comprehensive set of personalized recommendations for a user who is currently in their [PERIOD STAGE - $stage].

Your recommendations should cover the following key areas, keeping in mind the typical experiences and needs during this specific stage:

Well-being & Self-Care:

General tips for comfort and relaxation.
Suggestions for managing common symptoms (if applicable to the stage, e.g., cramps during period, bloating during ovulation).
Ideas for promoting mental and emotional well-being.
Physical Activity:

Recommended types of exercise or movement.
Activities to potentially avoid or modify.
Tips for staying active while respecting the body's current state.
Nutrition & Hydration:

Dietary suggestions that support the body during this stage (e.g., iron-rich foods during period, energy-boosting foods during fertile window).
Importance of hydration and specific fluid recommendations.
Family Planning & Intimacy:

Clear and concise advice regarding conception likelihood.
Recommendations for birth control measures or conception strategies relevant to this stage.
Suggestions for managing intimacy or comfort during this time.
'Lady Stuff' Shopping Suggestions:

Specific product recommendations that could be beneficial or necessary (e.g., menstrual products, ovulation tests, fertility-friendly lubricants, comfort items).
Ideas for items that enhance comfort or self-care.
Things to Look Out For / When to Seek Advice:

Brief mentions of any unusual symptoms that warrant attention.
Gentle encouragement to listen to their body.
Present the recommendations in an encouraging, easy-to-understand, and actionable format. Use clear headings or bullet points. The tone should be supportive and empowering, suitable for a health and wellness app targeting women.Return only the information, with no additional text or formatting
'''),
    ]),
  ];
  final response = await model.generateContentStream(content);
  await for (final chunk in response) {
    if (chunk.text != null) {
      aiResponse = aiResponse + chunk.text!;
    }
  }

  return aiResponse;
}

suggestGeneralPeriodSymptoms(String stage) async {
  String aiResponse = "";
  final content = [
    Content.multi([
      TextPart('''
As a helpful and informative assistant for the FemiHub app, describe the common physical and emotional symptoms a user might experience when they are in their [PERIOD STAGE - $stage].

For the specified stage, please detail:

Common Physical Symptoms:

What sensations or bodily changes might they notice (e.g., cramps, bloating, breast tenderness, increased energy, changes in discharge)?
How might these symptoms manifest (e.g., mild to severe, localized pain)?
Common Emotional/Mood Symptoms:

What emotional shifts or mood changes are frequently reported (e.g., irritability, sadness, increased libido, feeling calm, heightened sensitivity)?
How might these feelings be linked to hormonal fluctuations during this stage?
Less Common but Possible Symptoms:

Mention any other less frequent but known symptoms a user might encounter.
Normalcy and Variation:

Briefly emphasize that symptom experiences can vary greatly among individuals.
Reassure users that many of these symptoms are a normal part of the cycle.
When to Be Concerned (Briefly):

A very brief note on types of symptoms or severity that might warrant consulting a healthcare professional (e.g., 'severe pain that disrupts daily life').
Present the information in a clear, sensitive, and easy-to-understand manner, using non-medical language where possible. The tone should be empathetic and reassuring, suitable for a women's health app.Return only the information, with no additional text or formatting
'''),
    ]),
  ];
  final response = await model.generateContentStream(content);
  await for (final chunk in response) {
    if (chunk.text != null) {
      aiResponse = aiResponse + chunk.text!;
    }
  }

  return aiResponse;
}

suggestFamilyPlanningInfo() async {
  String aiResponse = "";
  final content = [
    Content.multi([
      TextPart('''
As a helpful and informative assistant for the FemiHub app, generate a comprehensive guide to Family Planning for our users. This guide should be empowering, easy to understand, and cover a range of considerations relevant to women managing their reproductive health.

Please include the following sections:

What is Family Planning?

A clear and concise definition, emphasizing that it includes both preventing and achieving pregnancy, and planning the timing and spacing of children.
Highlight its role in empowering women and couples to make informed choices.
Why is Family Planning Important?

Benefits for personal health (e.g., managing cycles, maternal health).
Benefits for family well-being (e.g., financial stability, child development).
Benefits for personal goals and freedom.
Methods of Contraception (Preventing Pregnancy):

Provide a brief overview of key categories (e.g., hormonal, barrier, IUDs, natural methods, permanent methods).
For each category, mention 1-2 common examples (e.g., "Pills, Patch, Ring" for hormonal; "Condoms" for barrier; "IUDs" for Intrauterine Devices).
Briefly touch upon the concept of effectiveness rates (without getting into precise percentages, just general terms like 'highly effective', 'less effective').
Emphasize that consulting a healthcare provider is crucial for method selection.
Planning for Pregnancy (Achieving Pregnancy):

Information on understanding the fertile window (linking to the FemiHub app's tracking features).
Tips for optimizing conception (e.g., healthy lifestyle, prenatal vitamins).
When to consider seeking fertility support.
Choosing the Right Family Planning Method:

Key factors to consider (e.g., lifestyle, health conditions, effectiveness desired, reversibility, personal preferences, partner involvement).
Stress the importance of discussing options with a healthcare provider.
Family Planning and the FemiHub App:

Briefly explain how the FemiHub app can support users in their family planning journey (e.g., period tracking, ovulation prediction, medication reminders, logging symptoms).
Mention how the 'Shop Lady Stuff' section might offer relevant products (e.g., ovulation tests, condoms, prenatal vitamins).
Where to Find More Information & Support:

Encourage users to speak to their doctor, gynecologist, or a local family planning clinic.
Suggest reliable online resources (without listing specific URLs, just categories like 'reputable health organizations').
Maintain a supportive, non-judgmental, and evidence-based tone. Use clear, accessible language, avoiding overly technical jargon. The information should empower users to make informed decisions about their reproductive health.
Return only the information, with no additional text or formatting
'''),
    ]),
  ];
  final response = await model.generateContentStream(content);
  await for (final chunk in response) {
    if (chunk.text != null) {
      aiResponse = aiResponse + chunk.text!;
    }
  }

  return aiResponse;
}

suggestFamilyPlanningSpecificInfo(String plan) async {
  String aiResponse = "";
  final content = [
    Content.multi([
      TextPart('''
As a helpful and informative assistant for the FemiHub app, generate a comprehensive guide to family planning method/term called ${plan} for our users. This guide should be empowering, easy to understand, and cover a range of considerations relevant to women.

Please include the following sections:

Definition

A clear and concise definition.
Highlight its role in empowering women and couples to make informed choices.

Merits and demerits

Where to Find More Information & Support:

Encourage users to speak to their doctor, gynecologist, or a local family planning clinic.
Suggest reliable online resources (without listing specific URLs, just categories like 'reputable health organizations').
Maintain a supportive, non-judgmental, and evidence-based tone. Use clear, accessible language, avoiding overly technical jargon. The information should empower users to make informed decisions about their reproductive health.
Return only the information, with no additional text or formatting
'''),
    ]),
  ];
  final response = await model.generateContentStream(content);
  await for (final chunk in response) {
    if (chunk.text != null) {
      aiResponse = aiResponse + chunk.text!;
    }
  }

  return aiResponse;
}

suggestPregnancyTip(String trimester) async {
  String aiResponse = "";
  final content = [
    Content.multi([
      TextPart('''
As a supportive and informative assistant for the FemiHub app, generate a comprehensive set of tips and guidance for a user based on their current Pregnancy Trimester. This information should be reassuring, practical, and address the unique experiences of each stage of pregnancy.

Please provide distinct sections for the following trimesters. For each trimester, include:

For the $trimester:

What to Expect (General Overview):

Briefly describe the key developmental milestones for the baby during this trimester.

Highlight major physical changes the pregnant person might experience.

Common Symptoms & How to Manage Them:

List typical symptoms for this specific trimester (e.g., morning sickness, fatigue, increased energy, heartburn, back pain, swelling).

Offer practical and gentle tips for managing these symptoms (e.g., dietary adjustments, rest, light exercise, comfort measures).

Nutrition & Hydration Tips:

Specific dietary recommendations or important nutrients for this trimester.

Advice on hydration.

Any foods or drinks to avoid.

Well-being & Self-Care:

Emotional support tips (e.g., coping with mood swings, managing anxiety, bonding with the baby).

Importance of rest and light activity.

Partner involvement suggestions.

Things to Do / Prepare For:

Key appointments or screenings to consider during this trimester.

Practical preparations (e.g., announcing pregnancy, nursery planning, birth plan discussions, packing a hospital bag).

Educational resources or classes to explore.

Things to Avoid / Be Mindful Of:

Any specific activities, medications, or situations that should be avoided or approached with caution during this trimester.

When to Contact Your Doctor/Midwife:

A brief, non-alarming note on any specific red-flag symptoms that warrant immediate medical attention for this trimester.

Maintain a warm, empathetic, and encouraging tone throughout. Use clear, accessible language, avoiding overly complex medical jargon. The information should empower expectant parents and help them navigate their pregnancy journey with confidence.
Return only the information, with no additional text or formatting
'''),
    ]),
  ];
  final response = await model.generateContentStream(content);
  await for (final chunk in response) {
    if (chunk.text != null) {
      aiResponse = aiResponse + chunk.text!;
    }
  }

  return aiResponse;
}
