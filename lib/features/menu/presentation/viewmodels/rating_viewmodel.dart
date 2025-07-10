import 'package:flutter/material.dart';

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
    item = rateableItem;
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

    _setLoading(true);
    try {
      print('Preparando rating para: ${item!.token}');
      final rating = RatingEntity(
        dishToken: item!.token,
        rating: selectedRating,
        comment: comment.isNotEmpty ? comment : null,
        createdAt: DateTime.now(),
      );

      final success = await _submitRating(rating);

      if (success) {
        isSubmitted = true;
        errorMessage = null;
      } else {
        errorMessage = 'Error al enviar la valoración. Verifica tu conexión a internet.';
      }
    } catch (e) {
      print('Error en submitRating: $e');
      errorMessage = 'Error al enviar la valoración: ${e.toString()}';
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
