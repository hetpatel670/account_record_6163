import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/balance_card_widget.dart';
import './widgets/empty_state_widget.dart';
import './widgets/quick_add_expense_widget.dart';
import './widgets/recent_transactions_widget.dart';

class MainDashboard extends StatefulWidget {
  const MainDashboard({super.key});

  @override
  State<MainDashboard> createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isDarkMode = false;
  bool _isLoading = false;

  // Mock financial data
  final List<Map<String, dynamic>> _transactions = [
    {
      "id": 1,
      "title": "Grocery Shopping",
      "category": "Food",
      "amount": -85.50,
      "date": DateTime.now().subtract(Duration(hours: 2)),
      "icon": "shopping_cart",
      "color": 0xFFFF6B6B,
    },
    {
      "id": 2,
      "title": "Salary Deposit",
      "category": "Income",
      "amount": 2500.00,
      "date": DateTime.now().subtract(Duration(days: 1)),
      "icon": "account_balance_wallet",
      "color": 0xFF4ECDC4,
    },
    {
      "id": 3,
      "title": "Coffee Shop",
      "category": "Food",
      "amount": -12.75,
      "date": DateTime.now().subtract(Duration(days: 1, hours: 3)),
      "icon": "local_cafe",
      "color": 0xFFFF6B6B,
    },
    {
      "id": 4,
      "title": "Gas Station",
      "category": "Transport",
      "amount": -45.20,
      "date": DateTime.now().subtract(Duration(days: 2)),
      "icon": "local_gas_station",
      "color": 0xFF45B7D1,
    },
    {
      "id": 5,
      "title": "Online Shopping",
      "category": "Shopping",
      "amount": -129.99,
      "date": DateTime.now().subtract(Duration(days: 3)),
      "icon": "shopping_bag",
      "color": 0xFFFFA726,
    },
  ];

