import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:red_balloon_app/utils/dialog_helpers.dart';

class FatoraService {
  // Toggle this to switch between modes
  static const bool isTestMode = true;

  static const String _prodApiKey = 'a1ac1512-6c07-4242-8d95-e9ed5db9eed4';
  static const String _testApiKey = 'E4B73FEE-F492-4607-A38D-852B0EBC91C9';

  static String get apiKey => isTestMode ? _testApiKey : _prodApiKey;

  static const String baseUrl = 'https://api.fatora.io/v1/payments/checkout';

  static Future<String?> initiatePayment({
    required double amount,
    required String customerName,
    required String customerEmail,
    String? note,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'api_key': apiKey, 'Content-Type': 'application/json'},
        body: jsonEncode({
          'amount': amount.toStringAsFixed(2),
          'currency': 'SAR',
          'order_id': DateTime.now().millisecondsSinceEpoch.toString(),
          'client': {
            'name': customerName.substring(0, min(customerName.length, 50)), // Limited length
            'email': customerEmail,
          },
          'language': 'en',
          'note': note ?? 'Add Funds',
          'success_url': 'https://fatora.io/payment/success',
          'failure_url': 'https://fatora.io/payment/failure',
        }),
      );

      debugPrint('Fatora Response Status: ${response.statusCode}');
      debugPrint('Fatora Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        // Standard Fatora v1 response format check (usually result -> checkout_url)
        if (data['status'] == 'success' || data['result'] != null) {
          return data['result']['checkout_url'];
        }
      } else {
        final errorData = jsonDecode(response.body);
        debugPrint('Fatora Error: ${errorData['message'] ?? 'Unknown error'}');
      }
      return null;
    } catch (e) {
      debugPrint('Fatora Exception: $e');
      return null;
    }
  }

  static Future<void> launchCheckout(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }
}
