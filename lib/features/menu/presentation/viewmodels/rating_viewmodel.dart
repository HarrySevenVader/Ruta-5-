import 'package:flutter/material.dart';

import '../../domain/entities/dish_entity.dart';
import '../../domain/entities/rateable_item.dart';
import '../../domain/entities/rating_entity.dart';
import '../../domain/usecases/submit_rating.dart';

class RatingViewModel extends ChangeNotifier {
  final SubmitRating _submitRating;

  RateableItem? item;
  int selectedRating = 0;
  String comment = '';
  bool isLoading = false;
  String? errorMessage;
  bool isSubmitted = false;

  RatingViewModel({required SubmitRating submitRating})
    : _submitRating = submitRating;

  void setItem(RateableItem rateableItem) {
    // Resetear completamente el estado cuando se establece un nuevo producto
    item = rateableItem;
    selectedRating = 0;
    comment = '';
    isLoading = false;
    errorMessage = null;
    isSubmitted = false;
    print('🔄 Nuevo producto establecido: ${rateableItem.name} - Estado reseteado');
    notifyListeners();
  }

  void setRating(int rating) {
    selectedRating = rating;
    notifyListeners();
  }

  void setComment(String newComment) {
    comment = newComment;
    notifyListeners();
  }

  Future<void> submitRating() async {
    if (item == null || selectedRating == 0) {
      errorMessage = 'Por favor selecciona una calificación';
      notifyListeners();
      return;
    }
    
    // Verificar si el elemento es una bebida
    if (item is! DishEntity) {
      errorMessage = 'Lo sentimos, actualmente solo se pueden calificar platos. Las bebidas estarán disponibles próximamente.';
      notifyListeners();
      return;
    }

    _setLoading(true);
    errorMessage = null; // Limpiar errores anteriores

    try {
      print('🚀 Preparando rating para: ${item!.token}');
      final rating = RatingEntity(
        dishToken: item!.token,
        rating: selectedRating,
        comment: comment.isNotEmpty ? comment : null,
        createdAt: DateTime.now(),
      );

      final success = await _submitRating(rating);

      if (success) {
        print('✅ Rating enviado exitosamente desde ViewModel');
        isSubmitted = true;
        errorMessage = null;
      } else {
        print('❌ Fallo al enviar rating desde ViewModel');
        errorMessage =
            'No se pudo enviar la calificación. Verifica tu conexión.';
      }
    } on Exception catch (e) {
      print('🔥 Excepción en submitRating: $e');
      if (e.toString().contains('Timeout')) {
        errorMessage = 'Tiempo de espera agotado. Verifica tu conexión.';
      } else if (e.toString().contains('SocketException')) {
        errorMessage = 'Sin conexión a internet.';
      } else {
        errorMessage = 'Error de conexión: ${e.toString()}';
      }
    } catch (e) {
      print('💥 Error inesperado en submitRating: $e');
      errorMessage = 'Error inesperado: ${e.toString()}';
    }
    _setLoading(false);
  }

  void reset() {
    selectedRating = 0;
    comment = '';
    isLoading = false;
    errorMessage = null;
    isSubmitted = false;
    notifyListeners();
  }

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }
}
