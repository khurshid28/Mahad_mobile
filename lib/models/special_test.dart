class SpecialTest {
  final int id;
  final String name;
  final String? description;
  final int subjectId;
  final int? bookId;
  final String? activationStart;
  final String? activationEnd;
  final int? timePerQuestion;
  final int? totalTime;
  final int questionCount;
  final List<int> sectionIds;
  final List<int> groupIds;
  final List<SpecialTestQuestion> questions;
  final String? createdAt;
  final String? updatedAt;
  final bool? hasAttempted;

  SpecialTest({
    required this.id,
    required this.name,
    this.description,
    required this.subjectId,
    this.bookId,
    this.activationStart,
    this.activationEnd,
    this.timePerQuestion,
    this.totalTime,
    required this.questionCount,
    required this.sectionIds,
    required this.groupIds,
    required this.questions,
    this.createdAt,
    this.updatedAt,
    this.hasAttempted,
  });

  factory SpecialTest.fromJson(Map<String, dynamic> json) {
    print('🟡 [Model] Parsing SpecialTest from JSON...');
    print('🟡 [Model] JSON keys: ${json.keys.toList()}');
    try {
      final test = SpecialTest(
        id: json['id'] ?? 0,
        name: json['name'] ?? '',
        description: json['description'],
        subjectId: json['subject_id'] ?? 0,
        bookId: json['book_id'],
        activationStart: json['activation_start'],
        activationEnd: json['activation_end'],
        timePerQuestion: json['time_per_question'],
        totalTime: json['total_time'],
        questionCount: json['question_count'] ?? 0,
        sectionIds: List<int>.from(json['section_ids'] ?? []),
        groupIds: List<int>.from(json['group_ids'] ?? []),
        questions:
            (json['questions'] as List?)
                ?.map((q) => SpecialTestQuestion.fromJson(q))
                .toList() ??
            [],
        createdAt: json['createdAt'],
        updatedAt: json['updatedAt'],
        hasAttempted: json['has_attempted'],
      );
      print(
        '🟢 [Model] Successfully parsed: ${test.name} (${test.questions.length} questions)',
      );
      return test;
    } catch (e, stack) {
      print('🔴 [Model] Parse error: $e');
      print('🔴 [Model] Stack: $stack');
      rethrow;
    }
  }

  bool get isActive {
    if (activationStart == null || activationEnd == null) return true;
    final now = DateTime.now();
    final start = DateTime.parse(activationStart!);
    final end = DateTime.parse(activationEnd!).add(const Duration(days: 1));
    return now.isAfter(start) && now.isBefore(end);
  }

  int? get timeInSeconds {
    // If totalTime is set and > 0, use it (assume it's in seconds)
    if (totalTime != null && totalTime! > 0) {
      return totalTime;
    }

    // If timePerQuestion is set, calculate total time (time_per_question is already in seconds)
    if (timePerQuestion != null && timePerQuestion! > 0) {
      return timePerQuestion! * questionCount; // seconds * count
    }

    // No time limit
    return null;
  }
}

class SpecialTestQuestion {
  final int id;
  final int number;
  final String question;
  final String answerA;
  final String answerB;
  final String? answerC;
  final String? answerD;
  final String answer;

  SpecialTestQuestion({
    required this.id,
    required this.number,
    required this.question,
    required this.answerA,
    required this.answerB,
    this.answerC,
    this.answerD,
    required this.answer,
  });

  factory SpecialTestQuestion.fromJson(Map<String, dynamic> json) {
    return SpecialTestQuestion(
      id: json['id'] ?? 0,
      number: json['number'] ?? 0,
      question: json['question'] ?? '',
      answerA: json['answer_A'] ?? '',
      answerB: json['answer_B'] ?? '',
      answerC: json['answer_C'],
      answerD: json['answer_D'],
      answer: json['answer'] ?? '',
    );
  }

  List<String> get options {
    final opts = [answerA, answerB];
    if (answerC != null && answerC!.isNotEmpty) opts.add(answerC!);
    if (answerD != null && answerD!.isNotEmpty) opts.add(answerD!);
    return opts;
  }
}

class SpecialTestResult {
  final String message;
  final int resultId;
  final int? solved;
  final int? total;

  SpecialTestResult({
    required this.message,
    required this.resultId,
    this.solved,
    this.total,
  });

  factory SpecialTestResult.fromJson(Map<String, dynamic> json) {
    return SpecialTestResult(
      message: json['message'] ?? '',
      resultId: json['result_id'] ?? 0,
      solved: json['solved'],
      total: json['total'],
    );
  }
}
