class Address {
  final String id;
  final String receiverName;
  final String phoneNumber;
  final String province;
  final String district;
  final String ward;
  final String streetDetail;
  final bool isDefault;

  Address({
    required this.id,
    required this.receiverName,
    required this.phoneNumber,
    required this.province,
    required this.district,
    required this.ward,
    required this.streetDetail,
    this.isDefault = false,
  });

  String get fullAddress => '$streetDetail, $ward, $district, $province';

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'] ?? '', // ← thêm fallback
      receiverName: json['receiver_name'] ?? '',
      phoneNumber: json['phone'] ?? '',
      province: json['city'] ?? '',
      district: json['district'] ?? '',
      ward: json['commune'] ?? '',
      streetDetail: json['address'] ?? '',
      isDefault: json['default'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'receiver_name': receiverName,
    'phone': phoneNumber,
    'city': province,
    'district': district,
    'commune': ward,
    'address': streetDetail,
    'default': isDefault,
  };

  factory Address.empty() => Address(
    id: '',
    receiverName: '',
    phoneNumber: '',
    province: '',
    district: '',
    ward: '',
    streetDetail: '',
    isDefault: false,
  );
}
