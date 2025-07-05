import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FilterBottomSheetWidget extends StatefulWidget {
  final DateTimeRange? selectedDateRange;
  final List<String> selectedCategories;
  final RangeValues amountRange;
  final Function(DateTimeRange?, List<String>, RangeValues) onApplyFilters;
  final VoidCallback onClearFilters;

  const FilterBottomSheetWidget({
    super.key,
    this.selectedDateRange,
    this.selectedCategories = const [],
    this.amountRange = const RangeValues(0, 10000),
    required this.onApplyFilters,
    required this.onClearFilters,
  });

  @override
  State<FilterBottomSheetWidget> createState() =>
      _FilterBottomSheetWidgetState();
}

class _FilterBottomSheetWidgetState extends State<FilterBottomSheetWidget> {
  DateTimeRange? _selectedDateRange;
  List<String> _selectedCategories = [];
  RangeValues _amountRange = const RangeValues(0, 10000);

  final List<String> _availableCategories = [
    'Food & Dining',
    'Transportation',
    'Entertainment',
    'Healthcare',
    'Shopping',
    'Bills & Utilities',
    'Income',
    'Investment',
    'Education',
    'Travel',
  ];

  @override
  void initState() {
    super.initState();
    _selectedDateRange = widget.selectedDateRange;
    _selectedCategories = List.from(widget.selectedCategories);
    _amountRange = widget.amountRange;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDateRangeSection(),
                  SizedBox(height: 3.h),
                  _buildCategorySection(),
                  SizedBox(height: 3.h),
                  _buildAmountRangeSection(),
                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppTheme.dividerLight,
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Filter Transactions',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: CustomIconWidget(
              iconName: 'close',
              color: AppTheme.textSecondaryLight,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateRangeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Date Range',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            border: Border.all(color: AppTheme.borderSubtleLight),
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            onTap: _selectDateRange,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _selectedDateRange != null
                      ? '${_formatDate(_selectedDateRange!.start)} - ${_formatDate(_selectedDateRange!.end)}'
                      : 'Select date range',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: _selectedDateRange != null
                        ? AppTheme.textPrimaryLight
                        : AppTheme.textSecondaryLight,
                  ),
                ),
                CustomIconWidget(
                  iconName: 'calendar_today',
                  color: AppTheme.textSecondaryLight,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
        if (_selectedDateRange != null) ...[
          SizedBox(height: 1.h),
          TextButton(
            onPressed: () {
              setState(() {
                _selectedDateRange = null;
              });
            },
            child: const Text('Clear date range'),
          ),
        ],
      ],
    );
  }

  Widget _buildCategorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Categories',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: _availableCategories.map((category) {
            final isSelected = _selectedCategories.contains(category);
            return FilterChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedCategories.add(category);
                  } else {
                    _selectedCategories.remove(category);
                  }
                });
              },
              backgroundColor: AppTheme.lightTheme.cardColor,
              selectedColor: AppTheme.primaryLight.withValues(alpha: 0.2),
              checkmarkColor: AppTheme.primaryLight,
              labelStyle: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: isSelected
                    ? AppTheme.primaryLight
                    : AppTheme.textPrimaryLight,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
              side: BorderSide(
                color: isSelected
                    ? AppTheme.primaryLight
                    : AppTheme.borderSubtleLight,
              ),
            );
          }).toList(),
        ),
        if (_selectedCategories.isNotEmpty) ...[
          SizedBox(height: 1.h),
          TextButton(
            onPressed: () {
              setState(() {
                _selectedCategories.clear();
              });
            },
            child: const Text('Clear categories'),
          ),
        ],
      ],
    );
  }

  Widget _buildAmountRangeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Amount Range',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            border: Border.all(color: AppTheme.borderSubtleLight),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '\$${_amountRange.start.toInt()}',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '\$${_amountRange.end.toInt()}',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              RangeSlider(
                values: _amountRange,
                min: 0,
                max: 10000,
                divisions: 100,
                labels: RangeLabels(
                  '\$${_amountRange.start.toInt()}',
                  '\$${_amountRange.end.toInt()}',
                ),
                onChanged: (values) {
                  setState(() {
                    _amountRange = values;
                  });
                },
                activeColor: AppTheme.primaryLight,
                inactiveColor: AppTheme.primaryLight.withValues(alpha: 0.2),
              ),
            ],
          ),
        ),
        if (_amountRange.start > 0 || _amountRange.end < 10000) ...[
          SizedBox(height: 1.h),
          TextButton(
            onPressed: () {
              setState(() {
                _amountRange = const RangeValues(0, 10000);
              });
            },
            child: const Text('Reset amount range'),
          ),
        ],
      ],
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: AppTheme.dividerLight,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                widget.onClearFilters();
                Navigator.pop(context);
              },
              child: const Text('Clear All'),
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                widget.onApplyFilters(
                  _selectedDateRange,
                  _selectedCategories,
                  _amountRange,
                );
                Navigator.pop(context);
              },
              child: const Text('Apply Filters'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: _selectedDateRange,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: AppTheme.primaryLight,
                ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDateRange = picked;
      });
    }
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }
}
