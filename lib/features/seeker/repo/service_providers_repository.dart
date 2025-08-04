import '../../../services/api_services.dart';
import '../models/service_providers_model.dart';

class ServiceProviderRepository {
  final ApiService _api = ApiService();

  Future<List<ServiceProvider>> fetchTopProviders({
    int? subcategoryId,
    required int areaId,
    int page = 1,
    int perPage = 10,
  }) async {
    try {
      String query = 'service-providers?';

      if (subcategoryId != null) {
        query +=
            'subcategoryId[eq]=${subcategoryId != null && subcategoryId != 0 ? subcategoryId : ''}&';
      }
      query += 'areaId[eq]=$areaId&page=$page&per_page=$perPage';
      final response = await _api.get(query, auth: true);
      // print('API Query: $query');

      if (response.data['success'] != true) {
        throw Exception(
          response.data['message'] ?? 'Failed to fetch providers',
        );
      }

      final List items = response.data['data']['items'];

      /* for (var item in items) {
        final int fetchedSubcategoryId = item['subcategory_id'];
        final int fetchedAreaId = item['area']['id'];
        print('Subcategory ID: $fetchedSubcategoryId, Area ID: $fetchedAreaId');
      } */

      return items.map((json) => ServiceProvider.fromJson(json)).toList();
    } catch (e) {
      throw Exception('An unexpected error occurred while fetching providers');
    }
  }
}
