import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class AddEditCategoryModal extends StatefulWidget {
  final Map<String, dynamic>? category;
  final Function(Map<String, dynamic>) onSave;

  const AddEditCategoryModal({
    super.key,
    this.category,
    required this.onSave,
  });

  @override
  State<AddEditCategoryModal> createState() => _AddEditCategoryModalState();
}

class _AddEditCategoryModalState extends State<AddEditCategoryModal> {
  final TextEditingController _nameController = TextEditingController();
  final FocusNode _nameFocusNode = FocusNode();

  String _selectedIcon = 'category';
  int _selectedColor = 0xFF2563EB;
  bool _isLoading = false;

  final List<String> _availableIcons = [
    'restaurant',
    'directions_car',
    'movie',
    'receipt_long',
    'shopping_bag',
    'local_hospital',
    'school',
    'fitness_center',
    'pets',
    'home',
    'work',
    'flight',
    'hotel',
    'local_gas_station',
    'local_grocery_store',
    'local_pharmacy',
    'local_laundry_service',
    'local_cafe',
    'local_bar',
    'sports_esports',
    'music_note',
    'book',
    'camera_alt',
    'brush',
    'build',
    'computer',
    'phone',
    'wifi',
    'electrical_services',
    'plumbing',
    'cleaning_services',
    'child_care',
    'elderly',
    'volunteer_activism',
  ];

  final List<int> _availableColors = [
    0xFF2563EB,
    0xFFFF6B6B,
    0xFF4ECDC4,
    0xFF45B7D1,
    0xFF96CEB4,
    0xFFFFA726,
    0xFF9C27B0,
    0xFFE91E63,
    0xFF66BB6A,
    0xFFFF7043,
    0xFF42A5F5,
    0xFFAB47BC,
    0xFF26A69A,
    0xFFEF5350,
    0xFF5C6BC0,
    0xFFFFCA28,
    0xFF8BC34A,
    0xFFFF8A65,
    0xFF29B6F6,
    0xFFEC407A,
  ];

  @override
  void initState() {
    super.initState();
    if (widget.category != null) {
      _nameController.text = widget.category!["name"] as String? ?? '';
      _selectedIcon = widget.category!["icon"] as String? ?? 'category';
      _selectedColor = widget.category!["color"] as int? ?? 0xFF2563EB;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nameFocusNode.dispose();
    super.dispose();
  }

  bool get _isEditing => widget.category != null;

  void _saveCategory() async {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Please enter a category name'),
          behavior: SnackBarBehavior.floating));
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate API call delay
    await Future.delayed(Duration(milliseconds: 500));

    final categoryData = {
      if (_isEditing) "id": widget.category!["id"],
      "name": _nameController.text.trim(),
      "icon": _selectedIcon,
      "color": _selectedColor,
    };

    widget.onSave(categoryData);

