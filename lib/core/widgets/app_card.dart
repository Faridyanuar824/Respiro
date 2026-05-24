import 'package:flutter/material.dart';
import 'package:respiro/core/theme/app_colors.dart';
import 'package:respiro/core/constants/app_constants.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;
  final Color? color;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? margin;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius,
    this.color,
    this.onTap,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? EdgeInsets.zero,
      child: Material(
        color: color ?? AppColors.white,
        borderRadius: BorderRadius.circular(borderRadius ?? AppConstants.cardRadius),
        elevation: 0,
        shadowColor: Colors.black.withAlpha(18),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius ?? AppConstants.cardRadius),
          child: Container(
            padding: padding ?? const EdgeInsets.all(AppConstants.paddingMd),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius ?? AppConstants.cardRadius),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(12),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
