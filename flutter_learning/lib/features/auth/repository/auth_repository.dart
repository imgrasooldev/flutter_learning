import 'package:flutter_learning/features/auth/models/user_model.dart';
import 'package:flutter_learning/services/api_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

class AuthRepository {
  final _api = ApiService();

  Future<UserModel> login(String email, String password) async {
    try {
      final res = await _api.post('login', {
        'email': email,
        'password': password,
      });

      if (res.data['success'] != true) {
        throw Exception(res.data['message'] ?? 'Login failed');
      }

      final data = res.data['data'];
      final user = UserModel.fromJson(data);
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('token', user.token);
      return user;
    } on DioException catch (e) {
      // Custom message for 404 or other errors
      final statusCode = e.response?.statusCode;
      final message =
          e.response?.data['message'] ?? 'Login failed (HTTP $statusCode)';
      // throw Exception("Login faild");
      throw message.toString();
    } catch (e) {
      throw Exception('An unexpected error occurred');
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
  }
}
