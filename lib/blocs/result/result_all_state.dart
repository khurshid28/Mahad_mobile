abstract class ResultAllState {}

class ResultAllIntialState extends ResultAllState {}

class ResultAllWaitingState extends ResultAllState {}

class ResultAllSuccessState extends ResultAllState {
  final List data;
  ResultAllSuccessState({required this.data});
}

class ResultAllErrorState extends ResultAllState {
  String? title;
  String? message;
  int? statusCode;
  ResultAllErrorState({required this.message, required this.title,required this.statusCode});
}