    setState(() {
      _isLoading = false;
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 85.h,
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
        child: Column(children: [
          // Handle Bar
          Container(
              margin: EdgeInsets.only(top: 2.h),
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurfaceVariant
                      .withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2))),

          // Header
          Container(
              padding: EdgeInsets.all(4.w),
              child: Row(children: [
                GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                        padding: EdgeInsets.all(2.w),
                        decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(12)),
                        child: CustomIconWidget(
                            iconName: 'close',
                            color: Theme.of(context).colorScheme.onSurface,
                            size: 20))),
                SizedBox(width: 4.w),
                Expanded(
                    child: Text(_isEditing ? 'Edit Category' : 'Add Category',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(fontWeight: FontWeight.w600))),
                ElevatedButton(
                    onPressed: _isLoading ? null : _saveCategory,
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                            horizontal: 6.w, vertical: 1.5.h),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12))),
                    child: _isLoading
                        ? SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Theme.of(context).colorScheme.onPrimary)))
                        : Text('Save')),
              ])),

          Divider(height: 1),

          // Content
          Expanded(
              child: SingleChildScrollView(
                  padding: EdgeInsets.all(4.w),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Category Name Input
                        Text('Category Name',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.w600)),
                        SizedBox(height: 2.h),
                        TextField(
                            controller: _nameController,
                            focusNode: _nameFocusNode,
                            maxLength: 30,
                            decoration: InputDecoration(
                                hintText: 'Enter category name',
                                counterText:
                                    '${_nameController.text.length}/30',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12))),
                            onChanged: (value) {
                              setState(() {}); // Update counter
                            }),

                        SizedBox(height: 4.h),

                        // Icon Selection
                        Text('Choose Icon',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.w600)),
                        SizedBox(height: 2.h),
                        Container(
                            height: 25.h,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color:
                                        Theme.of(context).colorScheme.outline),
                                borderRadius: BorderRadius.circular(12)),
                            child: GridView.builder(
                                padding: EdgeInsets.all(3.w),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 6,
                                        crossAxisSpacing: 2.w,
                                        mainAxisSpacing: 2.w),
                                itemBuilder: (context, index) {
                                  final icon = _availableIcons[index];
                                  final isSelected = icon == _selectedIcon;

                                  return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _selectedIcon = icon;
                                        });
                                      },
                                      child: Container(
                                          decoration: BoxDecoration(
                                              color: isSelected
                                                  ? Color(_selectedColor)
                                                      .withValues(alpha: 0.1)
                                                  : Colors.transparent,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(
                                                  color: isSelected
                                                      ? Color(_selectedColor)
                                                      : Colors.transparent,
                                                  width: 2)),
                                          child: Center(
                                              child: CustomIconWidget(
                                                  iconName: icon,
                                                  color: isSelected
                                                      ? Color(_selectedColor)
                                                      : Theme.of(context)
                                                          .colorScheme
                                                          .onSurfaceVariant,
                                                  size: 24))));
                                })),

                        SizedBox(height: 4.h),

                        // Color Selection
                        Text('Choose Color',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.w600)),
                        SizedBox(height: 2.h),
                        Container(
                            padding: EdgeInsets.all(3.w),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color:
                                        Theme.of(context).colorScheme.outline),
                                borderRadius: BorderRadius.circular(12)),
                            child: Wrap(
                                spacing: 3.w,
                                runSpacing: 2.h,
                                children: _availableColors.map((color) {
                                  final isSelected = color == _selectedColor;

                                  return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _selectedColor = color;
                                        });
                                      },
                                      child: Container(
                                          width: 12.w,
                                          height: 12.w,
                                          decoration: BoxDecoration(
                                              color: Color(color),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(
                                                  color: isSelected
                                                      ? Theme.of(context)
                                                          .colorScheme
                                                          .onSurface
                                                      : Colors.transparent,
                                                  width: 3)),
                                          child: isSelected
                                              ? Center(
                                                  child: CustomIconWidget(
                                                      iconName: 'check',
                                                      color: Colors.white,
                                                      size: 16))
                                              : null));
                                }).toList())),

                        SizedBox(height: 4.h),

                        // Preview
                        Text('Preview',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.w600)),
                        SizedBox(height: 2.h),
                        Container(
                            padding: EdgeInsets.all(4.w),
                            decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(12)),
                            child: Row(children: [
                              Container(
                                  width: 12.w,
                                  height: 12.w,
                                  decoration: BoxDecoration(
                                      color: Color(_selectedColor)
                                          .withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(12)),
                                  child: Center(
                                      child: CustomIconWidget(
                                          iconName: _selectedIcon,
                                          color: Color(_selectedColor),
                                          size: 24))),
                              SizedBox(width: 4.w),
                              Expanded(
                                  child: Text(
                                      _nameController.text.isEmpty
                                          ? 'Category Name'
                                          : _nameController.text,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                              fontWeight: FontWeight.w600,
                                              color:
                                                  _nameController.text.isEmpty
                                                      ? Theme.of(context)
                                                          .colorScheme
                                                          .onSurfaceVariant
                                                      : Theme.of(context)
                                                          .colorScheme
                                                          .onSurface))),
                            ])),

                        SizedBox(height: 6.h), // Extra space for bottom padding
                      ]))),
        ]));
  }
}
