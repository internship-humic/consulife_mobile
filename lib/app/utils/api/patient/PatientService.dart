import 'dart:convert';
import 'package:consulin_mobile_dev/app/models/patient/info-patient.dart';
import 'package:consulin_mobile_dev/app/models/psychologst/info-data-psychologst.dart';
import 'package:consulin_mobile_dev/app/models/user.dart';

import 'package:consulin_mobile_dev/app/utils/api/http_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../../models/patient/personalized-insight-result.dart';

import 'package:http/http.dart' as http;

class PatientService {
  Future<User> getPatientProfile() async {
    final response = await HttpService.getRequest(
      '/profile',
      includeBearer: true,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch psychologist profile');
    }

    final json = jsonDecode(response.body);

    return User.fromJson(json['data']);
  }

  Future<AppointmentPatient> getAppointmentPatient() async {
    final response = await HttpService.getRequest(
      '/patients/appointments',
      includeBearer: true,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch appointment data');
    }

    final json = jsonDecode(response.body);
    final appointmentsResponse = json['data'];

    // Mengonversi data janji temu
    final upcomingAppointments =
        (appointmentsResponse['upcoming_appointments'] as List)
            .map(
              (item) => Appointment(
                id: item['id'],
                channelId: item['channel_id'],
                date: item['date'],
                startTime: item['start_time'],
                endTime: item['end_time'],
                status: item['status'],
                user: User(
                  id: item['psychologist']['user_id'],
                  firstname: item['psychologist']['firstname'],
                  lastname: item['psychologist']['lastname'],
                ),
              ),
            )
            .toList();

    final history = (appointmentsResponse['history'] as List)
        .map(
          (item) => Appointment(
            id: item['id'],
            channelId: item['channel_id'],
            date: item['date'],
            startTime: item['start_time'],
            endTime: item['end_time'],
            status: item['status'],
            user: User(
              id: item['psychologist']['user_id'],
              firstname: item['psychologist']['firstname'],
              lastname: item['psychologist']['lastname'],
            ),
          ),
        )
        .toList();

    return AppointmentPatient(
      upcomingAppointments: upcomingAppointments,
      history: history,
    );
  }

  Future<Appointment> getAppointmentDetailPatient(String uuid) async {
    final response = await HttpService.getRequest(
      '/patients/appointments/$uuid/detail',
      includeBearer: true,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch appointment detail');
    }

    final json = jsonDecode(response.body);
    final item = json['data'];

    final detailAppointment = Appointment(
      id: item['id'],
      channelId: item['channel_id'],
      date: item['date'],
      startTime: item['start_time'],
      endTime: item['end_time'],
      duration: item['duration'],
      status: item['status'],
      note: item['note'],
      user: User(
        id: item['psychologist']['user_id'],
        firstname: item['psychologist']['firstname'],
        lastname: item['psychologist']['lastname'],
        email: item['psychologist']['email'],
        gender: item['psychologist']['gender'],
        psychologist: Psychologist(
          workExperience: item['psychologist']['work_experience'],
          specialization: List<String>.from(
            jsonDecode(item['psychologist']['specialization']),
          ),
        ),
      ),
    );

    return detailAppointment;
  }

  Future<PsychologistDataResponse> getPsychologistData({
    String name = "",
    String gender = "",
  }) async {
    const String apiUrl = '/patients/psychologists-list';

    // Menyusun URL dengan parameter query
    final Uri uri = Uri.parse(apiUrl).replace(
      queryParameters: {
        if (name.isNotEmpty) 'name': name,
        if (gender.isNotEmpty) 'gender': gender,
      },
    );

    // Menggunakan HttpService untuk melakukan GET request
    final response = await HttpService.getRequest(
      uri.toString(),
      includeBearer: true,
    );

    final json = jsonDecode(response.body);

    // Memeriksa apakah patientHasAIAnalysis tersedia di respons JSON
    final bool patientHasAIAnalysis = json['patient_has_aianalysis'] ?? false;

    // Mapping data psychologist jika ada
    final List<User> psychologists =
        (json['data'] as List<dynamic>?)?.map((item) {
          return User(
            id: item['user_id'],
            firstname: item['firstname'],
            lastname: item['lastname'],
            gender: item['gender'],
            profilePicture: item['profile_picture'],
            psychologist: Psychologist(
              id: item['id'],
              userId: item['user_id'],
              degree: item['degree'],
              specialization: item['specialization'] != null
                  ? List<String>.from(jsonDecode(item['specialization']))
                  : [],
              workExperience: item['work_experience'],
              profesionalIdentificationNumber:
                  item['profesional_identification_number'],
            ),
          );
        }).toList() ??
        [];

    return PsychologistDataResponse(
      patientHasAIAnalysis: patientHasAIAnalysis,
      psychologists: psychologists,
    );
  }

