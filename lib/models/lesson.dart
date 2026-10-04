class CaseStudy {
  final String company;
  final String situation;
  final String problem;
  final String approach;
  final String outcome;
  final String lessonLearned;

  const CaseStudy({
    required this.company,
    required this.situation,
    required this.problem,
    required this.approach,
    required this.outcome,
    required this.lessonLearned,
  });

  Map<String, dynamic> toJson() => {
    'company': company,
    'situation': situation,
    'problem': problem,
    'approach': approach,
    'outcome': outcome,
    'lessonLearned': lessonLearned,
  };

  factory CaseStudy.fromJson(Map<String, dynamic> json) {
    return CaseStudy(
      company: json['company'] as String? ?? '',
      situation: json['situation'] as String? ?? '',
      problem: json['problem'] as String? ?? '',
      approach: json['approach'] as String? ?? '',
      outcome: json['outcome'] as String? ?? '',
      lessonLearned: json['lessonLearned'] as String? ?? '',
    );
  }
}

class Lesson {
  final String id;
  final String title;
  final int estimatedMinutes;
  final String conceptExplanation;
  final List<String> keyPoints;
  final String? codeExample;
  final CaseStudy caseStudy;
  final List<String> keyTakeaways;

  const Lesson({
    required this.id,
    required this.title,
    required this.estimatedMinutes,
    required this.conceptExplanation,
    required this.keyPoints,
    this.codeExample,
    required this.caseStudy,
    required this.keyTakeaways,
  });
}
