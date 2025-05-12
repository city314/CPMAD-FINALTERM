class Review {
  final String? id;
  final String userId;
  final String productId;
  final num rating;
  final String comment;
  final DateTime timeCreate;

  Review({
    this.id,
    required this.userId,
    required this.productId,
    required this.rating,
    required this.comment,
    required this.timeCreate,
  });

  factory Review.fromJson(Map<String, dynamic> json) => Review(
    id: json['_id'] as String?,
    userId: json['user_id'] as String,
    productId: json['product_id'] as String,
    rating: json['rating'] as num,
    comment: json['comment'] as String,
    timeCreate: DateTime.parse(json['time_create'] as String),
  );

  Map<String, dynamic> toJson() => {
    if (id != null) '_id': id,
    'user_id': userId,
    'product_id': productId,
    'rating': rating,
    'comment': comment,
    'time_create': timeCreate.toIso8601String(),
  };
}