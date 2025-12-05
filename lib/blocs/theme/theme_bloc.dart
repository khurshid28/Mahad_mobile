import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/service/storage_service.dart';

// Events
abstract class ThemeEvent {}

class LoadTheme extends ThemeEvent {}

class ToggleTheme extends ThemeEvent {
  final bool isDark;
  ToggleTheme(this.isDark);
}

// States
abstract class ThemeState {
  final ThemeMode themeMode;
  ThemeState(this.themeMode);
}

class ThemeInitial extends ThemeState {
  ThemeInitial() : super(ThemeMode.light);
}

class ThemeLoaded extends ThemeState {
  ThemeLoaded(super.themeMode);
}

// BLoC
class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeInitial()) {
    on<LoadTheme>(_onLoadTheme);
    on<ToggleTheme>(_onToggleTheme);
  }

  Future<void> _onLoadTheme(
    LoadTheme event,
    Emitter<ThemeState> emit,
  ) async {
    final savedTheme = StorageService().read('theme_mode');
    final themeMode = savedTheme == 'dark' ? ThemeMode.dark : ThemeMode.light;
    emit(ThemeLoaded(themeMode));
  }

  Future<void> _onToggleTheme(
    ToggleTheme event,
    Emitter<ThemeState> emit,
  ) async {
    final themeMode = event.isDark ? ThemeMode.dark : ThemeMode.light;
    await StorageService().write('theme_mode', event.isDark ? 'dark' : 'light');
    emit(ThemeLoaded(themeMode));
  }
}
