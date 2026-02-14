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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Qurilma'),
        centerTitle: true,
        backgroundColor: AppConstant.primaryColor,
        foregroundColor: Colors.white,
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
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Device Info Card
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16.w),
                        child: Column(
                          children: [
                            // Device Icon and Name
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(12.w),
                                  decoration: BoxDecoration(
                                    color: getDeviceColor(device.deviceType).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  child: Icon(
                                    getDeviceIcon(device.deviceType),
                                    size: 32.sp,
                                    color: getDeviceColor(device.deviceType),
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
                                        ),
                                      ),
                                      SizedBox(height: 4.h),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 8.w,
                                          vertical: 4.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.green.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(4.r),
                                        ),
                                        child: Text(
                                          device.deviceType,
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            color: Colors.green,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (device.isActive)
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12.w,
                                      vertical: 6.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(20.r),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.check_circle,
                                          size: 16.sp,
                                          color: Colors.white,
                                        ),
                                        SizedBox(width: 4.w),
                                        Text(
                                          'Bu qurilma',
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                            
                            Divider(height: 32.h),
                            
                            // Last Active
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
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
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
                                'Boshqa qurilmadan kirsangiz, bu qurilma avtomatik chiqariladi.',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.grey.shade700,
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20.sp,
          color: AppConstant.primaryColor,
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey.shade600,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
