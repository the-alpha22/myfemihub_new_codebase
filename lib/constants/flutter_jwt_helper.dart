import 'dart:convert';
import 'dart:typed_data';

import 'package:basic_utils/basic_utils.dart';

class FlutterJWTHelper {
  /// Creates a Google-compatible RS256 JWT.
  static Future<String> createJWT({
    required String clientEmail,
    required String privateKeyPem,
    String audience = 'https://oauth2.googleapis.com/token',
    int expirationSeconds = 3600,
  }) async {
    try {
      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final exp = now + expirationSeconds;

      // JWT header
      final header = <String, dynamic>{'alg': 'RS256', 'typ': 'JWT'};

      // JWT payload
      final payload = <String, dynamic>{
        'iss': clientEmail,
        'sub': clientEmail,
        'aud': audience,
        'iat': now,
        'exp': exp,
        'scope': 'https://www.googleapis.com/auth/cloud-platform',
      };

      // Base64URL encode header and payload
      final headerEncoded = _base64UrlEncode(utf8.encode(jsonEncode(header)));

      final payloadEncoded = _base64UrlEncode(utf8.encode(jsonEncode(payload)));

      // This is what Google expects to be signed.
      final signingInput = '$headerEncoded.$payloadEncoded';

      // RSASSA-PKCS1-v1_5 + SHA-256 = RS256
      final privateKey = CryptoUtils.rsaPrivateKeyFromPem(privateKeyPem);

      final signature = CryptoUtils.rsaSign(
        privateKey,
        Uint8List.fromList(utf8.encode(signingInput)),
        algorithmName: 'SHA-256/RSA',
      );

      final signatureEncoded = _base64UrlEncode(signature);

      return '$signingInput.$signatureEncoded';
    } catch (e) {
      throw Exception('JWT creation failed: $e');
    }
  }

  /// Base64URL encoding without padding.
  static String _base64UrlEncode(List<int> bytes) {
    return base64Url.encode(bytes).replaceAll('=', '');
  }

  /// Decode JWT payload.
  ///
  /// This only decodes the JWT. It does NOT verify the signature.
  static Map<String, dynamic>? decodeJWT(String token) {
    try {
      final parts = token.split('.');

      if (parts.length != 3) {
        return null;
      }

      var payload = parts[1];

      // Restore Base64 padding.
      final missing = payload.length % 4;

      if (missing != 0) {
        payload += '=' * (4 - missing);
      }

      final decoded = utf8.decode(base64Url.decode(payload));

      final result = jsonDecode(decoded);

      if (result is Map<String, dynamic>) {
        return result;
      }

      return null;
    } catch (e) {
      return null;
    }
  }
}


class SecureCredentialManager {
  static const String _projectIdKey = 'gcp_project_id';
  static const String _serviceAccountEmailKey = 'gcp_service_account_email';
  static const String _privateKeyKey = 'gcp_private_key';

  /// Store GCP credentials securely.
  static Future<void> storeCredentials({
    required String projectId,
    required String serviceAccountEmail,
    required String privateKey,
  }) async {
    try {
      // If you actually need local secure storage on mobile/desktop,
      // install flutter_secure_storage and implement this here.
      //
      // const storage = FlutterSecureStorage();
      //
      // await storage.write(
      //   key: _projectIdKey,
      //   value: projectId,
      // );
      //
      // await storage.write(
      //   key: _serviceAccountEmailKey,
      //   value: serviceAccountEmail,
      // );
      //
      // await storage.write(
      //   key: _privateKeyKey,
      //   value: privateKey,
      // );

      print('Credentials would be stored securely.');

      throw UnimplementedError(
        'Add flutter_secure_storage to use this feature.',
      );
    } catch (e) {
      throw Exception('Failed to store credentials: $e');
    }
  }

  /// Retrieve stored GCP credentials.
  static Future<Map<String, String>?> getCredentials() async {
    try {
      // Implement with flutter_secure_storage when needed.

      throw UnimplementedError(
        'Add flutter_secure_storage to use this feature.',
      );
    } catch (e) {
      throw Exception('Failed to retrieve credentials: $e');
    }
  }

  /// Delete stored credentials.
  static Future<void> deleteCredentials() async {
    try {
      // Implement with flutter_secure_storage when needed.

      print('Credentials would be deleted.');
    } catch (e) {
      print('Error deleting credentials: $e');
    }
  }

  /// Check if credentials are stored.
  static Future<bool> hasCredentials() async {
    try {
      final creds = await getCredentials();
      return creds != null;
    } catch (_) {
      return false;
    }
  }
}
