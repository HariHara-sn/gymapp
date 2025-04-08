import 'package:flutter/material.dart';
import 'package:gymapp/Theme/appcolor.dart' show AppColors;

class PaymentDataTable extends StatelessWidget {
  final List<Map<String, dynamic>> members;

  const PaymentDataTable({
    super.key,
    required this.members,
  });

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    double columnSpacing = _calculateColumnSpacing(width);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: columnSpacing,
        dividerThickness: 0.5,
        columns: [
          DataColumn(
            label: Text(
              'Payment Method',
              style: TextStyle(color: AppColors.greenAccent),
            ),
          ),
          DataColumn(
            label: Text(
              'Payment Status',
              style: TextStyle(color: AppColors.greenAccent),
            ),
          ),
        ],
        rows: members.map((member) {
          return DataRow(
            cells: [
              DataCell(Text(member['payment_method'] ?? 'N/A')),
              DataCell(Text(member['payment_status'] ?? 'N/A')),
            ],
          );
        }).toList(),
      ),
    );
  }

  double _calculateColumnSpacing(double screenWidth) {
    if (screenWidth < 600) {
      return 60; // Mobile
    } else if (screenWidth >= 600 && screenWidth < 1024) {
      return 200; // Tablet
    } else {
      return 300; // Desktop
    }
  }
}