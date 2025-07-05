import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class PaymentMethodWidget extends StatelessWidget {
  final String selectedMethod;
  final ValueChanged<String> onMethodSelected;

  const PaymentMethodWidget({
    Key? key,
    required this.selectedMethod,
    required this.onMethodSelected,
  }) : super(key: key);

  final List<Map<String, dynamic>> _paymentMethods = const [
    {'name': 'Cash', 'icon': 'payments'},
    {'name': 'Card', 'icon': 'credit_card'},
    {'name': 'Digital', 'icon': 'smartphone'},
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payment Method',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 1.h),
        Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.colorScheme.outline,
              width: 1,
            ),
          ),
          child: Row(
            children: _paymentMethods.map((method) {
              final isSelected = selectedMethod == method['name'];
              final isFirst = _paymentMethods.first == method;
              final isLast = _paymentMethods.last == method;

              return Expanded(
                child: GestureDetector(
                  onTap: () => onMethodSelected(method['name']),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? theme.colorScheme.primary
                          : Colors.transparent,
                      borderRadius: BorderRadius.horizontal(
                        left: isFirst ? Radius.circular(11) : Radius.zero,
                        right: isLast ? Radius.circular(11) : Radius.zero,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: method['icon'],
                          color: isSelected
                              ? theme.colorScheme.onPrimary
                              : theme.colorScheme.onSurface,
                          size: 5.w,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          method['name'],
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: isSelected
                                ? theme.colorScheme.onPrimary
                                : theme.colorScheme.onSurface,
                            fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
