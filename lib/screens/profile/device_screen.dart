import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test_app/blocs/device/device_bloc.dart';
import 'package:test_app/blocs/device/device_state.dart';
import 'package:test_app/core/const/const.dart';
import 'package:intl/intl.dart';

class DeviceScreen extends StatefulWidget {
  const DeviceScreen({super.key});

  @override
  State<DeviceScreen> createState() => _DeviceScreenState();
}

class _DeviceScreenState extends State<DeviceScreen> {
  late DeviceBloc deviceBloc;

  @override
  void initState() {
    super.initState();
    deviceBloc = DeviceBloc();
    deviceBloc.fetchMyDevice();
  }

  @override
  void dispose() {
    deviceBloc.close();
    super.dispose();
  }

  String formatLastActive(DateTime lastActive) {
    final now = DateTime.now();
    final difference = now.difference(lastActive);

    if (difference.inSeconds < 60) {
      return 'Hozirgina';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} daqiqa oldin';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} soat oldin';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} kun oldin';
    } else {
      return DateFormat('dd.MM.yyyy HH:mm').format(lastActive);
    }
  }

  IconData getDeviceIcon(String deviceType) {
    switch (deviceType) {
      case 'ANDROID':
        return Icons.phone_android;
      case 'IOS':
        return Icons.phone_iphone;
      case 'WEB':
        return Icons.computer;
      default:
        return Icons.devices;
    }
  }

  Color getDeviceColor(String deviceType) {
    switch (deviceType) {
      case 'ANDROID':
        return Colors.green;
      case 'IOS':
        return Colors.grey.shade700;
      case 'WEB':
        return Colors.blue;
      default:
        return AppConstant.primaryColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? Colors.grey.shade900 : Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Qurilma ma\'lumotlari'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppConstant.primaryColor,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocBuilder<DeviceBloc, DeviceState>(
        bloc: deviceBloc,
        builder: (context, state) {
          if (state is DeviceLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is DeviceErrorState) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64.sp,
                    color: Colors.red,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    state.message,
                    style: TextStyle(fontSize: 16.sp),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16.h),
                  ElevatedButton(
                    onPressed: () {
                      deviceBloc.fetchMyDevice();
                    },
                    child: const Text('Qayta urinish'),
                  ),
                ],
              ),
            );
          } else if (state is DeviceLoadedState) {
            final device = state.device;
            return RefreshIndicator(
              onRefresh: () => deviceBloc.fetchMyDevice(),
              color: AppConstant.primaryColor,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Device Status Banner
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppConstant.primaryColor,
                            AppConstant.primaryColor.withOpacity(0.7),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: [
                          BoxShadow(
                            color: AppConstant.primaryColor.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(12.w),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Icon(
                              getDeviceIcon(device.deviceType),
                              size: 32.sp,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  device.deviceName,
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.check_circle,
                                      size: 16.sp,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 4.w),
                                    Text(
                                      'Bu qurilma faol',
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color: Colors.white.withOpacity(0.9),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: 24.h),
                    
                    Text(
                      'Qurilma tafsilotlari',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    
                    SizedBox(height: 12.h),
                    
                    // Device Info Card
                    Card(
                      elevation: isDark ? 2 : 1,
                      color: isDark ? Colors.grey.shade800 : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16.w),
                        child: Column(
                          children: [
                            _buildInfoRow(
                              icon: Icons.access_time,
                              label: 'Oxirgi faollik',
                              value: formatLastActive(device.lastActive),
                            ),
                            
                            if (device.lastApiEndpoint != null && device.lastApiMethod != null) ...[
                              SizedBox(height: 16.h),
                              _buildInfoRow(
                                icon: Icons.api,
                                label: 'Oxirgi so\'rov',
                                value: '${device.lastApiMethod} ${device.lastApiEndpoint}',
                              ),
                            ],
                            
                            if (device.ipAddress != null && device.ipAddress!.isNotEmpty) ...[
                              SizedBox(height: 16.h),
                              _buildInfoRow(
                                icon: Icons.location_on,
                                label: 'IP Address',
                                value: device.ipAddress!,
                              ),
                            ],
                            
                            if (device.appVersion != null) ...[
                              SizedBox(height: 16.h),
                              _buildInfoRow(
                                icon: Icons.info_outline,
                                label: 'Ilova versiyasi',
                                value: device.appVersion!,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    
                    SizedBox(height: 16.h),
                    
                    // Info Card
                    Card(
                      elevation: isDark ? 2 : 1,
                      color: isDark ? Colors.grey.shade800 : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        side: BorderSide(
                          color: AppConstant.primaryColor.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16.w),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: AppConstant.primaryColor,
                              size: 24.sp,
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Text(
                                'Bu qurilma faol ekan, boshqa qurilmadan kira olmaysiz. Avval bu qurilmani o\'chirish kerak.',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
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
            );
          }
          
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: AppConstant.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(
            icon,
            size: 20.sp,
            color: AppConstant.primaryColor,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
