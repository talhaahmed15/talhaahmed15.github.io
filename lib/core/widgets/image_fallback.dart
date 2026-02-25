import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class ImageFallback extends StatelessWidget {
  const ImageFallback({required this.label, super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.cardAlt,
      alignment: Alignment.center,
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: AppColors.textMuted,
        ),
      ),
    );
  }
}
