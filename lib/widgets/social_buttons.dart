import 'package:flutter/material.dart';

class SocialButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String iconPath;
  final String label;

  const SocialButton({
    super.key,
    required this.onPressed,
    required this.iconPath,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Image.asset(iconPath, height: 24, width: 24),
        label: Text(
          label,
          style: const TextStyle(
            fontFamily: 'WorkSans',
            fontSize: 15.19,
            fontWeight: FontWeight.w600,
            color: Color.fromARGB(255, 65, 65, 65),
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        ),
      ),
    );
  }
}
