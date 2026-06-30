import 'package:consulin_mobile_dev/app/constants/color.dart';
import 'package:consulin_mobile_dev/app/routes/app_pages.dart';
import 'package:consulin_mobile_dev/widgets/onboarding/dot_indicator.dart';
import 'package:consulin_mobile_dev/widgets/onboarding/slider_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/onboarding_controller.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: () {
                  Get.offNamed(Routes.ONBOARDING2);
                },
                child: const Text(
                  "Skip >",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xff434747),
                  ),
                ),
              ),
            ),
            Expanded(
              child: SliderWidget(
                pageController: controller.pageController,
                onboard: controller.data,
                pageIndex: controller.pageIndex.value,
                height: height,
                width: width,
                onChange: controller.onSlideChange,
              ),
            ),
            Obx(() {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: controller.pageIndex.value == 0
                              ? null
                              : controller.prevPage,
                          child: Text(
                              controller.pageIndex.value == 0 ? "" : "Prev",
                              style: TextStyle(
                                color: controller.pageIndex.value == 0
                                    ? Colors.transparent
                                    : const Color(0xff8D95A1),
                              )),
                        ),
                        DotIndicator(
                          itemCount: controller.data.length,
                          currentIndex: controller.pageIndex.value,
                        ),
                        TextButton(
                          onPressed: controller.nextPage,
                          child: const Text(
                            "Next",
                            style: TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
