import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:tech_care_app/app/app_localization.dart';
import 'package:tech_care_app/core/util/app_colors.dart';
import 'package:tech_care_app/core/util/app_constants.dart';
import 'package:tech_care_app/routes/app_router.dart';

class ReceiptCreatedDialog extends StatelessWidget {
  final void Function()? onPrint;

  const ReceiptCreatedDialog({
    super.key,
    this.onPrint,
  });

  static Future show(BuildContext context, { void Function()? onPrint}) {
    return showDialog<String?>(
      context: context,
      barrierDismissible: true,
      builder: (context) => ReceiptCreatedDialog(onPrint: onPrint),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(AppConstants.mediumPadding),
          child: Material(
            clipBehavior: Clip.antiAlias,
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(AppConstants.mediumPadding + 3),
            child: SizedBox(
              width: 500,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height *
                      2 /
                      3, // Set the maximum height
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () => AppRouter.navigator.pop(),
                          icon: const Icon(Icons.close)),
                    ),
                    Icon(
                      Icons.check_circle_outline_rounded,
                      color: AppColors.eucalyptusColor,
                      size: 50,
                    ),
                    Gap(AppConstants.mediumPadding),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppConstants.mediumPadding),
                      child: Text(
                        'receipt_created_successfully'.tr,
                        style: Theme.of(context).textTheme.titleLarge,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Gap(AppConstants.mediumPadding),
                    SizedBox.square(
                      dimension: 80,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                            boxShadow: [],
                            border: Border.all(
                              width: 2,
                              strokeAlign: BorderSide.strokeAlignOutside,
                              color: AppColors.silverColor,
                            ),
                            borderRadius: BorderRadius.circular(
                                AppConstants.smallPadding)),
                        child: MaterialButton(
                          elevation: 100,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  AppConstants.smallPadding)),
                          onPressed: onPrint,
                          child: Column(
                            children: [
                              Expanded(
                                child: Icon(
                                  color: Theme.of(context).colorScheme.primary,
                                  Icons.print_outlined,
                                  size: 30,
                                ),
                              ),
                              Expanded(
                                  child: Text(
                                'print_receipt'.tr,
                                textAlign: TextAlign.center,
                              ))
                            ],
                          ),
                        ),
                      ),
                    ),
                    Gap(AppConstants.mediumPadding),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
