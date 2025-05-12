class Variant {
  final String id;
  final String productId;
  final String variantName;
  final Map<String, dynamic> attributes;
  final double price;
  final int stock;
  final String sku;
  final String imageUrl;

  Variant({
    required this.id,
    required this.productId,
    required this.variantName,
    required this.attributes,
    required this.price,
    required this.stock,
    this.sku = '',
    this.imageUrl = '',
  });

  factory Variant.fromJson(Map<String, dynamic> json) {
    return Variant(
      id: json['_id'] ?? '',
      productId: json['product_id'] ?? '',
      variantName: json['variant_name'] ?? '',
      attributes: Map<String, dynamic>.from(json['attributes'] ?? {}),
      price: (json['price'] as num).toDouble(),
      stock: json['stock'] ?? 0,
      sku: json['sku'] ?? '',
      imageUrl: json['image_url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'variant_name': variantName,
      'attributes': attributes,
      'price': price,
      'stock': stock,
      'sku': sku,
      'image_url': imageUrl,
    };
  }
}
