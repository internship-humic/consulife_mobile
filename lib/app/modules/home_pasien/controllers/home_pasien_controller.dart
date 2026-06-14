import 'package:consulin_mobile_dev/app/models/patient/info-patient.dart';
import 'package:consulin_mobile_dev/app/modules/ai_analyzer_pasien/controllers/ai_analyzer_pasien_controller.dart';
import 'package:consulin_mobile_dev/app/modules/profile_pasien/controllers/profile_pasien_controller.dart';
import 'package:consulin_mobile_dev/app/utils/api/patient/PatientService.dart';

import 'package:get/get.dart';

import '../../../models/patient/personalized-insight-result.dart';

class HomePasienController extends GetxController {
  // Observable for loading state
  final isLoading = false.obs;
  final ProfilePasienController profilePasienController = Get.find<ProfilePasienController>();
  final AiAnalyzerPasienController aiAnalyzerPasienController = Get.find<AiAnalyzerPasienController>();

  final isInsightLoading = false.obs;
  final personalizedInsight = PersonalizedInsightResult.empty().obs;

  // Observable for appointment data
  var appointmentData = AppointmentPatient(upcomingAppointments: [], history: []).obs;

  // Observable for statistics
  var probabilityOfStress = 65.0.obs;
  var probabilityOfAnxiety = 40.0.obs;
  var probabilityOfDepression = 70.0.obs;

  @override
  void onInit() async {
    super.onInit();
    await fetchAppointments();
    await fetchPersonalizedInsight();
  }

  // Method to fetch appointment data
  Future<void> fetchAppointments() async {
    try {
      isLoading.value = true; // Set loading to true
      // Fetch appointment data
      appointmentData.value = await PatientService().getAppointmentPatient();

      // Limit the data to only the first 5 upcoming and history appointments
      appointmentData.value.upcomingAppointments = appointmentData.value.upcomingAppointments.take(5).toList();
      appointmentData.value.history = appointmentData.value.history.take(5).toList();
    } catch (e) {
      // Handle any errors that occur during the fetch
      print('Error fetching appointment data: $e');
    } finally {
      isLoading.value = false; // Set loading to false
    }
  }

  Future<void> fetchPersonalizedInsight() async {
    try {
      isInsightLoading.value = true;

      personalizedInsight.value = await PatientService().getPersonalizedInsight();
    } catch (e) {
      print('Error fetching personalized insight: $e');
      personalizedInsight.value = PersonalizedInsightResult.error();
    } finally {
      isInsightLoading.value = false;
    }
  }
}
