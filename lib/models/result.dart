class Result {
  final DateTime date;
  final int? solved;
  bool finished;
  String? type;
  final test;
  final List<dynamic>? answers;
  
  Result({
    required this.date, 
    this.solved,
    this.finished = true,
    required this.test,
    this.type,
    this.answers,
  });
}
