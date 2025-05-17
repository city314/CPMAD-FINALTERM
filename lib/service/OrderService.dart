import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/coupon.dart';

class OrderService {
  static const String baseUrl = 'http://localhost:3003/api/coupons'; // đổi lại IP nếu chạy thật
  static const String _urlOrder = 'http://localhost:3003/api/orders'; // đổi lại IP nếu chạy thật
  static const String _urlOrderDetails = 'http://localhost:3003/api/orderdetails';
  static const String _urlOrderStatus = 'http://localhost:3003/api/order-status';
  static const String _urlCouponUsage = 'http://localhost:3003/api/coupon-usage';

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

  static Future<Coupon?> checkCoupon(String code) async {
    final uri = Uri.parse('$baseUrl/check?code=${code.toUpperCase()}');
    final resp = await http.get(uri);
    if (resp.statusCode == 200) {
      return Coupon.fromJson(json.decode(resp.body));
    } else {
      return null;
    }
  }

  static Future<String?> createOrder(Map<String, dynamic> payload) async {
    final uri = Uri.parse(_urlOrder);
    final resp = await http.post(uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(payload));
    if (resp.statusCode == 200) {
      final data = json.decode(resp.body);
      return data['_id']; // hoặc theo response thực tế
    }
    return null;
  }

  static Future<bool> createOrderDetails(List<Map<String, dynamic>> details) async {
    final uri = Uri.parse(_urlOrderDetails);
    final resp = await http.post(uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(details));
    return resp.statusCode == 200;
  }

  static Future<bool> useCoupon(String code) async {
    final uri = Uri.parse('$baseUrl/use/$code');
    final response = await http.patch(uri);
    return response.statusCode == 200;
  }

  static Future<bool> sendConfirmationEmail({
    required String email,
    required String name,
    required String orderId,
    required List<Map<String, dynamic>> items,
    required double finalAmount,
  }) async {
    final uri = Uri.parse('$_urlOrder/send-confirmation');
    final resp = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': email,
        'name': name,
        'orderId': orderId,
        'items': items,
        'finalAmount': finalAmount,
      }),
    );
    return resp.statusCode == 200;
  }

  static Future<bool> saveOrderStatus({
    required String orderId,
    required String status,
  }) async {
    final uri = Uri.parse(_urlOrderStatus);
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'order_id': orderId,
        'status': status,
      }),
    );
    return response.statusCode == 201;
  }

  static Future<bool> saveCouponUsage({
    required String orderId,
    required String couponCode,
  }) async {
    final uri = Uri.parse(_urlCouponUsage);
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'order_id': orderId,
        'coupon_code': couponCode,
      }),
    );
    return response.statusCode == 201;
  }
}
