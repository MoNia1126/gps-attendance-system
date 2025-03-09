import 'package:flutter/material.dart';
import 'package:gps_attendance_system/core/themes/app_colors.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    required this.text,
    required this.onPressed,
    super.key,
    this.backgroundColor = AppColors.primary,
    this.opacity = 0.8,
  });

  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          //fontWeight: FontWeight.bold,
          color: AppColors.whiteColor,
        ),
      ),
    );
  }
}
