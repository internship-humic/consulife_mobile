import 'package:flutter/material.dart';

import '../../../../widgets/ui/column_chart.dart';
import '../../../constants/color.dart';

class MonthlyConsultations extends StatelessWidget {
  const MonthlyConsultations({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Monthly Consultations",
          style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor, fontSize: 16),
        ),
        const SizedBox(height: 10),
        const SizedBox(height: 320, child: ColumnChart()),
      ],
    );
  }
}
