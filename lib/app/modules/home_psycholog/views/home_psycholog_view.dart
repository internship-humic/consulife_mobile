import 'package:consulin_mobile_dev/app/constants/color.dart';
import 'package:consulin_mobile_dev/app/utils/helpers/string_helper.dart';
import 'package:consulin_mobile_dev/widgets/ui/appointment_card.dart';
import 'package:consulin_mobile_dev/widgets/ui/column_chart.dart';
import 'package:consulin_mobile_dev/widgets/ui/loading_custom.dart';
import 'package:consulin_mobile_dev/widgets/ui/refresh_custom.dart';
import 'package:consulin_mobile_dev/widgets/ui/stats_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:consulin_mobile_dev/app/routes/app_pages.dart';

import '../controllers/home_psycholog_controller.dart';
import '../widgets/appointment_history.dart';
import '../widgets/monthly_consultations.dart';
import '../widgets/upcoming_appointment.dart';
import '../widgets/your_summary.dart';

class HomePsychologView extends GetView<HomePsychologController> {
  const HomePsychologView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          return controller.isLoading.value
              ? const LoadingCustom()
              : CustomRefreshIndicator(
                  onRefresh: () async {
                    await controller.getConsultationDataPsychologist();
                  },
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Hi,${" ${controller.profilePychologController.profile.value.firstname.capitalizeFirst} ${controller.profilePychologController.profile.value.lastname.capitalizeFirst}"}",
                                    style: const TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                  const Row(
                                    children: [
                                      Text("Welcome to ", style: TextStyle(fontSize: 16)),
                                      Text("Consulife", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                    ],
                                  ),
                                ],
                              ),
                              // IconButton(
                              //     onPressed: () {
                              //       Get.toNamed(Routes.NOTIFICATION);
                              //     },
                              //     icon: const Icon(Icons.notifications)),
                            ],
                          ),
                          const SizedBox(height: 25),
                          UpcomingAppointment(),
                          const SizedBox(height: 25),
                          AppointmentHistory(),
                          const SizedBox(height: 25),
                          YourSummary(),
                          const SizedBox(height: 25),
                          MonthlyConsultations(),
                        ],
                      ),
                    ),
                  ),
                );
        }),
      ),
    );
  }
}
