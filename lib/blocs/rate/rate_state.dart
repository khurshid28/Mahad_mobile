abstract class RateState {}

class RateIntialState extends RateState {}

class RateWaitingState extends RateState {}

class RateSuccessState extends RateState {
  final List  data;
  RateSuccessState({required this.data});
}

class RateErrorState extends RateState {
  String? title;
  String? message;
  int? statusCode;
  RateErrorState({required this.message, required this.title,required this.statusCode});
}
