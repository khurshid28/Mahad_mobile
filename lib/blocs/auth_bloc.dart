import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:test_app/blocs/auth_state.dart';

part 'auth_event.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<LoginEvent>((event, emit) {
      emit(AuthLoading());
      Future.delayed(const Duration(seconds: 2), () {
        if (event.phone == "950642827" && event.password == "123456") {
          emit(AuthSuccess());
        } else {
          emit(AuthFailure("""
            The phone number or password you entered is incorrect.
            Please try again.
          """));
        }
      });
    });
  }
}
