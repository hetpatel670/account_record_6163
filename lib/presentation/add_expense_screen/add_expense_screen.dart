import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import './widgets/amount_input_widget.dart';
import './widgets/category_selection_widget.dart';
import './widgets/date_picker_widget.dart';
import './widgets/description_input_widget.dart';
import './widgets/payment_method_widget.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({Key? key}) : super(key: key);

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _scrollController = ScrollController();

  String _selectedCategory = '';
  DateTime _selectedDate = DateTime.now();
  String _selectedPaymentMethod = 'Cash';
  bool _isLoading = false;
  bool _isFormValid = false;

  final List<Map<String, dynamic>> _categories = [
    {'name': 'Food', 'icon': 'restaurant', 'color': 0xFFFF6B6B},
    {'name': 'Transport', 'icon': 'directions_car', 'color': 0xFF4ECDC4},
    {'name': 'Shopping', 'icon': 'shopping_bag', 'color': 0xFF45B7D1},
    {'name': 'Entertainment', 'icon': 'movie', 'color': 0xFF96CEB4},
    {'name': 'Bills', 'icon': 'receipt', 'color': 0xFFFECA57},
    {'name': 'Health', 'icon': 'local_hospital', 'color': 0xFFFF9FF3},
    {'name': 'Education', 'icon': 'school', 'color': 0xFF54A0FF},
    {'name': 'Other', 'icon': 'category', 'color': 0xFF5F27CD},
  ];

  @override
  void initState() {
    super.initState();
    _amountController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _validateForm() {
    final amount = _amountController.text.trim();
    final isValid = amount.isNotEmpty &&
        double.tryParse(amount) != null &&
        double.parse(amount) > 0 &&
        _selectedCategory.isNotEmpty;

    if (_isFormValid != isValid) {
      setState(() {
        _isFormValid = isValid;
      });
    }
  }

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
    });
    _validateForm();
  }

  void _onDateSelected(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
  }

  void _onPaymentMethodSelected(String method) {
    setState(() {
      _selectedPaymentMethod = method;
    });
  }

  Future<void> _saveExpense() async {
    if (!_isFormValid) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Haptic feedback
      HapticFeedback.lightImpact();

      final expense = {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'amount': double.parse(_amountController.text.trim()),
        'category': _selectedCategory,
        'date': _selectedDate.toIso8601String(),
        'description': _descriptionController.text.trim(),
        'paymentMethod': _selectedPaymentMethod,
        'type': 'expense',
        'createdAt': DateTime.now().toIso8601String(),
      };

      // Save to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final existingExpenses = prefs.getStringList('expenses') ?? [];
      existingExpenses.add(json.encode(expense));
      await prefs.setStringList('expenses', existingExpenses);

      // Success haptic feedback
      HapticFeedback.mediumImpact();

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Expense saved successfully!'),
            backgroundColor: AppTheme.getSuccessColor(
                Theme.of(context).brightness == Brightness.light),
            behavior: SnackBarBehavior.floating,
          ),
        );

        // Navigate back to dashboard
        Navigator.pop(context, true);
      }
    } catch (e) {
      // Error haptic feedback
      HapticFeedback.heavyImpact();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save expense. Please try again.'),
            backgroundColor: AppTheme.getErrorColor(
                Theme.of(context).brightness == Brightness.light),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _onCancel() {
    // Show confirmation if form has data
    if (_amountController.text.isNotEmpty ||
        _descriptionController.text.isNotEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Discard Changes?'),
          content: Text('Are you sure you want to discard your changes?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Keep Editing'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Text('Discard'),
            ),
          ],
        ),
      );
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                border: Border(
                  bottom: BorderSide(
                    color: theme.dividerColor,
                    width: 0.5,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: _onCancel,
                    child: Text(
                      'Cancel',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                  Text(
                    'Add Expense',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextButton(
                    onPressed:
                        _isFormValid && !_isLoading ? _saveExpense : null,
                    child: _isLoading
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                theme.colorScheme.primary,
                              ),
                            ),
                          )
                        : Text(
                            'Save',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: _isFormValid
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.onSurface
                                      .withValues(alpha: 0.4),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ],
              ),
            ),

            // Form Content
            Expanded(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Amount Input
                      AmountInputWidget(
                        controller: _amountController,
                        onChanged: (value) => _validateForm(),
                      ),

                      SizedBox(height: 3.h),

                      // Category Selection
                      CategorySelectionWidget(
                        categories: _categories,
                        selectedCategory: _selectedCategory,
                        onCategorySelected: _onCategorySelected,
                      ),

                      SizedBox(height: 3.h),

                      // Date Picker
                      DatePickerWidget(
                        selectedDate: _selectedDate,
                        onDateSelected: _onDateSelected,
                      ),

                      SizedBox(height: 3.h),

                      // Description Input
                      DescriptionInputWidget(
                        controller: _descriptionController,
                      ),

                      SizedBox(height: 3.h),

                      // Payment Method
                      PaymentMethodWidget(
                        selectedMethod: _selectedPaymentMethod,
                        onMethodSelected: _onPaymentMethodSelected,
                      ),

                      SizedBox(height: 4.h),

                      // Save Button
                      SizedBox(
                        width: double.infinity,
                        height: 6.h,
                        child: ElevatedButton(
                          onPressed:
                              _isFormValid && !_isLoading ? _saveExpense : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isFormValid
                                ? theme.colorScheme.primary
                                : theme.colorScheme.onSurface
                                    .withValues(alpha: 0.12),
                            foregroundColor: _isFormValid
                                ? theme.colorScheme.onPrimary
                                : theme.colorScheme.onSurface
                                    .withValues(alpha: 0.38),
                            elevation: _isFormValid ? 2 : 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: _isLoading
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                          theme.colorScheme.onPrimary,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 2.w),
                                    Text(
                                      'Saving...',
                                      style:
                                          theme.textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                )
                              : Text(
                                  'Save Expense',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),

                      SizedBox(height: 2.h),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
