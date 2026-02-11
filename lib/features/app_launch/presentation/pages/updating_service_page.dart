import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:tech_care_app/app/app_localization.dart';
import 'package:tech_care_app/core/util/app_colors.dart';
import 'package:tech_care_app/core/util/app_constants.dart';
import 'package:tech_care_app/core/util/app_strings.dart';

class UpdatingServicePage extends StatelessWidget {
  const UpdatingServicePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PopScope(
        canPop: false,
        child: Container(
          padding: const EdgeInsets.all(AppConstants.mediumPadding),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [
                0.5,
                1
              ],
                  colors: [
                AppColors.eucalyptusColor.withOpacity(0),
                AppColors.eucalyptusColor
              ])),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'update_service'.tr,
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              Gap(AppConstants.mediumPadding),
              Text(
                'come_later'.tr,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              Gap(AppConstants.mediumPadding),
              Image.asset(AppStrings.serviceUpdateImagePath),
            ],
          ),
        ),
      ),
    );
  }
}
