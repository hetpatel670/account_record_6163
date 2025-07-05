import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BalanceCardWidget extends StatelessWidget {
  final double totalBalance;
  final double totalIncome;
  final double totalExpenses;
  final bool isDarkMode;

  const BalanceCardWidget({
    super.key,
    required this.totalBalance,
    required this.totalIncome,
    required this.totalExpenses,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDarkMode
              ? [
                  AppTheme.primaryDark,
                  AppTheme.primaryDark.withValues(alpha: 0.8)
                ]
              : [
                  AppTheme.primaryLight,
                  AppTheme.primaryLight.withValues(alpha: 0.8)
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: (isDarkMode ? AppTheme.shadowDark : AppTheme.shadowLight),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total Balance',
            style: TextStyle(
              color: isDarkMode ? AppTheme.surfaceDark : AppTheme.surfaceLight,
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            '\$${totalBalance.toStringAsFixed(2)}',
            style: TextStyle(
              color: isDarkMode ? AppTheme.surfaceDark : AppTheme.surfaceLight,
              fontSize: 28.sp,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
            ),
          ),
          SizedBox(height: 3.h),
          Row(
            children: [
              Expanded(
                child: _buildBalanceItem(
                  'Income',
                  totalIncome,
                  'trending_up',
                  isDarkMode ? AppTheme.successDark : AppTheme.successLight,
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: _buildBalanceItem(
                  'Expenses',
                  totalExpenses,
                  'trending_down',
                  isDarkMode ? AppTheme.errorDark : AppTheme.errorLight,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceItem(
      String title, double amount, String iconName, Color color) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: (isDarkMode ? AppTheme.surfaceDark : AppTheme.surfaceLight)
            .withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: iconName,
                color: color,
                size: 16,
              ),
              SizedBox(width: 2.w),
              Text(
                title,
                style: TextStyle(
                  color: (isDarkMode
                          ? AppTheme.surfaceDark
                          : AppTheme.surfaceLight)
                      .withValues(alpha: 0.8),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            '\$${amount.toStringAsFixed(2)}',
            style: TextStyle(
              color: isDarkMode ? AppTheme.surfaceDark : AppTheme.surfaceLight,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
