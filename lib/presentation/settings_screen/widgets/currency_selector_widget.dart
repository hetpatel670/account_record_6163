import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CurrencySelectorWidget extends StatelessWidget {
  final String selectedCurrency;
  final Function(String) onCurrencyChanged;
  final bool isDarkMode;

  const CurrencySelectorWidget({
    super.key,
    required this.selectedCurrency,
    required this.onCurrencyChanged,
    required this.isDarkMode,
  });

  final List<Map<String, dynamic>> currencies = const [
    {"code": "USD", "name": "US Dollar", "symbol": "\$", "flag": "🇺🇸"},
    {"code": "EUR", "name": "Euro", "symbol": "€", "flag": "🇪🇺"},
    {"code": "GBP", "name": "British Pound", "symbol": "£", "flag": "🇬🇧"},
    {"code": "JPY", "name": "Japanese Yen", "symbol": "¥", "flag": "🇯🇵"},
    {"code": "CAD", "name": "Canadian Dollar", "symbol": "C\$", "flag": "🇨🇦"},
    {
      "code": "AUD",
      "name": "Australian Dollar",
      "symbol": "A\$",
      "flag": "🇦🇺"
    },
    {"code": "CHF", "name": "Swiss Franc", "symbol": "CHF", "flag": "🇨🇭"},
    {"code": "CNY", "name": "Chinese Yuan", "symbol": "¥", "flag": "🇨🇳"},
  ];

  @override
  Widget build(BuildContext context) {
    final theme = isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme;
    final selectedCurrencyData = currencies.firstWhere(
      (currency) => currency["code"] == selectedCurrency,
      orElse: () => currencies[0],
    );

    return InkWell(
      onTap: () => _showCurrencyPicker(context, theme),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        decoration: BoxDecoration(
          border: Border.all(color: theme.colorScheme.outline),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Text(
              selectedCurrencyData["flag"] as String,
              style: TextStyle(fontSize: 20.sp),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    selectedCurrencyData["name"] as String,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '${selectedCurrencyData["code"]} (${selectedCurrencyData["symbol"]})',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            CustomIconWidget(
              iconName: 'keyboard_arrow_down',
              color: theme.colorScheme.onSurface,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  void _showCurrencyPicker(BuildContext context, ThemeData theme) {
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
                'Select Currency',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 2.h),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: currencies.length,
                  itemBuilder: (context, index) {
                    final currency = currencies[index];
                    final isSelected = currency["code"] == selectedCurrency;

                    return ListTile(
                      leading: Text(
                        currency["flag"] as String,
                        style: TextStyle(fontSize: 18.sp),
                      ),
                      title: Text(
                        currency["name"] as String,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                      subtitle: Text(
                        '${currency["code"]} (${currency["symbol"]})',
                        style: theme.textTheme.bodySmall,
                      ),
                      trailing: isSelected
                          ? CustomIconWidget(
                              iconName: 'check_circle',
                              color: theme.colorScheme.primary,
                              size: 20,
                            )
                          : null,
                      onTap: () {
                        onCurrencyChanged(currency["code"] as String);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
              SizedBox(height: 2.h),
            ],
          ),
        );
      },
    );
  }
}
