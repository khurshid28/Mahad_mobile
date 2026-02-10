// ignore_for_file: prefer_const_constructors_in_immutables, use_key_in_widget_constructors

import 'package:test_app/export_files.dart';
import 'package:test_app/models/rate.dart';
import 'package:test_app/service/storage_service.dart';

class RateCard extends StatelessWidget {
  final Rate rate;
  // Har bir subject uchun alohida border rangi
  final VoidCallback onTap;
  RateCard({required this.rate, required this.onTap});
  bool IsMe() {
   
    Map? user = StorageService().read(StorageService.user);
    return rate.id.toString() ==user?["id"].toString() ;

  
  }

 

  @override
  Widget build(BuildContext context) {
    bool isMe = IsMe();
    bool isTopThree = (rate.index + 1) <= 3;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
        decoration: BoxDecoration(
          gradient: isMe
              ? LinearGradient(
                  colors: [
                    AppConstant.primaryColor.withOpacity(0.15),
                    AppConstant.primaryColor.withOpacity(0.05),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                )
              : null,
          color: isMe ? null : Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: isMe
              ? Border.all(
                  color: AppConstant.primaryColor.withOpacity(0.3),
                  width: 2,
                )
              : null,
          boxShadow: [
            BoxShadow(
              color: isMe
                  ? AppConstant.primaryColor.withOpacity(0.2)
                  : Colors.black.withOpacity(0.05),
              blurRadius: isMe ? 12 : 8,
              offset: Offset(0, isMe ? 6 : 3),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Row(
            children: [
              // Rank badge
              Container(
                width: 50.w,
                height: 50.w,
                decoration: BoxDecoration(
                  gradient: isTopThree
                      ? LinearGradient(
                          colors: [
                            _getRankColor(rate.index + 1),
                            _getRankColor(rate.index + 1).withOpacity(0.7),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : null,
                  color: isTopThree ? null : Colors.grey.shade100,
                  shape: BoxShape.circle,
                  border: !isTopThree
                      ? Border.all(
                          color: AppConstant.primaryColor.withOpacity(0.3),
                          width: 2,
                        )
                      : null,
                  boxShadow: isTopThree
                      ? [
                          BoxShadow(
                            color: _getRankColor(rate.index + 1).withOpacity(0.4),
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: isTopThree
                      ? Icon(
                          _getRankIcon(rate.index + 1),
                          color: Colors.white,
                          size: 24.sp,
                        )
                      : Text(
                          (rate.index + 1).toString(),
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w900,
                            color: AppConstant.primaryColor,
                          ),
                        ),
                ),
              ),
              
              SizedBox(width: 16.w),
              
              // Name and tests
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      rate.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                          decoration: BoxDecoration(
                            color: AppConstant.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.book_outlined,
                                size: 12.sp,
                                color: AppConstant.primaryColor,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                '${rate.regularTestCount}',
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppConstant.primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 6.w),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                          decoration: BoxDecoration(
                            color: AppConstant.accentOrange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.stars,
                                size: 12.sp,
                                color: AppConstant.accentOrange,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                '${rate.specialTestCount}',
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppConstant.accentOrange,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Percentage
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      _getPercentColor(rate.avg),
                      _getPercentColor(rate.avg).withOpacity(0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: _getPercentColor(rate.avg).withOpacity(0.3),
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Text(
                  '${rate.avg}%',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Color _getRankColor(int rank) {
    switch (rank) {
      case 1:
        return Color(0xFFFFD700); // Gold
      case 2:
        return Color(0xFFC0C0C0); // Silver
      case 3:
        return Color(0xFFCD7F32); // Bronze
      default:
        return AppConstant.primaryColor;
    }
  }
  
  IconData _getRankIcon(int rank) {
    switch (rank) {
      case 1:
        return Icons.workspace_premium;
      case 2:
        return Icons.military_tech;
      case 3:
        return Icons.stars;
      default:
        return Icons.emoji_events;
    }
  }
  
  Color _getPercentColor(num percent) {
    if (percent >= 80) return Color(0xFF4CAF50); // Green
    if (percent >= 60) return Color(0xFFFF9800); // Orange
    return Color(0xFFF44336); // Red
  }
}
