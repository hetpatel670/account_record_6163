import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AboutSectionWidget extends StatelessWidget {
  final bool isDarkMode;

  const AboutSectionWidget({
    super.key,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final theme = isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme;

    return Column(
      children: [
        _buildAboutOption(
          theme: theme,
          icon: 'info_outline',
          title: 'App Version',
          subtitle: '1.0.0 (Build 1)',
          onTap: () => _showVersionInfo(context, theme),
        ),
        SizedBox(height: 2.h),
        _buildAboutOption(
          theme: theme,
          icon: 'privacy_tip',
          title: 'Privacy Policy',
          subtitle: 'How we protect your data',
          onTap: () => _openPrivacyPolicy(context),
        ),
        SizedBox(height: 2.h),
        _buildAboutOption(
          theme: theme,
          icon: 'star_rate',
          title: 'Rate App',
          subtitle: 'Share your feedback',
          onTap: () => _rateApp(context),
        ),
        SizedBox(height: 2.h),
        _buildAboutOption(
          theme: theme,
          icon: 'help_outline',
          title: 'Help & Support',
          subtitle: 'Get assistance and tutorials',
          onTap: () => _openSupport(context),
        ),
        SizedBox(height: 3.h),
        Container(
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              CustomIconWidget(
                iconName: 'account_balance_wallet',
                color: theme.colorScheme.primary,
                size: 24,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Account Record',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    Text(
                      'Personal Finance Management',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAboutOption({
    required ThemeData theme,
    required String icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        decoration: BoxDecoration(
          border: Border.all(color: theme.colorScheme.outline),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            CustomIconWidget(
              iconName: icon,
              color: theme.colorScheme.primary,
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
            CustomIconWidget(
              iconName: 'chevron_right',
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  void _showVersionInfo(BuildContext context, ThemeData theme) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('App Information'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Version: 1.0.0', style: theme.textTheme.bodyLarge),
              SizedBox(height: 1.h),
              Text('Build: 1', style: theme.textTheme.bodyLarge),
              SizedBox(height: 1.h),
              Text('Release Date: December 2024',
                  style: theme.textTheme.bodyLarge),
              SizedBox(height: 2.h),
              Text(
                'Account Record is a personal finance management app designed to help you track your expenses and manage your budget effectively.',
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _openPrivacyPolicy(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Privacy Policy'),
          content: const Text(
            'Your privacy is important to us. All financial data is stored locally on your device and is never transmitted to external servers without your explicit consent.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _rateApp(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Rate Account Record'),
          content: const Text(
            'Enjoying Account Record? Please take a moment to rate us on the app store. Your feedback helps us improve!',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Later'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Mock opening app store
                print('Opening app store for rating');
              },
              child: const Text('Rate Now'),
            ),
          ],
        );
      },
    );
  }

  void _openSupport(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Help & Support'),
          content: const Text(
            'Need help? Contact our support team at support@accountrecord.com or visit our help center for tutorials and FAQs.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
