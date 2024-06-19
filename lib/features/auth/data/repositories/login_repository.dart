import 'dart:convert';

import 'package:alfath_stoer_app/features/auth/data/models/Login_response.dart';
import 'package:http/http.dart' as http;

class LoginRepository {
  final String baseUrl;

  LoginRepository({required this.baseUrl});

  Future<LoginResponse> login(String userName, String password) async {
    final url = '$baseUrl/User/Login';
    print(url);
    final request = await http.Request(
      'GET',
      Uri.parse(url),
    );

    var headers = {'Content-Type': 'application/json'};
    request.body = json.encode({"UserName": userName, "Password": password});

    request.headers.addAll(headers);

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (streamedResponse.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      return LoginResponse.fromJson(data);
    } else {
      throw Exception('Failed to load details');
    }
  }
}
