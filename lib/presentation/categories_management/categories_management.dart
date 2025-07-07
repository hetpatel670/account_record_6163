import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/add_edit_category_modal.dart';
import './widgets/category_card_widget.dart';
import './widgets/category_empty_state_widget.dart';

class CategoriesManagement extends StatefulWidget {
  const CategoriesManagement({super.key});

  @override
  State<CategoriesManagement> createState() => _CategoriesManagementState();
}

class _CategoriesManagementState extends State<CategoriesManagement> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _categories = [];
  List<Map<String, dynamic>> _filteredCategories = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _loadCategories();
    _searchController.addListener(_filterCategories);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadCategories() {
    // Mock categories data with default and custom categories
    _categories = [
      {
        "id": "1",
        "name": "Food & Dining",
        "icon": "restaurant",
        "color": 0xFFFF6B6B,
        "isDefault": true,
        "transactionCount": 24,
        "totalAmount": 1250.50,
      },
      {
        "id": "2",
        "name": "Transportation",
        "icon": "directions_car",
        "color": 0xFF4ECDC4,
        "isDefault": true,
        "transactionCount": 18,
        "totalAmount": 890.75,
      },
      {
        "id": "3",
        "name": "Entertainment",
        "icon": "movie",
        "color": 0xFF45B7D1,
        "isDefault": true,
        "transactionCount": 12,
        "totalAmount": 456.25,
      },
      {
        "id": "4",
        "name": "Bills & Utilities",
        "icon": "receipt_long",
        "color": 0xFFFFA726,
        "isDefault": true,
        "transactionCount": 8,
        "totalAmount": 2340.00,
      },
      {
        "id": "5",
        "name": "Shopping",
        "icon": "shopping_bag",
        "color": 0xFF9C27B0,
        "isDefault": false,
        "transactionCount": 15,
        "totalAmount": 678.90,
      },
      {
        "id": "6",
        "name": "Healthcare",
        "icon": "local_hospital",
        "color": 0xFF66BB6A,
        "isDefault": false,
        "transactionCount": 5,
        "totalAmount": 234.50,
      },
    ];
    _filteredCategories = List.from(_categories);
  }

  void _filterCategories() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _isSearching = query.isNotEmpty;
      _filteredCategories = query.isEmpty
          ? List.from(_categories)
          : _categories.where((category) {
              return (category["name"] as String).toLowerCase().contains(query);
            }).toList();
    });
  }

  void _showAddCategoryModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddEditCategoryModal(
        onSave: _addCategory,
      ),
    );
  }

  void _showEditCategoryModal(Map<String, dynamic> category) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddEditCategoryModal(
        category: category,
        onSave: _editCategory,
      ),
    );
  }

  void _addCategory(Map<String, dynamic> newCategory) {
    setState(() {
      newCategory["id"] = DateTime.now().millisecondsSinceEpoch.toString();
      newCategory["isDefault"] = false;
      newCategory["transactionCount"] = 0;
      newCategory["totalAmount"] = 0.0;
      _categories.add(newCategory);
      _filterCategories();
    });

    // Show success feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Category "${newCategory["name"]}" added successfully'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _editCategory(Map<String, dynamic> updatedCategory) {
    setState(() {
      final index =
          _categories.indexWhere((cat) => cat["id"] == updatedCategory["id"]);
      if (index != -1) {
        _categories[index] = {..._categories[index], ...updatedCategory};
        _filterCategories();
      }
    });

    // Show success feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text('Category "${updatedCategory["name"]}" updated successfully'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _deleteCategory(String categoryId) {
    final category = _categories.firstWhere((cat) => cat["id"] == categoryId);
    final hasTransactions = (category["transactionCount"] as int) > 0;

    if (hasTransactions) {
      _showDeleteConfirmationDialog(category);
    } else {
      _performDelete(categoryId);
    }
  }

  void _showDeleteConfirmationDialog(Map<String, dynamic> category) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Category'),
        content: Text(
          'This category has ${category["transactionCount"]} transactions. Deleting it will remove all associated transaction records. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _performDelete(category["id"] as String);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _performDelete(String categoryId) {
    final category = _categories.firstWhere((cat) => cat["id"] == categoryId);

    setState(() {
      _categories.removeWhere((cat) => cat["id"] == categoryId);
      _filterCategories();
    });

    // Show success feedback with undo option
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Category "${category["name"]}" deleted'),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _categories.add(category);
              _filterCategories();
            });
          },
        ),
      ),
    );
  }

  void _reorderCategories(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final item = _filteredCategories.removeAt(oldIndex);
      _filteredCategories.insert(newIndex, item);

      // Update the main categories list
      _categories = List.from(_filteredCategories);
    });

    // Provide haptic feedback
    HapticFeedback.lightImpact();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.outline,
                          width: 1,
                        ),
                      ),
                      child: CustomIconWidget(
                        iconName: 'arrow_back',
                        color: Theme.of(context).colorScheme.onSurface,
                        size: 20,
                      ),
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Text(
                      'Categories',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _showAddCategoryModal,
                    icon: CustomIconWidget(
                      iconName: 'add',
                      color: Theme.of(context).colorScheme.onPrimary,
                      size: 18,
                    ),
                    label: Text('Add'),
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Search Bar
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search categories...',
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(3.w),
                    child: CustomIconWidget(
                      iconName: 'search',
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                  ),
                  suffixIcon: _isSearching
                      ? GestureDetector(
                          onTap: () {
                            _searchController.clear();
                            FocusScope.of(context).unfocus();
                          },
                          child: Padding(
                            padding: EdgeInsets.all(3.w),
                            child: CustomIconWidget(
                              iconName: 'clear',
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                              size: 20,
                            ),
                          ),
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2,
                    ),
                  ),
                ),
              ),
            ),

            // Content Area
            Expanded(
              child: _filteredCategories.isEmpty
                  ? CategoryEmptyStateWidget(
                      onCreateCategory: _showAddCategoryModal,
                    )
                  : Column(
                      children: [
                        // Categories Count
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 4.w, vertical: 1.h),
                          child: Row(
                            children: [
                              Text(
                                '${_filteredCategories.length} Categories',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                    ),
                              ),
                              Spacer(),
                              if (!_isSearching)
                                Text(
                                  'Hold & drag to reorder',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant,
                                      ),
                                ),
                            ],
                          ),
                        ),

                        // Categories List
                        Expanded(
                          child: _isSearching
                              ? ListView.builder(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 4.w),
                                  itemCount: _filteredCategories.length,
                                  itemBuilder: (context, index) {
                                    final category = _filteredCategories[index];
                                    return CategoryCardWidget(
                                      category: category,
                                      onEdit: () =>
                                          _showEditCategoryModal(category),
                                      onDelete: () => _deleteCategory(
                                          category["id"] as String),
                                      showReorderHandle: false,
                                    );
                                  },
                                )
                              : ReorderableListView.builder(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 4.w),
                                  itemCount: _filteredCategories.length,
                                  onReorder: _reorderCategories,
                                  itemBuilder: (context, index) {
                                    final category = _filteredCategories[index];
                                    return CategoryCardWidget(
                                      key: ValueKey(category["id"]),
                                      category: category,
                                      onEdit: () =>
                                          _showEditCategoryModal(category),
                                      onDelete: () => _deleteCategory(
                                          category["id"] as String),
                                      showReorderHandle: true,
                                    );
                                  },
                                ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
