abstract class RandomTestState {}

class RandomTestIntialState extends RandomTestState {}

class RandomTestWaitingState extends RandomTestState {}

class RandomTestSuccessState extends RandomTestState {
  final List data;
  final String id;
  RandomTestSuccessState({required this.data,required this.id});
}

class RandomTestErrorState extends RandomTestState {
  String? title;
  String? message;
  int? statusCode;
  RandomTestErrorState({required this.message, required this.title,required this.statusCode});
}
