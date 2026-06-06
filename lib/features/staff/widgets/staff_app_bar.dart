import 'package:flutter/material.dart';
import 'package:respiro/core/theme/app_colors.dart';

class StaffAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showBack;
  final Widget? leading;

  const StaffAppBar({
    super.key,
    required this.title,
    this.actions,
    this.showBack = false,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          color: AppColors.gray900,
        ),
      ),
      centerTitle: false,
      backgroundColor: AppColors.white,
      elevation: 0,
      leading: showBack
          ? leading ??
              IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: AppColors.gray900,
                  size: 20,
                ),
                onPressed: () => Navigator.of(context).pop(),
              )
          : leading,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
