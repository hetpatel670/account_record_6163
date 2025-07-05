import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class CategoryCardWidget extends StatelessWidget {
  final Map<String, dynamic> category;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final bool showReorderHandle;

  const CategoryCardWidget({
    super.key,
    required this.category,
    required this.onEdit,
    required this.onDelete,
    this.showReorderHandle = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDefault = category["isDefault"] as bool? ?? false;
    final transactionCount = category["transactionCount"] as int? ?? 0;
    final totalAmount = category["totalAmount"] as double? ?? 0.0;
    final categoryColor = Color(category["color"] as int? ?? 0xFF2563EB);

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      child: Dismissible(
        key: ValueKey(category["id"]),
        direction:
            isDefault ? DismissDirection.none : DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.error,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(
                iconName: 'delete',
                color: Theme.of(context).colorScheme.onError,
                size: 24,
              ),
              SizedBox(height: 0.5.h),
              Text(
                'Delete',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Theme.of(context).colorScheme.onError,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
        ),
        confirmDismiss: (direction) async {
          if (isDefault) return false;
          return await _showDeleteConfirmation(context);
        },
        onDismissed: (direction) {
          if (!isDefault) {
            onDelete();
          }
        },
        child: GestureDetector(
          onTap: onEdit,
          child: Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Theme.of(context)
                    .colorScheme
                    .outline
                    .withValues(alpha: 0.2),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context)
                      .colorScheme
                      .shadow
                      .withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                // Category Icon with Color Indicator
                Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: BoxDecoration(
                    color: categoryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: CustomIconWidget(
                      iconName: category["icon"] as String? ?? 'category',
                      color: categoryColor,
                      size: 24,
                    ),
                  ),
                ),

                SizedBox(width: 4.w),

                // Category Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              category["name"] as String? ?? 'Unknown Category',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (isDefault)
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 2.w, vertical: 0.5.h),
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Default',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimaryContainer,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 1.h),
                      Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'receipt',
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                            size: 16,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            '$transactionCount transactions',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                    ),
                          ),
                          SizedBox(width: 4.w),
                          CustomIconWidget(
                            iconName: 'attach_money',
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                            size: 16,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            '\$${totalAmount.toStringAsFixed(2)}',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                      fontWeight: FontWeight.w500,
                                    ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(width: 2.w),

                // Action Buttons
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Edit Button
                    GestureDetector(
                      onTap: onEdit,
                      child: Container(
                        padding: EdgeInsets.all(2.w),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: CustomIconWidget(
                          iconName: 'edit',
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                          size: 18,
                        ),
                      ),
                    ),

                    SizedBox(width: 2.w),

                    // Reorder Handle or Delete Button
                    showReorderHandle
                        ? ReorderableDragStartListener(
                            index: 0, // This will be set by the parent
                            child: Container(
                              padding: EdgeInsets.all(2.w),
                              child: CustomIconWidget(
                                iconName: 'drag_handle',
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                                size: 18,
                              ),
                            ),
                          )
                        : !isDefault
                            ? GestureDetector(
                                onTap: onDelete,
                                child: Container(
                                  padding: EdgeInsets.all(2.w),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .errorContainer,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: CustomIconWidget(
                                    iconName: 'delete',
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onErrorContainer,
                                    size: 18,
                                  ),
                                ),
                              )
                            : SizedBox(
                                width:
                                    8.w), // Placeholder for default categories
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool?> _showDeleteConfirmation(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Category'),
        content: Text('Are you sure you want to delete "${category["name"]}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }
}
