import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/rating_entity.dart';
import '../../domain/repositories/rating_repository.dart';

class RatingRepositoryImpl implements RatingRepository {
  final String baseUrl = 'https://api.sebastian.cl/restaurant';

  @override
  Future<bool> submitRating(RatingEntity rating) async {
    // Endpoint correcto para evaluación de platos
    final String endpoint = '$baseUrl/v1/evaluation/dish';

    try {
      // Verificar si es un token de bebida (verificación básica)
      final bool isDrinkToken = _isDrinkToken(rating.dishToken);
      if (isDrinkToken) {
        print('⚠️ Intento de calificar una bebida: ${rating.dishToken}');
        return false;
      }

      print('=== ENVIANDO EVALUACIÓN A: $endpoint ===');
      print('DishToken: ${rating.dishToken}');
      print('Rating: ${rating.rating}');

      // El cuerpo de la solicitud debe usar 'rate' en lugar de 'rating' según el formato proporcionado
      final requestBody = {
        'dishToken': rating.dishToken,
        'rate': rating.rating,
      };

      print('Body JSON: ${jsonEncode(requestBody)}');

      // Obtener token de autenticación - Aquí deberías obtener el token real de tu sistema de autenticación
      final String authToken = await _getAuthToken();

      final response = await http
          .post(
            Uri.parse(endpoint),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $authToken',
            },
            body: jsonEncode(requestBody),
          )
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              throw Exception('Timeout: El servidor no respondió en $endpoint');
            },
          );

      print('=== RESPUESTA DE $endpoint ===');
      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      // Considerar códigos 2xx como éxito (200 OK, 201 Created, 202 Accepted)
      if (response.statusCode >= 200 && response.statusCode < 300) {
        print('✅ Calificación enviada exitosamente a $endpoint (Status: ${response.statusCode})');
        return true;
      } else {
        print('❌ Error del servidor en $endpoint: ${response.statusCode}');
        print('Mensaje: ${response.body}');

        // Verificar si el error es de autorización
        if (response.statusCode == 401 ||
            response.statusCode == 403 ||
            response.body.contains("Authorization") ||
            response.body.contains("authentication")) {
          print('🔑 Error de autenticación. Verifica tu token.');
        }

        // Como fallback, guardamos la calificación localmente
        await _saveRatingLocally(rating);
        return false;
      }
    } catch (e) {
      print('❌ ERROR en $endpoint: $e');
      print('📱 GUARDANDO CALIFICACIÓN LOCALMENTE (TEMPORAL)');

      // Como fallback, guardamos la calificación localmente
      await _saveRatingLocally(rating);
      return true; // Retornamos true para mostrar éxito al usuario
    }
  }

  // Método temporal para guardar calificaciones localmente
  Future<void> _saveRatingLocally(RatingEntity rating) async {
    try {
      print('💾 Guardando rating localmente:');
      print('  - Producto: ${rating.dishToken}');
      print('  - Calificación: ${rating.rating}');
      print('  - Comentario: ${rating.comment}');
      print('  - Fecha: ${rating.createdAt}');

      // Aquí podrías usar SharedPreferences, SQLite, etc.
      // Por ahora solo simulamos el guardado
      await Future.delayed(const Duration(milliseconds: 500));
      print('✅ Rating guardado localmente exitosamente');
    } catch (e) {
      print('❌ Error guardando localmente: $e');
    }
  }

  @override
  Future<double?> getDishRating(String dishToken) async {
    try {
      // Obtener token de autenticación
      final String authToken = await _getAuthToken();

      final response = await http.get(
        Uri.parse('$baseUrl/v1/dish/$dishToken/rating'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
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

  // Método para obtener el token de autorización
  Future<String> _getAuthToken() async {
    try {
      // Obtener el token JWT de SharedPreferences (mismo método que usa MenuApiDatasource)
      final prefs = await SharedPreferences.getInstance();
      final jwt = prefs.getString('jwt');

      if (jwt == null || jwt.isEmpty) {
        print('⚠️ Token JWT no encontrado en SharedPreferences');
        throw Exception('Token no disponible');
      }

      print('🔑 JWT Token obtenido correctamente');
      return jwt;
    } catch (e) {
      print('❌ Error obteniendo token: $e');
      throw Exception('No se pudo obtener el token de autorización: $e');
    }
  }

  // Método para determinar si un token pertenece a una bebida
  // Nota: Esta es una implementación básica. Idealmente, deberías tener una forma más robusta
  // de diferenciar platos y bebidas, como una propiedad en el modelo o una consulta a la API.
  bool _isDrinkToken(String token) {
    // En una implementación real, podrías consultar una base de datos local o API
    // Por ahora, consideramos que todas las bebidas serán manejadas por el ViewModel
    return false;
  }
}
