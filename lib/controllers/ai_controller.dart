import 'package:bridge_ai/constants/flutter_jwt_helper.dart';
import 'package:bridge_ai/models/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class VertexAIController {
  static const String LOCATION = "us-central1";
  static const String MODEL = "gemini-3.6-flash";

  // Credentials - loaded on initialization
  static String _projectId = "";
  static String _serviceAccountEmail = "";
  static String _privateKey = "";

  // Token cache for performance
  static String? _cachedAccessToken;
  static DateTime? _tokenExpiry;

  /// Initialize Vertex AI Controller
  /// Call this once on app startup
  static Future<void> initialize({
    required String projectId,
    required String serviceAccountEmail,
    required String privateKey,
  }) async {
    if (projectId.isEmpty ||
        serviceAccountEmail.isEmpty ||
        privateKey.isEmpty) {
      throw Exception("Invalid credentials provided");
    }

    _projectId = projectId;
    _serviceAccountEmail = serviceAccountEmail;
    _privateKey = privateKey;

    // Validate key format
    if (!_privateKey.contains("BEGIN PRIVATE KEY") &&
        !_privateKey.contains("BEGIN RSA PRIVATE KEY")) {
      throw Exception(
        "Invalid private key format. "
        "Must be PEM format (-----BEGIN PRIVATE KEY-----...-----END PRIVATE KEY-----)",
      );
    }

    print("✅ VertexAIController initialized successfully");
  }

  /// Check if controller is ready to use
  static bool get isInitialized =>
      _projectId.isNotEmpty &&
      _serviceAccountEmail.isNotEmpty &&
      _privateKey.isNotEmpty;

  /// Get or create access token (handles caching & refresh automatically)
  static Future<String> getAccessToken() async {
    if (!isInitialized) {
      throw Exception(
        "VertexAIController not initialized. "
        "Call VertexAIController.initialize(...) first",
      );
    }

    // Return cached token if still valid (refresh 60s before expiry)
    if (_cachedAccessToken != null &&
        _tokenExpiry != null &&
        DateTime.now().isBefore(_tokenExpiry!)) {
      return _cachedAccessToken!;
    }

    try {
      print("🔄 Generating new Vertex AI access token...");

      // Create JWT using FlutterJWTHelper
      final jwt = await FlutterJWTHelper.createJWT(
        clientEmail: _serviceAccountEmail,
        privateKeyPem: _privateKey,
      );

      // Exchange JWT for access token
      final tokenResponse = await http
          .post(
            Uri.parse("https://oauth2.googleapis.com/token"),
            headers: {"Content-Type": "application/x-www-form-urlencoded"},
            body: {
              "grant_type": "urn:ietf:params:oauth:grant-type:jwt-bearer",
              "assertion": jwt,
            },
          )
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () => throw Exception("Token request timeout (10s)"),
          );

      if (tokenResponse.statusCode != 200) {
        print("❌ Token exchange failed: ${tokenResponse.statusCode}");
        print("Response: ${tokenResponse.body}");
        throw Exception(
          "Failed to get access token: ${tokenResponse.statusCode} - ${tokenResponse.body}",
        );
      }

      final data = jsonDecode(tokenResponse.body);
      _cachedAccessToken = data["access_token"];
      final expiresIn = data["expires_in"] as int? ?? 3600;

      // Cache token, refresh 60 seconds before expiry
      _tokenExpiry = DateTime.now().add(Duration(seconds: expiresIn - 60));

      print("✅ Access token obtained (expires in ${expiresIn}s)");
      return _cachedAccessToken!;
    } catch (e) {
      print("❌ Token generation error: $e");
      throw Exception("Failed to obtain access token: $e");
    }
  }

  /// Main chatbot response function
  static Future<String> generateChatbotResponse(
    UserModel user,
    List<dynamic> messages,
    BuildContext context,
  ) async {
    try {
      final token = await getAccessToken();
      final history = _formatMessageHistory(user, messages);

      print(
        "📤 Sending request to Vertex AI (${history.length} messages in history)",
      );

      late List<Map<String, dynamic>> contents;

      if (history.isEmpty) {
        // First message - just introduction
        contents = [
          {
            "role": "user",
            "parts": [
              {
                "text":
                    '''You are a health assistant called Femi AI, integrated into the FemiHub app.

We provide:
- Information on pregnancy and sexual/reproductive health
- Virtual consultation services
- Period and pregnancy tracking
- Emotional support via community groups

Your role: Answer questions related to women's health, pregnancy, and menstruation.
Keep responses under 150 characters, informative and concise.

Generate an introductory message about yourself.''',
              },
            ],
          },
        ];
      } else {
        // Continued conversation
        contents = [
          {
            "role": "user",
            "parts": [
              {
                "text":
                    '''You are Femi AI, a health assistant for the FemiHub app.

INSTRUCTIONS:
1. Answer questions about women's health, pregnancy, menstruation
2. Keep responses under 150 characters
3. Use only the provided context
4. If unsure, suggest consulting a doctor

USER: ${user.name}
Date: ${DateTime.now()}

HISTORY:
${history.join("\n")}

CURRENT MESSAGE:
${history.last}

Respond helpfully.''',
              },
            ],
          },
        ];
      }

      final response = await http
          .post(
            Uri.parse(
              "https://aiplatform.googleapis.com/v1/projects/$_projectId/locations/$LOCATION/publishers/google/models/$MODEL:generateContent",
            ),
            headers: {
              "Content-Type": "application/json",
              "Authorization": "Bearer $token",
            },
            body: jsonEncode({
              "contents": contents,
              "generationConfig": {
                "maxOutputTokens": 280,
                "temperature": 0.9,
                "topP": 0.1,
                "topK": 16,
              },
            }),
          )
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () => throw Exception("Vertex AI request timeout (30s)"),
          );

      if (response.statusCode != 200) {
        print("❌ Vertex AI error: ${response.statusCode}");
        print("Response: ${response.body}");
        throw Exception(
          "Vertex AI error: ${response.statusCode} - ${response.body}",
        );
      }

      final data = jsonDecode(response.body);
      final aiResponse =
          data["candidates"]?[0]?["content"]?["parts"]?[0]?["text"] ??
          "I couldn't generate a response. Please try again.";

      print("✅ Response generated (${aiResponse.length} chars)");
      return aiResponse;
    } catch (e) {
      print("❌ Chat error: $e");
      return "An error occurred: $e";
    }
  }

  /// Get period information for specific stage
  static Future<String> suggestGeneralPeriodInfo(String stage) async {
    return _callVertexAI(
      prompt:
          '''Provide information about the $stage phase of the menstrual cycle.

Include:
1. Physiological changes
2. Things to watch for
3. Normal variations

Keep tone clear, concise, empathetic.''',
    );
  }

  /// Get period recommendations
  static Future<String> suggestGeneralPeriodRecommendation(String stage) async {
    return _callVertexAI(
      prompt:
          '''Generate recommendations for the $stage phase of menstrual cycle.

Cover:
- Well-being & Self-Care
- Physical Activity
- Nutrition & Hydration
- Family Planning & Intimacy
- Shopping suggestions
- Warning signs

Use encouraging, actionable format.''',
    );
  }

  /// Get symptoms for period stage
  static Future<String> suggestGeneralPeriodSymptoms(String stage) async {
    return _callVertexAI(
      prompt: '''Describe common symptoms during the $stage phase.

Include:
- Physical Symptoms
- Emotional/Mood Symptoms
- Less Common Symptoms
- When symptoms are concerning

Use clear, sensitive, reassuring language.''',
    );
  }

  /// Get family planning information
  static Future<String> suggestFamilyPlanningInfo() async {
    return _callVertexAI(
      prompt: '''Create a comprehensive family planning guide.

Include:
1. What is Family Planning?
2. Why it matters
3. Contraception methods
4. Planning pregnancy
5. Choosing methods
6. Resources

Use supportive, non-judgmental tone.''',
    );
  }

  /// Get info on specific family planning method
  static Future<String> suggestFamilyPlanningSpecificInfo(String method) async {
    return _callVertexAI(
      prompt: '''Provide detailed guide for $method family planning method.

Include:
1. Definition
2. Merits
3. Demerits
4. Resources

Use supportive tone.''',
    );
  }

  /// Get pregnancy tips for specific trimester
  static Future<String> suggestPregnancyTip(String trimester) async {
    return _callVertexAI(
      prompt: '''Generate pregnancy guidance for the $trimester trimester.

Include:
1. What to Expect
2. Common Symptoms
3. Nutrition & Hydration
4. Well-being & Self-Care
5. Preparations
6. Things to Avoid
7. Red Flags

Use warm, empathetic tone.''',
    );
  }

  /// Generic Vertex AI API call
  static Future<String> _callVertexAI({required String prompt}) async {
    try {
      final token = await getAccessToken();

      print("📤 Calling Vertex AI...");

      final response = await http
          .post(
            Uri.parse(
              "https://aiplatform.googleapis.com/v1/projects/$_projectId/locations/$LOCATION/publishers/google/models/$MODEL:generateContent",
            ),
            headers: {
              "Content-Type": "application/json",
              "Authorization": "Bearer $token",
            },
            body: jsonEncode({
              "contents": [
                {
                  "role": "user",
                  "parts": [
                    {"text": prompt},
                  ],
                },
              ],
              "generationConfig": {
                "maxOutputTokens": 512,
                "temperature": 0.9,
                "topP": 0.1,
                "topK": 16,
              },
            }),
          )
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () => throw Exception("API request timeout"),
          );

      if (response.statusCode != 200) {
        throw Exception("API error: ${response.statusCode} - ${response.body}");
      }

      final data = jsonDecode(response.body);
      final aiResponse =
          data["candidates"]?[0]?["content"]?["parts"]?[0]?["text"] ??
          "Unable to generate response.";

      print("✅ Response received (${aiResponse.length} chars)");
      return aiResponse;
    } catch (e) {
      print("❌ API error: $e");
      return "An error occurred: $e";
    }
  }

  /// Format chat history
  static List<String> _formatMessageHistory(
    UserModel user,
    List<dynamic> messages,
  ) {
    final history = <String>[];
    final reversedMessages = messages.reversed.toList();

    for (var message in reversedMessages) {
      if (message["userId"] == "chatbot") {
        history.add("Femi AI: ${message["message"]}");
      } else {
        history.add("${user.name}: ${message["message"]}");
      }
    }

    return history;
  }

  /// Clear token cache
  static void clearTokenCache() {
    _cachedAccessToken = null;
    _tokenExpiry = null;
    print("🧹 Token cache cleared");
  }

  /// Reset everything
  static void reset() {
    _projectId = "";
    _serviceAccountEmail = "";
    _privateKey = "";
    clearTokenCache();
    print("🔄 VertexAIController reset");
  }
}
