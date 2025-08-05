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
        padding: EdgeInsets.fromLTRB(24, 20, 24, viewInsets.bottom + 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _inputField(
              controller: _titleController,
              label: 'Job Title',
              hint: 'Enter job title...',
              icon: Icons.work_outline,
            ),
            const SizedBox(height: 20),
            _inputField(
              controller: _descriptionController,
              label: 'Description',
              hint: 'Describe the job...',
              icon: Icons.description_outlined,
              maxLines: 4,
            ),
            const SizedBox(height: 20),
            _categoryDropdown(),
            const SizedBox(height: 20),
            _selectableField(
              label: 'Select Date',
              value:
                  _selectedDate != null
                      ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                      : '',
              icon: Icons.calendar_today_outlined,
              onTap: _pickDate,
            ),
            const SizedBox(height: 20),
            _selectableField(
              label: 'Select Time Slot',
              value:
                  _selectedTime != null ? _selectedTime!.format(context) : '',
              icon: Icons.access_time,
              onTap: _pickTime,
            ),
            const SizedBox(height: 30),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryDark],
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: ElevatedButton(
                onPressed: _submitJob,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Submit Job Request',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
  }) {
    return Material(
      elevation: 2.5,
      shadowColor: Colors.black12,
      borderRadius: BorderRadius.circular(14),
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
          prefixIcon: Icon(icon, color: AppColors.primary),
          filled: true,
          fillColor: AppColors.fieldFill,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.4),
          ),
        ),
      ),
    );
  }

  Widget _categoryDropdown() {
    return Material(
      elevation: 2.5,
      borderRadius: BorderRadius.circular(14),
      shadowColor: Colors.black12,
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
          filled: true,
          fillColor: AppColors.fieldFill,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.4),
          ),
        ),
        items:
            widget.categories.map((cat) {
              return DropdownMenuItem<CategoryModel>(
                value: cat,
                child: Text(
                  cat.name,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 15.5),
                ),
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
    return Material(
      elevation: 2.5,
      borderRadius: BorderRadius.circular(14),
      shadowColor: Colors.black12,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Ink(
          decoration: BoxDecoration(
            color: AppColors.fieldFill,
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              Icon(icon, color: AppColors.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  isSelected ? value : label,
                  style: TextStyle(
                    fontSize: 15.5,
                    color:
                        isSelected
                            ? AppColors.textPrimary
                            : AppColors.primary, // <-- FIXED
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
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
              secondary: AppColors.primaryDark,
              onPrimary: Colors.white,
              onSurface: Colors.black87,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primaryDark,
              ),
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
              secondary: AppColors.primaryDark,
              onPrimary: Colors.white,
              onSurface: Colors.black87,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primaryDark,
              ),
            ),
            timePickerTheme: TimePickerThemeData(
              dialHandColor: AppColors.primaryDark,
              dialBackgroundColor: AppColors.primary.withOpacity(0.1),
              hourMinuteColor: AppColors.primaryDark,
              hourMinuteTextColor: Colors.white,
              entryModeIconColor: AppColors.primaryDark,
              helpTextStyle: const TextStyle(color: AppColors.primaryDark),
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
