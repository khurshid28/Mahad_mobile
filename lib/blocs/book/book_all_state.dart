abstract class BookAllState {}

class BookAllIntialState extends BookAllState {}

class BookAllWaitingState extends BookAllState {}

class BookAllSuccessState extends BookAllState {
  final List data;
  BookAllSuccessState({required this.data});
}

class BookAllErrorState extends BookAllState {
  String? title;
  String? message;
  int? statusCode;
  BookAllErrorState({required this.message, required this.title,required this.statusCode});
}
