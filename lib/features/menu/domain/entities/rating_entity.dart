class RatingEntity {
  final String dishToken;
  final int rating;
  final String? comment;
  final DateTime createdAt;

  RatingEntity({
    required this.dishToken,
    required this.rating,
    this.comment,
    required this.createdAt,
  });
}
