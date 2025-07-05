import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/about_section_widget.dart';
import './widgets/currency_selector_widget.dart';
import './widgets/data_management_widget.dart';
import './widgets/notification_settings_widget.dart';
import './widgets/settings_section_widget.dart';
import './widgets/theme_selector_widget.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isDarkMode = false;
  String _selectedCurrency = 'USD';
  bool _expenseReminders = true;
  bool _budgetAlerts = true;
  String _themeMode = 'System';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('isDarkMode') ?? false;
      _selectedCurrency = prefs.getString('selectedCurrency') ?? 'USD';
      _expenseReminders = prefs.getBool('expenseReminders') ?? true;
      _budgetAlerts = prefs.getBool('budgetAlerts') ?? true;
      _themeMode = prefs.getString('themeMode') ?? 'System';
    });
  }

  Future<void> _saveThemeMode(String mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('themeMode', mode);
    setState(() {
      _themeMode = mode;
      _isDarkMode =
          mode == 'Dark' ? true : (mode == 'Light' ? false : _isDarkMode);
    });
    _showConfirmationSnackBar('Theme updated successfully');
  }

  Future<void> _saveCurrency(String currency) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedCurrency', currency);
    setState(() {
      _selectedCurrency = currency;
    });
    _showConfirmationSnackBar('Currency updated to $currency');
  }

  Future<void> _saveNotificationSettings(bool reminders, bool alerts) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('expenseReminders', reminders);
    await prefs.setBool('budgetAlerts', alerts);
    setState(() {
      _expenseReminders = reminders;
      _budgetAlerts = alerts;
    });
    _showConfirmationSnackBar('Notification settings updated');
  }

  void _showConfirmationSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(4.w),
      ),
    );
  }

  void _showClearDataDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Clear All Data'),
          content: const Text(
            'This action will permanently delete all your financial data including transactions, categories, and settings. This cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _clearAllData();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.getErrorColor(!_isDarkMode),
              ),
              child: const Text('Clear Data'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _showConfirmationSnackBar('All data cleared successfully');
    setState(() {
      _isDarkMode = false;
      _selectedCurrency = 'USD';
      _expenseReminders = true;
      _budgetAlerts = true;
      _themeMode = 'System';
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = _isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme;

    return Theme(
      data: theme,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text(
            'Settings',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor: theme.scaffoldBackgroundColor,
          elevation: 0,
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: CustomIconWidget(
              iconName: 'arrow_back',
              color: theme.colorScheme.onSurface,
              size: 24,
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Appearance Section
                  SettingsSectionWidget(
                    title: 'Appearance',
                    icon: 'palette',
                    isDarkMode: _isDarkMode,
                    child: ThemeSelectorWidget(
                      selectedTheme: _themeMode,
                      onThemeChanged: _saveThemeMode,
                      isDarkMode: _isDarkMode,
                    ),
                  ),

                  SizedBox(height: 3.h),

                  // Currency Section
                  SettingsSectionWidget(
                    title: 'Currency',
                    icon: 'attach_money',
                    isDarkMode: _isDarkMode,
                    child: CurrencySelectorWidget(
                      selectedCurrency: _selectedCurrency,
                      onCurrencyChanged: _saveCurrency,
                      isDarkMode: _isDarkMode,
                    ),
                  ),

                  SizedBox(height: 3.h),

                  // Data Management Section
                  SettingsSectionWidget(
                    title: 'Data Management',
                    icon: 'storage',
                    isDarkMode: _isDarkMode,
                    child: DataManagementWidget(
                      onClearData: _showClearDataDialog,
                      isDarkMode: _isDarkMode,
                    ),
                  ),

                  SizedBox(height: 3.h),

                  // Notifications Section
                  SettingsSectionWidget(
                    title: 'Notifications',
                    icon: 'notifications',
                    isDarkMode: _isDarkMode,
                    child: NotificationSettingsWidget(
                      expenseReminders: _expenseReminders,
                      budgetAlerts: _budgetAlerts,
                      onSettingsChanged: _saveNotificationSettings,
                      isDarkMode: _isDarkMode,
                    ),
                  ),

                  SizedBox(height: 3.h),

                  // About Section
                  SettingsSectionWidget(
                    title: 'About',
                    icon: 'info',
                    isDarkMode: _isDarkMode,
                    child: AboutSectionWidget(
                      isDarkMode: _isDarkMode,
                    ),
                  ),

                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
