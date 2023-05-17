import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_care/stuff/classes.dart';

class PasswordStrength extends StatelessWidget {
  final String password;

  const PasswordStrength({super.key, required this.password});

  @override
  Widget build(BuildContext context) {
    final Map<String, bool> criteria = {"contains_uppercase": false, "contains_lowercase": false, "contains_digit": false, "length": false};

    if (password.contains(RegExp(r'[A-Z]'))) {
      criteria['contains_uppercase'] = true;
    }
    if (password.contains(RegExp(r'[a-z]'))) {
      criteria['contains_lowercase'] = true;
    }
    if (password.contains(RegExp(r'[0-9]'))) {
      criteria['contains_digit'] = true;
    }
    if (password.length >= 6) {
      criteria['length'] = true;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          children: <Widget>[
            Icon(criteria['contains_uppercase']! ? Icons.check_circle : Icons.cancel_outlined, color: criteria['contains_uppercase']! ? Colors.green : Colors.red),
            const SizedBox(width: 8),
            CustomizedText(text: 'Contains uppercase letter'.tr, fontSize: 16),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: <Widget>[
            Icon(criteria['contains_lowercase']! ? Icons.check_circle : Icons.cancel_outlined, color: criteria['contains_lowercase']! ? Colors.green : Colors.red),
            const SizedBox(width: 8),
            CustomizedText(text: 'Contains lowercase letter'.tr, fontSize: 16),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: <Widget>[
            Icon(criteria['contains_digit']! ? Icons.check_circle : Icons.cancel_outlined, color: criteria['contains_digit']! ? Colors.green : Colors.red),
            const SizedBox(width: 8),
            CustomizedText(text: 'Contains digit'.tr, fontSize: 16),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: <Widget>[
            Icon(criteria['length']! ? Icons.check_circle : Icons.cancel_outlined, color: criteria['length']! ? Colors.green : Colors.red),
            const SizedBox(width: 8),
            CustomizedText(text: 'Contains more than 5 characters'.tr, fontSize: 16),
          ],
        ),
      ],
    );
  }
}
