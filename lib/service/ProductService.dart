import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/brand.dart';
import '../models/category.dart';
import 'package:cpmad_final/pattern/current_user.dart';
import 'package:go_router/go_router.dart';

class ProductService {
  static const String _urlC = 'http://localhost:3002/api/category';
  static const String _urlB = 'http://localhost:3002/api/brand';

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
}