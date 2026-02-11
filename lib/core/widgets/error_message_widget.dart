import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:tech_care_app/app/app_localization.dart';
import 'package:tech_care_app/core/entities/translatable_value.dart';
import 'package:tech_care_app/core/util/app_constants.dart';
import 'package:tech_care_app/core/util/app_strings.dart';
import 'package:tech_care_app/features/receipts/presentation/widgets/image_place_holder.dart';

class ErrorMessageWidget extends StatelessWidget {
  final VoidCallback? onRetry;
  final TranslatableValue errorMessage;
  const ErrorMessageWidget(
      {required this.errorMessage, this.onRetry, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ImagePlaceHolder(
            imagePath: AppStrings.warningImagePath,
            msg: errorMessage
                .getDisplayValue(AppLocalizations.getLocale(context)),
          ),
          Gap(AppConstants.mediumPadding),
          onRetry != null
              ? IconButton.outlined(
                  onPressed: onRetry,
                  icon: Icon(Icons.refresh),
                )
              : SizedBox.shrink()
        ],
      ),
    );
  }
}
