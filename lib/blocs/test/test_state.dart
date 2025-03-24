abstract class TestState {}

class TestIntialState extends TestState {}

class TestWaitingState extends TestState {}

class TestSuccessState extends TestState {
  final  data;
  TestSuccessState({required this.data});
}

class TestErrorState extends TestState {
  String? title;
  String? message;
  int? statusCode;
  TestErrorState({required this.message, required this.title,required this.statusCode});
}
