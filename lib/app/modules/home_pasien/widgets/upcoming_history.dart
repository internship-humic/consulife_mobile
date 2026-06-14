import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../widgets/ui/appointment_card.dart';
import '../../../constants/color.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/helpers/string_helper.dart';
import '../controllers/home_pasien_controller.dart';

class UpcomingHistory extends GetView<HomePasienController> {
  const UpcomingHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Upcoming History",
              style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor, fontSize: 16),
            ),
            TextButton(
              onPressed: () {
                Get.toNamed(Routes.HISTORY_PASIEN);
              },
              child: const Text(
                "See More",
                style: TextStyle(color: textColor, fontWeight: FontWeight.w100),
              ),
            ),
          ],
        ),
        controller.appointmentData.value.history.isEmpty
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'No upcoming history',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textColor),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              )
            : ListView.separated(
                itemCount: controller.appointmentData.value.history.length,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return AppointmentCard(
                    isPatient: true,
                    isVertical: true,
                    id: controller.appointmentData.value.history[index].id.toString(),
                    status: controller.appointmentData.value.history[index].status,
                    name:
                        '${controller.appointmentData.value.history[index].user.firstname.capitalize} ${controller.appointmentData.value.history[index].user.lastname.capitalize}',
                    time:
                        "${formatDate(controller.appointmentData.value.history[index].date)}, ${controller.appointmentData.value.history[index].startTime}",
                  );
                },
                separatorBuilder: (context, index) => const SizedBox(height: 10),
              ),
      ],
    );
  }
}
