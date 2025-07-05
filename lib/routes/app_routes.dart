import 'package:flutter/material.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/add_expense_screen/add_expense_screen.dart';
import '../presentation/main_dashboard/main_dashboard.dart';
import '../presentation/settings_screen/settings_screen.dart';
import '../presentation/transaction_history/transaction_history.dart';
import '../presentation/categories_management/categories_management.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String splashScreen = '/splash-screen';
  static const String addExpenseScreen = '/add-expense-screen';
  static const String mainDashboard = '/main-dashboard';
  static const String settingsScreen = '/settings-screen';
  static const String transactionHistory = '/transaction-history';
  static const String categoriesManagement = '/categories-management';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    splashScreen: (context) => const SplashScreen(),
    addExpenseScreen: (context) => const AddExpenseScreen(),
    mainDashboard: (context) => const MainDashboard(),
    settingsScreen: (context) => const SettingsScreen(),
    transactionHistory: (context) => const TransactionHistory(),
    categoriesManagement: (context) => const CategoriesManagement(),
    // TODO: Add your other routes here
  };
}
