import 'package:flutter/material.dart';
import 'package:respiro/core/theme/app_colors.dart';

class RiskBadge extends StatelessWidget {
  final String riskLevel;
  final double fontSize;

  const RiskBadge({
    super.key,
    required this.riskLevel,
    this.fontSize = 10,
  });

  Color get backgroundColor {
    switch (riskLevel) {
      case 'High':
        return AppColors.coral;
      case 'Medium':
        return AppColors.amber;
      case 'Low':
        return AppColors.primaryTeal;
      default:
        return AppColors.gray500;
    }
  }

  Color get textColor {
    switch (riskLevel) {
      case 'High':
        return AppColors.coral;
      case 'Medium':
        return AppColors.amber;
      case 'Low':
        return AppColors.primaryTeal;
      default:
        return AppColors.gray500;
    }
  }

  Color get bgLight {
    switch (riskLevel) {
      case 'High':
        return AppColors.coralPale;
      case 'Medium':
        return AppColors.amber.withAlpha(30);
      case 'Low':
        return AppColors.tealPale;
      default:
        return AppColors.gray200;
    }
  }

  String get label {
    switch (riskLevel) {
      case 'High':
        return 'Tinggi';
      case 'Medium':
        return 'Sedang';
      case 'Low':
        return 'Rendah';
      default:
        return riskLevel;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgLight,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w700,
          color: textColor,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}
