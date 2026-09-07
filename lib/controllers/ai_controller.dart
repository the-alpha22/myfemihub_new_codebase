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

    if (!_privateKey.contains("BEGIN PRIVATE KEY") &&
        !_privateKey.contains("BEGIN RSA PRIVATE KEY")) {
      throw Exception(
        "Invalid private key format. "
        "Must be PEM format (-----BEGIN PRIVATE KEY-----...-----END PRIVATE KEY-----)",
      );
    }

    print("✅ VertexAIController initialized successfully");
  }

  static bool get isInitialized =>
      _projectId.isNotEmpty &&
      _serviceAccountEmail.isNotEmpty &&
      _privateKey.isNotEmpty;

  static Future<String> getAccessToken() async {
    if (!isInitialized) {
      throw Exception(
        "VertexAIController not initialized. "
        "Call VertexAIController.initialize(...) first",
      );
    }

    if (_cachedAccessToken != null &&
        _tokenExpiry != null &&
        DateTime.now().isBefore(_tokenExpiry!)) {
      return _cachedAccessToken!;
    }

    try {
      print("🔄 Generating new Vertex AI access token...");

      final jwt = await FlutterJWTHelper.createJWT(
        clientEmail: _serviceAccountEmail,
        privateKeyPem: _privateKey,
      );

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

      _tokenExpiry = DateTime.now().add(Duration(seconds: expiresIn - 60));

      print("✅ Access token obtained (expires in ${expiresIn}s)");
      return _cachedAccessToken!;
    } catch (e) {
      print("❌ Token generation error: $e");
      throw Exception("Failed to obtain access token: $e");
    }
  }

  // FIX 1: Strip markdown symbols (**, *, #, etc.) from AI responses
  static String _stripMarkdown(String text) {
    return text
        .replaceAll(RegExp(r'\*\*(.+?)\*\*'), r'$1') // **bold** → bold
        .replaceAll(RegExp(r'\*(.+?)\*'), r'$1') // *italic* → italic
        .replaceAll(RegExp(r'#{1,6}\s*'), '') // ## headings
        .replaceAll(RegExp(r'`(.+?)`'), r'$1') // `code` → code
        .replaceAll(RegExp(r'^\s*[-*+]\s+', multiLine: true), '• ') // bullets
        .replaceAll(
          RegExp(r'^\s*\d+\.\s+', multiLine: true),
          '',
        ) // numbered lists
        .trim();
  }

  /// Main chatbot response function
  static Future<String> generateChatbotResponse(
    UserModel user,
    List<dynamic> messages,
    BuildContext context,
  ) async {
    try {
      final token = await getAccessToken();

      late List<Map<String, dynamic>> contents;

      if (messages.isEmpty) {
        // First message — introduction only
        contents = [
          {
            "role": "user",
            "parts": [
              {
                "text":
                    'You are a health assistant called Femi AI, integrated into the FemiHub app. '
                    'You provide information on pregnancy, sexual/reproductive health, period and pregnancy tracking, '
                    'and emotional support. Answer questions related to women\'s health concisely. '
                    'Do NOT use markdown formatting (no **, *, #, or backticks). '
                    'Generate a short, friendly introductory message about yourself in plain text.',
              },
            ],
          },
        ];
      } else {
        // FIX 2: Build history in CORRECT order (oldest first) and extract
        //         the latest user message separately so the model knows what
        //         it is actually being asked right now.
        final historyLines = _formatMessageHistory(user, messages);

        // The last entry in the correctly-ordered list is the current user message
        final currentMessage =
            historyLines.isNotEmpty ? historyLines.last : "Hello";

        // Everything before the last entry is prior context
        final priorHistory =
            historyLines.length > 1
                ? historyLines.sublist(0, historyLines.length - 1).join("\n")
                : "(no prior messages)";

        contents = [
          {
            "role": "user",
            "parts": [
              {
                "text":
                    'You are Femi AI, a women\'s health assistant for the FemiHub app.\n\n'
                    'INSTRUCTIONS:\n'
                    '1. Answer questions about women\'s health, pregnancy, and menstruation.\n'
                    '2. Keep responses concise and helpful (2-4 sentences).\n'
                    '3. Do NOT use markdown formatting — no **, *, #, or backticks. Plain text only.\n'
                    '4. If a question is outside your scope, politely suggest consulting a doctor.\n\n'
                    'USER: ${user.name}\n'
                    'Date: ${DateTime.now()}\n\n'
                    'CONVERSATION HISTORY (oldest to newest):\n'
                    '$priorHistory\n\n'
                    'CURRENT USER MESSAGE:\n'
                    '$currentMessage\n\n'
                    'Respond to the CURRENT USER MESSAGE using the history for context.',
              },
            ],
          },
        ];
      }

      print(
        "📤 Sending request to Vertex AI (${messages.length} messages in history)",
      );

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
                // FIX 3: 280 tokens was cutting responses mid-sentence; 1024 is safe
                "maxOutputTokens": 1024,
                "temperature": 0.7,
                "topP": 0.9,
                "topK": 40,
                // FIX 1 (server-side): request plain text to reduce markdown
                "responseMimeType": "text/plain",
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
      final rawResponse =
          data["candidates"]?[0]?["content"]?["parts"]?[0]?["text"] ??
          "I couldn't generate a response. Please try again.";

      // Apply client-side markdown stripping as a safety net
      final aiResponse = _stripMarkdown(rawResponse);

      print("✅ Response generated (${aiResponse.length} chars)");
      return aiResponse;
    } catch (e) {
      print("❌ Chat error: $e");
      return "An error occurred. Please try again.";
    }
  }

  /// Get period information for specific stage
  static Future<String> suggestGeneralPeriodInfo(String stage) async {
    return _callVertexAI(
      prompt:
          'Provide information about the $stage phase of the menstrual cycle. '
          'Include: physiological changes, things to watch for, and normal variations. '
          'Keep the tone clear, concise, and empathetic. Use plain text only — no markdown.',
    );
  }

  /// Get period recommendations
  static Future<String> suggestGeneralPeriodRecommendation(String stage) async {
    return _callVertexAI(
      prompt:
          'Generate recommendations for the $stage phase of the menstrual cycle. '
          'Cover: well-being and self-care, physical activity, nutrition and hydration, '
          'family planning and intimacy, shopping suggestions, and warning signs. '
          'Use an encouraging, actionable format. Plain text only — no markdown.',
    );
  }

  /// Get symptoms for period stage
  static Future<String> suggestGeneralPeriodSymptoms(String stage) async {
    return _callVertexAI(
      prompt:
          'Describe common symptoms during the $stage phase of the menstrual cycle. '
          'Include: physical symptoms, emotional/mood symptoms, less common symptoms, '
          'and when symptoms are concerning. Use clear, sensitive, reassuring language. '
          'Plain text only — no markdown.',
    );
  }

  /// Get family planning information
  static Future<String> suggestFamilyPlanningInfo() async {
    return _callVertexAI(
      prompt:
          'Create a comprehensive family planning guide covering: what family planning is, '
          'why it matters, contraception methods, planning pregnancy, how to choose a method, '
          'and resources. Use a supportive, non-judgmental tone. Plain text only — no markdown.',
    );
  }

  /// Get info on specific family planning method
  static Future<String> suggestFamilyPlanningSpecificInfo(String method) async {
    return _callVertexAI(
      prompt:
          'Provide a detailed guide for the $method family planning method. '
          'Include: definition, merits, demerits, and resources. '
          'Use a supportive tone. Plain text only — no markdown.',
    );
  }

  /// Get pregnancy tips for specific trimester
  static Future<String> suggestPregnancyTip(String trimester) async {
    return _callVertexAI(
      prompt:
          'Generate pregnancy guidance for the $trimester trimester. '
          'Include: what to expect, common symptoms, nutrition and hydration, '
          'well-being and self-care, preparations, things to avoid, and red flags. '
          'Use a warm, empathetic tone. Plain text only — no markdown.',
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
                "maxOutputTokens": 1024,
                "temperature": 0.7,
                "topP": 0.9,
                "topK": 40,
                "responseMimeType": "text/plain",
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
      final rawResponse =
          data["candidates"]?[0]?["content"]?["parts"]?[0]?["text"] ??
          "Unable to generate response.";

      final aiResponse = _stripMarkdown(rawResponse);

      print("✅ Response received (${aiResponse.length} chars)");
      return aiResponse;
    } catch (e) {
      print("❌ API error: $e");
      return "An error occurred. Please try again.";
    }
  }

  /// Format chat history — oldest message first (correct chronological order)
  static List<String> _formatMessageHistory(
    UserModel user,
    List<dynamic> messages,
  ) {
    // FIX 2: Do NOT reverse — keep messages in original order (oldest → newest)
    final history = <String>[];

    for (var message in messages) {
      if (message["userId"] == "chatbot") {
        history.add("Femi AI: ${message["message"]}");
      } else {
        history.add("${user.name}: ${message["message"]}");
      }
    }

    return history;
  }

  static void clearTokenCache() {
    _cachedAccessToken = null;
    _tokenExpiry = null;
    print("🧹 Token cache cleared");
  }

  static void reset() {
    _projectId = "";
    _serviceAccountEmail = "";
    _privateKey = "";
    clearTokenCache();
    print("🔄 VertexAIController reset");
  }
}