  Future<User> getDetailPsychologistPatient(String uuid) async {
    final response = await HttpService.getRequest(
      '/patients/psychologists/$uuid',
      includeBearer: true,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch psychologist data');
    }

    final json = jsonDecode(response.body);

    final item = json['data'];
    print(item);

    // Mapping data untuk user dan psikolog
    final psychologist = User(
      id: item['user_id'] ?? item['id'],
      firstname: item['user']['firstname'],
      lastname: item['user']['lastname'],
      email: item['user']['email'],
      phoneNumber: item['user']['phone_number'],
      isVerified: item['is_verified'] == 1,
      isRejected: item['is_rejected'] == 1,
      gender: item['user']['gender'],
      profilePicture: item['user']['profile_picture'],
      psychologist: Psychologist.fromJson({
        'id': item['id'],
        'user_id': item['user_id'],
        'degree': item['degree'],
        'major': item['major'],
        'university': item['university'],
        'graduation_year': item['graduation_year'],
        'language': jsonDecode(item['language']),
        'certification': jsonDecode(item['certification']),
        'specialization': jsonDecode(item['specialization']),
        'work_experience': item['work_experience'],
        'profesional_identification_number':
            item['profesional_identification_number'],
        'cv': item['cv'] != null ? jsonDecode(item['cv']) : [],
        'practice_license': item['practice_license'] != null
            ? jsonDecode(item['practice_license'])
            : [],
        'schedule': item['schedule'],
        'upcoming_schedules': json['upcoming_schedules'] ?? [],
      }),
    );

    return psychologist;
  }

  // Fungsi untuk menambahkan janji temu
  Future<Map<String, String>> addAppointment(
    String psychologistId,
    Map<String, String> data,
  ) async {
    try {
      // Menyiapkan endpoint untuk request
      final endpoint = '/patients/psychologists/$psychologistId/book';

      // Mengirimkan POST request menggunakan HttpService
      final response = await HttpService.postRequest(
        endpoint,
        body: data,
        includeBearer: true, // Include Bearer token
      );

      // Memeriksa status code response
      final responseData = jsonDecode(response.body);

      // Jika status sukses
      if (responseData['status'] == 'success') {
        // Jika perlu, lakukan revalidation atau tindakan lainnya

        return {
          'status': 'success',
          'message': 'Appointment successfully scheduled',
        };
      } else {
        return {
          'status': 'error',
          'message': responseData['message'] ?? 'Failed to add appointment.',
        };
      }
    } catch (error) {
      return {
        'status': 'error',
        'message': 'An error occurred while scheduling the appointment.',
      };
    }
  }

  // Method to fetch AI analysis history
  Future<List<AiAnalyzer>?> getHistoryAiAnalyzer() async {
    final response = await HttpService.getRequest(
      '/patients/ai-analysis-history', // API endpoint
      includeBearer: true, // Include Bearer token in the request
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch AI analysis history');
    }

    final json = jsonDecode(response.body);
    print(json);

    if (json['data'] == null || (json['data'] as List).isEmpty) {
      return null;
    }

    // Mapping data from JSON to a list of AiAnalyzer objects
    List<AiAnalyzer> analyzers = (json['data'] as List).map((item) {
      return AiAnalyzer(
        id: item['id'],
        complaint: item['complaint'],
        stress: item['stress'].toDouble(),
        anxiety: item['anxiety'].toDouble(),
        depression: item['depression'].toDouble(),
        createdAt: item['created_at'],
        updatedAt: item['updated_at'],
        patientId: item['patient_id'],
      );
    }).toList();

    return analyzers;
  }

  // Method to fetch the latest AI analysis history
  Future<AiAnalyzer?> getLatestHistoryAiAnalyzer() async {
    final response = await HttpService.getRequest(
      '/patients/ai-analysis-history', // API endpoint
      includeBearer: true, // Include Bearer token in the request
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch AI analysis history');
    }

    final json = jsonDecode(response.body);

    if (json['data'] == null || (json['data'] as List).isEmpty) {
      return null;
    }

    // Getting the latest data (first item in the list)
    final latestData = json['data'][0];

    // Mapping the latest data to an AiAnalyzer object
    final latestAnalyzer = AiAnalyzer(
      id: latestData['id'],
      complaint: latestData['complaint'],
      stress: latestData['stress'],
      anxiety: latestData['anxiety'],
      depression: latestData['depression'],
      createdAt: latestData['created_at'],
      updatedAt: latestData['updated_at'],
      patientId: latestData['patient_id'],
    );

    return latestAnalyzer;
  }

