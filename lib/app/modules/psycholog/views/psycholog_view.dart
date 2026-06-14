import 'package:consulin_mobile_dev/app/routes/app_pages.dart';
import 'package:consulin_mobile_dev/app/utils/helpers/string_helper.dart';
import 'package:consulin_mobile_dev/widgets/ui/custom_elevated_button.dart';
import 'package:consulin_mobile_dev/widgets/ui/loading_custom.dart';
import 'package:consulin_mobile_dev/widgets/ui/refresh_custom.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/psycholog_controller.dart';
import 'package:consulin_mobile_dev/app/constants/color.dart';
import 'package:consulin_mobile_dev/app/models/user.dart';

import '../widget/gender_filter_button.dart';
import '../widget/psychologist_card.dart';

class PsychologView extends GetView<PsychologController> {
  const PsychologView({super.key});

  @override
  Widget build(BuildContext context) {
    // Use Obx to manage the UI based on state
    return Scaffold(
      body: Obx(() {
        if (!controller.patientHasAIAnalysis.value) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('AI Analysis Required', style: TextStyle(fontSize: 25, color: textColor)),
                  const Text(
                    " You need to complete the AI analysis before proceeding. Please go to your Ai Analyzer and fill out the required information.",
                  ),
                  const SizedBox(height: 16),
                  CustomElevatedButton(
                    onPressed: () {
                      controller.landingPatientController.selectedIndex.value = 2;
                    }, // Implement navigation to AI Analyzer
                    buttonText: 'Go to Ai Analyzer',
                    primaryColor: primaryColor,
                  ),
                ],
              ),
            ),
          );
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: const Text(
                  "Find Your Specialist",
                  style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor, fontSize: 20),
                ),
              ),
              // Search Bar
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  margin: EdgeInsets.zero,
                  elevation: 4,
                  shadowColor: Colors.black.withOpacity(0.08),
                  color: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  child: TextField(
                    controller: controller.name,
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        controller.fetchPsychologists(name: value, gender: controller.gender.value);
                      }
                    },
                    decoration: InputDecoration(
                      hintText: 'Search psychologist by name...',
                      hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 16),
                      border: InputBorder.none,
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: const Icon(Icons.search, color: Color(0xFF64748B), size: 28),
                      contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ),
              // Gender Filter with Obx
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    GenderFilterButton(
                      genderLabel: 'All',
                      genderValue: '',
                      selectedGender: controller.gender,
                      onGenderSelected: (gender) {
                        controller.gender.value = gender;
                        controller.fetchPsychologists(name: controller.name.text, gender: gender);
                      },
                    ),
                    const SizedBox(width: 8.0),
                    GenderFilterButton(
                      genderLabel: 'Male',
                      genderValue: 'Male',
                      selectedGender: controller.gender,
                      onGenderSelected: (gender) {
                        controller.gender.value = gender;
                        controller.fetchPsychologists(name: controller.name.text, gender: gender);
                      },
                    ),
                    const SizedBox(width: 8.0),
                    GenderFilterButton(
                      genderLabel: 'Female',
                      genderValue: 'Female',
                      selectedGender: controller.gender,
                      onGenderSelected: (gender) {
                        controller.gender.value = gender;
                        controller.fetchPsychologists(name: controller.name.text, gender: gender);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8.0),
              // List of Psychologists
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const LoadingCustom();
                  } else if (controller.psychologists.isEmpty) {
                    return const Center(child: Text("No psychologists found."));
                  } else {
                    return CustomRefreshIndicator(
                      onRefresh: () =>
                          controller.fetchPsychologists(name: controller.name.text, gender: controller.gender.value),
                      child: ListView.builder(
                        itemCount: controller.psychologists.length,
                        itemBuilder: (context, index) {
                          final psychologist = controller.psychologists[index];
                          return PsychologistCard(
                            psychologist: psychologist,
                            onTap: () {
                              // Handle onTap action here
                              Get.toNamed(Routes.DETAIL_AVAILABLE_PASIEN, arguments: psychologist.id);
                            },
                          );
                        },
                      ),
                    );
                  }
                }),
              ),
            ],
          );
        }
      }),
    );
  }
}
