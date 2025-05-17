enum OrderStatus { pending, complete, canceled, shipped, paid }

class Order {
  final String? id;
  final String? userId;
  final num totalPrice;
  final num loyaltyPointUsed;
  final num discount;
  final num coupon;
  final num tax;
  final num shippingFee;
  final num finalPrice;
  final OrderStatus status;
  final DateTime timeCreate;

  Order({
    this.id,
    this.userId,
    required this.totalPrice,
    required this.loyaltyPointUsed,
    required this.discount,
    required this.coupon,
    required this.tax,
    required this.shippingFee,
    required this.finalPrice,
    required this.status,
    required this.timeCreate,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
    id: json['_id'] as String?,
    userId: json['user_id'] as String?,
    totalPrice: json['total_price'] as num,
    loyaltyPointUsed: json['loyalty_point_used'] as num,
    discount: json['discount'] as num,
    coupon: json['coupon'] as num,
    tax: json['tax'] as num,
    shippingFee: json['shipping_fee'] as num,
    finalPrice: json['final_price'] as num,
    status: OrderStatus.values.firstWhere((e) => e.name == (json['status'] as String)),
    timeCreate: DateTime.parse(json['time_create'] as String),
  );

  Map<String, dynamic> toJson() => {
    if (id != null) '_id': id,
    'user_id': userId,
    'total_price': totalPrice,
    'loyalty_point_used': loyaltyPointUsed,
    'discount': discount,
    'coupon': coupon,
    'tax': tax,
    'shipping_fee': shippingFee,
    'final_price': finalPrice,
    'status': status.name,
    'time_create': timeCreate.toIso8601String(),
  };

  Order copyWith({ OrderStatus? status }) {
    return Order(
      id: this.id,
      userId: this.userId,
      totalPrice: this.totalPrice,
      loyaltyPointUsed: this.loyaltyPointUsed,
      discount: this.discount,
      coupon: this.coupon,
      tax: this.tax,
      shippingFee: this.shippingFee,
      finalPrice: this.finalPrice,
      status: status ?? this.status,
      timeCreate: this.timeCreate,
    );
  }

}
