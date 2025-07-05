import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ThemeSelectorWidget extends StatelessWidget {
  final String selectedTheme;
  final Function(String) onThemeChanged;
  final bool isDarkMode;

  const ThemeSelectorWidget({
    super.key,
    required this.selectedTheme,
    required this.onThemeChanged,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final theme = isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme;
    final List<String> themeOptions = ['Light', 'Dark', 'System'];

    return Column(
      children: themeOptions.map((option) {
        final bool isSelected = selectedTheme == option;

        return Container(
          margin: EdgeInsets.only(bottom: 2.h),
          child: InkWell(
            onTap: () => onThemeChanged(option),
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: isSelected
                    ? theme.colorScheme.primary.withValues(alpha: 0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.outline,
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: _getThemeIcon(option),
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurface,
                    size: 20,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Text(
                      option,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: isSelected
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurface,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ),
                  isSelected
                      ? CustomIconWidget(
                          iconName: 'check_circle',
                          color: theme.colorScheme.primary,
                          size: 20,
                        )
                      : const SizedBox.shrink(),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  String _getThemeIcon(String theme) {
    switch (theme) {
      case 'Light':
        return 'light_mode';
      case 'Dark':
        return 'dark_mode';
      case 'System':
        return 'settings_system_daydream';
      default:
        return 'settings';
    }
  }
}
