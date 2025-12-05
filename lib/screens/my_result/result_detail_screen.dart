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
    super.key,
    required this.result,
    required this.totalQuestions,
    required this.testName,
    this.subjectName,
    this.bookName,
  });

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
        leading: Center(
          child: IconButton(
            icon: Container(
              width: 36.w,
              height: 36.w,
              decoration: BoxDecoration(
                color: AppConstant.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Center(
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 16.sp,
                  color: AppConstant.primaryColor,
                ),
              ),
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
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

            // User's Answers Section (faqat oddiy test va RANDOM uchun)
            if (result.type != "SpecialTest" && 
                result.answers != null && 
                result.answers!.isNotEmpty) ...[
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
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(10.w),
                          decoration: BoxDecoration(
                            color: AppConstant.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Icon(
                            Icons.quiz_outlined,
                            color: AppConstant.primaryColor,
                            size: 24.sp,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Text(
                            'Savollar va Javoblar',
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    
                    // Savollar ro'yxati
                    ...List.generate(result.answers!.length, (index) {
                      final answer = result.answers![index];
                      
                      if (answer is! Map) return SizedBox.shrink();
                      
                      final answerMap = answer is Map<String, dynamic> 
                          ? answer 
                          : Map<String, dynamic>.from(answer);
                      
                      final questionNumber = answerMap['number'] ?? index + 1;
                      final questionText = answerMap['question']?.toString() ?? '';
                      final myAnswer = answerMap['my_answer']?.toString().toUpperCase() ?? '';
                      final correctAnswer = answerMap['answer']?.toString().toUpperCase() ?? '';
                      
                      final isCorrect = myAnswer == correctAnswer && myAnswer.isNotEmpty;
                      
                      // Variantlar
                      final optionA = answerMap['answer_A']?.toString() ?? '';
                      final optionB = answerMap['answer_B']?.toString() ?? '';
                      final optionC = answerMap['answer_C']?.toString() ?? '';
                      final optionD = answerMap['answer_D']?.toString() ?? '';
                      
                      return Container(
                        margin: EdgeInsets.only(bottom: 16.h),
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: isCorrect 
                              ? Colors.green.shade50 
                              : Colors.red.shade50,
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(
                            color: isCorrect 
                                ? Colors.green.shade300 
                                : Colors.red.shade300,
                            width: 2,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Savol header
                            Row(
                              children: [
                                Container(
                                  width: 36.w,
                                  height: 36.w,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: isCorrect
                                          ? [Colors.green.shade600, Colors.green.shade400]
                                          : [Colors.red.shade600, Colors.red.shade400],
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '$questionNumber',
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: Text(
                                    isCorrect ? 'To\'g\'ri javob' : 'Noto\'g\'ri javob',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                      color: isCorrect 
                                          ? Colors.green.shade700 
                                          : Colors.red.shade700,
                                    ),
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
                            
                            SizedBox(height: 12.h),
                            
                            // Savol matni
                            if (questionText.isNotEmpty) ...[
                              Container(
                                padding: EdgeInsets.all(12.w),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: Text(
                                  questionText,
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                              SizedBox(height: 12.h),
                            ],
                            
                            // Variantlar
                            if (optionA.isNotEmpty)
                              _buildOption('A', optionA, myAnswer, correctAnswer),
                            if (optionB.isNotEmpty)
                              _buildOption('B', optionB, myAnswer, correctAnswer),
                            if (optionC.isNotEmpty)
                              _buildOption('C', optionC, myAnswer, correctAnswer),
                            if (optionD.isNotEmpty)
                              _buildOption('D', optionD, myAnswer, correctAnswer),
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
                      result.type == "SpecialTest"
                          ? 'Xavfsizlik sababli maxsus test javoblari ko\'rsatilmaydi'
                          : (result.answers != null && result.answers!.isNotEmpty
                              ? '${result.answers!.length} ta savolga javoblar ko\'rsatilgan'
                              : 'Javoblar mavjud emas'),
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

  Widget _buildOption(String optionLetter, String optionText, String myAnswer, String correctAnswer) {
    final isMyAnswer = optionLetter == myAnswer;
    final isCorrectAnswer = optionLetter == correctAnswer;
    
    Color bgColor = Colors.white;
    Color borderColor = Colors.grey.shade300;
    Color textColor = Colors.black87;
    IconData? icon;
    
    if (isCorrectAnswer) {
      bgColor = Colors.green.shade100;
      borderColor = Colors.green.shade400;
      textColor = Colors.green.shade900;
      icon = Icons.check_circle;
    } else if (isMyAnswer && !isCorrectAnswer) {
      bgColor = Colors.red.shade100;
      borderColor = Colors.red.shade400;
      textColor = Colors.red.shade900;
      icon = Icons.cancel;
    }
    
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: borderColor,
          width: isMyAnswer || isCorrectAnswer ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 32.w,
            height: 32.w,
            decoration: BoxDecoration(
              color: isCorrectAnswer 
                  ? Colors.green.shade600
                  : (isMyAnswer ? Colors.red.shade600 : AppConstant.primaryColor.withOpacity(0.1)),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                optionLetter,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w900,
                  color: (isCorrectAnswer || isMyAnswer) ? Colors.white : AppConstant.primaryColor,
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              optionText,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: (isMyAnswer || isCorrectAnswer) ? FontWeight.w600 : FontWeight.w500,
                color: textColor,
                height: 1.3,
              ),
            ),
          ),
          if (icon != null) ...[
            SizedBox(width: 8.w),
            Icon(
              icon,
              color: isCorrectAnswer ? Colors.green.shade600 : Colors.red.shade600,
              size: 20.sp,
            ),
          ],
        ],
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
