import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test_app/blocs/theme/theme_bloc.dart';
import 'package:test_app/core/const/const.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void _toggleTheme(BuildContext context, bool value) {
    context.read<ThemeBloc>().add(ToggleTheme(value));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        final isDarkMode = themeState.themeMode == ThemeMode.dark;
        
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            title: Text(
              'Sozlamalar',
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark 
                    ? AppConstant.whiteColor 
                    : AppConstant.blackColor,
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios, 
                color: Theme.of(context).brightness == Brightness.dark 
                    ? AppConstant.whiteColor 
                    : AppConstant.blackColor,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: ListView(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            children: [
              _buildSectionTitle('Ko\'rinish', context),
              _buildThemeTile(context, isDarkMode),
              SizedBox(height: 16.h),
              _buildSectionTitle('Ilova haqida', context),
              _buildInfoTile(
                'Versiya',
                '1.0.0',
                Icons.info_outline,
                context,
              ),
              _buildInfoTile(
                'Ishlab chiqaruvchi',
                'Mahad Team',
                Icons.code,
                context,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title, BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          color: AppConstant.greyColor,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildThemeTile(BuildContext context, bool isDarkMode) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppConstant.greyColor1,
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 45.w,
            height: 45.w,
            decoration: BoxDecoration(
              color: isDarkMode 
                  ? AppConstant.whiteColor.withOpacity(0.1)
                  : AppConstant.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Center(
              child: Icon(
                isDarkMode ? Icons.dark_mode : Icons.light_mode,
                color: isDarkMode ? AppConstant.whiteColor : AppConstant.primaryColor,
                size: 24.w,
              ),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Qorong\'i rejim',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).brightness == Brightness.dark 
                        ? AppConstant.whiteColor 
                        : AppConstant.blackColor,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  isDarkMode ? 'Yoqilgan' : 'O\'chirilgan',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: AppConstant.greyColor,
                  ),
                ),
              ],
            ),
          ),
          Transform.scale(
            scale: 0.9,
            child: Switch(
              value: isDarkMode,
              onChanged: (value) => _toggleTheme(context, value),
              activeColor: AppConstant.primaryColor,
              activeTrackColor: AppConstant.primaryColor.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile(String title, String subtitle, IconData icon, BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppConstant.greyColor1,
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 45.w,
            height: 45.w,
            decoration: BoxDecoration(
              color: AppConstant.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Center(
              child: Icon(
                icon,
                color: AppConstant.primaryColor,
                size: 24.w,
              ),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).brightness == Brightness.dark 
                        ? AppConstant.whiteColor 
                        : AppConstant.blackColor,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: AppConstant.greyColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
