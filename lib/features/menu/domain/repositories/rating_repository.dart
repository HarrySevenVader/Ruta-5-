import '../entities/rating_entity.dart';

abstract class RatingRepository {
  Future<bool> submitRating(RatingEntity rating);
  Future<double?> getDishRating(String dishToken);
}
