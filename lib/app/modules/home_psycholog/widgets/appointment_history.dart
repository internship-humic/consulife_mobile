import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../widgets/ui/appointment_card.dart';
import '../../../constants/color.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/helpers/string_helper.dart';
import '../controllers/home_psycholog_controller.dart';

class AppointmentHistory extends GetView<HomePsychologController> {
  const AppointmentHistory({super.key});

  @override
  Widget build(BuildContext context) {
    var appointmentHistoryLength = controller.appointmentHistory.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Appointment History",
              style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor, fontSize: 16),
            ),
            TextButton(
              onPressed: () {
                Get.toNamed(Routes.PSIKOLOG_HISTORY);
              },
              child: const Text(
                "See More",
                style: TextStyle(color: textColor, fontWeight: FontWeight.w100),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        controller.appointmentHistory.isEmpty
            ? const SizedBox(
                height: 100,
                child: Center(
                  child: Text('No appointment history', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              )
            : ListView.separated(
                itemCount: appointmentHistoryLength <= 3 ? appointmentHistoryLength : 3,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return AppointmentCard(
                    isPatient: false,
                    isVertical: true,
                    id: controller.appointmentHistory[index].id.toString(),
                    status: controller.appointmentHistory[index].status,
                    name:
                        "${controller.appointmentHistory[index].user.firstname} ${controller.appointmentHistory[index].user.lastname}",
                    time:
                        "${formatDate(controller.appointmentHistory[index].date)}, ${controller.appointmentHistory[index].startTime}",
                  );
                },
                separatorBuilder: (context, index) => const SizedBox(height: 10),
              ),
      ],
    );
  }
}
