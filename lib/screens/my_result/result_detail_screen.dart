import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test_app/export_files.dart';
import 'package:test_app/models/result.dart';
import 'package:intl/intl.dart';

class ResultDetailScreen extends StatelessWidget {
  final Result result;
  final int totalQuestions;
  final String testName;
  final String? subjectName;
  final String? bookName;

  const ResultDetailScreen({
    Key? key,
    required this.result,
    required this.totalQuestions,
    required this.testName,
    this.subjectName,
    this.bookName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final solved = result.solved ?? 0;
    final percentage = totalQuestions > 0 ? (solved / totalQuestions * 100) : 0;
    final isPassed = percentage >= 56;
    
    // Debug: Print answers to see what we have
    print('🔍 Result answers: ${result.answers}');
    print('🔍 Answers length: ${result.answers?.length}');
    print('🔍 Answers type: ${result.answers.runtimeType}');

    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF1A1A1A)
          : const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          'Test Natijalari',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Result Status Card
            Container(
              margin: EdgeInsets.all(16.w),
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isPassed
                      ? [const Color(0xFF4CAF50), const Color(0xFF66BB6A)]
                      : [const Color(0xFFF44336), const Color(0xFFE57373)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: (isPassed ? const Color(0xFF4CAF50) : const Color(0xFFF44336))
                        .withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Icon(
                    isPassed ? Icons.check_circle_outline : Icons.cancel_outlined,
                    size: 80.sp,
                    color: Colors.white,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    isPassed ? 'Tabriklaymiz!' : 'Afsuski',
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    isPassed
                        ? 'Testdan muvaffaqiyatli o\'tdingiz'
                        : 'Sizning natijangiz',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),

            // Score Card
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16.w),
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
                children: [
                  Text(
                    'Natijangiz',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _ScoreItem(
                        label: 'To\'g\'ri',
                        value: solved.toString(),
                        color: const Color(0xFF4CAF50),
                        icon: Icons.check_circle,
                      ),
                      Container(
                        width: 1,
                        height: 60.h,
                        color: Colors.grey.shade300,
                      ),
                      _ScoreItem(
                        label: 'Jami',
                        value: totalQuestions.toString(),
                        color: const Color(0xFF2196F3),
                        icon: Icons.help_outline,
                      ),
                      Container(
                        width: 1,
                        height: 60.h,
                        color: Colors.grey.shade300,
                      ),
                      _ScoreItem(
                        label: 'Foiz',
                        value: '${percentage.toStringAsFixed(1)}%',
                        color: const Color(0xFFFF9800),
                        icon: Icons.percent,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 16.h),

            // Test Info Card
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16.w),
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
                  Text(
                    'Test Ma\'lumotlari',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  _InfoRow(
                    icon: Icons.assignment_outlined,
                    label: 'Test nomi',
                    value: testName,
                  ),
                  if (subjectName != null) ...[
                    SizedBox(height: 12.h),
                    _InfoRow(
                      icon: Icons.subject_outlined,
                      label: 'Fan',
                      value: subjectName!,
                    ),
                  ],
                  if (bookName != null) ...[
                    SizedBox(height: 12.h),
                    _InfoRow(
                      icon: Icons.menu_book_outlined,
                      label: 'Kitob',
                      value: bookName!,
                    ),
                  ],
                  SizedBox(height: 12.h),
                  _InfoRow(
                    icon: Icons.calendar_today_outlined,
                    label: 'Sana',
                    value: DateFormat('dd.MM.yyyy HH:mm').format(result.date),
                  ),
                ],
              ),
            ),

            SizedBox(height: 16.h),

            // User's Answers Section
            if (result.answers != null && result.answers!.isNotEmpty) ...[
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16.w),
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
                    Text(
                      'Sizning Javoblaringiz',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    ...List.generate(result.answers!.length, (index) {
                      final answer = result.answers![index];
                      final questionNumber = index + 1;
                      
                      // Handle both formats: String or Map
                      String? selectedDisplay;
                      String? correctDisplay;
                      bool isCorrect = false;
                      
                      if (answer is String) {
                        // Simple string format: just the selected answer
                        selectedDisplay = answer.isNotEmpty ? answer.toUpperCase() : '$questionNumber';
                        correctDisplay = null; // We don't have correct answer in this format
                        isCorrect = false; // Can't determine without correct answer
                      } else if (answer is Map) {
                        // Map format with selected and correct options
                        final answerMap = answer is Map<String, dynamic> 
                            ? answer 
                            : Map<String, dynamic>.from(answer);
                        
                        final selectedOption = answerMap['selected_option']?.toString().toUpperCase();
                        final correctOption = answerMap['correct_option']?.toString().toUpperCase();
                        
                        selectedDisplay = selectedOption != null && selectedOption.isNotEmpty 
                            ? selectedOption 
                            : '$questionNumber';
                        correctDisplay = correctOption != null && correctOption.isNotEmpty
                            ? correctOption
                            : null;
                        
                        isCorrect = selectedOption != null && 
                                   correctOption != null && 
                                   selectedOption == correctOption;
                      } else {
                        return const SizedBox.shrink();
                      }
                      
                      return Container(
                        margin: EdgeInsets.only(bottom: 12.h),
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: isCorrect 
                              ? Colors.green.shade50 
                              : Colors.red.shade50,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: isCorrect 
                                ? Colors.green.shade200 
                                : Colors.red.shade200,
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 40.w,
                              height: 40.w,
                              decoration: BoxDecoration(
                                color: isCorrect 
                                    ? Colors.green.shade100 
                                    : Colors.red.shade100,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  '$questionNumber',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                    color: isCorrect 
                                        ? Colors.green.shade700 
                                        : Colors.red.shade700,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 16.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Sizning javobingiz: ',
                                        style: TextStyle(
                                          fontSize: 13.sp,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                      Text(
                                        selectedDisplay,
                                        style: TextStyle(
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.bold,
                                          color: isCorrect 
                                              ? Colors.green.shade700 
                                              : Colors.red.shade700,
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (!isCorrect && correctDisplay != null) ...[
                                    SizedBox(height: 4.h),
                                    Row(
                                      children: [
                                        Text(
                                          'To\'g\'ri javob: ',
                                          style: TextStyle(
                                            fontSize: 13.sp,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                        Text(
                                          correctDisplay,
                                          style: TextStyle(
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green.shade700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            Icon(
                              isCorrect ? Icons.check_circle : Icons.cancel,
                              color: isCorrect 
                                  ? Colors.green.shade600 
                                  : Colors.red.shade600,
                              size: 28.sp,
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
            ],

            // Info Message
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16.w),
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.blue.shade700,
                    size: 24.sp,
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      result.answers != null && result.answers!.isNotEmpty
                          ? 'Javoblaringiz va to\'g\'ri javoblar ko\'rsatilgan'
                          : 'Xavfsizlik sababli savollar va javoblar ko\'rsatilmaydi',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: Colors.blue.shade900,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 80.h),
          ],
        ),
      ),
    );
  }
}

class _ScoreItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;

  const _ScoreItem({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: color,
            size: 24.sp,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(icon, size: 20.sp, color: Colors.grey.shade700),
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
