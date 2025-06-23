import 'dart:convert';
import 'package:http/http.dart' as http;

import '../constants/app_constants.dart';
import '../errors/exceptions.dart';

class NetworkClient {
  final http.Client client;
  
  NetworkClient({required this.client});
  
  Future<dynamic> get(String url, {Map<String, String>? headers}) async {
    try {
      final response = await client
          .get(Uri.parse(url), headers: headers)
          .timeout(const Duration(milliseconds: AppConstants.connectionTimeout));
      
      return _processResponse(response);
    } on Exception {
      throw NetworkException();
    }
  }
  
  Future<dynamic> post(String url, {Map<String, String>? headers, dynamic body}) async {
    try {
      final response = await client
          .post(
            Uri.parse(url),
            headers: headers ?? {'Content-Type': 'application/json'},
            body: jsonEncode(body),
          )
          .timeout(const Duration(milliseconds: AppConstants.connectionTimeout));
      
      return _processResponse(response);
    } on Exception {
      throw NetworkException();
    }
  }
  
  dynamic _processResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      throw AuthException('Error de autenticación: ${response.statusCode}');
    } else {
      throw ServerException('Error del servidor: ${response.statusCode}');
    }
  }
}