import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../theme/app_colors.dart';

class BookingBottomSheet extends StatefulWidget {
  final String providerName;
  final String serviceType; // 'between' | 'single'

  const BookingBottomSheet({
    super.key,
    required this.providerName,
    required this.serviceType,
  });

  @override
  State<BookingBottomSheet> createState() => _BookingBottomSheetState();
}

class _BookingBottomSheetState extends State<BookingBottomSheet> {
  bool isUrdu = true;

  DateTime? startDate;
  DateTime? endDate;
  TimeOfDay? fromTime;
  TimeOfDay? toTime;
  TextEditingController commentsController = TextEditingController();

  Future<void> _pickStartDate() async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primaryDark,
              secondary: AppColors.primaryDark, // fix for accent minute dial
              onPrimary: Colors.white,
              onSurface: AppColors.textPrimary,
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
    if (date != null) {
      setState(() => startDate = date);
    }
  }

  Future<void> _pickEndDate() async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: startDate ?? DateTime.now().add(const Duration(days: 1)),
      firstDate: startDate ?? DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primaryDark,
              secondary: AppColors.primaryDark,
              onPrimary: Colors.white,
              onSurface: AppColors.textPrimary,
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
    if (date != null) {
      setState(() => endDate = date);
    }
  }

  Future<void> _pickFromTime() async {
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: TimePickerThemeData(
              dialHandColor: AppColors.primaryDark,
              dialBackgroundColor: AppColors.primary.withOpacity(0.1),
              hourMinuteColor: AppColors.primaryDark,
              hourMinuteTextColor: Colors.white,
              entryModeIconColor: AppColors.primaryDark,
              helpTextStyle: const TextStyle(color: AppColors.primaryDark),
            ),
            colorScheme: ColorScheme.light(
              primary: AppColors.primaryDark,
              secondary: AppColors.primaryDark,
              onPrimary: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (time != null) {
      setState(() => fromTime = time);
    }
  }

  Future<void> _pickToTime() async {
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: TimePickerThemeData(
              dialHandColor: AppColors.primaryDark,
              dialBackgroundColor: AppColors.primary.withOpacity(0.1),
              hourMinuteColor: AppColors.primaryDark,
              hourMinuteTextColor: Colors.white,
              entryModeIconColor: AppColors.primaryDark,
              helpTextStyle: const TextStyle(color: AppColors.primaryDark),
            ),
            colorScheme: ColorScheme.light(
              primary: AppColors.primaryDark,
              secondary: AppColors.primaryDark,
              onPrimary: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (time != null) {
      setState(() => toTime = time);
    }
  }

  void _submitBooking() {
    if (startDate == null) {
      _showError(isUrdu ? 'Start Date chunein' : 'Please select start date');
      return;
    }

    if (widget.serviceType == 'between' && endDate == null) {
      _showError(isUrdu ? 'End Date chunein' : 'Please select end date');
      return;
    }

    if (fromTime == null || toTime == null) {
      _showError(isUrdu ? 'Apni Availability Time chunein' : 'Select your availability time');
      return;
    }

    String bookingDetails = "${DateFormat('dd MMM yyyy').format(startDate!)}";

    if (widget.serviceType == 'between' && endDate != null) {
      bookingDetails += " - ${DateFormat('dd MMM yyyy').format(endDate!)}";
    }

    bookingDetails += " ${isUrdu ? 'ko' : 'from'} ${fromTime!.format(context)} to ${toTime!.format(context)}";

    Navigator.pop(context); // Close Bottom Sheet
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text((isUrdu ? 'Booking bhej di gayi' : 'Booking sent') + " $bookingDetails")),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 40),
                  Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, size: 28, color: Colors.black54),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    isUrdu
                        ? (widget.serviceType == 'between'
                            ? "Select Start & End Dates"
                            : "Apni Availability Hours ka intikhab karein")
                        : (widget.serviceType == 'between'
                            ? "Select Start & End Dates"
                            : "Select Your Availability Hours"),
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryDark),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => setState(() => isUrdu = !isUrdu),
                    icon: const Icon(Icons.language, color: AppColors.primaryDark),
                  )
                ],
              ),
              const SizedBox(height: 20),
              _bigButton(
                icon: Icons.calendar_today,
                label: startDate != null
                    ? DateFormat('dd MMM yyyy').format(startDate!)
                    : (isUrdu ? 'Start Date Chunein' : 'Pick Start Date'),
                onTap: _pickStartDate,
              ),
              if (widget.serviceType == 'between') ...[
                const SizedBox(height: 12),
                _bigButton(
                  icon: Icons.calendar_today,
                  label: endDate != null
                      ? DateFormat('dd MMM yyyy').format(endDate!)
                      : (isUrdu ? 'End Date Chunein' : 'Pick End Date'),
                  onTap: _pickEndDate,
                ),
              ],
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _bigButton(
                      icon: Icons.login,
                      label: fromTime != null
                          ? fromTime!.format(context)
                          : (isUrdu ? 'From Time' : 'From Time'),
                      onTap: _pickFromTime,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _bigButton(
                      icon: Icons.logout,
                      label: toTime != null
                          ? toTime!.format(context)
                          : (isUrdu ? 'To Time' : 'To Time'),
                      onTap: _pickToTime,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextField(
                controller: commentsController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: isUrdu ? 'Kisi cheez ki tafseelat likhain...' : 'Add any specific instructions...',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _submitBooking,
                  icon: const Icon(Icons.send, color: Colors.white,),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryDark,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  label: Text(
                    isUrdu ? "Booking Bhejain" : "Send Booking",
                    style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.background),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bigButton({required IconData icon, required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primaryDark),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            const Icon(Icons.arrow_drop_down, color: AppColors.primaryDark),
          ],
        ),
      ),
    );
  }
}
