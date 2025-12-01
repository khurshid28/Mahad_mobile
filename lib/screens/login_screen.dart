// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:test_app/blocs/auth/auth_bloc.dart';
import 'package:test_app/blocs/auth/auth_state.dart';
import 'package:test_app/controller/auth_controller.dart';
import 'package:test_app/core/const/const.dart';
import 'package:test_app/core/utilitiets/phone_number_formats.dart';
import 'package:test_app/screens/main_screen.dart';
import 'package:test_app/service/loading_service.dart';
import 'package:test_app/service/storage_service.dart';
import 'package:test_app/service/toast_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible = true;

  LoadingService loadingService = LoadingService();
  ToastService toastService = ToastService();

  @override
  void initState() {
    phoneController.text = StorageService().read(StorageService.login) ?? "";
     passwordController.text = StorageService().read(StorageService.password) ?? "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [
                    const Color(0xFF1A1A1A),
                    const Color(0xFF2A2A2A),
                  ]
                : [
                    AppConstant.primaryColor.withOpacity(0.05),
                    Colors.white,
                  ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(24.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 50.h),
                _buildLogo(),
                SizedBox(height: 40.h),
                _buildTitle(),
                SizedBox(height: 8.h),
                _buildSubtitle(),
                SizedBox(height: 32.h),
                _buildPhoneInput(),
                SizedBox(height: 20.h),
                _buildPasswordInput(),
                SizedBox(height: 40.h),
                _buildLoginButton(),
                SizedBox(height: 40.h),

                BlocListener<AuthBloc, AuthState>(
                  child: const SizedBox(),
                  listener: (context, state) async {
                    if (state is AuthWaitingState) {
                      loadingService.showLoading(context);
                    } else if (state is AuthErrorState) {
                      loadingService.closeLoading(context);
                      toastService.error(message: state.message ?? "Xatolik Bor");
                    } else if (state is AuthSuccessState) {
                      loadingService.closeLoading(context);
                      await Future.wait([
                        StorageService().write(
                          StorageService.access_token,
                          state.access_token.toString(),
                        ),
                        StorageService().write(StorageService.user, state.user),
                        StorageService().write(
                          StorageService.login,
                          phoneController.text,
                        ),
                        StorageService().write(
                          StorageService.password,
                          passwordController.text,
                        ),
                      ]);
                      toastService.success(
                        message: state.message ?? "Successfully",
                      );
                      _navigateToHome();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Center(
      child: Image.asset('assets/images/splash_logo.png', width: 120.w),
    );
  }

  Widget _buildTitle() {
    return Text(
      "Xush kelibsiz!",
      style: TextStyle(
        fontSize: 28.sp,
        fontWeight: FontWeight.bold,
        color: AppConstant.primaryColor,
      ),
    );
  }

  Widget _buildSubtitle() {
    return Text(
      "Test tizimiga kirish uchun ma'lumotlaringizni kiriting",
      style: TextStyle(
        fontSize: 14.sp,
        color: Colors.grey.shade600,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Widget _buildPhoneInput() {
    
    return TextFormField(
      controller: phoneController,
      keyboardType: TextInputType.phone,
      cursorColor: AppConstant.secondaryColor,
       autofillHints:  [ "Telefon raqam"],
      onChanged: (value) => setState(() {}),
      decoration: _inputDecoration(
        labelText: '+998',
        hintText: 'Telefon raqam',
        iconPath: 'assets/icons/phone.svg',
      ),
      style: TextStyle(color: AppConstant.blackColor, fontSize: 16.sp),
      inputFormatters: <TextInputFormatter>[uzFormat],
    );
  }

  Widget _buildPasswordInput() {
    return TextFormField(
      controller: passwordController,
      keyboardType: TextInputType.visiblePassword,
      cursorColor: AppConstant.secondaryColor,
      obscureText: isPasswordVisible,
      onChanged: (value) => setState(() {}),
      decoration: _inputDecoration(
        labelText: 'Parol',
        hintText: 'Parolni kiriting',
        iconPath: 'assets/icons/lock.svg',
        suffixIcon: Padding(
          padding: EdgeInsets.only(right: 12.w),
          child: IconButton(
            icon: Icon(
              isPasswordVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined,
              color: AppConstant.primaryColor,
              size: 22.sp,
            ),
            onPressed:
                () => setState(() => isPasswordVisible = !isPasswordVisible),
          ),
        ),
      ),
      style: TextStyle(color: AppConstant.blackColor, fontSize: 16.sp),
    );
  }

  void _navigateToHome() {
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    }
  }

  Widget _buildLoginButton() {
    final isValid = phoneController.text.length == 12 &&
        passwordController.text.length >= 8;
    
    return Container(
      width: double.infinity,
      height: 56.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        gradient: isValid
            ? LinearGradient(
                colors: [
                  AppConstant.primaryColor,
                  AppConstant.primaryColor.withOpacity(0.8),
                ],
              )
            : null,
        color: isValid ? null : Colors.grey.shade400,
        boxShadow: isValid
            ? [
                BoxShadow(
                  color: AppConstant.primaryColor.withOpacity(0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16.r),
          onTap: isValid ? () async {
            var login = "+998${phoneController.text.replaceAll(" ", "")}";
            var password = passwordController.text;
            if (login.length == 13 && password.length >= 8) {
              await AuthController.login(
                context,
                login: login,
                password: password,
              );
            }
          } : null,
          child: Center(
            child: Text(
              "Kirish",
              style: TextStyle(
                color: Colors.white,
                fontSize: 17.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String labelText,
    required String hintText,
    required String iconPath,
    Widget? suffixIcon,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return InputDecoration(
      filled: true,
      fillColor: isDark ? const Color(0xFF2A2A2A) : Colors.grey.shade50,
      prefixIcon: Padding(
        padding: EdgeInsets.all(12.w),
        child: SvgPicture.asset(
          iconPath,
          colorFilter: ColorFilter.mode(
            AppConstant.primaryColor,
            BlendMode.srcIn,
          ),
        ),
      ),
      suffixIcon: suffixIcon,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.r),
        borderSide: BorderSide(
          color: isDark ? Colors.white.withOpacity(0.1) : Colors.grey.shade300,
          width: 1.5,
        ),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.r),
        borderSide: BorderSide(
          color: AppConstant.primaryColor,
          width: 1.5,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.r),
        borderSide: BorderSide(
          color: AppConstant.primaryColor,
          width: 2.5,
        ),
      ),
      labelText: labelText,
      labelStyle: TextStyle(
        color: AppConstant.primaryColor,
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
      ),
      hintText: hintText,
      hintStyle: TextStyle(
        color: Colors.grey.shade400,
        fontSize: 14.sp,
      ),
      errorStyle: TextStyle(
        color: AppConstant.redColor,
        fontWeight: FontWeight.w400,
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: 20.w,
        vertical: 18.h,
      ),
    );
  }

}
