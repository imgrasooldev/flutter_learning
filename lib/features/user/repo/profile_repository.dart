import '../../../services/api_services.dart';
import '../../auth/models/user_model.dart';

class UserRepository {
  final ApiService _api = ApiService();

  Future<UserModel> fetchUserProfile() async {
    try {
      final response = await _api.get('user/profile', auth: true);

      if (response.data['success'] != true) {
        throw Exception(
          response.data['message'] ?? 'Failed to fetch user profile',
        );
      }
      print("user profile fetched: $response");
      final userData = response.data['data'];

      return UserModel.fromJson(userData);
    } catch (e, stackTrace) {
      throw Exception('Failed to fetch user profile: $e');
    }
  }
}
