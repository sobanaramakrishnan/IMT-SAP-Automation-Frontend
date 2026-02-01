import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/login_request.dart';

class AuthService {
  static const String baseUrl = "http://127.0.0.1:8000";

  static Future<Map<String, dynamic>> login(LoginRequest request) async {
    final url = Uri.parse("$baseUrl/user/login");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Invalid email or password");
    }
  }
}
