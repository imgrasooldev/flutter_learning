import 'package:flutter/material.dart';
import 'package:flutter_learning/features/seeker/models/category_model.dart';
import '../../../../theme/app_colors.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final List<CategoryModel> filteredServices;
  final Function(CategoryModel) onSelect;

  const SearchBarWidget({
    super.key,
    required this.controller,
    required this.filteredServices,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final bool isTyping = controller.text.isNotEmpty;

    return Column(
      children: [
        Material(
          elevation: 3,
          borderRadius: BorderRadius.circular(12),
          shadowColor: Colors.black12,
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: 'Search services e.g., plumber, tutor...',
              prefixIcon: const Icon(Icons.search, color: AppColors.primary),
              suffixIcon:
                  isTyping
                      ? IconButton(
                        icon: const Icon(Icons.clear, color: AppColors.primary),
                        onPressed: () {
                          controller.clear();
                        },
                      )
                      : null,
              filled: true,
              fillColor: AppColors.fieldFill,
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        if (filteredServices.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 8),
            constraints: const BoxConstraints(maxHeight: 200),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: ListView.builder(
              itemCount: filteredServices.length,
              itemBuilder: (context, index) {
                final service = filteredServices[index];
                return ListTile(
                  title: Text(service.name),
                  onTap: () => onSelect(service),
                );
              },
            ),
          ),
      ],
    );
  }
}
