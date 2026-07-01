import 'package:consulin_mobile_dev/app/constants/color.dart';
import 'package:consulin_mobile_dev/app/routes/app_pages.dart';
import 'package:consulin_mobile_dev/widgets/ui/custom_elevated_button.dart';
import 'package:consulin_mobile_dev/widgets/ui/manage-day.dart';
import 'package:consulin_mobile_dev/widgets/ui/manage-time.dart';
import 'package:consulin_mobile_dev/widgets/ui/refresh_custom.dart';
import 'package:consulin_mobile_dev/widgets/ui/schedule_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../controllers/manage_schedule_controller.dart';

class ManageScheduleView extends GetView<ManageScheduleController> {
  const ManageScheduleView({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          return controller.isLoading.value
              ? Center(child: LoadingAnimationWidget.progressiveDots(color: Colors.black, size: 50))
              : CustomRefreshIndicator(
                  onRefresh: () async {
                    await controller.getSchedule();
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(() {
                          return controller.scheduleOpen.isEmpty
                              ? const SizedBox()
                              : Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                                      child: Column(children: [_buildHeader(), const SizedBox(height: 5)]),
                                    ),
                                    _buildScheduleCards(height),
                                  ],
                                );
                        }),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 20),
                              Text("Choose Day", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                              const SizedBox(height: 5),
                              Text("(can multiple select)", style: TextStyle(fontSize: 10)),
                              const SizedBox(height: 10),
                              ManageDay(value: controller.selectedDays, onChange: controller.onSelectedDay, disabled: true),
                              const SizedBox(height: 20),
                              Text("Set Available Time Slot", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                              const SizedBox(height: 5),
                              Text("(can multiple select)", style: TextStyle(fontSize: 10)),
                              ManageTime(
                                onChange: controller.onSelectedTime,
                                value: controller.selectedTime,
                                disabled: true,
                              ),
                              const SizedBox(height: 25),
                              CustomElevatedButton(
                                primaryColor: primaryColor,
                                onPressed: () {
                                  Get.toNamed(Routes.EDIT_SCHEDULE);
                                },
                                buttonText: "Edit Schedule",
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
        }),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text("Schedule Overview", style: TextStyle(fontWeight: FontWeight.bold)),
        Obx(() {
          return Switch(
            focusColor: primaryColor,
            activeColor: primaryColor,
            inactiveThumbColor: primaryColor.withOpacity(0.5),
            value: controller.isOpenAppointment.value,
            onChanged: controller.onChanged,
          );
        }),
      ],
    );
  }

  SizedBox _buildScheduleCards(double height) {
    // Access the ManageScheduleController
    final controller = Get.find<ManageScheduleController>();

    return SizedBox(
      height: height / 7,
      child: Obx(() {
        // Use the scheduleOpen observable to get the data
        final scheduleData = controller.scheduleOpen;

        // Flatten the schedule data to create a list of time slots
        final flattenedSchedule = scheduleData.expand((daySchedule) {
          final day = daySchedule['day'];
          final times = daySchedule['times'] as List<Map<String, String>>;
          return times.map((time) {
            return {'day': day, 'time': '${time['start']} - ${time['end']}'};
          });
        }).toList();

        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: flattenedSchedule.length, // Use the length of the flattened schedule
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            final scheduleItem = flattenedSchedule[index];
            return ScheduleCard(
              title: scheduleItem['day'], // Day name
              time: scheduleItem['time'], // Time range
            );
          },
          separatorBuilder: (context, index) {
            return const SizedBox(width: 15); // Space between cards
          },
        );
      }),
    );
  }
}
