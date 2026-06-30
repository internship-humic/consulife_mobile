import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/ai_analyzer_pasien_controller.dart';

class SpeechListeningDialog extends StatelessWidget {
  final AiAnalyzerPasienController controller;

  const SpeechListeningDialog({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 28),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
        side: const BorderSide(color: Color(0xFF8E24AA), width: 1.2),
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: AlignmentDirectional.topStart,
              child: IconButton(
                onPressed: () async {
                  await controller.stopVoiceInput();
                },
                icon: const Icon(Icons.close, color: Colors.black, size: 28),
              ),
            ),
            const Icon(Icons.graphic_eq_rounded, color: Color(0xFF234A76), size: 96),
            const SizedBox(height: 12),
            Obx(
              () => Text(
                controller.isListening.value ? 'Mendengarkan..' : 'Memproses..',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.black),
              ),
            ),
            const SizedBox(height: 8),
            Obx(
              () => Text(
                controller.recognizedWords.value.isEmpty
                    ? controller.speechStatusText.value
                    : controller.recognizedWords.value,
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 15, color: Colors.black),
              ),
            ),
            const SizedBox(height: 22),
            Obx(
              () => InkWell(
                onTap: () async {
                  await controller.stopVoiceInput();
                },
                borderRadius: BorderRadius.circular(40),
                child: CircleAvatar(
                  radius: 28,
                  backgroundColor: controller.isListening.value ? const Color(0xFF234A76) : Colors.grey,
                  child: const Icon(Icons.mic, color: Colors.white, size: 30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
