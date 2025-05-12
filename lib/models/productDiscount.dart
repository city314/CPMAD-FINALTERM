class ProductDiscount {
  final String? id;
  final String productId;
  final double discountPercent;
  final DateTime startDate;
  final DateTime endDate;

  ProductDiscount({
    this.id,
    required this.productId,
    required this.discountPercent,
    required this.startDate,
    required this.endDate,
  });

  factory ProductDiscount.fromJson(Map<String, dynamic> json) => ProductDiscount(
    id: json['_id'] as String?,
    productId: json['product_id'] as String,
    discountPercent: (json['discount_percent'] as num).toDouble(),
    startDate: DateTime.parse(json['start_date'] as String),
    endDate: DateTime.parse(json['end_date'] as String),
  );

  Map<String, dynamic> toJson() => {
    if (id != null) '_id': id,
    'product_id': productId,
    'discount_percent': discountPercent,
    'start_date': startDate.toIso8601String(),
    'end_date': endDate.toIso8601String(),
  };
}