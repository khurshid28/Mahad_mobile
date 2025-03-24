abstract class SectionAllState {}

class SectionAllIntialState extends SectionAllState {}

class SectionAllWaitingState extends SectionAllState {}

class SectionAllSuccessState extends SectionAllState {
  final List data;
  SectionAllSuccessState({required this.data});
}

class SectionAllErrorState extends SectionAllState {
  String? title;
  String? message;
  int? statusCode;
  SectionAllErrorState({required this.message, required this.title,required this.statusCode});
}
