import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/cart.dart';

/// Service để tương tác với API Cart
class CartService {
  /// Địa chỉ server API (điền URL của bạn)
  static const String _baseUrl = 'http://your-domain.com';

  /// Lấy danh sách Cart items theo userId hoặc sessionId
  ///
  /// Nếu [userId] != null, API sẽ dùng userId, ngược lại sẽ dùng sessionId.
  /// Trả về Future<List<Cart>>
  Future<List<Cart>> fetchCartItems({String? userId, String? sessionId}) async {
    if (userId == null && sessionId == null) {
      throw ArgumentError('Phải truyền userId hoặc sessionId');
    }
    final uri = Uri.parse('$_baseUrl/api/cart').replace(
      queryParameters: {
        if (userId != null) 'userId': userId,
        if (sessionId != null) 'sessionId': sessionId,
      },
    );

    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Cart.fromJson(json)).toList();
    } else {
      throw Exception('Lấy Cart items thất bại: HTTP ${response.statusCode}');
    }
  }

  /// Thêm một Cart item mới
  Future<Cart> addCartItem(Cart cart) async {
    final uri = Uri.parse('$_baseUrl/api/cart');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(cart.toJson()),
    );
    if (response.statusCode == 201) {
      return Cart.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Thêm Cart item thất bại: HTTP ${response.statusCode}');
    }
  }

  /// Cập nhật số lượng của Cart item
  Future<void> updateCartItem(String cartId, int quantity) async {
    final uri = Uri.parse('$_baseUrl/api/cart/$cartId');
    final response = await http.put(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'quantity': quantity}),
    );
    if (response.statusCode != 200) {
      throw Exception('Cập nhật Cart item thất bại: HTTP ${response.statusCode}');
    }
  }

  /// Xóa một Cart item theo [cartId]
  Future<void> deleteCartItem(String cartId) async {
    final uri = Uri.parse('$_baseUrl/api/cart/$cartId');
    final response = await http.delete(uri);
    if (response.statusCode != 200) {
      throw Exception('Xóa Cart item thất bại: HTTP ${response.statusCode}');
    }
  }
}
