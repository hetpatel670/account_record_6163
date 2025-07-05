import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RecentTransactionsWidget extends StatelessWidget {
  final List<Map<String, dynamic>> transactions;
  final bool isDarkMode;
  final Function(Map<String, dynamic>) onTransactionTap;
  final Function(Map<String, dynamic>) onTransactionLongPress;
  final Function(int) onTransactionDelete;

  const RecentTransactionsWidget({
    super.key,
    required this.transactions,
    required this.isDarkMode,
    required this.onTransactionTap,
    required this.onTransactionLongPress,
    required this.onTransactionDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Transactions',
                style: (isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme)
                    .textTheme
                    .titleMedium,
              ),
              TextButton(
                onPressed: () {
                  // Navigate to all transactions
                },
                child: Text(
                  'View All',
                  style: TextStyle(
                    color: isDarkMode
                        ? AppTheme.primaryDark
                        : AppTheme.primaryLight,
                    fontSize: 12.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 1.h),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          itemCount: transactions.length > 5 ? 5 : transactions.length,
          itemBuilder: (context, index) {
            final transaction = transactions[index];
            return Dismissible(
              key: Key(transaction["id"].toString()),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) {
                onTransactionDelete(transaction["id"] as int);
              },
              background: Container(
                alignment: Alignment.centerRight,
                padding: EdgeInsets.only(right: 4.w),
                margin: EdgeInsets.only(bottom: 2.h),
                decoration: BoxDecoration(
                  color: isDarkMode ? AppTheme.errorDark : AppTheme.errorLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: CustomIconWidget(
                  iconName: 'delete',
                  color:
                      isDarkMode ? AppTheme.surfaceDark : AppTheme.surfaceLight,
                  size: 24,
                ),
              ),
              child: GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  onTransactionTap(transaction);
                },
                onLongPress: () {
                  HapticFeedback.mediumImpact();
                  onTransactionLongPress(transaction);
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: 2.h),
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: isDarkMode ? AppTheme.cardDark : AppTheme.cardLight,
                    borderRadius: BorderRadius.circular(12),
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
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(3.w),
                        decoration: BoxDecoration(
                          color: Color(transaction["color"] as int)
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: CustomIconWidget(
                          iconName: transaction["icon"] as String,
                          color: Color(transaction["color"] as int),
                          size: 24,
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              transaction["title"] as String,
                              style: TextStyle(
                                color: isDarkMode
                                    ? AppTheme.textPrimaryDark
                                    : AppTheme.textPrimaryLight,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 0.5.h),
                            Text(
                              transaction["category"] as String,
                              style: TextStyle(
                                color: isDarkMode
                                    ? AppTheme.textSecondaryDark
                                    : AppTheme.textSecondaryLight,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(height: 0.5.h),
                            Text(
                              _formatDate(transaction["date"] as DateTime),
                              style: TextStyle(
                                color: isDarkMode
                                    ? AppTheme.textSecondaryDark
                                    : AppTheme.textSecondaryLight,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${(transaction["amount"] as double) >= 0 ? '+' : ''}\$${(transaction["amount"] as double).toStringAsFixed(2)}',
                            style: TextStyle(
                              color: (transaction["amount"] as double) >= 0
                                  ? (isDarkMode
                                      ? AppTheme.successDark
                                      : AppTheme.successLight)
                                  : (isDarkMode
                                      ? AppTheme.errorDark
                                      : AppTheme.errorLight),
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.month}/${date.day}/${date.year}';
    }
  }
}
