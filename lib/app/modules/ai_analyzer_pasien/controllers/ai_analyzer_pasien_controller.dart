import 'package:consulin_mobile_dev/app/models/psychologst/info-data-psychologst.dart';
import 'package:consulin_mobile_dev/app/modules/psycholog/controllers/psycholog_controller.dart';
import 'package:consulin_mobile_dev/app/utils/api/patient/PatientService.dart';
import 'package:consulin_mobile_dev/app/utils/helpers/toast_helper.dart';
import 'package:consulin_mobile_dev/widgets/ui/loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class AiAnalyzerPasienController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final textController = TextEditingController();
  final isLoading = false.obs;

  final stressProbability = 0.0.obs;
  final anxietyProbability = 0.0.obs;
  final depressionProbability = 0.0.obs;

  final aiHistory = <AiAnalyzer>[].obs;
  final PsychologController psychologController = Get.find<PsychologController>();

  // Voice to text
  final stt.SpeechToText speechToText = stt.SpeechToText();

  String _committedTranscript = '';
  String _lastPartialTranscript = '';

  final recognizedWords = ''.obs;
  final isListening = false.obs;
  final isSpeechAvailable = false.obs;
  final speechStatusText = 'Bicara sekarang'.obs;

  @override
  void onInit() {
    super.onInit();
    initSpeech();
    fetchLatestAiAnalyzer();
  }

  @override
  void onClose() {
    speechToText.cancel();
    textController.dispose();
    super.onClose();
  }

  Future<void> initSpeech() async {
    try {
      final available = await speechToText.initialize(
        onStatus: _onSpeechStatus,
        onError: (error) {
          isListening.value = false;
          speechStatusText.value = 'Gagal mengenali suara';

          ToastHelper.show(
            message: 'Voice recognition error: ${error.errorMsg}',
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 14.0,
          );

          Future.delayed(const Duration(milliseconds: 500), () {
            _closeSpeechDialogIfOpen();
          });
        },
      );

      isSpeechAvailable.value = available;
    } catch (e) {
      isSpeechAvailable.value = false;

      ToastHelper.show(
        message: 'Speech recognition tidak tersedia di device ini',
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 14.0,
      );
    }
  }

  Future<bool> startVoiceInput() async {
    if (isListening.value) {
      await stopVoiceInput();
      return false;
    }

    if (!isSpeechAvailable.value) {
      await initSpeech();
    }

    if (!isSpeechAvailable.value) {
      ToastHelper.show(
        message: 'Speech recognition tidak tersedia atau permission microphone ditolak',
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 14.0,
      );
      return false;
    }

    // Clear dulu sesuai kebutuhan kamu
    textController.clear();

    _committedTranscript = '';
    _lastPartialTranscript = '';
    recognizedWords.value = '';
    speechStatusText.value = 'Bicara sekarang';
    isListening.value = true;

    await speechToText.listen(
      onResult: _onSpeechResult,
      listenFor: const Duration(minutes: 5),
      pauseFor: const Duration(seconds: 6),
      partialResults: true,
      cancelOnError: false,
      listenMode: stt.ListenMode.dictation,
    );

    return true;
  }

  Future<void> stopVoiceInput() async {
    if (_lastPartialTranscript.isNotEmpty) {
      _commitTranscript(_lastPartialTranscript);
      _lastPartialTranscript = '';
    }

    if (speechToText.isListening) {
      await speechToText.stop();
    }

    isListening.value = false;
    speechStatusText.value = 'Selesai';

    recognizedWords.value = _committedTranscript;
    textController.text = _committedTranscript;

    textController.selection = TextSelection.fromPosition(TextPosition(offset: textController.text.length));

    Future.delayed(const Duration(milliseconds: 300), () {
      _closeSpeechDialogIfOpen();
    });
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    final currentPartial = result.recognizedWords.trim();

    if (currentPartial.isEmpty) return;

    /*
    Kalau recognizer tiba-tiba mengganti partial lama dengan kalimat baru,
    kita commit partial sebelumnya supaya tidak hilang.
  */
    if (_lastPartialTranscript.isNotEmpty &&
        currentPartial != _lastPartialTranscript &&
        !_isSimilarOrExtended(_lastPartialTranscript, currentPartial)) {
      _commitTranscript(_lastPartialTranscript);
    }

    _lastPartialTranscript = currentPartial;

    final combinedText = _combineTranscript(_committedTranscript, currentPartial);

    recognizedWords.value = combinedText;
    textController.text = combinedText;

    textController.selection = TextSelection.fromPosition(TextPosition(offset: textController.text.length));

    if (result.finalResult) {
      _commitTranscript(currentPartial);
      _lastPartialTranscript = '';

      recognizedWords.value = _committedTranscript;
      textController.text = _committedTranscript;

      textController.selection = TextSelection.fromPosition(TextPosition(offset: textController.text.length));
    }
  }

  void _onSpeechStatus(String status) {
    if (status == 'listening') {
      isListening.value = true;
      speechStatusText.value = 'Bicara sekarang';
    }

    if (status == 'done' || status == 'notListening') {
      isListening.value = false;
      speechStatusText.value = 'Selesai';

      Future.delayed(const Duration(milliseconds: 500), () {
        _closeSpeechDialogIfOpen();
      });
    }
  }

  void _closeSpeechDialogIfOpen() {
    if (Get.isDialogOpen == true) {
      Get.back();
    }
  }

  Future<void> fetchLatestAiAnalyzer() async {
    try {
      isLoading.value = true;
      final latest = await PatientService().getLatestHistoryAiAnalyzer();

      if (latest != null) {
        stressProbability.value = latest.stress;
        anxietyProbability.value = latest.anxiety;
        depressionProbability.value = latest.depression;
        textController.text = latest.complaint;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch the latest AI analysis');
    } finally {
      isLoading.value = false;
    }
  }

  void analyze() async {
    if (formKey.currentState!.validate()) {
      LoadingDialog.show(Get.context!);
      isLoading.value = true;

      Map<String, String> data = {'text': textController.text};

      try {
        await PatientService().aiAnalyzer(data);

        await fetchLatestAiAnalyzer();

        if (!psychologController.patientHasAIAnalysis.value) {
          await psychologController.fetchPsychologists();
        }

        ToastHelper.show(
          message: "AI analysis successful",
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } catch (e) {
        ToastHelper.show(message: e.toString(), backgroundColor: Colors.red, textColor: Colors.white, fontSize: 16.0);
      } finally {
        LoadingDialog.hide(Get.context!);
        isLoading.value = false;
      }
    }
  }

  bool _isSimilarOrExtended(String oldText, String newText) {
    final oldLower = oldText.toLowerCase();
    final newLower = newText.toLowerCase();

    return newLower.contains(oldLower) || oldLower.contains(newLower);
  }

  void _commitTranscript(String text) {
    final cleanText = text.trim();

    if (cleanText.isEmpty) return;

    if (_committedTranscript.isEmpty) {
      _committedTranscript = cleanText;
      return;
    }

    final committedLower = _committedTranscript.toLowerCase();
    final cleanLower = cleanText.toLowerCase();

    if (!committedLower.contains(cleanLower)) {
      _committedTranscript = '$_committedTranscript $cleanText'.trim();
    }
  }

  String _combineTranscript(String committed, String partial) {
    final committedClean = committed.trim();
    final partialClean = partial.trim();

    if (committedClean.isEmpty) return partialClean;
    if (partialClean.isEmpty) return committedClean;

    if (committedClean.toLowerCase().contains(partialClean.toLowerCase())) {
      return committedClean;
    }

    return '$committedClean $partialClean'.trim();
  }
}
