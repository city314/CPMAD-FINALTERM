enum Role { admin, customer }
enum Status { active, inactive }

class Address {
  final String id;
  final String receiverName;
  final String phone;
  final String address;
  final String commune;
  final String district;
  final String city;
  final bool isDefault;

  Address({
    required this.id,
    required this.receiverName,
    required this.phone,
    required this.address,
    required this.commune,
    required this.district,
    required this.city,
    required this.isDefault,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    id: json['id'] as String,
    receiverName: json['receiver_name'] as String,
    phone: json['phone'] as String,
    address: json['address'] as String,
    commune: json['commune'] as String,
    district: json['district'] as String,
    city: json['city'] as String,
    isDefault: json['default'] as bool,
  );

  get fullAddress => '$address, $commune, $district, $city';

  Map<String, dynamic> toJson() => {
    'id': id,
    'receiver_name': receiverName,
    'phone': phone,
    'address': address,
    'commune': commune,
    'district': district,
    'city': city,
    'default': isDefault,
  };
}

class User {
  final String? id;
  final String avatar;
  final String email;
  final String name;
  final String password;
  final List<Address> addresses;
  final Role role;
  final Status status;
  final DateTime timeCreate;

  User({
    this.id,
    required this.avatar,
    required this.email,
    required this.name,
    required this.password,
    required this.addresses,
    required this.role,
    required this.status,
    required this.timeCreate,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['_id'] as String?,
    avatar: json['avatar'] as String,
    email: json['email'] as String,
    name: json['name'] as String,
    password: json['password'] as String,
    addresses: (json['address'] as List<dynamic>)
        .map((e) => Address.fromJson(e as Map<String, dynamic>))
        .toList(),
    role: Role.values.firstWhere((e) => e.name == (json['role'] as String)),
    status:
    Status.values.firstWhere((e) => e.name == (json['status'] as String)),
    timeCreate: DateTime.parse(json['time_create'] as String),
  );

  Map<String, dynamic> toJson() => {
    if (id != null) '_id': id,
    'avatar': avatar,
    'email': email,
    'name': name,
    'password': password,
    'address': addresses.map((a) => a.toJson()).toList(),
    'role': role.name,
    'status': status.name,
    'time_create': timeCreate.toIso8601String(),
  };
}