  final List<Map<String, dynamic>> _quickCategories = [
    {
      "name": "Food",
      "icon": "restaurant",
      "color": 0xFFFF6B6B,
    },
    {
      "name": "Transport",
      "icon": "directions_car",
      "color": 0xFF45B7D1,
    },
    {
      "name": "Shopping",
      "icon": "shopping_bag",
      "color": 0xFFFFA726,
    },
    {
      "name": "Entertainment",
      "icon": "movie",
      "color": 0xFF9C27B0,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadThemePreference();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    });
  }

  Future<void> _toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
    await prefs.setBool('isDarkMode', _isDarkMode);

    // Haptic feedback
    HapticFeedback.lightImpact();
  }

  Future<void> _refreshData() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(Duration(seconds: 1));

    // Haptic feedback
    HapticFeedback.mediumImpact();

    setState(() {
      _isLoading = false;
    });
  }

  void _deleteTransaction(int transactionId) {
    setState(() {
      _transactions
          .removeWhere((transaction) => transaction["id"] == transactionId);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Transaction deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            // Implement undo functionality
          },
        ),
      ),
    );
  }

  void _showTransactionOptions(Map<String, dynamic> transaction) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: CustomIconWidget(
                iconName: 'edit',
                color: _isDarkMode
                    ? AppTheme.textPrimaryDark
                    : AppTheme.textPrimaryLight,
                size: 24,
              ),
              title: Text('Edit Transaction'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to edit screen
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'delete',
                color: _isDarkMode ? AppTheme.errorDark : AppTheme.errorLight,
                size: 24,
              ),
              title: Text('Delete Transaction'),
              onTap: () {
                Navigator.pop(context);
                _deleteTransaction(transaction["id"]);
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'content_copy',
                color: _isDarkMode
                    ? AppTheme.textPrimaryDark
                    : AppTheme.textPrimaryLight,
                size: 24,
              ),
              title: Text('Duplicate Transaction'),
              onTap: () {
                Navigator.pop(context);
                // Implement duplicate functionality
              },
            ),
          ],
        ),
      ),
    );
  }

  double get _totalBalance {
    return _transactions.fold(
        0.0, (sum, transaction) => sum + (transaction["amount"] as double));
  }

  double get _totalIncome {
    return _transactions
        .where((transaction) => (transaction["amount"] as double) > 0)
        .fold(
            0.0, (sum, transaction) => sum + (transaction["amount"] as double));
  }

  double get _totalExpenses {
    return _transactions
        .where((transaction) => (transaction["amount"] as double) < 0)
        .fold(
            0.0,
            (sum, transaction) =>
                sum + (transaction["amount"] as double).abs());
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: _isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme,
      child: Scaffold(
        backgroundColor:
            _isDarkMode ? AppTheme.surfaceDark : AppTheme.surfaceLight,
        body: SafeArea(
          child: Column(
            children: [
              // Header with theme toggle
              Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Account Record',
                      style: (_isDarkMode
                              ? AppTheme.darkTheme
                              : AppTheme.lightTheme)
                          .textTheme
                          .headlineSmall,
                    ),
                    GestureDetector(
                      onTap: _toggleTheme,
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        padding: EdgeInsets.all(2.w),
                        decoration: BoxDecoration(
                          color: (_isDarkMode
                                  ? AppTheme.primaryDark
                                  : AppTheme.primaryLight)
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: CustomIconWidget(
                          iconName: _isDarkMode ? 'light_mode' : 'dark_mode',
                          color: _isDarkMode
                              ? AppTheme.primaryDark
                              : AppTheme.primaryLight,
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Tab Bar
              Container(
                margin: EdgeInsets.symmetric(horizontal: 4.w),
                decoration: BoxDecoration(
                  color: (_isDarkMode ? AppTheme.cardDark : AppTheme.cardLight),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    color: _isDarkMode
                        ? AppTheme.primaryDark
                        : AppTheme.primaryLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  labelColor: _isDarkMode
                      ? AppTheme.surfaceDark
                      : AppTheme.surfaceLight,
                  unselectedLabelColor: _isDarkMode
                      ? AppTheme.textSecondaryDark
                      : AppTheme.textSecondaryLight,
                  tabs: [
                    Tab(text: 'Dashboard'),
                    Tab(text: 'Transactions'),
                    Tab(text: 'Categories'),
                    Tab(text: 'Settings'),
                  ],
                ),
              ),

              SizedBox(height: 2.h),

              // Tab Bar View
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // Dashboard Tab
                    RefreshIndicator(
                      onRefresh: _refreshData,
                      child: SingleChildScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
                        child: Column(
                          children: [
                            // Balance Card
                            BalanceCardWidget(
                              totalBalance: _totalBalance,
                              totalIncome: _totalIncome,
                              totalExpenses: _totalExpenses,
                              isDarkMode: _isDarkMode,
                            ),

                            SizedBox(height: 3.h),

                            // Quick Add Expense
                            QuickAddExpenseWidget(
                              categories: _quickCategories,
                              isDarkMode: _isDarkMode,
                              onCategoryTap: (category) {
                                Navigator.pushNamed(
                                    context, '/add-expense-screen');
                              },
                            ),

                            SizedBox(height: 3.h),

                            // Recent Transactions
                            _transactions.isEmpty
                                ? EmptyStateWidget(isDarkMode: _isDarkMode)
                                : RecentTransactionsWidget(
                                    transactions: _transactions,
                                    isDarkMode: _isDarkMode,
                                    onTransactionTap: (transaction) {
                                      Navigator.pushNamed(
                                          context, '/add-expense-screen');
                                    },
                                    onTransactionLongPress:
                                        _showTransactionOptions,
                                    onTransactionDelete: _deleteTransaction,
                                  ),

                            SizedBox(height: 10.h),
                          ],
                        ),
                      ),
                    ),

                    // Transactions Tab
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomIconWidget(
                            iconName: 'receipt_long',
                            color: _isDarkMode
                                ? AppTheme.textSecondaryDark
                                : AppTheme.textSecondaryLight,
                            size: 48,
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            'Transaction History',
                            style: (_isDarkMode
                                    ? AppTheme.darkTheme
                                    : AppTheme.lightTheme)
                                .textTheme
                                .titleLarge,
                          ),
                          SizedBox(height: 1.h),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, '/transaction-history');
                            },
                            child: Text('View All Transactions'),
                          ),
                        ],
                      ),
                    ),

                    // Categories Tab
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomIconWidget(
                            iconName: 'category',
                            color: _isDarkMode
                                ? AppTheme.textSecondaryDark
                                : AppTheme.textSecondaryLight,
                            size: 48,
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            'Categories Management',
                            style: (_isDarkMode
                                    ? AppTheme.darkTheme
                                    : AppTheme.lightTheme)
                                .textTheme
                                .titleLarge,
                          ),
                          SizedBox(height: 1.h),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, '/categories-management');
                            },
                            child: Text('Manage Categories'),
                          ),
                        ],
                      ),
                    ),

                    // Settings Tab
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomIconWidget(
                            iconName: 'settings',
                            color: _isDarkMode
                                ? AppTheme.textSecondaryDark
                                : AppTheme.textSecondaryLight,
                            size: 48,
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            'Settings',
                            style: (_isDarkMode
                                    ? AppTheme.darkTheme
                                    : AppTheme.lightTheme)
                                .textTheme
                                .titleLarge,
                          ),
                          SizedBox(height: 1.h),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/settings-screen');
                            },
                            child: Text('Open Settings'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: _tabController.index == 0
            ? FloatingActionButton.extended(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  Navigator.pushNamed(context, '/add-expense-screen');
                },
                icon: CustomIconWidget(
                  iconName: 'add',
                  color: _isDarkMode
                      ? AppTheme.surfaceDark
                      : AppTheme.surfaceLight,
                  size: 24,
                ),
                label: Text(
                  'Add Expense',
                  style: TextStyle(
                    color: _isDarkMode
                        ? AppTheme.surfaceDark
                        : AppTheme.surfaceLight,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                backgroundColor:
                    _isDarkMode ? AppTheme.primaryDark : AppTheme.primaryLight,
              )
            : null,
      ),
    );
  }
}
