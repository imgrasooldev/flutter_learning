import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_learning/features/seeker/bloc/category_event.dart';
import 'package:flutter_learning/features/seeker/bloc/category_state.dart';
import 'package:flutter_learning/features/seeker/models/category_model.dart';
import 'package:flutter_learning/features/seeker/repo/category_repository.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRepository categoryRepository;
  List<CategoryModel> _cachedCategories = [];

  CategoryBloc(this.categoryRepository) : super(CategoryInitial()) {
    on<FetchCategories>((event, emit) async {
      if (_cachedCategories.isNotEmpty) {
        emit(CategoryLoaded(_cachedCategories));
        return;
      }

      emit(CategoryLoading());
      try {
        final categories = await categoryRepository.fetchCategories();
        _cachedCategories = categories; // Cache the data
        emit(CategoryLoaded(categories));
      } catch (e) {
        emit(CategoryError(e.toString()));
      }
    });
  }
}
