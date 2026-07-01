class PersonalizedInsightResult {
  final String title;
  final String message;
  final String recommendation;
  final String severity;

  PersonalizedInsightResult({
    required this.title,
    required this.message,
    required this.recommendation,
    required this.severity,
  });

  factory PersonalizedInsightResult.fromJson(Map<String, dynamic> json) {
    return PersonalizedInsightResult(
      title: json['title'] ?? 'Personalized Insight',
      message: json['message'] ?? 'No insight available yet.',
      recommendation: json['recommendation'] ?? 'Keep Monitoring',
      severity: json['severity'] ?? 'moderate',
    );
  }

  factory PersonalizedInsightResult.empty() {
    return PersonalizedInsightResult(
      title: 'No Recent Insight',
      message: 'There is not enough recent analyzer data from the last 3 days.',
      recommendation: 'Complete Analyzer',
      severity: 'low',
    );
  }

  factory PersonalizedInsightResult.urgent() {
    return PersonalizedInsightResult(
      title: 'Urgent Support Recommended',
      message:
          'Your recent analyzer history contains sensitive distress signals. Please contact someone you trust or a professional now.',
      recommendation: 'Seek Immediate Support',
      severity: 'urgent',
    );
  }

  factory PersonalizedInsightResult.error() {
    return PersonalizedInsightResult(
      title: 'Insight Unavailable',
      message: 'We could not generate your personalized insight right now.',
      recommendation: 'Try Again',
      severity: 'moderate',
    );
  }
}
