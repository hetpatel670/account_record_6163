import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TransactionCardWidget extends StatelessWidget {
  final Map<String, dynamic> transaction;
  final bool isMultiSelectMode;
  final bool isSelected;
  final String searchQuery;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const TransactionCardWidget({
    super.key,
    required this.transaction,
    this.isMultiSelectMode = false,
    this.isSelected = false,
    this.searchQuery = '',
    this.onTap,
    this.onLongPress,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final amount = transaction['amount'] as double;
    final isExpense = amount < 0;
    final amountColor = isExpense ? AppTheme.errorLight : AppTheme.successLight;
    final amountText = isExpense
        ? '-\$${amount.abs().toStringAsFixed(2)}'
        : '+\$${amount.toStringAsFixed(2)}';

    return Dismissible(
      key: Key(transaction['id']),
      background: _buildSwipeBackground(true),
      secondaryBackground: _buildSwipeBackground(false),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          onEdit?.call();
          return false;
        } else {
          return await _showDeleteConfirmation(context);
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.5.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.lightTheme.colorScheme.primaryContainer
              : AppTheme.lightTheme.cardColor,
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? Border.all(color: AppTheme.primaryLight, width: 2)
              : null,
          boxShadow: [
            BoxShadow(
              color: AppTheme.shadowLight,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            onLongPress: onLongPress,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Row(
                children: [
                  if (isMultiSelectMode) ...[
                    Container(
                      width: 24,
                      height: 24,
                      margin: EdgeInsets.only(right: 3.w),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected
                              ? AppTheme.primaryLight
                              : AppTheme.borderSubtleLight,
                          width: 2,
                        ),
                        color: isSelected
                            ? AppTheme.primaryLight
                            : Colors.transparent,
                      ),
                      child: isSelected
                          ? CustomIconWidget(
                              iconName: 'check',
                              color: Colors.white,
                              size: 16,
                            )
                          : null,
                    ),
                  ],
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: amountColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: CustomIconWidget(
                        iconName: transaction['categoryIcon'] ?? 'category',
                        color: amountColor,
                        size: 24,
                      ),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHighlightedText(
                          transaction['description'] ?? '',
                          searchQuery,
                          AppTheme.lightTheme.textTheme.titleMedium!,
                        ),
                        SizedBox(height: 0.5.h),
                        Row(
                          children: [
                            _buildHighlightedText(
                              transaction['category'] ?? '',
                              searchQuery,
                              AppTheme.lightTheme.textTheme.bodySmall!.copyWith(
                                color: AppTheme.textSecondaryLight,
                              ),
                            ),
                            Text(
                              ' • ${_formatTime(transaction['date'] as DateTime)}',
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme.textSecondaryLight,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        amountText,
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          color: amountColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        _formatDate(transaction['date'] as DateTime),
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondaryLight,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSwipeBackground(bool isEdit) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: isEdit ? AppTheme.primaryLight : AppTheme.errorLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Align(
        alignment: isEdit ? Alignment.centerLeft : Alignment.centerRight,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(
                iconName: isEdit ? 'edit' : 'delete',
                color: Colors.white,
                size: 24,
              ),
              SizedBox(height: 0.5.h),
              Text(
                isEdit ? 'Edit' : 'Delete',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHighlightedText(String text, String query, TextStyle style) {
    if (query.isEmpty) {
      return Text(text, style: style);
    }

    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase();
    final index = lowerText.indexOf(lowerQuery);

    if (index == -1) {
      return Text(text, style: style);
    }

    return RichText(
      text: TextSpan(
        children: [
          if (index > 0)
            TextSpan(
              text: text.substring(0, index),
              style: style,
            ),
          TextSpan(
            text: text.substring(index, index + query.length),
            style: style.copyWith(
              backgroundColor: AppTheme.warningLight.withValues(alpha: 0.3),
              fontWeight: FontWeight.w600,
            ),
          ),
          if (index + query.length < text.length)
            TextSpan(
              text: text.substring(index + query.length),
              style: style,
            ),
        ],
      ),
    );
  }

  String _formatTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;

    if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Yesterday';
    } else {
      return '${date.month}/${date.day}/${date.year}';
    }
  }

  Future<bool> _showDeleteConfirmation(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              'Delete Transaction',
              style: AppTheme.lightTheme.textTheme.titleLarge,
            ),
            content: Text(
              'Are you sure you want to delete "${transaction['description']}"?',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, true);
                  onDelete?.call();
                },
                child: const Text('Delete'),
              ),
            ],
          ),
        ) ??
        false;
  }
}
