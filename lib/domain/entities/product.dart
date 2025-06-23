class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String? imageUrl;
  final List<String> categories;
  final List<String> ingredients;
  final bool available;
  final int stock;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.imageUrl,
    this.ingredients = const [],
    this.categories = const [],
    this.available = true,
    this.stock = 15,
  });
}
