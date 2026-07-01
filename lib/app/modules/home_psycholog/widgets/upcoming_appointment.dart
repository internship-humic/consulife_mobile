import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../widgets/ui/appointment_card.dart';
import '../../../constants/color.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/helpers/string_helper.dart';
import '../controllers/home_psycholog_controller.dart';

class UpcomingAppointment extends GetView<HomePsychologController> {
  const UpcomingAppointment({super.key});

  @override
  Widget build(BuildContext context) {
    var consultationsLength = controller.consultationDataPsychologst.value.consultations.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Upcoming Appointment",
              style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor, fontSize: 15),
            ),
            TextButton(
              onPressed: () {
                Get.toNamed(Routes.UPCOMING_APPOINTMENT);
              },
              child: const Text(
                "See More",
                style: TextStyle(color: textColor, fontWeight: FontWeight.w100, fontSize: 12),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 100,
          child: controller.consultationDataPsychologst.value.consultations.isEmpty
              ? const Center(
                  child: Text('No upcoming appointments', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                )
              : ListView.separated(
                  // itemCount: controller.consultationDataPsychologst.value.consultations.length,
                  itemCount: consultationsLength <= 3 ? consultationsLength : 3,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return AppointmentCard(
                      isPatient: false,
                      isVertical: true,
                      id: controller.consultationDataPsychologst.value.consultations[index].id.toString(),
                      status: controller.consultationDataPsychologst.value.consultations[index].status,
                      name:
                          "${controller.consultationDataPsychologst.value.consultations[index].user.firstname.capitalizeFirst} ${controller.consultationDataPsychologst.value.consultations[index].user.lastname.capitalizeFirst}",
                      time:
                          "${formatDate(controller.consultationDataPsychologst.value.consultations[index].date)}, ${controller.consultationDataPsychologst.value.consultations[index].startTime}",
                    );
                  },
                  separatorBuilder: (context, index) => const SizedBox(width: 8),
                ),
        ),
      ],
    );
  }
}
