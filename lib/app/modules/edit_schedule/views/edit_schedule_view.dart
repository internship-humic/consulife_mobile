import 'package:consulin_mobile_dev/app/constants/color.dart';
import 'package:consulin_mobile_dev/widgets/ui/button_back.dart';
import 'package:consulin_mobile_dev/widgets/ui/custom_elevated_button.dart';
import 'package:consulin_mobile_dev/widgets/ui/loading_custom.dart';
import 'package:consulin_mobile_dev/widgets/ui/manage-day.dart';
import 'package:consulin_mobile_dev/widgets/ui/manage-time.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../controllers/edit_schedule_controller.dart';

class EditScheduleView extends GetView<EditScheduleController> {
  const EditScheduleView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Obx(() {
          if (controller.isLoading.value) {
            return const LoadingCustom();
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ButtonBack(),
              const SizedBox(height: 20),
              Text("Choose Day", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              const SizedBox(height: 5),
              Text("(can multiple select)", style: TextStyle(fontSize: 10)),
              const SizedBox(height: 10),
              ManageDay(
                value: controller.selectedDays,
                onChange: controller.onSelectedDay,
              ),
              const SizedBox(height: 25),
              Text("Set Available Time Slot", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              const SizedBox(height: 5),
              Text("(can multiple select)", style: TextStyle(fontSize: 10)),
              ManageTime(
                onChange: controller.onSelectedTime,
                value: controller.selectedTime,
              ),
              const SizedBox(
                height: 50,
              ),
              CustomElevatedButton(
                primaryColor: primaryColor,
                onPressed: () {
                  // Call your updateSchedule method here
                  controller.updateSchedule();
                },
                buttonText: 'Edit Schedule',
                isLoading:
                    controller.isLoadingButton.value, // Pass the loading state
              )
            ],
          );
        }),
      ),
    );
  }

  Row _buildChooseDaySection() {
    return const Row(
      children: [
        Text("Choose Day", style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(width: 5),
        Text("(can multiple select)"),
      ],
    );
  }
}
