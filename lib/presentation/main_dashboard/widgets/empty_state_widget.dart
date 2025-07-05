import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EmptyStateWidget extends StatelessWidget {
  final bool isDarkMode;

  const EmptyStateWidget({
    super.key,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 30.w,
            height: 30.w,
            decoration: BoxDecoration(
              color: (isDarkMode ? AppTheme.primaryDark : AppTheme.primaryLight)
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20.w),
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: 'receipt_long',
                color:
                    isDarkMode ? AppTheme.primaryDark : AppTheme.primaryLight,
                size: 48,
              ),
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'No Transactions Yet',
            style: (isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme)
                .textTheme
                .titleLarge,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 2.h),
          Text(
            'Start tracking your expenses by adding your first transaction. Tap the button below to get started.',
            style: TextStyle(
              color: isDarkMode
                  ? AppTheme.textSecondaryDark
                  : AppTheme.textSecondaryLight,
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4.h),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, '/add-expense-screen');
            },
            icon: CustomIconWidget(
              iconName: 'add',
              color: isDarkMode ? AppTheme.surfaceDark : AppTheme.surfaceLight,
              size: 20,
            ),
            label: Text(
              'Add Your First Expense',
              style: TextStyle(
                color:
                    isDarkMode ? AppTheme.surfaceDark : AppTheme.surfaceLight,
                fontWeight: FontWeight.w500,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  isDarkMode ? AppTheme.primaryDark : AppTheme.primaryLight,
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
