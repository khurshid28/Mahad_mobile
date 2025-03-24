abstract class SectionState {}

class SectionIntialState extends SectionState {}

class SectionWaitingState extends SectionState {}

class SectionSuccessState extends SectionState {
  final  data;
  SectionSuccessState({required this.data});
}

class SectionErrorState extends SectionState {
  String? title;
  String? message;
  int? statusCode;
  SectionErrorState({required this.message, required this.title,required this.statusCode});
}
