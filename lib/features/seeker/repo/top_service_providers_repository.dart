import 'package:dio/dio.dart';
import '../../../services/api_services.dart';
import '../models/service_providers_model.dart';

class ServiceProviderRepository {
  final ApiService _api = ApiService();

  Future<List<ServiceProvider>> fetchTopProviders({
    required int subcategoryId,
    required int areaId,
    int page = 1,
    int perPage = 10,
  }) async {
    try {
      final response = await _api.get(
        'service-providers?subcategoryId=$subcategoryId&areaId=$areaId&page=$page&per_page=$perPage',
        auth: true,
      );

      if (response.data['success'] != true) {
        throw Exception(
          response.data['message'] ?? 'Failed to fetch providers',
        );
      }

      final List items = response.data['data']['items'];
      return items.map((json) => ServiceProvider.fromJson(json)).toList();
    } on DioException catch (e) {
      final message =
          e.response?.data['message'] ?? 'Failed to fetch providers';
      throw Exception(message);
    } catch (e, stacktrace) {
      throw Exception('An unexpected error occurred while fetching providers');
    }
  }
}
