class Cart {
  final String? id;
  final String? userId;
  final String sessionId;
  final String productId;
  final int quantity;
  final DateTime timeAdd;

  Cart({
    this.id,
    this.userId,
    required this.sessionId,
    required this.productId,
    required this.quantity,
    required this.timeAdd,
  });

  factory Cart.fromJson(Map<String, dynamic> json) => Cart(
    id: json['_id'] as String?,
    userId: json['user_id'] as String?,
    sessionId: json['session_id'] as String,
    productId: json['product_id'] as String,
    quantity: json['quantity'] as int,
    timeAdd: DateTime.parse(json['time_add'] as String),
  );

  Map<String, dynamic> toJson() => {
    if (id != null) '_id': id,
    'user_id': userId,
    'session_id': sessionId,
    'product_id': productId,
    'quantity': quantity,
    'time_add': timeAdd.toIso8601String(),
  };
}