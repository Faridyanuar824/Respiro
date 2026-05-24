import 'package:flutter/material.dart';
import 'package:respiro/core/theme/app_colors.dart';

class AppInput extends StatelessWidget {
  final String? label;
  final String? hint;
  final String? errorText;
  final bool isPassword;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final IconData? prefixIcon;
  final String? Function(String?)? validator;
  final int? maxLines;

  const AppInput({
    super.key,
    this.label,
    this.hint,
    this.errorText,
    this.isPassword = false,
    this.controller,
    this.keyboardType,
    this.prefixIcon,
    this.validator,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.gray700,
            ),
          ),
          const SizedBox(height: 6),
        ],
        TextFormField(
          controller: controller,
          obscureText: isPassword,
          keyboardType: keyboardType,
          validator: validator,
          maxLines: maxLines,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.gray900,
          ),
          decoration: InputDecoration(
            hintText: hint,
            errorText: errorText,
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, size: 20, color: AppColors.gray500)
                : null,
          ),
        ),
      ],
    );
  }
}
