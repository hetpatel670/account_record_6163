import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import './transaction_card_widget.dart';

class TransactionSectionWidget extends StatelessWidget {
  final String sectionTitle;
  final List<Map<String, dynamic>> transactions;
  final bool isMultiSelectMode;
  final Set<String> selectedTransactions;
  final String searchQuery;
  final Function(Map<String, dynamic>) onTransactionTap;
  final Function(Map<String, dynamic>) onTransactionLongPress;
  final Function(Map<String, dynamic>) onEditTransaction;
  final Function(Map<String, dynamic>) onDeleteTransaction;

  const TransactionSectionWidget({
    super.key,
    required this.sectionTitle,
    required this.transactions,
    this.isMultiSelectMode = false,
    this.selectedTransactions = const {},
    this.searchQuery = '',
    required this.onTransactionTap,
    required this.onTransactionLongPress,
    required this.onEditTransaction,
    required this.onDeleteTransaction,
  });

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return const SizedBox.shrink();
    }

    final totalAmount = transactions.fold<double>(
      0.0,
      (sum, transaction) => sum + (transaction['amount'] as double),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                sectionTitle,
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimaryLight,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: totalAmount >= 0
                      ? AppTheme.successLight.withValues(alpha: 0.1)
                      : AppTheme.errorLight.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  totalAmount >= 0
                      ? '+\$${totalAmount.toStringAsFixed(2)}'
                      : '-\$${totalAmount.abs().toStringAsFixed(2)}',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: totalAmount >= 0
                        ? AppTheme.successLight
                        : AppTheme.errorLight,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: transactions.length,
          itemBuilder: (context, index) {
            final transaction = transactions[index];
            final transactionId = transaction['id'] as String;

            return TransactionCardWidget(
              transaction: transaction,
              isMultiSelectMode: isMultiSelectMode,
              isSelected: selectedTransactions.contains(transactionId),
              searchQuery: searchQuery,
              onTap: () => onTransactionTap(transaction),
              onLongPress: () => onTransactionLongPress(transaction),
              onEdit: () => onEditTransaction(transaction),
              onDelete: () => onDeleteTransaction(transaction),
            );
          },
        ),
        SizedBox(height: 2.h),
      ],
    );
  }
}
