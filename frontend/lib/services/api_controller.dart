import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nutrition_ai/services/shared_prefs_service.dart';

class ApiController {
final String baseUrl = 'YOUR SERVER LINK/api';

  Future<Map<String, String>> _headers() async {
    final token = await SharedPrefsService().getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<dynamic> get(String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');
    print('REQUEST: GET $url');

    try {
      final headers = await _headers();
      final response = await http.get(url, headers: headers);

      print('RESPONSE: ${response.statusCode} $url');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return jsonDecode(response.body);
      } else {
        throw Exception('API Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('GET Error: $e');
      rethrow;
    }
  }

  Future<dynamic> post(String endpoint, Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl$endpoint');
    print('REQUEST: POST $url');

    try {
      final headers = await _headers();
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(data),
      );

      print('RESPONSE: ${response.statusCode} $url');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return jsonDecode(response.body);
      } else {
        throw Exception('API Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('POST Error: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> postT(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    try {
      print('REQUEST: POST $baseUrl$endpoint');
      print('DATA: $data');

      final headers = await _headers();
      final response = await http
          .post(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
        body: json.encode(data),
      )
          .timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          print('API timeout after 15 seconds');
          throw TimeoutException('Request timeout');
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        return {
          'success': false,
          'message': 'Server error: ${response.statusCode}',
        };
      }
    } on TimeoutException catch (e) {
      print('Timeout: $e');
      return null;
    } catch (e) {
      print('API Error: $e');
      return null;
    }
  }

  Future<dynamic> patch(String endpoint, Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl$endpoint');
    print('REQUEST: PATCH $url');

    try {
      final headers = await _headers();
      final response = await http.patch(
        url,
        headers: headers,
        body: jsonEncode(data),
      );

      print('RESPONSE: ${response.statusCode} $url');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return jsonDecode(response.body);
      } else {
        throw Exception('API Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('PATCH Error: $e');
      rethrow;
    }
  }

  Future<dynamic> delete(String endpoint, {Map<String, dynamic>? data}) async {
    final url = Uri.parse('$baseUrl$endpoint');
    print('REQUEST: DELETE $url');

    try {
      final headers = await _headers();
      final response = await http.delete(
        url,
        headers: headers,
        body: data != null ? jsonEncode(data) : null,
      );

      print('RESPONSE: ${response.statusCode} $url');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (response.body.isNotEmpty) {
          return jsonDecode(response.body);
        }
        return {'success': true};
      } else {
        throw Exception('API Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('DELETE Error: $e');
      rethrow;
    }
  }
}
