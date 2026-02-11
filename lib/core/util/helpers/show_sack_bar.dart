import 'package:flutter/material.dart';
import 'package:tech_care_app/core/util/app_colors.dart';

void showSnackBar(
  BuildContext context, {
  required String msg,
  Color? fontColor = AppColors.whiteColor,
  Color? backgroundColor = AppColors.mojoColor,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      
      behavior: SnackBarBehavior.floating,
      content: Text(
        msg,
        style:
            Theme.of(context).textTheme.titleMedium!.copyWith(color: fontColor),
      ),
      duration: const Duration(seconds: 3),
      backgroundColor: backgroundColor,
      
    ),
  );
}
