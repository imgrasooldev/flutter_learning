import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_learning/features/seeker/models/sub_category_model.dart';
import '../../../theme/app_colors.dart';

class AddServicePage extends StatefulWidget {
  final List<SubCategoryModel> subCategories;

  const AddServicePage({super.key, required this.subCategories});

  @override
  State<AddServicePage> createState() => _AddServicePageState();
}

class _AddServicePageState extends State<AddServicePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();

  SubCategoryModel? _selectedSubCategory;
  String? _availableTime;

  void _pickTime() async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primaryDark,
              onPrimary: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _availableTime = picked.format(context);
      });
    }
  }

  void _submitService() {
    if (_titleController.text.isEmpty ||
        _selectedSubCategory == null ||
        _availableTime == null ||
        _experienceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    final serviceData = {
      'title': _titleController.text,
      'subcategory_id': _selectedSubCategory!.id,
      'experience': int.parse(_experienceController.text),
      'available_time': _availableTime,
    };

    print('Submitting Service: $serviceData');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Service Added Successfully!')),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final viewInsets = MediaQuery.of(context).viewInsets;

    return Theme(
      data: Theme.of(context).copyWith(
        inputDecorationTheme: InputDecorationTheme(
          floatingLabelStyle: const TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
          ),
          labelStyle: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
        ),
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('Add New Service', style: TextStyle(color: Colors.white)),
          backgroundColor: AppColors.primary,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(20, 20, 20, viewInsets.bottom + 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _sectionDivider('Service Details'),
              const SizedBox(height: 20),
              _inputField(
                controller: _titleController,
                label: 'Service Title (Details)',
                hint: 'Enter detailed service title...',
                icon: Icons.work_outline,
                keyboardType: TextInputType.multiline,
                maxLines: 4,
              ),
              const SizedBox(height: 18),
              _inputField(
                controller: _experienceController,
                label: 'Experience (Years)',
                hint: 'Enter experience in years...',
                icon: Icons.description_outlined,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              const SizedBox(height: 30),
              _sectionDivider('Category & Timing'),
              const SizedBox(height: 20),
              _subCategoryDropdown(),
              const SizedBox(height: 18),
              _selectableField(
                label: 'Select Available Time',
                value: _availableTime ?? '',
                icon: Icons.access_time,
                onTap: _pickTime,
              ),
              const SizedBox(height: 40),
              _submitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionDivider(String title) {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.black12, thickness: 1)),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 12),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 14.5,
              color: AppColors.primaryDark,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(child: Divider(color: Colors.black12, thickness: 1)),
      ],
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.fieldFill,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          hintStyle: const TextStyle(color: AppColors.textMuted),
          prefixIcon: Icon(icon, color: AppColors.primary),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
        ),
        style: const TextStyle(color: AppColors.textPrimary),
      ),
    );
  }

  Widget _subCategoryDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.fieldFill,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonFormField<SubCategoryModel>(
        value: _selectedSubCategory,
        isExpanded: true,
        icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.primary),
        decoration: InputDecoration(
          labelText: 'Select Subcategory',
          labelStyle: const TextStyle(color: AppColors.textPrimary),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        items: widget.subCategories.map((subCat) {
          return DropdownMenuItem<SubCategoryModel>(
            value: subCat,
            child: Text(subCat.name, style: const TextStyle(fontSize: 16, color: AppColors.textPrimary)),
          );
        }).toList(),
        onChanged: (value) {
          setState(() => _selectedSubCategory = value);
        },
      ),
    );
  }

  Widget _selectableField({
    required String label,
    required String value,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final bool isSelected = value.isNotEmpty;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Ink(
        decoration: BoxDecoration(
          color: AppColors.fieldFill,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black12.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                isSelected ? value : label,
                style: TextStyle(
                  fontSize: 16,
                  color: isSelected ? AppColors.textPrimary : AppColors.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _submitButton() {
    return GestureDetector(
      onTap: _submitService,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primary.withOpacity(0.9),
              AppColors.primaryDark.withOpacity(0.85),
            ],
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: const Center(
          child: Text(
            'Add Service',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }
}
