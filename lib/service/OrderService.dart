import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/coupon.dart';

class OrderService {
  static const String baseUrl = 'http://localhost:3003/api/coupons'; // đổi lại IP nếu chạy thật

  /// Lấy danh sách coupon
  static Future<List<Coupon>> fetchAllCoupons() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => Coupon.fromJson(e)).toList();
    } else {
      throw Exception('Không thể tải danh sách coupon');
    }
  }

  /// Thêm coupon mới
  static Future<bool> createCoupon(Coupon coupon) async {
    final url = Uri.parse(baseUrl);
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'code': coupon.code,
        'discount_amount': coupon.discountAmount, // ✅ Đúng tên backend
        'usage_max': coupon.usageMax,             // ✅ Đúng tên backend
      }),
    );
    if (response.statusCode == 201) return true;

    // In lỗi để debug nếu cần
    print('Create failed: ${response.body}');
    return false;
  }

  /// Sửa coupon
  static Future<bool> updateCoupon(Coupon coupon) async {
    final url = Uri.parse('$baseUrl/${coupon.id}');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'code': coupon.code,
        'discount_amount': coupon.discountAmount,
        'usage_max': coupon.usageMax,
      }),
    );
    if (response.statusCode == 200) return true;

    print('Update failed: ${response.body}');
    return false;
  }

  /// Xoá coupon
  static Future<bool> deleteCoupon(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    return response.statusCode == 200;
  }
}
