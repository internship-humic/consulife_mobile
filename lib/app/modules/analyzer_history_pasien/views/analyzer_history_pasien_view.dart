import 'package:consulin_mobile_dev/app/utils/helpers/string_helper.dart';
import 'package:consulin_mobile_dev/widgets/ui/button_back.dart';
import 'package:consulin_mobile_dev/widgets/ui/loading_custom.dart';
import 'package:consulin_mobile_dev/widgets/ui/refresh_custom.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/analyzer_history_pasien_controller.dart';
import 'package:consulin_mobile_dev/app/constants/color.dart';

class AnalyzerHistoryPasienView extends GetView<AnalyzerHistoryPasienController> {
  const AnalyzerHistoryPasienView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const ButtonBack(),
        title: const Text(
          'AI Analyzer History',
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Obx(() {
        return controller.isLoading.value
            ? const LoadingCustom()
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: CustomRefreshIndicator(
                  onRefresh: () async {
                    await controller.fetchAnalyzerHistory();
                  },
                  child: ListView.builder(
                    itemCount: controller.analyzerHistory.length,
                    itemBuilder: (context, index) {
                      var analyzeResult = controller.analyzerHistory[index];

                      return Container(
                        margin: const EdgeInsets.only(bottom: 22),
                        padding: const EdgeInsets.fromLTRB(26, 24, 26, 26),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF2F8FD),
                          borderRadius: BorderRadius.circular(32),
                          border: Border.all(color: const Color(0xFFD9EAF6), width: 1.2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.03),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _formatConcernDate(analyzeResult.createdAt),
                              style: const TextStyle(
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                                color: Color(0xFF6B7A93),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              '"${(analyzeResult.complaint).trim().isEmpty ? '-' : analyzeResult.complaint.trim()}"',
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Color(0xFF172033)),
                            ),

                            const SizedBox(height: 15),
                            const Divider(height: 1, thickness: 1, color: Color(0xFFDCE6EF)),
                            const SizedBox(height: 15),

                            _buildConcernStatRow(label: 'Stress Probability', value: analyzeResult.stress),
                            const SizedBox(height: 8),
                            _buildConcernStatRow(label: 'Anxiety Probability', value: analyzeResult.anxiety),
                            const SizedBox(height: 8),
                            _buildConcernStatRow(label: 'Depression Probability', value: analyzeResult.depression),
                          ],
                        ),
                      );
                      // return _buildAnalyzeResultSection(
                      //   appointmentDate: analyzeResult.createdAt,
                      //   description: analyzeResult.complaint,
                      //   stressProbability: analyzeResult.stress,
                      //   anxietyProbability: analyzeResult.anxiety,
                      //   depressionProbability: analyzeResult.depression,
                      // );
                    },
                  ),
                ),
              );
      }),
    );
  }

  Widget _buildConcernStatRow({required String label, required dynamic value}) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Color(0xFF8794AD), height: 1.3),
          ),
        ),
        const SizedBox(width: 16),
        Text(
          _formatPercentage(value),
          textAlign: TextAlign.right,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF0D1B33)),
        ),
      ],
    );
  }

  String _formatPercentage(dynamic value) {
    if (value == null) return '-';

    final result = value.toString().trim();
    if (result.isEmpty) return '-';

    return result.endsWith('%') ? result : '$result%';
  }

  String _formatConcernDate(String? date) {
    if (date == null || date.trim().isEmpty) {
      return '-';
    }

    return formatDate(date).toUpperCase();
  }
}
