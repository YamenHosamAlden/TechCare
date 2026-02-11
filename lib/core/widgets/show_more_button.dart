import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:tech_care_app/app/app_localization.dart';
import 'package:tech_care_app/core/util/app_colors.dart';
import 'package:tech_care_app/core/util/app_constants.dart';

class ShowMoreButton extends StatelessWidget {
  final Function()? onPressed;
  const ShowMoreButton({
    super.key,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
            style: ButtonStyle(
                foregroundColor:
                    MaterialStatePropertyAll(AppColors.eucalyptusColor)),
            onPressed: onPressed,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('show_more'.tr),
                Gap(AppConstants.extraSmallPadding),
                AppLocalizations.isDirectionRTL(context)
                    ? Icon(Icons.arrow_circle_left_rounded)
                    : Icon(Icons.arrow_circle_right_rounded)
              ],
            )),
      ],
    );
  }
}
