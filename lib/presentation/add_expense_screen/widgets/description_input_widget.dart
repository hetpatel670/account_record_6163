import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class DescriptionInputWidget extends StatelessWidget {
  final TextEditingController controller;

  const DescriptionInputWidget({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description (Optional)',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 1.h),
        Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: controller.text.isNotEmpty
                  ? theme.colorScheme.primary
                  : theme.colorScheme.outline,
              width: controller.text.isNotEmpty ? 2 : 1,
            ),
          ),
          child: TextFormField(
            controller: controller,
            maxLines: 3,
            textInputAction: TextInputAction.done,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface,
            ),
            decoration: InputDecoration(
              hintText: 'Add a note about this expense...',
              hintStyle: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 4.w,
                vertical: 2.h,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
