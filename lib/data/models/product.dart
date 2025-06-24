class Product {
  final String name;
  final String category;
  final List<String> ingredients;
  final double price;
  final String imagePath;
  bool isAvailable;
  int stock;

  Product({
    required this.name,
    required this.category,
    required this.ingredients,
    required this.price,
    required this.imagePath,
    this.isAvailable = true,
    int? stock,
  }) : stock = stock ?? 15;

  // Método de serialización
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['name'],
      category: json['category'],
      ingredients: List<String>.from(json['ingredients']),
      price: json['price'].toDouble(),
      imagePath: json['imagePath'],
      isAvailable: json['isAvailable'] ?? true,
      stock: json['stock'] ?? 15,
    );
  }

  // Método de deserialización
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'category': category,
      'ingredients': ingredients,
      'price': price,
      'imagePath': imagePath,
      'isAvailable': isAvailable,
      'stock': stock,
    };
  }

  // Método para crear un Producto vacío
  static Product empty() {
    return Product(
      name: '',
      category: '',
      ingredients: [],
      price: 0,
      imagePath: '',
      isAvailable: false,
      stock: 0,
    );
  }
}
