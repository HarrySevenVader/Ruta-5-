import '../entities/rating_entity.dart';
import '../repositories/rating_repository.dart';

class SubmitRating {
  final RatingRepository repository;

  SubmitRating(this.repository);

  Future<bool> call(RatingEntity rating) async {
    return await repository.submitRating(rating);
  }
}
