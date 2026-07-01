import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../utils/helpers/string_helper.dart';
import '../../controllers/detail_completed_controller.dart';

class BuildAiAnalysResult extends GetView<DetailCompletedController> {
  const BuildAiAnalysResult({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final analyzer = controller.appointmentDetail.value?.aiAnalyzer;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header AI Analysis
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'AI Analysis Result',
                      style: TextStyle(color: Color(0xFF111827), fontSize: 15, fontWeight: FontWeight.w600, height: 1.2),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Last analyzed: ${_formatAnalysisDate(analyzer?.createdAt.toString())}',
                      style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              TextButton(
                onPressed: () {
                  controller.changeTab(2);
                },
                style: TextButton.styleFrom(minimumSize: Size.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                child: const Text(
                  'See Review Concern',
                  textAlign: TextAlign.right,
                  style: TextStyle(color: Color(0xFF0066D6), fontSize: 10, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          _buildAnalysisResultCard(
            title: 'Probability of Stress',
            value: analyzer?.stress,
            iconPath: 'assets/icons/stress.svg',
            semanticsLabel: 'Stress Icon',
          ),
          const SizedBox(height: 15),
          _buildAnalysisResultCard(
            title: 'Probability of Anxiety',
            value: analyzer?.anxiety,
            iconPath: 'assets/icons/ansiety.svg',
            semanticsLabel: 'Anxiety Icon',
          ),
          const SizedBox(height: 15),
          _buildAnalysisResultCard(
            title: 'Probability of Depression',
            value: analyzer?.depression,
            iconPath: 'assets/icons/depresi.svg',
            semanticsLabel: 'Depression Icon',
          ),
        ],
      );
    });
  }

  Widget _buildAnalysisResultCard({
    required String title,
    required dynamic value,
    required String iconPath,
    required String semanticsLabel,
  }) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 75),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.025), blurRadius: 18, offset: const Offset(0, 6))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icon container
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: const Color(0xFF071426), borderRadius: BorderRadius.circular(15)),
            child: SvgPicture.asset(
              iconPath,
              width: 25,
              semanticsLabel: semanticsLabel,
              colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            ),
          ),
          const SizedBox(width: 15),
          // Analysis name
          Expanded(
            child: Text(title, style: const TextStyle(color: Color(0xFF172033), fontSize: 15)),
          ),
          const SizedBox(width: 12),
          // Percentage
          Text(
            _formatPercentage(value),
            textAlign: TextAlign.right,
            style: const TextStyle(color: Color(0xFF0066D6), fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  String _formatPercentage(dynamic value) {
    if (value == null) {
      return '-';
    }
    final String result = value.toString().trim();
    if (result.isEmpty) {
      return '-';
    }
    // Mencegah hasil seperti 52.58%%
    if (result.endsWith('%')) {
      return result;
    }
    return '$result%';
  }

  String _formatAnalysisDate(String? date) {
    if (date == null || date.trim().isEmpty) {
      return '-';
    }
    return formatDate(date);
  }
}
