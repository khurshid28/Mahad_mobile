import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test_app/blocs/special_test/special_test_bloc.dart';
import 'package:test_app/core/widgets/common_loading.dart';
import 'package:test_app/models/special_test.dart';
import 'package:test_app/screens/special_test/special_test_result_screen.dart';
import 'package:test_app/service/toast_service.dart';

class SpecialTestDetailScreen extends StatefulWidget {
  final int testId;

  const SpecialTestDetailScreen({super.key, required this.testId});

  @override
  State<SpecialTestDetailScreen> createState() =>
      _SpecialTestDetailScreenState();
}

class _SpecialTestDetailScreenState extends State<SpecialTestDetailScreen> {
  @override
  void initState() {
    super.initState();
    print('🟡 [DetailScreen] initState for testId: ${widget.testId}');
    
    // Simply load the test - we'll check attempt status later if needed
    print('🟡 [DetailScreen] Triggering LoadSpecialTest');
    context.read<SpecialTestBloc>().add(LoadSpecialTest(widget.testId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF1A1A1A)
          : const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          'Test Tafsilotlari',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: BlocConsumer<SpecialTestBloc, SpecialTestState>(
        listener: (context, state) {
          if (state is SpecialTestError) {
            ToastService().error(message: state.message);
          }
        },
        builder: (context, state) {
          print('🟡 [DetailScreen] BlocBuilder state: ${state.runtimeType}');
          
          if (state is SpecialTestLoading) {
            print('🟡 [DetailScreen] Showing loading...');
            return CommonLoading(
              message: "Test yuklanmoqda...",
            );
          }

          if (state is SpecialTestLoaded) {
            print('🟢 [DetailScreen] Test loaded: ${state.test.name}, hasAttempted: ${state.hasAttempted}');
            final test = state.test;
            final hasAttempted = state.hasAttempted || (test.hasAttempted ?? false);

            return SingleChildScrollView(
              child: Column(
                children: [
                  _TestInfoCard(test: test),
                  if (hasAttempted)
                    _AlreadyTakenCard()
                  else if (!test.isActive)
                    _InactiveTestCard(test: test)
                  else
                    _StartTestCard(test: test),
                  SizedBox(height: 20.h),
                ],
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}

class _TestInfoCard extends StatelessWidget {
  final SpecialTest test;

  const _TestInfoCard({required this.test});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.assignment_outlined,
                  color: const Color(0xFF4CAF50),
                  size: 28.sp,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Text(
                  test.name,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          if (test.description != null) ...[
            SizedBox(height: 16.h),
            Text(
              test.description!,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey.shade700,
                height: 1.5,
              ),
            ),
          ],
          SizedBox(height: 20.h),
          _InfoRow(
            icon: Icons.quiz_outlined,
            label: 'Savollar soni',
            value: '${test.questionCount} ta',
            color: const Color(0xFF2196F3),
          ),
          if (test.timeInSeconds != null) ...[
            SizedBox(height: 12.h),
            _InfoRow(
              icon: Icons.access_time,
              label: 'Vaqt',
              value: _formatTime(test.timeInSeconds!),
              color: const Color(0xFFFF9800),
            ),
          ],
          if (test.activationStart != null && test.activationEnd != null) ...[
            SizedBox(height: 12.h),
            _InfoRow(
              icon: Icons.date_range,
              label: 'Faollik muddati',
              value:
                  '${_formatDate(test.activationStart!)} - ${_formatDate(test.activationEnd!)}',
              color: const Color(0xFF9C27B0),
            ),
          ],
        ],
      ),
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    if (minutes >= 60) {
      final hours = minutes ~/ 60;
      final remainingMinutes = minutes % 60;
      if (remainingMinutes > 0) {
        return '$hours soat $remainingMinutes daqiqa';
      }
      return '$hours soat';
    }
    return '$minutes daqiqa';
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return '${date.day}.${date.month}.${date.year}';
    } catch (e) {
      return dateStr;
    }
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(icon, size: 20.sp, color: color),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey.shade600,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AlreadyTakenCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Column(
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 64.sp,
            color: Colors.orange.shade600,
          ),
          SizedBox(height: 16.h),
          Text(
            'Siz bu testni allaqachon ishlagansiz',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: Colors.orange.shade900,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Har bir maxsus testni faqat bir marta ishlash mumkin',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.orange.shade800,
            ),
          ),
        ],
      ),
    );
  }
}

