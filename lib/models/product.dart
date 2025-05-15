import 'variant.dart';

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
  final List<Variant> variants;      // ← thêm trường này

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
    this.variants = const [],         // ← khởi mặc định là danh sách rỗng
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
    variants: (json['variants'] as List<dynamic>?)
        ?.map((e) => Variant.fromJson(e as Map<String, dynamic>))
        .toList() ?? [],
  );

  Map<String, dynamic> toJson() {
    final m = <String, dynamic>{
      'name': name,
      'category_id': categoryId,
      'brand_id': brandId,
      'price': price,
      'description': description,
      'stock': stock,
      'img_url': imgUrl,
      'time_add': timeAdd.toIso8601String(),
      'variants': variants.map((v) => v.toJson()).toList(),
    };
    if (id != null) m['_id'] = id;
    return m;
  }

  Product copyWith({
    String? id,
    String? name,
    String? categoryId,
    String? brandId,
    double? price,
    String? description,
    int? stock,
    String? imgUrl,
    DateTime? timeAdd,
    String? series,
    List<Variant>? variants,       // ← thêm param cho copyWith
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      categoryId: categoryId ?? this.categoryId,
      brandId: brandId ?? this.brandId,
      price: price ?? this.price,
      description: description ?? this.description,
      stock: stock ?? this.stock,
      imgUrl: imgUrl ?? this.imgUrl,
      timeAdd: timeAdd ?? this.timeAdd,
      variants: variants ?? this.variants,
    );
  }

  /// Named constructor trả về một Product “rỗng” (empty)
  factory Product.empty() {
    return Product(
      id: '',
      name: '',
      categoryId: '',
      brandId: '',
      price: 0.0,
      description: '',
      stock: 0,
      imgUrl: '',
      timeAdd: DateTime.now(),
      variants: [],
    );
  }
}
