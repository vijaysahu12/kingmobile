import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class RefreshHelper {
  static Widget buildRefreshIndicator({
    required Future<void> Function() onRefresh,
    required Widget child,
    // double headerHeight = 160.0,
  }) {
    RefreshController _refreshController =
        RefreshController(initialRefresh: false);

    return SmartRefresher(
      controller: _refreshController,
      enablePullDown: true,
      enablePullUp: false,
      header: WaterDropMaterialHeader(
        backgroundColor: Colors.grey[200]!,
        color: Colors.blue,
      ),
      onRefresh: () async {
        await onRefresh();
        _refreshController.refreshCompleted();
      },
      child: child,
    );
  }

  static Future<void> defaultOnRefresh() async {
    await Future.delayed(Duration(seconds: 2));
  }
}
