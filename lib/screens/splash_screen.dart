// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:test_app/core/const/const.dart';
import 'package:test_app/screens/main_screen.dart';
import 'package:test_app/service/storage_service.dart';
import 'package:test_app/service/version_service.dart';
import 'package:test_app/widgets/update_required_dialog.dart';
import '../screens/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final VersionService _versionService = VersionService();

  @override
  void initState() {
    super.initState();
    _checkVersionAndNavigate();
  }

  void _checkVersionAndNavigate() async {
    try {
      // Check version
      final currentVersion = await _versionService.getCurrentAppVersion();
      final serverVersionModel = await _versionService.getServerVersion();
      
      print('🟡 Current version: $currentVersion');
      print('🟡 Server version: ${serverVersionModel.version}');
      
      // Check if update is required
      if (_versionService.isUpdateRequired(currentVersion, serverVersionModel.version)) {
        // Show update dialog
        if (mounted) {
          await Future.delayed(const Duration(seconds: 2));
          _showUpdateDialog(currentVersion, serverVersionModel.version);
        }
        return;
      }
    } catch (e) {
      print('🔴 Version check error: $e');
      // Continue even if version check fails
    }
    
    // Navigate to next screen after delay
    Future.delayed(const Duration(seconds: 3), () async {
      if (mounted) {
        if ((StorageService().read(StorageService.access_token)) != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MainScreen()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        }
      }
    });
  }

  void _showUpdateDialog(String currentVersion, String latestVersion) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => UpdateRequiredDialog(
        currentVersion: currentVersion,
        latestVersion: latestVersion,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppConstant.primaryColor,
              AppConstant.primaryDark,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLogo(),
              SizedBox(height: 24.h),
              _buildTitle(),
              SizedBox(height: 40.h),
              _buildLoadingIndicator(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Image.asset(
        'assets/images/splash_logo.png',
        width: 100.w,
        height: 100.w,
      ),
    );
  }

  Widget _buildTitle() {
    return Column(
      children: [
        Text(
          "Test Platform",
          style: TextStyle(
            fontSize: 28.sp,
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          "Bilimingizni sinab ko'ring",
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.white.withOpacity(0.9),
            fontWeight: FontWeight.w400,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingIndicator() {
    return SpinKitWave(
      color: Colors.white,
      size: 40.w,
      itemCount: 5,
    );
  }
}
