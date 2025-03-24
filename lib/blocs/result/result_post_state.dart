abstract class ResultPostState {}

class ResultPostIntialState extends ResultPostState {}

class ResultPostWaitingState extends ResultPostState {}

class ResultPostSuccessState extends ResultPostState {
  final  data;
  ResultPostSuccessState({required this.data});
}

class ResultPostErrorState extends ResultPostState {
  String? title;
  String? message;
  int? statusCode;
  ResultPostErrorState({required this.message, required this.title,required this.statusCode});
}
