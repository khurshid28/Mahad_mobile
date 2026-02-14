import 'package:test_app/models/device_model.dart';

abstract class DeviceState {}

class DeviceInitialState extends DeviceState {}

class DeviceLoadingState extends DeviceState {}

class DeviceLoadedState extends DeviceState {
  final DeviceModel device;
  DeviceLoadedState({required this.device});
}

class DeviceErrorState extends DeviceState {
  final String message;
  DeviceErrorState({required this.message});
}
