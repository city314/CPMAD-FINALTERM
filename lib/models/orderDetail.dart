class OrderDetail {
  final String? id;
  final String orderId;
  final String productId;
  final int quantity;
  final num price;

  OrderDetail({
    this.id,
    required this.orderId,
    required this.productId,
    required this.quantity,
    required this.price,
  });

  factory OrderDetail.fromJson(Map<String, dynamic> json) => OrderDetail(
    id: json['_id'] as String?,
    orderId: json['order_id'] as String,
    productId: json['product_id'] as String,
    quantity: json['quantity'] as int,
    price: json['price'] as num,
  );

  Map<String, dynamic> toJson() => {
    if (id != null) '_id': id,
    'order_id': orderId,
    'product_id': productId,
    'quantity': quantity,
    'price': price,
  };
}
