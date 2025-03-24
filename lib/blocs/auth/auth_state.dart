abstract class AuthState {}

class AuthIntialState extends AuthState {}

class AuthWaitingState extends AuthState {}

class AuthSuccessState extends AuthState {
  final user;
  final String? access_token;
  final String? message;
  AuthSuccessState({required this.user,required this.access_token,required this.message});
}

class AuthErrorState extends AuthState {
  String? title;
  String? message;
  int? statusCode;
  AuthErrorState({required this.message, required this.title,required this.statusCode});
}
