import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:tech_care_app/app/app_localization.dart';
import 'package:tech_care_app/core/util/app_colors.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
        duration: Durations.medium2,
        tween: Tween(begin: 0, end: 1),
        child: Center(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CupertinoActivityIndicator(
              color: AppColors.martiniqueColor,
              radius: 15,
            ),
            Gap(10),
            Text(
              'loading'.tr,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: AppColors.martiniqueColor,
                  ),
            )
          ],
        )),
        builder: (context, value, child) {
          return Opacity(
            opacity: value,
            child: child,
          );
        });
  }
}
