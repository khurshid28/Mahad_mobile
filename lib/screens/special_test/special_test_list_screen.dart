import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test_app/blocs/special_test/special_test_bloc.dart';
import 'package:test_app/core/const/const.dart';
import 'package:test_app/core/widgets/common_loading.dart';
import 'package:test_app/models/special_test.dart';
import 'package:test_app/screens/special_test/special_test_detail_screen.dart'
    as detail;

class SpecialTestListScreen extends StatefulWidget {
  const SpecialTestListScreen({super.key});

  @override
  State<SpecialTestListScreen> createState() => _SpecialTestListScreenState();
}

class _SpecialTestListScreenState extends State<SpecialTestListScreen> {
  List<SpecialTest>? _cachedTests;

  @override
  void initState() {
    super.initState();
    print('🟡 [ListScreen] initState - triggering LoadSpecialTests');
    _loadTests();
  }

  void _loadTests() {
    print('🟡 [ListScreen] _loadTests called');
    context.read<SpecialTestBloc>().add(LoadSpecialTests());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Theme.of(context).brightness == Brightness.dark
              ? const Color(0xFF1A1A1A)
              : const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          'Maxsus Testlar',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: Center(
          child: IconButton(
            icon: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppConstant.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 16,
                  color: AppConstant.primaryColor,
                ),
              ),
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      body: BlocBuilder<SpecialTestBloc, SpecialTestState>(
        builder: (context, state) {
          print('🟡 [ListScreen] BlocBuilder state: ${state.runtimeType}');

          // Cache the loaded tests
          if (state is SpecialTestsLoaded) {
            _cachedTests = state.tests;
          }

          // Show cached data while loading if available
          if (state is SpecialTestLoading && _cachedTests != null) {
            print('🟡 [ListScreen] Loading with cached data...');
            final tests = _cachedTests!;
            return RefreshIndicator(
              color: const Color(0xFF4CAF50),
              onRefresh: () async {
                context.read<SpecialTestBloc>().add(LoadSpecialTests());
              },
              child: Stack(
                children: [
                  ListView.builder(
                    padding: EdgeInsets.all(16.w),
                    itemCount: tests.length,
                    itemBuilder: (context, index) {
                      final test = tests[index];
                      return _SpecialTestCard(test: test, onReturn: _loadTests);
                    },
                  ),
                  // Show subtle loading indicator
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 3,
                      child: LinearProgressIndicator(
                        backgroundColor: Colors.transparent,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppConstant.primaryColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          if (state is SpecialTestLoading) {
            print('🟡 [ListScreen] Showing loading...');
            return CommonLoading(message: "Testlar yuklanmoqda...");
          }

          if (state is SpecialTestError) {
            print('🔴 [ListScreen] Showing error: ${state.message}');

            // If we have cached data, show it with error banner
            if (_cachedTests != null && _cachedTests!.isNotEmpty) {
              final tests = _cachedTests!;
              return Column(
                children: [
                  // Error banner
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(12.w),
                    color: Colors.red.shade50,
                    child: Row(
                      children: [
                        Icon(
                          Icons.warning_amber,
                          color: Colors.red.shade700,
                          size: 20.sp,
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            'Yangilashda xatolik: ${state.message}',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.red.shade700,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            context.read<SpecialTestBloc>().add(
                              LoadSpecialTests(),
                            );
                          },
                          child: Text(
                            'Qayta',
                            style: TextStyle(fontSize: 12.sp),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Show cached tests
                  Expanded(
                    child: RefreshIndicator(
                      color: const Color(0xFF4CAF50),
                      onRefresh: () async {
                        context.read<SpecialTestBloc>().add(LoadSpecialTests());
                      },
                      child: ListView.builder(
                        padding: EdgeInsets.all(16.w),
                        itemCount: tests.length,
                        itemBuilder: (context, index) {
                          final test = tests[index];
                          return _SpecialTestCard(
                            test: test,
                            onReturn: _loadTests,
                          );
                        },
                      ),
                    ),
                  ),
                ],
              );
            }

            // No cached data - show full error screen
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64.sp,
                    color: Colors.red.shade300,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'Xatolik yuz berdi',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32.w),
                    child: Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.read<SpecialTestBloc>().add(LoadSpecialTests());
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Qayta urinish'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4CAF50),
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: 12.h,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          if (state is SpecialTestsLoaded) {
            final tests = state.tests;
            print('🟢 [ListScreen] Tests loaded: ${tests.length} tests');
            if (tests.isNotEmpty) {
              print(
                '🟢 [ListScreen] First test: ${tests[0].name}, active: ${tests[0].isActive}',
              );
            }

            if (tests.isEmpty) {
              print('⚪ [ListScreen] Tests list is empty, showing empty state');
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(32.w),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppConstant.primaryColor.withOpacity(0.1),
                            AppConstant.primaryColor.withOpacity(0.05),
                          ],
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.assignment_outlined,
                        size: 80.sp,
                        color: AppConstant.primaryColor,
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Text(
                      'Maxsus testlar yo\'q',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 48.w),
                      child: Text(
                        'Hozircha sizga tayinlangan maxsus testlar yo\'q',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              color: const Color(0xFF4CAF50),
              onRefresh: () async {
                context.read<SpecialTestBloc>().add(LoadSpecialTests());
              },
              child: ListView.builder(
                padding: EdgeInsets.all(16.w),
                itemCount: tests.length,
                itemBuilder: (context, index) {
                  final test = tests[index];
                  return _SpecialTestCard(test: test, onReturn: _loadTests);
                },
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}

class _SpecialTestCard extends StatelessWidget {
  final SpecialTest test;
  final VoidCallback? onReturn;

  const _SpecialTestCard({required this.test, this.onReturn});

  @override
  Widget build(BuildContext context) {
    final isActive = test.isActive;
    final hasTime = test.timeInSeconds != null;

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.white, Colors.white]),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppConstant.primaryColor.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
            spreadRadius: 2,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap:
              isActive && test.hasAttempted != true
                  ? () async {
                    print(
                      '🟡 [ListScreen] Starting test immediately for test ${test.id}',
                    );
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) =>
                                detail.SpecialTestDetailScreen(
                                  testId: test.id,
                                  startImmediately: true,
                                ),
                      ),
                    );
                    // Refresh when returning from test
                    print(
                      '🟡 [ListScreen] Returned from test, refreshing...',
                    );
                    if (context.mounted) {
                      onReturn?.call();
                    }
                  }
                  : null,
          borderRadius: BorderRadius.circular(16.r),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(14.w),
                      decoration: BoxDecoration(
                        gradient:
                            isActive && test.hasAttempted != true
                                ? LinearGradient(
                                  colors: [
                                    AppConstant.primaryColor.withOpacity(0.15),
                                    AppConstant.primaryColor.withOpacity(0.05),
                                  ],
                                )
                                : LinearGradient(
                                  colors: [
                                    Colors.grey.shade200,
                                    Colors.grey.shade100,
                                  ],
                                ),
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      child: Icon(
                        test.hasAttempted == true
                            ? Icons.check_circle
                            : Icons.assignment_outlined,
                        color:
                            test.hasAttempted == true
                                ? const Color(0xFF9C27B0)
                                : isActive
                                ? const Color(0xFF4CAF50)
                                : Colors.grey.shade400,
                        size: 24.sp,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            test.name,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          if (test.description != null) ...[
                            SizedBox(height: 4.h),
                            Text(
                              test.description!,
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: Colors.grey.shade600,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: [
                    _InfoChip(
                      icon: Icons.quiz_outlined,
                      label: '${test.questionCount} ta savol',
                      color: const Color(0xFF2196F3),
                    ),
                    if (hasTime)
                      _InfoChip(
                        icon: Icons.access_time,
                        label: _formatTime(test.timeInSeconds!),
                        color: const Color(0xFFFF9800),
                      ),
                    _InfoChip(
                      icon: isActive ? Icons.check_circle : Icons.lock_clock,
                      label: isActive ? 'Faol' : 'Faol emas',
                      color:
                          isActive
                              ? const Color(0xFF4CAF50)
                              : Colors.grey.shade400,
                    ),
                    if (test.hasAttempted == true)
                      _InfoChip(
                        icon: Icons.task_alt,
                        label: 'Yechilgan',
                        color: const Color(0xFF9C27B0),
                      ),
                  ],
                ),
                if (test.activationStart != null &&
                    test.activationEnd != null) ...[
                  SizedBox(height: 12.h),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      color:
                          isActive
                              ? const Color(0xFF4CAF50).withOpacity(0.1)
                              : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(
                        color:
                            isActive
                                ? const Color(0xFF4CAF50).withOpacity(0.3)
                                : Colors.grey.shade300,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.date_range,
                          size: 16.sp,
                          color:
                              isActive
                                  ? const Color(0xFF4CAF50)
                                  : Colors.grey.shade600,
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            '${_formatDate(test.activationStart!)} - ${_formatDate(test.activationEnd!)}',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color:
                                  isActive
                                      ? const Color(0xFF4CAF50)
                                      : Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
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

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16.sp, color: color),
          SizedBox(width: 4.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
