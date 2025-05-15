import 'package:cpmad_final/models/product.dart';

class Cart {
  final String id;
  final String? userId;
  final String sessionId;
  final String productId;
  final String variantId;
  int quantity;
  final DateTime timeAdd;

  Cart({
    required this.id,
    this.userId,
    required this.sessionId,
    required this.productId,
    required this.variantId,
    this.quantity = 0,
    DateTime? timeAdd,
  }) : timeAdd = timeAdd ?? DateTime.now();

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      id: json['_id'] as String,
      userId: json['userId'] as String?,
      sessionId: json['sessionId'] as String,
      productId: json['productId'] as String,
      variantId: json['variantId'] as String,
      quantity: json['quantity'] as int? ?? 1,
      timeAdd: DateTime.parse(json['timeAdd'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    if (userId != null) 'userId': userId,
    'sessionId': sessionId,
    'productId': productId,
    'variantId': variantId,
    'quantity': quantity,
    'timeAdd': timeAdd.toIso8601String(),
  };

  Cart copyWith({
    String? id,
    String? userId,
    String? sessionId,
    String? productId,
    String? variantId,
    int? quantity,
    DateTime? timeAdd,
  }) {
    return Cart(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      sessionId: sessionId ?? this.sessionId,
      productId: productId ?? this.productId,
      variantId: variantId ?? this.variantId,
      quantity: quantity ?? this.quantity,
      timeAdd: timeAdd ?? this.timeAdd,
    );
  }

  /// Tính tổng tiền dựa trên giá của variant
  double totalPrice(List<Product> products) {
    final product = products.firstWhere(
          (p) => p.id == productId,
      orElse: () => throw Exception('Product $productId not found'),
    );
    final variant = product.variants.firstWhere(
          (v) => v.id == variantId,
      orElse: () => throw Exception('Variant $variantId not found'),
    );
    return variant.importPrice * quantity;
  }
}