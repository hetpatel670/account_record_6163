import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class NotificationSettingsWidget extends StatelessWidget {
  final bool expenseReminders;
  final bool budgetAlerts;
  final Function(bool, bool) onSettingsChanged;
  final bool isDarkMode;

  const NotificationSettingsWidget({
    super.key,
    required this.expenseReminders,
    required this.budgetAlerts,
    required this.onSettingsChanged,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final theme = isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme;

    return Column(
      children: [
        _buildNotificationOption(
          theme: theme,
          icon: 'notifications_active',
          title: 'Expense Reminders',
          subtitle: 'Daily reminders to log expenses',
          value: expenseReminders,
          onChanged: (value) => onSettingsChanged(value, budgetAlerts),
        ),
        SizedBox(height: 2.h),
        _buildNotificationOption(
          theme: theme,
          icon: 'warning',
          title: 'Budget Alerts',
          subtitle: 'Notifications when approaching budget limits',
          value: budgetAlerts,
          onChanged: (value) => onSettingsChanged(expenseReminders, value),
        ),
        SizedBox(height: 2.h),
        Container(
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: AppTheme.getWarningColor(!isDarkMode).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color:
                  AppTheme.getWarningColor(!isDarkMode).withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            children: [
              CustomIconWidget(
                iconName: 'info',
                color: AppTheme.getWarningColor(!isDarkMode),
                size: 20,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  'Notification permissions may be required for alerts to work properly.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.getWarningColor(!isDarkMode),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationOption({
    required ThemeData theme,
    required String icon,
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        border: Border.all(color: theme.colorScheme.outline),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: icon,
            color: value
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurface.withValues(alpha: 0.6),
            size: 24,
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: theme.colorScheme.primary,
          ),
        ],
      ),
    );
  }
}
