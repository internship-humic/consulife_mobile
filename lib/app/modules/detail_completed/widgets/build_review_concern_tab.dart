import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/helpers/string_helper.dart';
import '../controllers/detail_completed_controller.dart';

class BuildReviewConcernTab extends GetView<DetailCompletedController> {
  const BuildReviewConcernTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final history = controller.aiAnalysisHistory.value ?? [];

      if (history.isEmpty) {
        return const Center(
          child: Text('No review concern data', style: TextStyle(fontSize: 16, color: Color(0xFF7C8AA5))),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
        itemCount: history.length,
        itemBuilder: (context, index) {
          final item = history[index];

          return Container(
            margin: const EdgeInsets.only(bottom: 22),
            padding: const EdgeInsets.fromLTRB(26, 24, 26, 26),
            decoration: BoxDecoration(
              color: const Color(0xFFF2F8FD),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: const Color(0xFFD9EAF6), width: 1.2),
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 12, offset: const Offset(0, 4)),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _formatConcernDate(item.createdAt),
                  style: const TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    color: Color(0xFF6B7A93),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  '"${(item.complaint).trim().isEmpty ? '-' : item.complaint.trim()}"',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Color(0xFF172033)),
                ),

                const SizedBox(height: 15),
                const Divider(height: 1, thickness: 1, color: Color(0xFFDCE6EF)),
                const SizedBox(height: 15),

                _buildConcernStatRow(label: 'Stress Probability', value: item.stress),
                const SizedBox(height: 8),
                _buildConcernStatRow(label: 'Anxiety Probability', value: item.anxiety),
                const SizedBox(height: 8),
                _buildConcernStatRow(label: 'Depression Probability', value: item.depression),
              ],
            ),
          );
        },
      );
    });
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
