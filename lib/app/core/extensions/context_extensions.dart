import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:syncup/app/core/enums/app_enums.dart';
import 'package:syncup/app/core/themes/app_colors.dart';

extension ContextExtensions on BuildContext {
  // Navigation
  Future<T?> push<T>(PageRouteInfo route) => router.push<T>(route);
  Future<bool> pop<T>([T? result]) => router.maybePop<T>(result);
  Future<void> pushAndPopAll(PageRouteInfo route) => router.replaceAll([route]);
  Future<T?> popAndPush<T>(PageRouteInfo route) => router.popAndPush<T, dynamic>(route);

  // Dimensions
  double get width => MediaQuery.sizeOf(this).width;
  double get height => MediaQuery.sizeOf(this).height;

  // SnackBar
  void showCustomSnackBar({
    required String message,
    SnackBarStatus snackBarStatus = SnackBarStatus.info,
    Duration duration = const Duration(seconds: 3),
  }) {
    Color bg;
    IconData icon;

    switch (snackBarStatus) {
      case SnackBarStatus.success:
        bg = AppColors.success;
        icon = Icons.check_circle_outline;
        break;
      case SnackBarStatus.error:
        bg = AppColors.danger;
        icon = Icons.error_outline;
        break;
      case SnackBarStatus.warning:
        bg = AppColors.warning;
        icon = Icons.warning_amber_outlined;
        break;
      case SnackBarStatus.info:
        bg = AppColors.primary;
        icon = Icons.info_outline;
        break;
    }

    ScaffoldMessenger.of(this).hideCurrentSnackBar();
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: bg,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  // Dialogs
  Future<T?> showCustomAlertDialog<T>({required Widget dialog}) {
    return showDialog<T>(
      context: this,
      builder: (_) => dialog,
    );
  }

  // BottomSheet
  Future<T?> showBottomSheet<T>({required Widget bottomSheetBody}) {
    return showModalBottomSheet<T>(
      context: this,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => bottomSheetBody,
    );
  }
}
