import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/Address.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cpmad_final/pattern/current_user.dart';
import 'package:go_router/go_router.dart';

import '../screens/user/home.dart';

class UserService {
  static const String _url = 'http://localhost:3001/api/users';

  static Future<void> registerUser({
    required String email,
    required String fullName,
    required String password,
  }) async {
    final url = Uri.parse('$_url/register');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'name': fullName,
        'password': password,
      }),
    );

    if (response.statusCode == 201) {
      // Đăng ký thành công
      print('Đăng ký thành công!');
    } else {
      // Lỗi đăng ký
      final error = jsonDecode(response.body)['message'];
      print('Lỗi: $error');
    }
  }

  static Future<void> loginUser({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    final url = Uri.parse('$_url/login');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // final prefs = await SharedPreferences.getInstance();
        // await prefs.setString('token', data['token']);
        // await prefs.setString('userName', data['user']['name']);

        CurrentUser().update(
          email: data['user']['email'],
          role: data['user']['role'],
          userId: data['user']['id'],
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đăng nhập thành công!')),
        );

        context.go('/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? 'Đăng nhập thất bại')),
        );
      }
    } catch (e) {
      print('Lỗi response body: ${e.toString()}');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lỗi định dạng phản hồi từ server')),
      );
    }
  }

  static Future<String> sendOtpToEmail(String email) async {
    final url = Uri.parse('$_url/forgot-password');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['otp']; // ⬅ trả mã OTP về
    } else {
      final error = jsonDecode(response.body)['message'];
      throw Exception(error);
    }
  }

  static Future<void> resetPassword(String email, String newPassword) async {
    final url = Uri.parse('$_url/reset-password');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'newPassword': newPassword,
      }),
    );

    if (response.statusCode != 200) {
      final data = jsonDecode(response.body);
      throw Exception(data['message'] ?? 'Lỗi khi đổi mật khẩu');
    }
  }

  static Future<Map<String, dynamic>> fetchUserByEmail(String email) async {
    final url = Uri.parse('$_url/profile/$email');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Không tìm thấy người dùng');
    }
  }

  static Future<List<Address>> fetchAddressesByEmail(String email) async {
    final url = Uri.parse('$_url/$email/addresses');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((json) => Address(
        receiverName: json['receiver_name'] ?? '',
        phoneNumber: json['phone'] ?? '',
        province: json['city'] ?? '',
        district: json['district'] ?? '',
        ward: json['commune'] ?? '',
        streetDetail: json['address'] ?? '',
      )).toList();
    } else {
      throw Exception('Không thể tải địa chỉ');
    }
  }

  static Future<void> addAddress(String email, Address addr) async {
    final url = Uri.parse('$_url/$email/addresses');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(addr.toJson()),
    );
    if (response.statusCode != 200) throw Exception('Lỗi thêm địa chỉ');
  }

  static Future<void> updateAddress(String email, int index, Address addr) async {
    final url = Uri.parse('$_url/$email/addresses/$index');
    print("toi ne");
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(addr.toJson()),
    );
    if (response.statusCode != 200) {
      print('Body: ${response.body}');
      throw Exception('Lỗi cập nhật địa chỉ');
    }
  }

  static Future<void> deleteAddress(String email, int index) async {
    final url = Uri.parse('$_url/$email/addresses/$index');
    final response = await http.delete(url);
    if (response.statusCode != 200) throw Exception('Lỗi xoá địa chỉ');
  }
}
