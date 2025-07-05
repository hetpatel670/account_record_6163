import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import '../add_expense_screen/widgets/amount_input_widget.dart';
import '../add_expense_screen/widgets/date_picker_widget.dart';
import '../add_expense_screen/widgets/description_input_widget.dart';
import '../add_expense_screen/widgets/payment_method_widget.dart';
import './widgets/income_source_selection_widget.dart';

class AddIncomeScreen extends StatefulWidget {
  const AddIncomeScreen({super.key});

  @override
  State<AddIncomeScreen> createState() => _AddIncomeScreenState();
}

class _AddIncomeScreenState extends State<AddIncomeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  bool _isDarkMode = false;
  bool _isLoading = false;
  String _selectedIncomeSource = '';
  DateTime _selectedDate = DateTime.now();
  String _selectedPaymentMethod = 'Bank Transfer';

  final List<Map<String, dynamic>> _incomeSources = [
    {
      "name": "Salary",
      "icon": "account_balance_wallet",
      "color": 0xFF4ECDC4,
    },
    {
      "name": "Freelance",
      "icon": "work",
      "color": 0xFF45B7D1,
    },
    {
      "name": "Investment",
      "icon": "trending_up",
      "color": 0xFF96CEB4,
    },
    {
      "name": "Gift",
      "icon": "card_giftcard",
      "color": 0xFFFFB74D,
    },
    {
      "name": "Other",
      "icon": "more_horiz",
      "color": 0xFF9C27B0,
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadThemePreference();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    });
  }

  bool get _isFormValid {
    return _amountController.text.isNotEmpty &&
        double.tryParse(_amountController.text) != null &&
        double.parse(_amountController.text) > 0 &&
        _selectedIncomeSource.isNotEmpty;
  }

  Future<void> _saveIncome() async {
    if (!_isFormValid) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate API call
      await Future.delayed(Duration(seconds: 1));

      // Haptic feedback for success
      HapticFeedback.lightImpact();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Income added successfully!'),
          backgroundColor: AppTheme.getSuccessColor(!_isDarkMode),
          behavior: SnackBarBehavior.floating));

      // Navigate back to dashboard
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error adding income: ${e.toString()}'),
          backgroundColor: AppTheme.getErrorColor(!_isDarkMode),
          behavior: SnackBarBehavior.floating));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = _isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme;

    return Theme(
        data: theme,
        child: Scaffold(
            backgroundColor: theme.scaffoldBackgroundColor,
            body: SafeArea(
                child: Column(children: [
              // Header with Cancel and Save actions
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                  decoration: BoxDecoration(color: theme.cardColor, boxShadow: [
                    BoxShadow(
                        color: theme.shadowColor,
                        blurRadius: 8,
                        offset: Offset(0, 2)),
                  ]),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('Cancel',
                                style: theme.textTheme.labelLarge?.copyWith(
                                    color: theme.colorScheme.onSurface))),
                        Text('Add Income',
                            style: theme.textTheme.titleLarge?.copyWith(
                                color: AppTheme.getSuccessColor(!_isDarkMode),
                                fontWeight: FontWeight.w600)),
                        TextButton(
                            onPressed: _isFormValid ? _saveIncome : null,
                            child: _isLoading
                                ? SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                AppTheme.getSuccessColor(
                                                    !_isDarkMode))))
                                : Text('Save',
                                    style: theme.textTheme.labelLarge?.copyWith(
                                        color: _isFormValid
                                            ? AppTheme.getSuccessColor(
                                                !_isDarkMode)
                                            : theme.colorScheme.onSurface
                                                .withAlpha(128),
                                        fontWeight: FontWeight.w600))),
                      ])),

              // Main Content
              Expanded(
                  child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      child: Padding(
                          padding: EdgeInsets.all(4.w),
                          child: Form(
                              key: _formKey,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Amount Input
                                    AmountInputWidget(
                                        controller: _amountController,
                                        onChanged: (value) {
                                          setState(() {});
                                        }),

                                    SizedBox(height: 3.h),

                                    // Income Source Selection
                                    IncomeSourceSelectionWidget(
                                        sources: _incomeSources,
                                        selectedSource: _selectedIncomeSource,
                                        isDarkMode: _isDarkMode,
                                        onSourceSelected: (source) {
                                          setState(() {
                                            _selectedIncomeSource = source;
                                          });
                                        }),

                                    SizedBox(height: 3.h),

                                    // Date Picker
                                    DatePickerWidget(
                                        selectedDate: _selectedDate,
                                        onDateSelected: (date) {
                                          setState(() {
                                            _selectedDate = date;
                                          });
                                        }),

                                    SizedBox(height: 3.h),

                                    // Description Input
                                    DescriptionInputWidget(
                                        controller: _descriptionController),

                                    SizedBox(height: 3.h),

                                    // Payment Method Selection
                                    PaymentMethodWidget(
                                        selectedMethod: _selectedPaymentMethod,
                                        onMethodSelected: (method) {
                                          setState(() {
                                            _selectedPaymentMethod = method;
                                          });
                                        }),

                                    SizedBox(height: 4.h),
                                  ]))))),

              // Bottom Save Button
              Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(color: theme.cardColor, boxShadow: [
                    BoxShadow(
                        color: theme.shadowColor,
                        blurRadius: 8,
                        offset: Offset(0, -2)),
                  ]),
                  child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: _isFormValid ? _saveIncome : null,
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  AppTheme.getSuccessColor(!_isDarkMode),
                              foregroundColor: theme.colorScheme.onPrimary,
                              disabledBackgroundColor:
                                  theme.colorScheme.onSurface.withAlpha(64),
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12))),
                          child: _isLoading
                              ? SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          theme.colorScheme.onPrimary)))
                              : Text('Save Income',
                                  style: theme.textTheme.labelLarge?.copyWith(
                                      color: theme.colorScheme.onPrimary,
                                      fontWeight: FontWeight.w600))))),
            ]))));
  }
}