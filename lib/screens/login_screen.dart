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
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppConstant.whiteColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 50.h),
              _buildLogo(),
              SizedBox(height: 20.h),
              _buildTitle(),
              SizedBox(height: 20.h),
              _buildPhoneInput(),
              SizedBox(height: 20.h),
              _buildPasswordInput(),
              const Spacer(),
              _buildLoginButton(),

              BlocListener<AuthBloc, AuthState>(
                child: SizedBox(),
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
    );
  }

  Widget _buildLogo() {
    return Center(
      child: Image.asset('assets/images/splash_logo.png', width: 120.w),
    );
  }

  Widget _buildTitle() {
    return Text(
      "Test tizimiga kirish",
      style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold),
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
        suffixIcon: IconButton(
          icon: Icon(
            isPasswordVisible ? Icons.visibility_off : Icons.visibility,
            color: AppConstant.greyColor,
          ),
          onPressed:
              () => setState(() => isPasswordVisible = !isPasswordVisible),
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
    return 
    
    ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor:
            (phoneController.text.length == 12 &&
                    passwordController.text.length >= 8)
                ? AppConstant.primaryColor
                : AppConstant.greyColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
        padding: EdgeInsets.symmetric(vertical: 14.h),
      ),
      onPressed: () async {
        var login = "+998${phoneController.text.replaceAll(" ", "")}";
        var password = passwordController.text;
        if (login.length == 13 && password.length >= 8) {
          await AuthController.login(context, login: login, password: password);
        }
      },
      child: Center(
        child: Text(
          "Kirish",
          style: TextStyle(color: Colors.white, fontSize: 16.sp),
        ),
      ),
    );

    // return BlocBuilder<AuthBloc, AuthState>(
    //   builder: (context, state) {
    //     return
    //     },
    // );
  }

  InputDecoration _inputDecoration({
    required String labelText,
    required String hintText,
    required String iconPath,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      prefixIcon: Padding(
        padding: EdgeInsets.all(12.w),
        child: SvgPicture.asset(
          iconPath,
          colorFilter: ColorFilter.mode(
            AppConstant.secondaryColor,
            BlendMode.srcIn,
          ),
        ),
      ),
      suffixIcon: suffixIcon,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.r),
        borderSide: BorderSide(color: AppConstant.secondaryColor),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.r),
        borderSide: BorderSide(color: AppConstant.secondaryColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.r),
        borderSide: BorderSide(color: AppConstant.secondaryColor),
      ),
      labelText: labelText,
      labelStyle: TextStyle(color: AppConstant.blackColor, fontSize: 16.sp),
      hintText: hintText,
      hintStyle: TextStyle(color: AppConstant.greyColor, fontSize: 16.sp),
      errorStyle: TextStyle(
        color: AppConstant.redColor,
        fontWeight: FontWeight.w400,
      ),
    );
  }

}
