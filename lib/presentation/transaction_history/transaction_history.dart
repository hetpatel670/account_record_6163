import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/filter_bottom_sheet_widget.dart';
import './widgets/transaction_section_widget.dart';

class TransactionHistory extends StatefulWidget {
  const TransactionHistory({super.key});

  @override
  State<TransactionHistory> createState() => _TransactionHistoryState();
}

class _TransactionHistoryState extends State<TransactionHistory>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool _isSearching = false;
  bool _isMultiSelectMode = false;
  bool _isLoading = false;
  String _searchQuery = '';
  Set<String> _selectedTransactions = {};

  // Filter states
  DateTimeRange? _selectedDateRange;
  List<String> _selectedCategories = [];
  RangeValues _amountRange = const RangeValues(0, 10000);

  // Mock transaction data
  final List<Map<String, dynamic>> _allTransactions = [
    {
      "id": "1",
      "description": "Grocery Shopping",
      "amount": -85.50,
      "category": "Food & Dining",
      "categoryIcon": "shopping_cart",
      "date": DateTime.now(),
      "type": "expense"
    },
    {
      "id": "2",
      "description": "Salary Deposit",
      "amount": 3500.00,
      "category": "Income",
      "categoryIcon": "account_balance_wallet",
      "date": DateTime.now().subtract(const Duration(hours: 2)),
      "type": "income"
    },
    {
      "id": "3",
      "description": "Coffee Shop",
      "amount": -4.75,
      "category": "Food & Dining",
      "categoryIcon": "local_cafe",
      "date": DateTime.now().subtract(const Duration(hours: 5)),
      "type": "expense"
    },
    {
      "id": "4",
      "description": "Gas Station",
      "amount": -45.20,
      "category": "Transportation",
      "categoryIcon": "local_gas_station",
      "date": DateTime.now().subtract(const Duration(days: 1)),
      "type": "expense"
    },
    {
      "id": "5",
      "description": "Freelance Payment",
      "amount": 750.00,
      "category": "Income",
      "categoryIcon": "work",
      "date": DateTime.now().subtract(const Duration(days: 1, hours: 3)),
      "type": "income"
    },
    {
      "id": "6",
      "description": "Netflix Subscription",
      "amount": -15.99,
      "category": "Entertainment",
      "categoryIcon": "movie",
      "date": DateTime.now().subtract(const Duration(days: 2)),
      "type": "expense"
    },
    {
      "id": "7",
      "description": "Pharmacy",
      "amount": -28.45,
      "category": "Healthcare",
      "categoryIcon": "local_pharmacy",
      "date": DateTime.now().subtract(const Duration(days: 3)),
      "type": "expense"
    },
    {
      "id": "8",
      "description": "Investment Dividend",
      "amount": 125.00,
      "category": "Income",
      "categoryIcon": "trending_up",
      "date": DateTime.now().subtract(const Duration(days: 5)),
      "type": "income"
    },
  ];

  List<Map<String, dynamic>> _filteredTransactions = [];
  Map<String, List<Map<String, dynamic>>> _groupedTransactions = {};

  @override
  void initState() {
    super.initState();
    _filteredTransactions = List.from(_allTransactions);
    _groupTransactions();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadMoreTransactions();
    }
  }

  void _loadMoreTransactions() {
    if (!_isLoading) {
      setState(() {
        _isLoading = true;
      });

      // Simulate loading delay
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }

  void _groupTransactions() {
    _groupedTransactions.clear();
    final now = DateTime.now();

    for (var transaction in _filteredTransactions) {
      final transactionDate = transaction['date'] as DateTime;
      final difference = now.difference(transactionDate).inDays;

      String groupKey;
      if (difference == 0) {
        groupKey = 'Today';
      } else if (difference == 1) {
        groupKey = 'Yesterday';
      } else if (difference <= 7) {
        groupKey = 'This Week';
      } else if (difference <= 30) {
        groupKey = 'This Month';
      } else {
        groupKey = 'Earlier';
      }

      if (!_groupedTransactions.containsKey(groupKey)) {
        _groupedTransactions[groupKey] = [];
      }
      _groupedTransactions[groupKey]!.add(transaction);
    }

    // Sort transactions within each group by date (newest first)
    _groupedTransactions.forEach((key, transactions) {
      transactions.sort(
          (a, b) => (b['date'] as DateTime).compareTo(a['date'] as DateTime));
    });
  }

  void _filterTransactions() {
    setState(() {
      _filteredTransactions = _allTransactions.where((transaction) {
        // Search filter
        if (_searchQuery.isNotEmpty) {
          final description =
              (transaction['description'] as String).toLowerCase();
          final category = (transaction['category'] as String).toLowerCase();
          final amount = transaction['amount'].toString();

          if (!description.contains(_searchQuery.toLowerCase()) &&
              !category.contains(_searchQuery.toLowerCase()) &&
              !amount.contains(_searchQuery)) {
            return false;
          }
        }

        // Date range filter
        if (_selectedDateRange != null) {
          final transactionDate = transaction['date'] as DateTime;
          if (transactionDate.isBefore(_selectedDateRange!.start) ||
              transactionDate.isAfter(_selectedDateRange!.end)) {
            return false;
          }
        }

        // Category filter
        if (_selectedCategories.isNotEmpty) {
          if (!_selectedCategories.contains(transaction['category'])) {
            return false;
          }
        }

        // Amount range filter
        final amount = (transaction['amount'] as double).abs();
        if (amount < _amountRange.start || amount > _amountRange.end) {
          return false;
        }

        return true;
      }).toList();

      _groupTransactions();
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
    _filterTransactions();
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        _searchQuery = '';
        _filterTransactions();
      }
    });
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheetWidget(
        selectedDateRange: _selectedDateRange,
        selectedCategories: _selectedCategories,
        amountRange: _amountRange,
        onApplyFilters: (dateRange, categories, amountRange) {
          setState(() {
            _selectedDateRange = dateRange;
            _selectedCategories = categories;
            _amountRange = amountRange;
          });
          _filterTransactions();
        },
        onClearFilters: () {
          setState(() {
            _selectedDateRange = null;
            _selectedCategories.clear();
            _amountRange = const RangeValues(0, 10000);
          });
          _filterTransactions();
        },
      ),
    );
  }

  void _toggleMultiSelect() {
    setState(() {
      _isMultiSelectMode = !_isMultiSelectMode;
      if (!_isMultiSelectMode) {
        _selectedTransactions.clear();
      }
    });
  }

  void _toggleTransactionSelection(String transactionId) {
    setState(() {
      if (_selectedTransactions.contains(transactionId)) {
        _selectedTransactions.remove(transactionId);
      } else {
        _selectedTransactions.add(transactionId);
      }
    });
  }

  void _deleteSelectedTransactions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Delete Transactions',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        content: Text(
          'Are you sure you want to delete ${_selectedTransactions.length} transaction(s)? This action cannot be undone.',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _allTransactions.removeWhere((transaction) =>
                    _selectedTransactions.contains(transaction['id']));
                _selectedTransactions.clear();
                _isMultiSelectMode = false;
              });
              _filterTransactions();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Transactions deleted successfully')),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _editTransaction(Map<String, dynamic> transaction) {
    Navigator.pushNamed(context, '/add-expense-screen');
  }

  void _deleteTransaction(Map<String, dynamic> transaction) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Delete Transaction',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        content: Text(
          'Are you sure you want to delete "${transaction['description']}"?',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _allTransactions
                    .removeWhere((t) => t['id'] == transaction['id']);
              });
              _filterTransactions();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Transaction deleted successfully')),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Future<void> _refreshTransactions() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _filteredTransactions = List.from(_allTransactions);
      _groupTransactions();
    });
  }

  @override
  Widget build(BuildContext context) {
    final hasActiveFilters = _selectedDateRange != null ||
        _selectedCategories.isNotEmpty ||
        _amountRange.start > 0 ||
        _amountRange.end < 10000;

    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        elevation: AppTheme.lightTheme.appBarTheme.elevation,
        leading: _isMultiSelectMode
            ? IconButton(
                onPressed: _toggleMultiSelect,
                icon: CustomIconWidget(
                  iconName: 'close',
                  color: AppTheme.lightTheme.appBarTheme.foregroundColor!,
                  size: 24,
                ),
              )
            : null,
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search transactions...',
                  border: InputBorder.none,
                  hintStyle: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondaryLight,
                  ),
                ),
                style: AppTheme.lightTheme.textTheme.bodyMedium,
                onChanged: _onSearchChanged,
              )
            : _isMultiSelectMode
                ? Text(
                    '${_selectedTransactions.length} selected',
                    style: AppTheme.lightTheme.appBarTheme.titleTextStyle,
                  )
                : Text(
                    'Transaction History',
                    style: AppTheme.lightTheme.appBarTheme.titleTextStyle,
                  ),
        actions: _isMultiSelectMode
            ? [
                if (_selectedTransactions.isNotEmpty)
                  IconButton(
                    onPressed: _deleteSelectedTransactions,
                    icon: CustomIconWidget(
                      iconName: 'delete',
                      color: AppTheme.errorLight,
                      size: 24,
                    ),
                  ),
              ]
            : [
                IconButton(
                  onPressed: _toggleSearch,
                  icon: CustomIconWidget(
                    iconName: _isSearching ? 'close' : 'search',
                    color: AppTheme.lightTheme.appBarTheme.foregroundColor!,
                    size: 24,
                  ),
                ),
                IconButton(
                  onPressed: _showFilterBottomSheet,
                  icon: Stack(
                    children: [
                      CustomIconWidget(
                        iconName: 'filter_list',
                        color: AppTheme.lightTheme.appBarTheme.foregroundColor!,
                        size: 24,
                      ),
                      if (hasActiveFilters)
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: AppTheme.primaryLight,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    switch (value) {
                      case 'multi_select':
                        _toggleMultiSelect();
                        break;
                      case 'export':
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Export feature coming soon')),
                        );
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'multi_select',
                      child: Text('Multi Select'),
                    ),
                    const PopupMenuItem(
                      value: 'export',
                      child: Text('Export Data'),
                    ),
                  ],
                  icon: CustomIconWidget(
                    iconName: 'more_vert',
                    color: AppTheme.lightTheme.appBarTheme.foregroundColor!,
                    size: 24,
                  ),
                ),
              ],
      ),
      body: SafeArea(
        child: _filteredTransactions.isEmpty
            ? _buildEmptyState()
            : Column(
                children: [
                  if (_searchQuery.isNotEmpty)
                    Container(
                      width: double.infinity,
                      padding:
                          EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                      color: AppTheme.lightTheme.colorScheme.primaryContainer,
                      child: Text(
                        '${_filteredTransactions.length} results found',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme
                              .lightTheme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: _refreshTransactions,
                      color: AppTheme.primaryLight,
                      child: ListView.builder(
                        controller: _scrollController,
                        padding: EdgeInsets.symmetric(vertical: 1.h),
                        itemCount: _groupedTransactions.keys.length +
                            (_isLoading ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == _groupedTransactions.keys.length) {
                            return _buildLoadingIndicator();
                          }

                          final groupKey =
                              _groupedTransactions.keys.elementAt(index);
                          final transactions = _groupedTransactions[groupKey]!;

                          return TransactionSectionWidget(
                            sectionTitle: groupKey,
                            transactions: transactions,
                            isMultiSelectMode: _isMultiSelectMode,
                            selectedTransactions: _selectedTransactions,
                            searchQuery: _searchQuery,
                            onTransactionTap: (transaction) {
                              if (_isMultiSelectMode) {
                                _toggleTransactionSelection(transaction['id']);
                              }
                            },
                            onTransactionLongPress: (transaction) {
                              if (!_isMultiSelectMode) {
                                _toggleMultiSelect();
                                _toggleTransactionSelection(transaction['id']);
                              }
                            },
                            onEditTransaction: _editTransaction,
                            onDeleteTransaction: _deleteTransaction,
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/add-expense-screen'),
        backgroundColor:
            AppTheme.lightTheme.floatingActionButtonTheme.backgroundColor,
        foregroundColor:
            AppTheme.lightTheme.floatingActionButtonTheme.foregroundColor,
        child: CustomIconWidget(
          iconName: 'add',
          color: AppTheme.lightTheme.floatingActionButtonTheme.foregroundColor!,
          size: 24,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'receipt_long',
              color: AppTheme.textSecondaryLight,
              size: 80,
            ),
            SizedBox(height: 3.h),
            Text(
              _searchQuery.isNotEmpty
                  ? 'No transactions found'
                  : 'No transactions yet',
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                color: AppTheme.textSecondaryLight,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              _searchQuery.isNotEmpty
                  ? 'Try adjusting your search or filters'
                  : 'Start tracking your expenses and income',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondaryLight,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.h),
            ElevatedButton.icon(
              onPressed: () =>
                  Navigator.pushNamed(context, '/add-expense-screen'),
              icon: CustomIconWidget(
                iconName: 'add',
                color: AppTheme
                    .lightTheme.elevatedButtonTheme.style!.foregroundColor!
                    .resolve({})!,
                size: 20,
              ),
              label: const Text('Add Transaction'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      padding: EdgeInsets.all(4.w),
      child: Center(
        child: CircularProgressIndicator(
          color: AppTheme.primaryLight,
        ),
      ),
    );
  }
}
