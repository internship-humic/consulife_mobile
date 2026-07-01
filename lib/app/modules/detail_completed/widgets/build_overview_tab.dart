import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../widgets/ui/refresh_custom.dart';
import '../controllers/detail_completed_controller.dart';
import 'overview/build_ai_analys_result.dart';
import 'overview/build_patient_card.dart';

class BuildOverviewTab extends GetView<DetailCompletedController> {
  const BuildOverviewTab({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomRefreshIndicator(
      onRefresh: () => controller.fetchAppointmentDetails(Get.arguments.toString()),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(22, 16, 22, 32),
        children: [BuildPatientCard(), const SizedBox(height: 28), BuildAiAnalysResult()],
      ),
    );
  }
}
