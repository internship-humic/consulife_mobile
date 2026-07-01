import 'package:consulin_mobile_dev/app/utils/helpers/string_helper.dart';
import 'package:consulin_mobile_dev/widgets/ui/loading_custom.dart';
import 'package:consulin_mobile_dev/widgets/ui/refresh_custom.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../controllers/detail_completed_controller.dart';
import 'package:consulin_mobile_dev/app/constants/color.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../widgets/build_overview_tab.dart';
import '../widgets/build_review_concern_tab.dart';
import '../widgets/overview/build_ai_analys_result.dart';
import '../widgets/overview/build_patient_card.dart';

class DetailCompletedView extends GetView<DetailCompletedController> {
  const DetailCompletedView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: textColor, size: 40),
          onPressed: () {
            Get.back();
          },
        ),
        title: const Text(
          'Patient Detail',
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        actions: [
          Obx(() {
            if (controller.appointmentDetail.value != null && controller.appointmentDetail.value!.status == 'ongoing') {
              return IconButton(
                icon: const Icon(Icons.videocam, color: primaryColor),
                onPressed: controller.joinMeet,
              );
            } else {
              return Container();
            }
          }),
          // IconButton(
          //   icon: const Icon(Icons.videocam, color: primaryColor),
          //   onPressed: controller.joinMeet,
          // )
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: LoadingAnimationWidget.progressiveDots(color: Colors.black, size: 50));
        }
        return Column(
          children: [
            _buildProfileSection(),
            _buildTabNavigation(),
            Expanded(child: _buildTabContent()),
          ],
        );
      }),
    );
  }

  Widget _buildProfileSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.grey[200],
            child: const Icon(Icons.person_2_outlined, size: 40, color: textColor),
          ),
          const SizedBox(height: 16.0),
          Text(
            '${controller.appointmentDetail.value!.user.firstname} ${controller.appointmentDetail.value!.user.lastname}',
            style: const TextStyle(fontSize: 15, color: textColor, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8.0),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: _getStatusColor(controller.appointmentDetail.value!.status).withOpacity(0.25),
              borderRadius: BorderRadius.circular(100.0),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _getStatusIcon(controller.appointmentDetail.value!.status),
                  color: _getStatusColor(controller.appointmentDetail.value!.status),
                  size: 15,
                ),
                SizedBox(width: 8),
                Text(
                  '${controller.appointmentDetail.value!.status.capitalizeFirst!} Appointment',
                  style: TextStyle(
                    color: _getStatusColor(controller.appointmentDetail.value!.status),
                    fontWeight: FontWeight.bold,
                    fontSize: 12.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'waiting':
        return primaryColor;
      case 'ongoing':
        return textColor;
      case 'canceled':
        return Colors.red;
      case 'completed':
        return successColor;
      default:
        return Colors.white;
    }
  }

  IconData? _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'waiting':
        return Icons.timer;
      case 'ongoing':
        return Icons.support_agent;
      case 'canceled':
        return Icons.cancel;
      case 'completed':
        return Icons.check_circle;
      default:
        return Icons.error;
    }
  }

  Widget _buildTabNavigation() {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [_buildTabButton('Overview', 0), _buildTabButton('Chat Room', 1), _buildTabButton('Review Concern', 2)],
      ),
    );
  }

  Widget _buildTabButton(String label, int index) {
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.changeTab(index),
        child: Obx(
          () => Container(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            alignment: Alignment.center,
            child: Column(
              children: [
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: controller.selectedTabIndex.value == index ? textColor : Colors.grey.shade400,
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: controller.selectedTabIndex.value == index ? label.length * 12 / 2 : 0.0,
                  height: 3.0,
                  color: controller.selectedTabIndex.value == index ? textColor : Colors.transparent,
                  margin: const EdgeInsets.only(top: 5.0),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    return Obx(() {
      if (controller.selectedTabIndex.value == 0) {
        return BuildOverviewTab();
      } else if (controller.selectedTabIndex.value == 1) {
        return _buildChatRoomTab();
      } else {
        return BuildReviewConcernTab();
      }
    });
  }

  Widget _buildChatRoomTab() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const LoadingCustom();
      }

      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: GoogleFonts.poppins().fontFamily, scaffoldBackgroundColor: const Color(0xffF5F5F7)),
        builder: (context, widget) {
          return StreamChat(client: controller.client, child: widget);
        },
        home: Obx(() {
          return controller.isLoading.value
              ? Center(child: LoadingAnimationWidget.progressiveDots(color: Colors.black, size: 50))
              : StreamChannel(
                  showLoading: true,
                  loadingBuilder: (context) => const LoadingCustom(),
                  channel: controller.channel,
                  child: ChannelPage(),
                );
        }),
      );
    });
  }
}

class ChannelPage extends StatelessWidget {
  final DetailCompletedController controller = Get.find();
  ChannelPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          const Expanded(child: StreamMessageListView()),
          Obx(() {
            if (controller.appointmentDetail.value!.status == 'ongoing') {
              return const StreamMessageInput();
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }
}
