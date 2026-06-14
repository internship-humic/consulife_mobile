import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../widgets/ui/column_chart_analysis.dart';
import '../../../constants/color.dart';
import '../../../routes/app_pages.dart';
import '../controllers/home_pasien_controller.dart';

class AnalysisResult extends GetView<HomePasienController> {
  const AnalysisResult({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Analysis Results",
          style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor, fontSize: 16),
        ),
        Card(
          color: carddetail,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Expanded(child: ColumnChartAnalysis())],
                ),
                const SizedBox(height: 16.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Probability of Stress: ${controller.aiAnalyzerPasienController.stressProbability.value}%'),
                    Text('Probability of Anxiety: ${controller.aiAnalyzerPasienController.anxietyProbability.value}%'),
                    Text('Probability of Depression: ${controller.aiAnalyzerPasienController.depressionProbability.value}%'),
                  ],
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    Get.toNamed(Routes.ANALYZER_HISTORY_PASIEN);
                  },
                  child: const Text(
                    'Analyzer History',
                    style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
