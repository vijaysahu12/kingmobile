// import 'package:flutter/material.dart';
// import 'package:kraapp/Screens/Constants/app_color.dart';

// class RefreshHelper {
//   static GlobalKey<RefreshIndicatorState> refreshKey =
//       GlobalKey<RefreshIndicatorState>();

//   static Widget buildRefreshIndicator({
//     required Future<void> Function() onRefresh,
//     required Widget child,
//   }) {
//     return RefreshIndicator(
//       displacement: 150,
//       backgroundColor: AppColors.lightShadow,
//       color: AppColors.dark,
//       strokeWidth: 3,
//       triggerMode: RefreshIndicatorTriggerMode.onEdge,
//       key: refreshKey,
//       onRefresh: onRefresh,
//       child: child,
//     );
//   }

//   static Future<void> defaultOnRefresh() async {
//     await Future.delayed(Duration(seconds: 2));
//   }

//   static void showRefreshIndicator() {
//     refreshKey.currentState?.show();
//   }
// }
