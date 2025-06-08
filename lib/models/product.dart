class Product {
  final String name;
  final String category;
  final List<String> ingredients;
  final double price;
  final String imagePath;
  final bool isAvailable;

  Product({
    required this.name,
    required this.category,
    required this.ingredients,
    required this.price,
    required this.imagePath,
    this.isAvailable = true,
  });
}
