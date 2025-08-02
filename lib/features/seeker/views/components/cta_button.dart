import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../theme/app_colors.dart';

class CTAButton extends StatelessWidget {
  const CTAButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 16,
      right: 16,
      bottom: 16,
      child: ElevatedButton.icon(
        onPressed: () => context.go('/provider_home'),
        icon: const Icon(Icons.handyman_outlined, color: Colors.white),
        label: const Text(
          'Offer your service',
          style: TextStyle(color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 50),
          backgroundColor: AppColors.primaryDark,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26),
          ),
          elevation: 4,
        ),
      ),
    );
  }
}
