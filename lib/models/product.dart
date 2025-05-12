class Product {
  final String? id;
  final String name;
  final String categoryId;
  final String brand;
  final double price;
  final String description;
  final int stock;

  Product({
    this.id,
    required this.name,
    required this.categoryId,
    required this.brand,
    required this.price,
    required this.description,
    required this.stock,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json['_id'] as String?,
    name: json['name'] as String,
    categoryId: json['category_id'] as String,
    brand: json['brand'] as String,
    price: (json['price'] as num).toDouble(),
    description: json['description'] as String,
    stock: json['stock'] as int,
  );

  Map<String, dynamic> toJson() => {
    if (id != null) '_id': id,
    'name': name,
    'category_id': categoryId,
    'brand': brand,
    'price': price,
    'description': description,
    'stock': stock,
  };
}