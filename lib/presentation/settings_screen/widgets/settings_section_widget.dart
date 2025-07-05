import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SettingsSectionWidget extends StatelessWidget {
  final String title;
  final String icon;
  final Widget child;
  final bool isDarkMode;

  const SettingsSectionWidget({
    super.key,
    required this.title,
    required this.icon,
    required this.child,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final theme = isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: icon,
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
                SizedBox(width: 3.w),
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
            color: theme.dividerColor,
            indent: 4.w,
            endIndent: 4.w,
          ),
          Padding(
            padding: EdgeInsets.all(4.w),
            child: child,
          ),
        ],
      ),
    );
  }
}
