import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class CategoryEmptyStateWidget extends StatelessWidget {
  final VoidCallback onCreateCategory;

  const CategoryEmptyStateWidget({
    super.key,
    required this.onCreateCategory,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Illustration Container
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .primaryContainer
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(20.w),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Background circles for depth
                  Positioned(
                    top: 8.w,
                    left: 8.w,
                    child: Container(
                      width: 8.w,
                      height: 8.w,
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(4.w),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 6.w,
                    right: 6.w,
                    child: Container(
                      width: 6.w,
                      height: 6.w,
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .secondary
                            .withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(3.w),
                      ),
                    ),
                  ),

                  // Main icon
                  Container(
                    width: 20.w,
                    height: 20.w,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(10.w),
                    ),
                    child: Center(
                      child: CustomIconWidget(
                        iconName: 'category',
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        size: 32,
                      ),
                    ),
                  ),

                  // Plus icon overlay
                  Positioned(
                    bottom: 8.w,
                    right: 8.w,
                    child: Container(
                      width: 8.w,
                      height: 8.w,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(4.w),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.surface,
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: CustomIconWidget(
                          iconName: 'add',
                          color: Theme.of(context).colorScheme.onPrimary,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 6.h),

            // Title
            Text(
              'No Custom Categories Yet',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 2.h),

            // Description
            Text(
              'Create custom categories to better organize your expenses and get more detailed insights into your spending habits.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    height: 1.5,
                  ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 4.h),

            // Benefits List
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _buildBenefitItem(
                    context,
                    icon: 'insights',
                    title: 'Better Insights',
                    description:
                        'Track spending patterns with personalized categories',
                  ),
                  SizedBox(height: 3.h),
                  _buildBenefitItem(
                    context,
                    icon: 'palette',
                    title: 'Custom Design',
                    description:
                        'Choose icons and colors that match your style',
                  ),
                  SizedBox(height: 3.h),
                  _buildBenefitItem(
                    context,
                    icon: 'sort',
                    title: 'Easy Organization',
                    description: 'Organize transactions exactly how you want',
                  ),
                ],
              ),
            ),

            SizedBox(height: 6.h),

            // Create Category Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onCreateCategory,
                icon: CustomIconWidget(
                  iconName: 'add',
                  color: Theme.of(context).colorScheme.onPrimary,
                  size: 20,
                ),
                label: Text(
                  'Create Your First Category',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            SizedBox(height: 2.h),

            // Secondary Action
            TextButton(
              onPressed: () {
                // Show info about default categories
                _showDefaultCategoriesInfo(context);
              },
              child: Text(
                'Learn about default categories',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBenefitItem(
    BuildContext context, {
    required String icon,
    required String title,
    required String description,
  }) {
    return Row(
      children: [
        Container(
          width: 10.w,
          height: 10.w,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: CustomIconWidget(
              iconName: icon,
              color: Theme.of(context).colorScheme.primary,
              size: 20,
            ),
          ),
        ),
        SizedBox(width: 4.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                description,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showDefaultCategoriesInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Default Categories'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your account comes with these default categories:',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 2.h),
            _buildDefaultCategoryItem(context, 'Food & Dining', 'restaurant'),
            _buildDefaultCategoryItem(
                context, 'Transportation', 'directions_car'),
            _buildDefaultCategoryItem(context, 'Entertainment', 'movie'),
            _buildDefaultCategoryItem(
                context, 'Bills & Utilities', 'receipt_long'),
            SizedBox(height: 2.h),
            Text(
              'Default categories cannot be deleted but can be customized with different icons and colors.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Got it'),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultCategoryItem(
      BuildContext context, String name, String icon) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: icon,
            color: Theme.of(context).colorScheme.primary,
            size: 16,
          ),
          SizedBox(width: 2.w),
          Text(
            name,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
