import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:tech_care_app/app/app_localization.dart';
import 'package:tech_care_app/core/util/app_constants.dart';
import 'package:tech_care_app/features/receipts/presentation/widgets/image_place_holder.dart';

class PagePlaceHolder extends StatelessWidget {
  final String msg;
  final String imagePath;
  final void Function()? onRetry;
  const PagePlaceHolder({
    required this.imagePath,
    required this.msg,
    this.onRetry,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ImagePlaceHolder(
            imagePath: imagePath,
            msg: 'no_receipts'.tr,
          ),
          if (onRetry != null) ...[
            Gap(AppConstants.mediumPadding),
            IconButton.outlined(
              onPressed: onRetry,
              icon: Icon(Icons.refresh),
            )
          ]
        ],
      ),
    );
  }
}
