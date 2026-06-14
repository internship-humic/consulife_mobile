import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/color.dart';
import '../controllers/home_pasien_controller.dart';

class PersonalizedInsights extends GetView<HomePasienController> {
  const PersonalizedInsights({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final insight = controller.personalizedInsight.value;
      final isLoading = controller.isInsightLoading.value;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Personalized Insights",
            style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor, fontSize: 16),
          ),
          const SizedBox(height: 12),
          Card(
            color: Colors.white,
            elevation: 1.5,
            surfaceTintColor: Colors.white,
            shadowColor: Colors.black26,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: isLoading
                  ? const SizedBox(height: 120, child: Center(child: CircularProgressIndicator()))
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Card(
                              margin: const EdgeInsets.only(right: 15),
                              elevation: 0,
                              color: _getIconBackgroundColor(insight.severity),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Icon(
                                  _getInsightIcon(insight.severity),
                                  color: _getIconColor(insight.severity),
                                  size: 24,
                                ),
                              ),
                            ),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    insight.title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 15,
                                      color: Color(0xFF1E1E2D),
                                    ),
                                  ),

                                  const SizedBox(height: 8),

                                  Text(
                                    insight.message,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                      height: 1.35,
                                      color: Color(0xFF1E1E2D),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Card(
                          elevation: 0,
                          margin: EdgeInsets.zero,
                          color: _getRecommendationColor(insight.severity),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'RECOMMENDATION',
                                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        insight.recommendation,
                                        style: const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 12),
                                ElevatedButton(
                                  onPressed: () {
                                    // Untuk sekarang dikosongkan dulu.
                                    // Nanti bisa diarahkan ke halaman booking / emergency support.
                                  },
                                  style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    backgroundColor: const Color(0xFFF9F7FF),
                                    foregroundColor: const Color(0xFF1E416B),
                                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                  ),
                                  child: Text(
                                    insight.severity == 'urgent' ? 'Get Help' : 'Book Now',
                                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      );
    });
  }

  Color _getIconBackgroundColor(String severity) {
    switch (severity) {
      case 'urgent':
        return const Color(0x33FFCDD2);
      case 'high':
        return const Color(0x33FFDAD6);
      case 'moderate':
        return const Color(0x33FFF3CD);
      case 'low':
      default:
        return const Color(0x3328A745);
    }
  }

  Color _getIconColor(String severity) {
    switch (severity) {
      case 'urgent':
        return const Color(0xFFD32F2F);
      case 'high':
        return const Color(0xFFC62828);
      case 'moderate':
        return const Color(0xFFF9A825);
      case 'low':
      default:
        return const Color(0xFF2E7D32);
    }
  }

  Color _getRecommendationColor(String severity) {
    switch (severity) {
      case 'urgent':
        return const Color(0xFFB71C1C);
      case 'high':
        return const Color(0xFF234A76);
      case 'moderate':
        return primaryColor;
      case 'low':
      default:
        return primaryColor;
    }
  }

  IconData _getInsightIcon(String severity) {
    switch (severity) {
      case 'urgent':
        return Icons.warning_amber_rounded;
      case 'high':
        return Icons.trending_up_rounded;
      case 'moderate':
        return Icons.insights_rounded;
      case 'low':
      default:
        return Icons.check_circle_outline_rounded;
    }
  }
}
