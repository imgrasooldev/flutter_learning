import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../seeker/models/category_model.dart';

class JobPostPage extends StatefulWidget {
  final List<CategoryModel> categories;

  const JobPostPage({super.key, required this.categories});

  @override
  State<JobPostPage> createState() => _JobPostPageState();
}

class _JobPostPageState extends State<JobPostPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  CategoryModel? _selectedCategory;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  void _submitJob() {
    if (_titleController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _selectedCategory == null ||
        _selectedDate == null ||
        _selectedTime == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Job posted successfully!')));

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final viewInsets = MediaQuery.of(context).viewInsets;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Post Your Job',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(20, 20, 20, viewInsets.bottom + 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _sectionDivider('Job Details'),
            const SizedBox(height: 20),
            _inputField(
              controller: _titleController,
              label: 'Job Title',
              hint: 'Enter job title...',
              icon: Icons.work_outline,
            ),
            const SizedBox(height: 18),
            _inputField(
              controller: _descriptionController,
              label: 'Description',
              hint: 'Describe the job...',
              icon: Icons.description_outlined,
              maxLines: 4,
            ),
            const SizedBox(height: 30),
            _sectionDivider('Category & Timing'),
            const SizedBox(height: 20),
            _categoryDropdown(),
            const SizedBox(height: 18),
            _selectableField(
              label: 'Select Date',
              value:
                  _selectedDate != null
                      ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                      : '',
              icon: Icons.calendar_today_outlined,
              onTap: _pickDate,
            ),
            const SizedBox(height: 18),
            _selectableField(
              label: 'Select Time Slot',
              value:
                  _selectedTime != null ? _selectedTime!.format(context) : '',
              icon: Icons.access_time,
              onTap: _pickTime,
            ),
            const SizedBox(height: 40),
            _submitButton(),
          ],
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
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.w500,
          ),
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey),
          prefixIcon: Icon(icon, color: AppColors.primary),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
        ),
      ),
    );
  }

  Widget _categoryDropdown() {
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
      child: DropdownButtonFormField<CategoryModel>(
        value: _selectedCategory,
        isExpanded: true,
        icon: const Icon(Icons.keyboard_arrow_down),
        decoration: InputDecoration(
          labelText: 'Select Category',
          labelStyle: const TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.w500,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        items:
            widget.categories.map((cat) {
              return DropdownMenuItem<CategoryModel>(
                value: cat,
                child: Text(cat.name, style: const TextStyle(fontSize: 16)),
              );
            }).toList(),
        onChanged: (value) {
          setState(() => _selectedCategory = value);
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
      onTap: _submitJob,
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
            'Submit Job Request',
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

  Future<void> _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
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
    if (pickedDate != null) {
      setState(() => _selectedDate = pickedDate);
    }
  }

  Future<void> _pickTime() async {
    final pickedTime = await showTimePicker(
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
    if (pickedTime != null) {
      setState(() => _selectedTime = pickedTime);
    }
  }
}
