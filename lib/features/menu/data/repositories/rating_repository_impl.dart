import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../domain/entities/rating_entity.dart';
import '../../domain/repositories/rating_repository.dart';

class RatingRepositoryImpl implements RatingRepository {
  final String baseUrl = 'https://api.sebastian.cl/restaurant';

  @override
  Future<bool> submitRating(RatingEntity rating) async {
    try {
      print('Enviando calificación para: ${rating.dishToken}');
      print('Rating: ${rating.rating}');
      print('Comentario: ${rating.comment}');

      final response = await http.post(
        Uri.parse('$baseUrl/rating'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'dishToken': rating.dishToken,
          'rating': rating.rating,
          'comment': rating.comment,
        }),
      );

      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('Error al enviar calificación: $e');
      return false;
    }
  }

  @override
  Future<double?> getDishRating(String dishToken) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/rating/$dishToken'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['averageRating']?.toDouble();
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