class _InactiveTestCard extends StatelessWidget {
  final SpecialTest test;

  const _InactiveTestCard({required this.test});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final start = test.activationStart != null
        ? DateTime.parse(test.activationStart!)
        : null;
    final end = test.activationEnd != null
        ? DateTime.parse(test.activationEnd!).add(const Duration(days: 1))
        : null;

    String message;
    if (start != null && now.isBefore(start)) {
      message =
          'Test ${_formatDate(test.activationStart!)} sanasidan boshlanadi';
    } else if (end != null && now.isAfter(end)) {
      message = 'Test muddati ${_formatDate(test.activationEnd!)} da tugagan';
    } else {
      message = 'Test hozirda faol emas';
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          Icon(
            Icons.lock_clock,
            size: 64.sp,
            color: Colors.grey.shade500,
          ),
          SizedBox(height: 16.h),
          Text(
            'Test faol emas',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return '${date.day}.${date.month}.${date.year}';
    } catch (e) {
      return dateStr;
    }
  }
}

class _StartTestCard extends StatelessWidget {
  final SpecialTest test;

  const _StartTestCard({required this.test});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF4CAF50),
            const Color(0xFF66BB6A),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4CAF50).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            Icons.play_circle_outline,
            size: 64.sp,
            color: Colors.white,
          ),
          SizedBox(height: 16.h),
          Text(
            'Testni boshlashga tayyormisiz?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Testni faqat bir marta ishlash imkoniyati bor',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          SizedBox(height: 20.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TakeTestScreen(test: test),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF4CAF50),
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                elevation: 0,
              ),
              child: Text(
                'Testni boshlash',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TakeTestScreen extends StatefulWidget {
  final SpecialTest test;

  const TakeTestScreen({super.key, required this.test});

  @override
  State<TakeTestScreen> createState() => _TakeTestScreenState();
}

class _TakeTestScreenState extends State<TakeTestScreen> {
  final Map<int, String> _answers = {};
  int _currentQuestionIndex = 0;
  Timer? _timer;
  int? _remainingSeconds;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    if (widget.test.timeInSeconds != null) {
      _remainingSeconds = widget.test.timeInSeconds;
      _startTimer();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds == null) return;
      
      setState(() {
        _remainingSeconds = _remainingSeconds! - 1;
      });

      if (_remainingSeconds! <= 0) {
        _timer?.cancel();
        _submitTest(autoSubmit: true);
      }
    });
  }

  Future<void> _submitTest({bool autoSubmit = false}) async {
    if (_isSubmitting) return;

    // Check if all questions are answered
    if (_answers.length != widget.test.questions.length) {
      if (!autoSubmit) {
        final shouldSubmit = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Ogohlantirish'),
            content: Text(
              'Siz ${widget.test.questions.length - _answers.length} ta savolga javob bermadingiz. Testni topshirishni xohlaysizmi?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Yo\'q'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50),
                ),
                child: const Text('Ha, topshirish'),
              ),
            ],
          ),
        );
        if (shouldSubmit != true) return;
      }
    }

    setState(() {
      _isSubmitting = true;
    });

    final answersMap = <String, String>{};
    _answers.forEach((questionId, answer) {
      answersMap[questionId.toString()] = answer;
    });

    // Fill unanswered questions with empty answer
    for (var question in widget.test.questions) {
      if (!answersMap.containsKey(question.id.toString())) {
        answersMap[question.id.toString()] = '';
      }
    }

    context
        .read<SpecialTestBloc>()
        .add(SubmitSpecialTest(widget.test.id, answersMap));
  }

  @override
  Widget build(BuildContext context) {
    final question = widget.test.questions[_currentQuestionIndex];
    final progress = (_currentQuestionIndex + 1) / widget.test.questions.length;

    return WillPopScope(
      onWillPop: () async {
        final shouldExit = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Testdan chiqish'),
            content: const Text(
              'Agar testdan chiqsangiz, natijangiz saqlanmaydi. Chiqishni xohlaysizmi?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Yo\'q'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: const Text('Ha, chiqish'),
              ),
            ],
          ),
        );
        return shouldExit ?? false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7FA),
        appBar: AppBar(
          title: Text(
            'Savol ${_currentQuestionIndex + 1}/${widget.test.questions.length}',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.black87),
          actions: [
            if (_remainingSeconds != null)
              Center(
                child: Container(
                  margin: EdgeInsets.only(right: 16.w),
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: _remainingSeconds! < 60
                        ? Colors.red.shade50
                        : const Color(0xFF4CAF50).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 18.sp,
                        color: _remainingSeconds! < 60
                            ? Colors.red
                            : const Color(0xFF4CAF50),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        _formatRemainingTime(_remainingSeconds!),
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: _remainingSeconds! < 60
                              ? Colors.red
                              : const Color(0xFF4CAF50),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
        body: BlocListener<SpecialTestBloc, SpecialTestState>(
          listener: (context, state) {
            if (state is SpecialTestSubmitted) {
              _timer?.cancel();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => SpecialTestResultScreen(result: state.result),
                ),
              );
            } else if (state is SpecialTestError) {
              setState(() {
                _isSubmitting = false;
              });
              ToastService().error(message: state.message);
            }
          },
          child: Column(
            children: [
              LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey.shade200,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  Color(0xFF4CAF50),
                ),
                minHeight: 4.h,
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(20.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(8.w),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF4CAF50)
                                        .withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  child: Text(
                                    '${question.number}',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF4CAF50),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: Text(
                                    'Savol',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16.h),
                            Text(
                              question.question,
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.h),
                      ..._buildOptions(question),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: Row(
                    children: [
                      if (_currentQuestionIndex > 0)
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _isSubmitting
                                ? null
                                : () {
                                    setState(() {
                                      _currentQuestionIndex--;
                                    });
                                  },
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 14.h),
                              side: const BorderSide(
                                color: Color(0xFF4CAF50),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                            ),
                            child: Text(
                              'Orqaga',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF4CAF50),
                              ),
                            ),
                          ),
                        ),
                      if (_currentQuestionIndex > 0) SizedBox(width: 12.w),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _isSubmitting
                              ? null
                              : () {
                                  if (_currentQuestionIndex <
                                      widget.test.questions.length - 1) {
                                    setState(() {
                                      _currentQuestionIndex++;
                                    });
                                  } else {
                                    _submitTest();
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4CAF50),
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            elevation: 0,
                          ),
                        child: _isSubmitting
                            ? SizedBox(
                                height: 20.h,
                                width: 20.h,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                _currentQuestionIndex <
                                        widget.test.questions.length - 1
                                    ? 'Keyingi'
                                    : 'Topshirish',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildOptions(SpecialTestQuestion question) {
    final options = ['A', 'B', 'C', 'D'];
    final answers = [
      question.answerA,
      question.answerB,
      question.answerC,
      question.answerD,
    ];

    return List.generate(
      4,
      (index) {
        if (answers[index] == null || answers[index]!.isEmpty) {
          return const SizedBox.shrink();
        }

        final option = options[index];
        final isSelected = _answers[question.id] == option;

        return Container(
          margin: EdgeInsets.only(bottom: 12.h),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _isSubmitting
                  ? null
                  : () {
                      setState(() {
                        _answers[question.id] = option;
                      });
                    },
              borderRadius: BorderRadius.circular(12.r),
              child: Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF4CAF50).withOpacity(0.1)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF4CAF50)
                        : Colors.grey.shade300,
                    width: isSelected ? 2 : 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 32.w,
                      height: 32.w,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF4CAF50)
                            : Colors.grey.shade100,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF4CAF50)
                              : Colors.grey.shade400,
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          option,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : Colors.black54,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Text(
                        answers[index]!,
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.normal,
                          color: Colors.black87,
                          height: 1.4,
                        ),
                      ),
                    ),
                    if (isSelected)
                      Icon(
                        Icons.check_circle,
                        color: const Color(0xFF4CAF50),
                        size: 24.sp,
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  String _formatRemainingTime(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;

    if (hours > 0) {
      return '${hours}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }
}
