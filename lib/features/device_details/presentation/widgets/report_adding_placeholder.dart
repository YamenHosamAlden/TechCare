import 'package:flutter/material.dart';
import 'package:tech_care_app/core/util/app_colors.dart';
import 'package:tech_care_app/core/util/app_constants.dart';

class ReportAddingPlaceholder extends StatelessWidget {
  const ReportAddingPlaceholder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          height: 20,
          width: 20,
          margin: EdgeInsets.all(AppConstants.extraSmallPadding),
          padding: EdgeInsets.all(AppConstants.extraSmallPadding),
          decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(100),
                bottomLeft: Radius.circular(100),
                bottomRight: Radius.circular(100),
              )),
          child: CircularProgressIndicator(
            strokeWidth: 1,
          ),
        ),
      ),
    );
  }
}
