import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/brand.dart';
import '../models/category.dart';
import 'package:cpmad_final/pattern/current_user.dart';
import 'package:go_router/go_router.dart';

import '../models/product.dart';
import '../models/productDiscount.dart';
import '../models/variant.dart';

class ProductService {
  static const String _urlC = 'http://localhost:3002/api/category';
  static const String _urlB = 'http://localhost:3002/api/brands';
  static const String _urlProduct = 'http://localhost:3002/api/products';
  static const String _urlVariants = 'http://localhost:3002/api/variants';

  static Future<List<Category>> fetchAllCategory() async {
    final res = await http.get(Uri.parse(_urlC));
    if (res.statusCode == 200) {
      return (json.decode(res.body) as List)
          .map((e) => Category.fromJson(e))
          .toList();
    }
    throw Exception('Failed to load categories');
  }

  static Future<Category> createCategory(String name) async {
    final res = await http.post(
      Uri.parse(_urlC),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'name': name}),
    );
    if (res.statusCode == 200) return Category.fromJson(json.decode(res.body));
    throw Exception(json.decode(res.body)['message'] ?? 'Create failed');
  }

  static Future<Category> updateCategory(String id, String name) async {
    print(id);
    final res = await http.put(
      Uri.parse('$_urlC/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'name': name}),
    );
    if (res.statusCode == 200) return Category.fromJson(json.decode(res.body));
    throw Exception('Update failed');
  }

  static Future<void> deleteCategory(String id) async {
    final res = await http.delete(Uri.parse('$_urlC/$id'));
    if (res.statusCode != 200) {
      final msg = json.decode(res.body)['message'] ?? 'Delete failed';
      throw Exception(msg);
    }
  }

  static Future<List<Brand>> fetchAllBrand() async {
    final res = await http.get(Uri.parse(_urlB));
    if (res.statusCode == 200) {
      return (json.decode(res.body) as List)
          .map((e) => Brand.fromJson(e))
          .toList();
    }
    throw Exception('Failed to load brand');
  }

  static Future<Brand> createBrand(String name) async {
    final res = await http.post(
      Uri.parse(_urlB),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'name': name}),
    );
    if (res.statusCode == 200) return Brand.fromJson(json.decode(res.body));
    throw Exception(json.decode(res.body)['message'] ?? 'Create failed');
  }

  static Future<Brand> updateBrand(String id, String name) async {
    print(id);
    final res = await http.put(
      Uri.parse('$_urlB/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'name': name}),
    );
    if (res.statusCode == 200) return Brand.fromJson(json.decode(res.body));
    throw Exception('Update failed');
  }

  static Future<void> deleteBrand(String id) async {
    final res = await http.delete(Uri.parse('$_urlB/$id'));
    if (res.statusCode != 200) {
      final msg = json.decode(res.body)['message'] ?? 'Delete failed';
      throw Exception(msg);
    }
  }

  static Future<List<Variant>> fetchVariantsByProduct(String productId) async {
    final response = await http.get(Uri.parse('$_urlVariants/by-product/$productId'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      final List<Variant> variants = jsonList.map((e) => Variant.fromJson(e)).toList();
      return variants;
    } else {
      throw Exception('Lỗi khi tải danh sách biến thể');
    }
  }

  static Future<Variant> createVariant(Variant v) async {
    final res = await http.post(
      Uri.parse(_urlVariants),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(v.toJson()),
    );
    if (res.statusCode == 201) {
      return Variant.fromJson(jsonDecode(res.body));
    } else {
      throw Exception('Tạo variant thất bại');
    }
  }

  static Future<Variant> updateVariant(String id, Variant v) async {
    final res = await http.put(
      Uri.parse('$_urlVariants/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(v.toJson()),
    );
    if (res.statusCode == 200) {
      return Variant.fromJson(jsonDecode(res.body));
    } else {
      throw Exception('Cập nhật variant thất bại');
    }
  }

  static Future<void> deleteVariant(String id) async {
    final res = await http.delete(Uri.parse('$_urlVariants/$id'));
    if (res.statusCode != 200) {
      throw Exception('Xoá variant thất bại');
    }
  }

  static Future<List<Product>> fetchAllProducts() async {
    final response = await http.get(Uri.parse(_urlProduct));
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  static Future<Product> createProduct(Product p) async {
    final res = await http.post(
      Uri.parse(_urlProduct),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(p.toJson()),
    );
    if (res.statusCode == 201) {
      return Product.fromJson(jsonDecode(res.body));
    } else {
      throw Exception('Tạo thất bại');
    }
  }

  static Future<Product> updateProduct(String id, Product p) async {
    final res = await http.put(
      Uri.parse('$_urlProduct/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(p.toJson()),
    );
    if (res.statusCode == 200) {
      return Product.fromJson(jsonDecode(res.body));
    } else {
      throw Exception('Cập nhật thất bại');
    }
  }

  static Future<void> deleteProduct(String id) async {
    final res = await http.delete(Uri.parse('$_urlProduct/$id'));
    if (res.statusCode != 200) {
      throw Exception('Xoá thất bại');
    }
  }

  static Future<bool> updateDiscounts(List<ProductDiscount> discounts) async {
    final url = Uri.parse('$_urlProduct/discounts/update');

    final body = jsonEncode({
      'discounts': discounts.map((e) => {
        'productId': e.productId,
        'discountPercent': e.discountPercent,
      }).toList()
    });

    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode == 200) return true;
    print('Update failed: ${response.body}');
    return false;
  }
}