  // Fungsi untuk menganalisis AI
  Future<void> aiAnalyzer(Map<String, String> data) async {
    try {
      // Memanggil API untuk analisis AI
      final response = await HttpService.postRequest(
        '/patients/ai-analyze',
        body: data,
        includeBearer: true,
      );
      final responseJson = jsonDecode(response.body);
      print(responseJson);
      if (response.statusCode == 200) {
        if (responseJson['success'] == true) {
          return; // Tidak ada nilai yang dikembalikan, cukup selesai
        } else {
          throw Exception(responseJson['message'] ?? "AI analysis failed");
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  ///Personalized Insight Service--------------------------------------------------------------
  Future<PersonalizedInsightResult> getPersonalizedInsight() async {
    try {
      final history = await getHistoryAiAnalyzer();
      final allHistory = history ?? [];

      if (allHistory.isEmpty) {
        return PersonalizedInsightResult.empty();
      }

      final recentHistory = _getLatest3History(allHistory);

      if (recentHistory.isEmpty) {
        return PersonalizedInsightResult.empty();
      }

      // Urgent insight harus cepat dan tidak perlu menunggu AI.
      if (_hasUrgentSignal(recentHistory)) {
        return PersonalizedInsightResult.urgent();
      }

      try {
        return await _generateInsightWithGroq(recentHistory);
      } catch (aiError) {
        print('Groq failed, using local insight: $aiError');

        // Kalau provider AI gagal, tetap tampilkan insight lokal.
        return _generateLocalInsight(recentHistory);
      }
    } catch (e) {
      print('Error getPersonalizedInsight: $e');
      return PersonalizedInsightResult.error();
    }
  }

  List<AiAnalyzer> _getLatest3History(List<AiAnalyzer> histories) {
    final sorted = [...histories]
      ..sort((a, b) {
        final dateA =
            DateTime.tryParse(a.createdAt.toString()) ?? DateTime(2000);
        final dateB =
            DateTime.tryParse(b.createdAt.toString()) ?? DateTime(2000);

        return dateB.compareTo(dateA);
      });

    return sorted.take(3).toList();
  }

  bool _hasUrgentSignal(List<AiAnalyzer> histories) {
    final urgentPatterns = <RegExp>[
      RegExp(r'\bmati\b', caseSensitive: false),
      RegExp(r'\bmati saja\b', caseSensitive: false),
      RegExp(r'\bingin mati\b', caseSensitive: false),
      RegExp(r'\bmau mati\b', caseSensitive: false),
      RegExp(r'\bbunuh diri\b', caseSensitive: false),
      RegExp(r'\bmengakhiri hidup\b', caseSensitive: false),
      RegExp(r'\bself[\s-]?harm\b', caseSensitive: false),
      RegExp(r'\bsuicide\b', caseSensitive: false),
      RegExp(r'\bkill myself\b', caseSensitive: false),
      RegExp(r'\bwant to die\b', caseSensitive: false),
      RegExp(r'\bdie\b', caseSensitive: false),
      RegExp(r'\bdead\b', caseSensitive: false),
      RegExp(r'\bdeath\b', caseSensitive: false),
      RegExp(r'\bending my life\b', caseSensitive: false),
      RegExp(r'\bend my life\b', caseSensitive: false),
      RegExp(r"\bcan't go on\b", caseSensitive: false),
      RegExp(r'\bcannot go on\b', caseSensitive: false),
    ];

    for (final item in histories) {
      final complaint = item.complaint.toString();

      for (final pattern in urgentPatterns) {
        if (pattern.hasMatch(complaint)) {
          return true;
        }
      }
    }

    return false;
  }

  Future<PersonalizedInsightResult> _generateInsightWithGroq(
    List<AiAnalyzer> histories,
  ) async {
    final groqApiKey = dotenv.env["GROQ_API_KEY"]?.trim() ?? '';

    if (groqApiKey.isEmpty) {
      throw Exception('GROQ_API_KEY is empty');
    }

    final prompt = _buildInsightPrompt(histories);

    final url = Uri.parse('https://api.groq.com/openai/v1/chat/completions');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $groqApiKey',
      },
      body: jsonEncode({
        "model": "llama-3.1-8b-instant",
        "temperature": 0.2,
        "max_tokens": 250,
        "response_format": {"type": "json_object"},
        "messages": [
          {
            "role": "system",
            "content":
                "You are a supportive mental health insight assistant for a patient mobile app. Always return a valid JSON object only.",
          },
          {"role": "user", "content": prompt},
        ],
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Groq error: ${response.body}');
    }

    final decoded = jsonDecode(response.body);
    final text = decoded['choices']?[0]?['message']?['content'];

    if (text == null || text.toString().isEmpty) {
      throw Exception('AI response is empty');
    }

    final jsonResult = jsonDecode(text);

    if (jsonResult is! Map<String, dynamic>) {
      throw Exception('AI response is not a valid JSON object');
    }

    return PersonalizedInsightResult.fromJson(
      _normalizeInsightJson(jsonResult),
    );
  }

  String _buildInsightPrompt(List<AiAnalyzer> histories) {
    final data = histories.map((item) {
      return {
        "complaint": item.complaint,
        "stress": item.stress,
        "anxiety": item.anxiety,
        "depression": item.depression,
        "created_at": item.createdAt.toString(),
      };
    }).toList();

    return '''
You are a supportive mental health insight assistant for a patient mobile app.

Task:
Generate one personalized insight based on the user's latest 3 analyzer history entries.

Important rules:
- Do NOT diagnose.
- Do NOT say the user has a mental disorder.
- Do NOT use scary or clinical language.
- Use warm, short, and supportive language.
- The title must be short.
- The message must be under 30 words.
- The recommendation must be short.
- Severity must be only: low, moderate, or high.
- Do NOT return urgent. Urgent handling is already handled outside the AI flow.
- Return ONLY valid JSON.

Output JSON format:
{
  "title": "...",
  "message": "...",
  "recommendation": "...",
  "severity": "low | moderate | high"
}

Analyzer history:
${jsonEncode(data)}
''';
  }

  Map<String, dynamic> _normalizeInsightJson(Map<String, dynamic> json) {
    return {
      'title': (json['title'] ?? '').toString().trim().isEmpty
          ? 'Personalized Insight'
          : json['title'],
      'message': (json['message'] ?? '').toString().trim().isEmpty
          ? 'Take a moment to check in with yourself today.'
          : json['message'],
      'recommendation': (json['recommendation'] ?? '').toString().trim().isEmpty
          ? 'Keep Monitoring'
          : json['recommendation'],
      'severity': _normalizeSeverity(json['severity']),
    };
  }

  String _normalizeSeverity(dynamic severity) {
    final value = severity?.toString().toLowerCase().trim() ?? '';

    switch (value) {
      case 'low':
      case 'moderate':
      case 'high':
        return value;
      default:
        return 'moderate';
    }
  }

  PersonalizedInsightResult _generateLocalInsight(List<AiAnalyzer> histories) {
    if (histories.isEmpty) {
      return PersonalizedInsightResult.empty();
    }

    final avgStress =
        histories.map((e) => e.stress).reduce((a, b) => a + b) /
        histories.length;
    final avgAnxiety =
        histories.map((e) => e.anxiety).reduce((a, b) => a + b) /
        histories.length;
    final avgDepression =
        histories.map((e) => e.depression).reduce((a, b) => a + b) /
        histories.length;

    final highestScore = {
      'stress': avgStress,
      'anxiety': avgAnxiety,
      'depression': avgDepression,
    }.entries.reduce((a, b) => a.value >= b.value ? a : b);

    final dominant = highestScore.key;
    final score = highestScore.value;

    if (score >= 70) {
      return PersonalizedInsightResult(
        title: '${_capitalize(dominant)} Trend Detected',
        message:
            'Your recent analyzer results show elevated $dominant levels. Consider taking time to rest and seek support if needed.',
        recommendation: 'Consult a Psychologist',
        severity: 'high',
      );
    }

    if (score >= 50) {
      return PersonalizedInsightResult(
        title: '${_capitalize(dominant)} Needs Attention',
        message:
            'Your recent results show moderate $dominant signals. A short break or mindful activity may help.',
        recommendation: 'Practice Mindful Rest',
        severity: 'moderate',
      );
    }

    return PersonalizedInsightResult(
      title: 'Stable Recent Pattern',
      message:
          'Your recent analyzer results look relatively stable. Keep monitoring your emotional condition regularly.',
      recommendation: 'Keep Monitoring',
      severity: 'low',
    );
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  ///-----------------------------------------------------------------------------------------
}
