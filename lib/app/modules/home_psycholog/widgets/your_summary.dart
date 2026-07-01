import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../widgets/ui/stats_card.dart';
import '../controllers/home_psycholog_controller.dart';

class YourSummary extends GetView<HomePsychologController> {
  const YourSummary({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Your Summary", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: StatsCard(
                title: "Total\nConsultation",
                value: controller.consultationDataPsychologst.value.totalConsultation.toString(),
                subTitle: "Consultation",
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: StatsCard(
                title: "Today\nSession",
                value: controller.consultationDataPsychologst.value.todayOngoingConsultation.toString(),
                subTitle: "Session",
              ),
            ),
          ],
        ),
      ],
    );
  }
}
