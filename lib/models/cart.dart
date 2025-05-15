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
    required this.quantity,
    required this.timeAdd,
  });

  factory Cart.fromJson(Map<String, dynamic> json) => Cart(
    id: json['_id'] as String,
    userId: json['user_id'] as String?,
    sessionId: json['session_id'] as String,
    productId: json['product_id'] as String,
    variantId: json['variant_id'] as String,
    quantity: json['quantity'] as int,
    timeAdd: DateTime.parse(json['time_add'] as String),
  );

  Map<String, dynamic> toJson() => {
    '_id': id,
    'user_id': userId,
    'session_id': sessionId,
    'product_id': productId,
    'variant_id': variantId,
    'quantity': quantity,
    'time_add': timeAdd.toIso8601String(),
  };

  Cart copyWith({ int? quantity }) {
    return Cart(
      id:        id,
      userId:    userId,
      sessionId: sessionId,
      productId: productId,
      variantId: variantId,
      quantity:  quantity ?? this.quantity,
      timeAdd:   timeAdd,
    );
  }

  /// Tính tổng tiền dựa trên giá hiện tại của variant
  double totalPrice(List<Product> products) {
    final product = products.firstWhere((p) => p.id == productId);
    final variant = product.variants.firstWhere((v) => v.id == variantId);
    return variant.price * quantity;
  }
}