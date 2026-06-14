import 'package:consulin_mobile_dev/widgets/ui/column_chart_analysis.dart';
import 'package:consulin_mobile_dev/widgets/ui/loading_custom.dart';
import 'package:consulin_mobile_dev/widgets/ui/refresh_custom.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:consulin_mobile_dev/app/constants/color.dart';
import '../controllers/ai_analyzer_pasien_controller.dart';
import 'package:consulin_mobile_dev/widgets/ui/custom_elevated_button.dart';
import 'package:consulin_mobile_dev/app/routes/app_pages.dart';

import '../widget/speech_listening_dialog.dart';

class AiAnalyzerPasienView extends GetView<AiAnalyzerPasienController> {
  const AiAnalyzerPasienView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          return controller.isLoading.value
              ? const LoadingCustom()
              : CustomRefreshIndicator(
                  onRefresh: () async {
                    await controller.fetchLatestAiAnalyzer();
                  },
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16),
                          Card(
                            color: carddetail,
                            elevation: 4,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Health Mental Analyzer',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: textColor),
                                  ),
                                  const SizedBox(height: 16),
                                  Form(
                                    key: controller.formKey,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        TextFormField(
                                          controller: controller.textController,
                                          autovalidateMode: AutovalidateMode.onUserInteraction,
                                          maxLines: 20,
                                          minLines: 15,
                                          keyboardType: TextInputType.multiline,
                                          decoration: InputDecoration(
                                            fillColor: Colors.white,
                                            filled: true,
                                            hintText: 'Tell us about your current mental state...',
                                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                          ),
                                          scrollPadding: const EdgeInsets.all(16.0),
                                          scrollPhysics: const BouncingScrollPhysics(),
                                          validator: (value) => value != null && value.length < 10
                                              ? 'Field must contain at least 10 characters'
                                              : null,
                                        ),
                                        const SizedBox(height: 16),
                                        Row(
                                          children: [
                                            ElevatedButton(
                                              onPressed: controller.analyze,
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: textColor,
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                              ),
                                              child: const Text('Analyze', style: TextStyle(color: Colors.white)),
                                            ),
                                            SizedBox(width: 12),
                                            ElevatedButton(
                                              onPressed: () async {
                                                final started = await controller.startVoiceInput();

                                                if (started) {
                                                  Get.dialog(
                                                    SpeechListeningDialog(controller: controller),
                                                    barrierDismissible: false,
                                                  );
                                                }
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: textColor,
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                              ),
                                              child: const Icon(Icons.mic, color: Colors.white, size: 25),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 20),
                                        const ColumnChartAnalysis(),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('Probability of Stress: ${controller.stressProbability.value}%'),
                                            Text('Probability of Anxiety: ${controller.anxietyProbability.value}%'),
                                            Text('Probability of Depression: ${controller.depressionProbability.value}%'),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              CustomElevatedButton(
                                primaryColor: primaryColor,
                                onPressed: () {
                                  Get.toNamed(Routes.ANALYZER_HISTORY_PASIEN);
                                },
                                buttonText: "Analyzer History",
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
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
