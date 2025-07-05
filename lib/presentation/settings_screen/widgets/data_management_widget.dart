import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DataManagementWidget extends StatelessWidget {
  final VoidCallback onClearData;
  final bool isDarkMode;

  const DataManagementWidget({
    super.key,
    required this.onClearData,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final theme = isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme;

    return Column(
      children: [
        _buildDataOption(
          context: context,
          theme: theme,
          icon: 'file_download',
          title: 'Export Data',
          subtitle: 'Download your financial data',
          onTap: () => _showExportOptions(context, theme),
        ),
        SizedBox(height: 2.h),
        _buildDataOption(
          context: context,
          theme: theme,
          icon: 'file_upload',
          title: 'Import Data',
          subtitle: 'Restore from backup file',
          onTap: () => _showImportDialog(context, theme),
        ),
        SizedBox(height: 2.h),
        _buildDataOption(
          context: context,
          theme: theme,
          icon: 'delete_forever',
          title: 'Clear All Data',
          subtitle: 'Permanently delete all records',
          onTap: onClearData,
          isDestructive: true,
        ),
      ],
    );
  }

  Widget _buildDataOption({
    required BuildContext context,
    required ThemeData theme,
    required String icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        decoration: BoxDecoration(
          border: Border.all(
            color: isDestructive
                ? AppTheme.getErrorColor(!isDarkMode).withValues(alpha: 0.3)
                : theme.colorScheme.outline,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            CustomIconWidget(
              iconName: icon,
              color: isDestructive
                  ? AppTheme.getErrorColor(!isDarkMode)
                  : theme.colorScheme.primary,
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
                      color: isDestructive
                          ? AppTheme.getErrorColor(!isDarkMode)
                          : theme.colorScheme.onSurface,
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

  void _showExportOptions(BuildContext context, ThemeData theme) {
    showModalBottomSheet(
      context: context,
      backgroundColor: theme.bottomSheetTheme.backgroundColor,
      shape: theme.bottomSheetTheme.shape,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(4.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 12.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: theme.colorScheme.outline,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                'Export Format',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 2.h),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'table_chart',
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
                title: const Text('CSV Format'),
                subtitle: const Text('Compatible with Excel and Google Sheets'),
                onTap: () {
                  Navigator.pop(context);
                  _exportData('CSV');
                },
              ),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'code',
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
                title: const Text('JSON Format'),
                subtitle: const Text('Complete data with all details'),
                onTap: () {
                  Navigator.pop(context);
                  _exportData('JSON');
                },
              ),
              SizedBox(height: 2.h),
            ],
          ),
        );
      },
    );
  }

  void _showImportDialog(BuildContext context, ThemeData theme) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Import Data'),
          content: const Text(
            'Select a backup file to restore your financial data. This will merge with your existing data.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _importData();
              },
              child: const Text('Select File'),
            ),
          ],
        );
      },
    );
  }

  void _exportData(String format) {
    // Mock export functionality
    print('Exporting data in $format format');
  }

  void _importData() {
    // Mock import functionality
    print('Importing data from file');
  }
}
