class Product {
  final String? id;
  final String name;
  final String categoryId;
  final String brandId;
  final double price;
  final String description;
  final int stock;
  final String imgUrl;
  final DateTime timeAdd;
  final String series;

  Product({
    this.id,
    required this.name,
    required this.categoryId,
    required this.brandId,
    required this.price,
    required this.description,
    required this.stock,
    required this.imgUrl,
    required this.timeAdd,
    required this.series,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json['_id'] as String?,
    name: json['name'] as String,
    categoryId: json['category_id'] as String,
    brandId: json['brand_id'] as String,
    price: (json['price'] as num).toDouble(),
    description: json['description'] as String,
    stock: json['stock'] as int,
    imgUrl: json['img_url'] as String,
    timeAdd: DateTime.parse(json['time_add'] as String),
    series: json['series'] as String,
  );

  Map<String, dynamic> toJson() => {
    if (id != null) '_id': id,
    'name': name,
    'category_id': categoryId,
    'brand_id': brandId,
    'price': price,
    'description': description,
    'stock': stock,
    'img_url': imgUrl,
    'time_add': timeAdd.toIso8601String(),
    'series': series,
  };
}