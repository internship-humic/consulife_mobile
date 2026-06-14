import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../widgets/ui/appointment_card.dart';
import '../../../constants/color.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/helpers/string_helper.dart';
import '../controllers/home_pasien_controller.dart';

class UpcomingAppointments extends GetView<HomePasienController> {
  const UpcomingAppointments({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Upcoming Appointments",
              style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor, fontSize: 16),
            ),
            TextButton(
              onPressed: () {
                Get.toNamed(Routes.UPCOMING_APPOINTMET_PASIEN);
              },
              child: const Text(
                "See More",
                style: TextStyle(color: textColor, fontWeight: FontWeight.w100),
              ),
            ),
          ],
        ),
        controller.appointmentData.value.upcomingAppointments.isEmpty
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'No upcoming appointments',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textColor),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              )
            : SizedBox(
                height: 100,
                child: ListView.separated(
                  itemCount: controller.appointmentData.value.upcomingAppointments.length,
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return AppointmentCard(
                      isPatient: true,
                      isVertical: false,
                      id: controller.appointmentData.value.upcomingAppointments[index].id.toString(),
                      status: controller.appointmentData.value.upcomingAppointments[index].status,
                      name:
                          '${controller.appointmentData.value.upcomingAppointments[index].user.firstname.capitalize} ${controller.appointmentData.value.upcomingAppointments[index].user.lastname.capitalize}',
                      time:
                          "${formatDate(controller.appointmentData.value.upcomingAppointments[index].date)}, ${controller.appointmentData.value.upcomingAppointments[index].startTime}",
                    );
                  },
                  separatorBuilder: (context, index) => const SizedBox(width: 10),
                ),
              ),
      ],
    );
  }
}
