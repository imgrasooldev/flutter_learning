import 'package:dio/dio.dart';
import '../models/sub_category_model.dart';
import '../../../services/api_services.dart';

class SubCategoryRepository {
  final ApiService _api = ApiService();

  Future<List<SubCategoryModel>> fetchCategories() async {
    try {
      final response = await _api.get(
        'categories/search-category-list-dropdown',
        auth: true,
      );

      if (response.data['success'] != true) {
        throw Exception(
          response.data['message'] ?? 'Failed to fetch categories',
        );
      }

      final List categoriesJson = response.data['data'];
      print('Fetched Categories JSON: $categoriesJson');
      return categoriesJson
          .map((json) => SubCategoryModel.fromJson(json))
          .toList();
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      final message =
          e.response?.data['message'] ??
          'Failed to fetch categories (HTTP $statusCode)';
      throw Exception(message);
    } catch (e) {
      throw Exception('An unexpected error occurred while fetching categories');
    }
  }
}
