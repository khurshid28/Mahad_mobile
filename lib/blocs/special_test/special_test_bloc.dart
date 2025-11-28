import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/controller/special_test_controller.dart';
import 'package:test_app/models/special_test.dart';

// Events
abstract class SpecialTestEvent {}

class LoadSpecialTests extends SpecialTestEvent {}

class LoadSpecialTest extends SpecialTestEvent {
  final int testId;
  LoadSpecialTest(this.testId);
}

class SubmitSpecialTest extends SpecialTestEvent {
  final int testId;
  final Map<String, String> answers;
  SubmitSpecialTest(this.testId, this.answers);
}

class CheckTestAvailability extends SpecialTestEvent {
  final int testId;
  final int studentId;
  CheckTestAvailability(this.testId, this.studentId);
}

// States
abstract class SpecialTestState {}

class SpecialTestInitial extends SpecialTestState {}

class SpecialTestLoading extends SpecialTestState {}

class SpecialTestsLoaded extends SpecialTestState {
  final List<SpecialTest> tests;
  SpecialTestsLoaded(this.tests);
}

class SpecialTestLoaded extends SpecialTestState {
  final SpecialTest test;
  final bool hasAttempted;
  SpecialTestLoaded(this.test, {this.hasAttempted = false});
}

class SpecialTestSubmitting extends SpecialTestState {}

class SpecialTestSubmitted extends SpecialTestState {
  final SpecialTestResult result;
  SpecialTestSubmitted(this.result);
}

class SpecialTestError extends SpecialTestState {
  final String message;
  SpecialTestError(this.message);
}

// BLoC
class SpecialTestBloc extends Bloc<SpecialTestEvent, SpecialTestState> {
  final SpecialTestRepository _repository = SpecialTestRepository();

  SpecialTestBloc() : super(SpecialTestInitial()) {
    on<LoadSpecialTests>(_onLoadSpecialTests);
    on<LoadSpecialTest>(_onLoadSpecialTest);
    on<SubmitSpecialTest>(_onSubmitSpecialTest);
    on<CheckTestAvailability>(_onCheckTestAvailability);
  }

  Future<void> _onLoadSpecialTests(
    LoadSpecialTests event,
    Emitter<SpecialTestState> emit,
  ) async {
    print('🟡 [SpecialTestBloc] LoadSpecialTests started');
    emit(SpecialTestLoading());
    try {
      print('🟡 [SpecialTestBloc] Calling repository...');
      final tests = await _repository.getAllSpecialTests();
      print('🟢 [SpecialTestBloc] Got ${tests.length} tests');
      if (tests.isNotEmpty) {
        print('🟢 [SpecialTestBloc] First test: ${tests[0].name} (ID: ${tests[0].id})');
        print('🟢 [SpecialTestBloc] Questions: ${tests[0].questions.length}');
      }
      emit(SpecialTestsLoaded(tests));
    } catch (e) {
      print('🔴 [SpecialTestBloc] Error: $e');
      emit(SpecialTestError(e.toString()));
    }
  }

  Future<void> _onLoadSpecialTest(
    LoadSpecialTest event,
    Emitter<SpecialTestState> emit,
  ) async {
    print('🟡 [SpecialTestBloc] LoadSpecialTest started for test ${event.testId}');
    emit(SpecialTestLoading());
    try {
      print('🟡 [SpecialTestBloc] Getting test details...');
      final test = await _repository.getSpecialTest(event.testId);
      print('🟢 [SpecialTestBloc] Got test: ${test.name}, questions: ${test.questions.length}');
      emit(SpecialTestLoaded(test));
      print('🟢 [SpecialTestBloc] Emitted SpecialTestLoaded state');
    } catch (e, stack) {
      print('🔴 [SpecialTestBloc] LoadSpecialTest error: $e');
      print('🔴 [SpecialTestBloc] Stack: $stack');
      emit(SpecialTestError(e.toString()));
    }
  }

  Future<void> _onSubmitSpecialTest(
    SubmitSpecialTest event,
    Emitter<SpecialTestState> emit,
  ) async {
    print('🟡 [SpecialTestBloc] SubmitSpecialTest started for test ${event.testId}');
    print('🟡 [SpecialTestBloc] Answers count: ${event.answers.length}');
    emit(SpecialTestSubmitting());
    try {
      final result = await _repository.submitTest(event.testId, event.answers);
      print('🟢 [SpecialTestBloc] Test submitted successfully: ${result.message}');
      emit(SpecialTestSubmitted(result));
    } catch (e, stack) {
      print('🔴 [SpecialTestBloc] Submit error: $e');
      print('🔴 [SpecialTestBloc] Stack: $stack');
      emit(SpecialTestError(e.toString()));
    }
  }

  Future<void> _onCheckTestAvailability(
    CheckTestAvailability event,
    Emitter<SpecialTestState> emit,
  ) async {
    print('🟡 [SpecialTestBloc] CheckTestAvailability started for test ${event.testId}, student ${event.studentId}');
    emit(SpecialTestLoading());
    try {
      print('🟡 [SpecialTestBloc] Getting test details...');
      final test = await _repository.getSpecialTest(event.testId);
      print('🟢 [SpecialTestBloc] Got test: ${test.name}');
      
      print('🟡 [SpecialTestBloc] Checking if student has attempted...');
      final hasAttempted =
          await _repository.hasStudentTakenTest(event.testId, event.studentId);
      print('🟢 [SpecialTestBloc] hasAttempted: $hasAttempted');
      
      emit(SpecialTestLoaded(test, hasAttempted: hasAttempted));
      print('🟢 [SpecialTestBloc] Emitted SpecialTestLoaded state');
    } catch (e, stack) {
      print('🔴 [SpecialTestBloc] CheckTestAvailability error: $e');
      print('🔴 [SpecialTestBloc] Stack: $stack');
      emit(SpecialTestError(e.toString()));
    }
  }
}
