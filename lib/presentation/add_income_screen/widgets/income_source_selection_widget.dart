import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class IncomeSourceSelectionWidget extends StatelessWidget {
  final List<Map<String, dynamic>> sources;
  final String selectedSource;
  final Function(String) onSourceSelected;
  final bool isDarkMode;

  const IncomeSourceSelectionWidget({
    super.key,
    required this.sources,
    required this.selectedSource,
    required this.onSourceSelected,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final theme = isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Income Source',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 2.h),
        SizedBox(
          height: 12.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: BouncingScrollPhysics(),
            itemCount: sources.length,
            itemBuilder: (context, index) {
              final source = sources[index];
              final isSelected = selectedSource == source["name"];

              return Container(
                margin: EdgeInsets.only(right: 3.w),
                child: GestureDetector(
                  onTap: () => onSourceSelected(source["name"] as String),
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    width: 20.w,
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.getSuccessColor(!isDarkMode).withAlpha(26)
                          : theme.cardColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? AppTheme.getSuccessColor(!isDarkMode)
                            : theme.colorScheme.outline,
                        width: isSelected ? 2 : 1,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: AppTheme.getSuccessColor(!isDarkMode)
                                    .withAlpha(51),
                                blurRadius: 8,
                                offset: Offset(0, 2),
                              ),
                            ]
                          : [],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: source["icon"] as String,
                          size: 28,
                          color: isSelected
                              ? AppTheme.getSuccessColor(!isDarkMode)
                              : Color(source["color"] as int),
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          source["name"] as String,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: isSelected
                                ? AppTheme.getSuccessColor(!isDarkMode)
                                : theme.colorScheme.onSurface,
                            fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.w400,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        if (selectedSource.isEmpty)
          Container(
            margin: EdgeInsets.only(top: 1.h),
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: AppTheme.getErrorColor(!isDarkMode).withAlpha(26),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'error_outline',
                  size: 16,
                  color: AppTheme.getErrorColor(!isDarkMode),
                ),
                SizedBox(width: 2.w),
                Text(
                  'Please select an income source',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.getErrorColor(!isDarkMode),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
