import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class DatePickerWidget extends StatelessWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  const DatePickerWidget({
    Key? key,
    required this.selectedDate,
    required this.onDateSelected,
  }) : super(key: key);

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(Duration(days: 1));
    final selectedDay = DateTime(date.year, date.month, date.day);

    if (selectedDay == today) {
      return 'Today';
    } else if (selectedDay == yesterday) {
      return 'Yesterday';
    } else {
      return '${date.month}/${date.day}/${date.year}';
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final theme = Theme.of(context);

    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2020),
        lastDate: DateTime.now(),
        builder: (context, child) {
          return DatePickerTheme(
              data: DatePickerThemeData(
                  backgroundColor: theme.colorScheme.surface,
                  headerBackgroundColor: theme.colorScheme.primary,
                  headerForegroundColor: theme.colorScheme.onPrimary,
                  dayForegroundColor: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.selected)) {
                      return theme.colorScheme.onPrimary;
                    }
                    return theme.colorScheme.onSurface;
                  }),
                  dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.selected)) {
                      return theme.colorScheme.primary;
                    }
                    return Colors.transparent;
                  })),
              child: child!);
        });

    if (picked != null && picked != selectedDate) {
      onDateSelected(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Date',
          style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600, color: theme.colorScheme.onSurface)),
      SizedBox(height: 1.h),
      GestureDetector(
          onTap: () => _selectDate(context),
          child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border:
                      Border.all(color: theme.colorScheme.outline, width: 1)),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_formatDate(selectedDate),
                        style: theme.textTheme.titleMedium
                            ?.copyWith(color: theme.colorScheme.onSurface)),
                    CustomIconWidget(
                        iconName: 'calendar_today',
                        color: theme.colorScheme.primary,
                        size: 5.w),
                  ]))),
    ]);
  }
}
