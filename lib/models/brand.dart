class Brand {
  final String? id;
  final String name;
  final String imgUrl;

  Brand({
    this.id,
    required this.name,
    required this.imgUrl,
  });

  factory Brand.fromJson(Map<String, dynamic> json) => Brand(
        id: json['_id'] as String?,
        name: json['name'] as String,
        imgUrl: json['img_url'] as String,
      );

  Map<String, dynamic> toJson() => {
        if (id != null) '_id': id,
        'name': name,
        'img': imgUrl
      };
} 