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
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        title: const Text(
          'Post Your Job',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ), // <-- This line makes Back Button white
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: EdgeInsets.only(
              left: 24,
              right: 24,
              top: 16,
              bottom: MediaQuery.of(context).viewInsets.bottom + 24,
            ),
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
                      _selectedTime != null
                          ? _selectedTime!.format(context)
                          : '',
                  icon: Icons.access_time,
                  onTap: _pickTime,
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _submitJob,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 4,
                    shadowColor: AppColors.primary.withOpacity(0.3),
                  ),
                  child: const Text(
                    'Submit Job Request',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
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
      elevation: 1.5,
      borderRadius: BorderRadius.circular(14),
      shadowColor: Colors.black12,
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: AppColors.primary,
            fontSize: 15.5,
            fontWeight: FontWeight.w600,
          ),
          hintText: hint,
          prefixIcon: Icon(icon, color: AppColors.primary),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: AppColors.primary, width: 1.2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: AppColors.primary, width: 1.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: AppColors.primary, width: 1.2),
          ),
        ),
      ),
    );
  }

  Widget _categoryDropdown() {
    return Material(
      elevation: 1.5,
      borderRadius: BorderRadius.circular(14),
      shadowColor: Colors.black12,
      child: DropdownButtonFormField<CategoryModel>(
        value: _selectedCategory,
        isExpanded: true,
        icon: const Icon(Icons.keyboard_arrow_down),
        decoration: InputDecoration(
          labelText: 'Select Category',
          labelStyle: TextStyle(
            color: AppColors.primary,
            fontSize: 15.5,
            fontWeight: FontWeight.w600,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: AppColors.primary, width: 1.2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: AppColors.primary, width: 1.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: AppColors.primary, width: 1.2),
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
      elevation: 1.5,
      borderRadius: BorderRadius.circular(14),
      shadowColor: Colors.black12,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.primary, width: 1.2),
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
                    color: isSelected ? Colors.black : Colors.grey,
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
    );
    if (pickedDate != null) {
      setState(() => _selectedDate = pickedDate);
    }
  }

  Future<void> _pickTime() async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() => _selectedTime = pickedTime);
    }
  }
}
