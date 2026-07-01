import 'package:consulin_mobile_dev/widgets/ui/loading_custom.dart';
import 'package:consulin_mobile_dev/widgets/ui/refresh_custom.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_pasien_controller.dart';

import '../widgets/analysis_result.dart';
import '../widgets/personalized_insights.dart';
import '../widgets/upcoming_appointments.dart';
import '../widgets/upcoming_history.dart';

class HomePasienView extends GetView<HomePasienController> {
  const HomePasienView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          return controller.isLoading.value
              ? const LoadingCustom()
              : CustomRefreshIndicator(
                  onRefresh: () async {
                    await controller.fetchAppointments();
                    await controller.fetchPersonalizedInsight();
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
                                    "Hi, ${controller.profilePasienController.profile.value.firstname} ${controller.profilePasienController.profile.value.lastname}",
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
                              //       Get.toNamed(Routes.NOTIFICATION_PASIEN);
                              //     },
                              //     icon:
                              //         const Icon(Icons.notifications_outlined)),
                            ],
                          ),
                          const SizedBox(height: 20),

                          ///UPCOMING APPOINTMENTS
                          UpcomingAppointments(),
                          const SizedBox(height: 25),

                          ///UPCOMING HISTORY
                          UpcomingHistory(),
                          const SizedBox(height: 25),

                          ///ANALYSIS RESULTS
                          AnalysisResult(),
                          const SizedBox(height: 25),

                          ///Personalized Insights
                          PersonalizedInsights(),
                          const SizedBox(height: 25),
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
