abstract class SubjectAllState {}

class SubjectAllIntialState extends SubjectAllState {}

class SubjectAllWaitingState extends SubjectAllState {}

class SubjectAllSuccessState extends SubjectAllState {
  final List data;
  SubjectAllSuccessState({required this.data});
}

class SubjectAllErrorState extends SubjectAllState {
  String? title;
  String? message;
  int? statusCode;
  SubjectAllErrorState({required this.message, required this.title,required this.statusCode});
}
