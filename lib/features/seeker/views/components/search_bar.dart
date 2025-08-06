import 'package:flutter/material.dart';
import '../../models/sub_category_model.dart';
import '../../../../theme/app_colors.dart';

class SearchBarWidget extends StatefulWidget {
  final TextEditingController controller;
  final List<SubCategoryModel> filteredServices;
  final Function(SubCategoryModel) onSelect;
  final VoidCallback onClear;

  const SearchBarWidget({
    super.key,
    required this.controller,
    required this.filteredServices,
    required this.onSelect,
    required this.onClear,
  });

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  @override
  Widget build(BuildContext context) {
    final bool isTyping = widget.controller.text.isNotEmpty;
    final bool shouldShowSuggestions = widget.controller.text.length >= 1;

    return Column(
      children: [
        Material(
          elevation: 3,
          borderRadius: BorderRadius.circular(12),
          shadowColor: Colors.black12,
          child: TextField(
            controller: widget.controller,
            decoration: InputDecoration(
              hintText: 'Search services e.g., plumber, tutor...',
              prefixIcon: const Icon(Icons.search, color: AppColors.primary),
              suffixIcon:
                  isTyping
                      ? IconButton(
                        icon: const Icon(Icons.clear, color: AppColors.primary),
                        onPressed: () {
                          widget.controller.clear();
                          widget.onClear(); // <-- Trigger clear action
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
        if (widget.filteredServices.isNotEmpty)
          /* Container(
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
              itemCount: widget.filteredServices.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final service = widget.filteredServices[index];
                return ListTile(
                  title: Text(service.name),
                  onTap: () {
                    widget.onSelect(service); // <-- Trigger select action
                  },
                );
              },
            ),
          ), */
          if (shouldShowSuggestions && widget.filteredServices.isNotEmpty)
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
                itemCount: widget.filteredServices.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final service = widget.filteredServices[index];
                  return ListTile(
                    title: Text(service.name),
                    onTap: () {
                      widget.onSelect(service); // <-- Trigger select action
                    },
                  );
                },
              ),
            ),
      ],
    );
  }
}
