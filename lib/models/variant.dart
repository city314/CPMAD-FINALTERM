// lib/models/variant.dart

import 'dart:convert';

/// Model cho ảnh của variant (schema embedded)
class VariantImage {
  final String imageUrl;

  VariantImage({required this.imageUrl});

  factory VariantImage.fromJson(Map<String, dynamic> json) {
    return VariantImage(
      imageUrl: json['image_url'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'image_url': imageUrl,
  };
}

/// Model cho Variant
class Variant {
  final String? id;
  final String productId;
  final String variantName;
  final String color;
  final String attributes;
  final double price;
  final int stock;
  final List<VariantImage> images;
  final DateTime createdAt;
  final DateTime updatedAt;

  Variant({
    this.id,
    required this.productId,
    required this.variantName,
    this.color = 'black',
    required this.attributes,
    required this.price,
    required this.stock,
    this.images = const [],
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  factory Variant.fromJson(Map<String, dynamic> json) {
    return Variant(
      id: json['_id'] as String?,
      productId: json['product_id'] as String,
      variantName: json['variant_name'] as String,
      color: json['color'] as String? ?? 'black',
      attributes: json['attributes'] as String,
      price: (json['price'] as num).toDouble(),
      stock: json['stock'] as int,
      images: (json['images'] as List<dynamic>?)
          ?.map((e) => VariantImage.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'product_id': productId,
      'variant_name': variantName,
      'color': color,
      'attributes': attributes,
      'price': price,
      'stock': stock,
      'images': images.map((i) => i.toJson()).toList(),
    };
    if (id != null) data['_id'] = id;
    data['createdAt'] = createdAt.toIso8601String();
    data['updatedAt'] = updatedAt.toIso8601String();
    return data;
  }

  Variant copyWith({
    String? id,
    String? productId,
    String? variantName,
    String? color,
    String? attributes,
    double? price,
    int? stock,
    List<VariantImage>? images,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Variant(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      variantName: variantName ?? this.variantName,
      color: color ?? this.color,
      attributes: attributes ?? this.attributes,
      price: price ?? this.price,
      stock: stock ?? this.stock,
      images: images ?? this.images,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() => jsonEncode(toJson());
}
