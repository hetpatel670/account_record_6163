import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuickAddExpenseWidget extends StatelessWidget {
  final List<Map<String, dynamic>> categories;
  final bool isDarkMode;
  final Function(Map<String, dynamic>) onCategoryTap;

  const QuickAddExpenseWidget({
    super.key,
    required this.categories,
    required this.isDarkMode,
    required this.onCategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Text(
            'Quick Add',
            style: (isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme)
                .textTheme
                .titleMedium,
          ),
        ),
        SizedBox(height: 2.h),
        Container(
          height: 12.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return Container(
                margin: EdgeInsets.only(right: 3.w),
                child: GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    onCategoryTap(category);
                  },
                  child: Container(
                    width: 20.w,
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color:
                          isDarkMode ? AppTheme.cardDark : AppTheme.cardLight,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: (isDarkMode
                            ? AppTheme.borderSubtleDark
                            : AppTheme.borderSubtleLight),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: (isDarkMode
                              ? AppTheme.shadowDark
                              : AppTheme.shadowLight),
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(2.w),
                          decoration: BoxDecoration(
                            color: Color(category["color"] as int)
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: CustomIconWidget(
                            iconName: category["icon"] as String,
                            color: Color(category["color"] as int),
                            size: 24,
                          ),
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          category["name"] as String,
                          style: TextStyle(
                            color: isDarkMode
                                ? AppTheme.textPrimaryDark
                                : AppTheme.textPrimaryLight,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
