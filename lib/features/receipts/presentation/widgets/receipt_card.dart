import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:tech_care_app/app/app_localization.dart';
import 'package:tech_care_app/core/util/app_colors.dart';
import 'package:tech_care_app/core/util/app_constants.dart';
import 'package:tech_care_app/core/util/app_strings.dart';
import 'package:tech_care_app/core/widgets/custom_phone_view.dart';
import 'package:tech_care_app/core/widgets/dialogs/communication_dialog.dart';
import 'package:tech_care_app/core/widgets/show_more_button.dart';
import 'package:tech_care_app/features/receipts/domain/entities/receipt.dart';
import 'package:tech_care_app/routes/app_router.dart';
import 'package:tech_care_app/routes/app_routes.dart';
import 'package:tech_care_app/routes/route_params.dart';

class ReceiptCard extends StatelessWidget {
  final Receipt receipt;
  final ReceiptDisplayType receiptDisplayType;
  const ReceiptCard(
      {required this.receipt, super.key, required this.receiptDisplayType});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MaterialButton(
          clipBehavior: Clip.hardEdge,
          onPressed: () {
            AppRouter.navigator.pushNamed(AppRoutes.receiptDetailsPageRoute,
                arguments: ReceiptDetailsParams(
                  receiptID: receipt.id,
                  receiptDisplayType: receiptDisplayType,
                ));
          },
          padding: EdgeInsets.zero,
          elevation: 0,
          color: AppColors.whiteColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.smallPadding)),
          child: ShowBanner(
            showBanner: receipt.hasReturnedDevice,
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.mediumPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildMainInfo(context),
                  Divider(
                    height: AppConstants.mediumPadding * 2,
                    endIndent: 100,
                    color: AppColors.altoColor,
                  ),
                  _buildSubInfo(context),
                ],
              ),
            ),
          ),
        ),
        ShowMoreButton(
          onPressed: () {
            AppRouter.navigator.pushNamed(AppRoutes.receiptDetailsPageRoute,
                arguments: ReceiptDetailsParams(
                  receiptID: receipt.id,
                  receiptDisplayType: receiptDisplayType,
                ));
          },
        )
      ],
    );
  }

  Row _buildInfo(
      {double? prefixHeight = 20,
      bool isExpanded = true,
      required Widget prefix,
      required Widget Info}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: prefixHeight, width: 20, child: prefix),
        Gap(AppConstants.extraSmallPadding),
        Expanded(flex: isExpanded ? 1 : 0, child: Info),
      ],
    );
  }

  _buildMainInfo(BuildContext context) {
    return Column(
      children: [
        _buildInfo(
            prefixHeight: 26,
            prefix: Image.asset(AppStrings.barcodeIconPath),
            Info: Text(receipt.receiptNumber,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ))),
        Gap(AppConstants.smallPadding),
        _buildInfo(
            prefixHeight: 26,
            prefix: Image.asset(AppStrings.datetimeIconPath),
            Info: Text(
                DateFormat('dd/MM/yyyy hh:mm a').format(receipt.createdAt),
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: _colorDifference(receipt.createdAt)))),
      ],
    );
  }

  Widget _buildSubInfo(BuildContext context) {
    // final prefix = Icon(
    //   Icons.circle,
    //   size: 10,
    //   color: AppColors.linkWaterColor,
    // );
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                child: _buildInfo(
                    prefix: Icon(
                      Icons.settings,
                      size: 15,
                      color: AppColors.silverColor,
                    ),
                    Info: Text(receipt.groupName))),
            Gap(AppConstants.smallPadding),
            Expanded(
                child: _buildInfo(
                    prefix: Icon(
                      Icons.sort_rounded,
                      size: 15,
                      color: AppColors.silverChaliceColor,
                    ),
                    isExpanded: false,
                    Info: Container(
                      padding:
                          EdgeInsets.all(AppConstants.extraSmallPadding + 2),
                      decoration: BoxDecoration(
                          color: _priorityColor(),
                          borderRadius:
                              BorderRadius.circular(AppConstants.largePadding)),
                      child: Text(
                        receipt.priority.getDisplayValue(
                            AppLocalizations.getLocale(context)),
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: AppColors.whiteColor, height: 0.75),
                      ),
                    ))),
          ],
        ),
        Gap(AppConstants.smallPadding),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                child: _buildInfo(
                    prefix: Icon(
                      Icons.person,
                      size: 15,
                      color: AppColors.silverColor,
                    ),
                    Info: Text(receipt.customerName))),
            Gap(AppConstants.smallPadding),
            Expanded(
                child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(100),
                onTap: () => CommunicationDialog.show(context,
                    phone: receipt.customerPhoneNumber),
                child: _buildInfo(
                    prefix: Icon(
                      Icons.phone_rounded,
                      size: 15,
                      color: AppColors.silverColor,
                    ),
                    Info: CustomPhoneView(phone: receipt.customerPhoneNumber)),
              ),
            )),
          ],
        ),
      ],
    );
  }

  Color _priorityColor() {
    if (receipt.priority.translations['en'] == "Urgent") {
      return AppColors.mojoColor;
    }
    if (receipt.priority.translations['en'] == "Shipping") {
      return AppColors.darkOrange;
    }
    if (receipt.priority.translations['en'] == "Internal") {
      return AppColors.eucalyptusColor;
    }
    return AppColors.silverColor;
  }

  Color _colorDifference(DateTime createdAt) {
    DateTime now = DateTime.now();
    Duration difference = now.difference(createdAt);

    double t = difference.inHours / 72;
    if (t > 1) {
      t = 1;
    }

    return Color.lerp(AppColors.blackColor, AppColors.mojoColor, t) ??
        AppColors.blackColor;
  }
}

enum ReceiptDisplayType {
  received,
  maintenance,
  quality,
  finished,
  display;
}

class ShowBanner extends StatelessWidget {
  final bool showBanner;
  final Widget child;
  const ShowBanner({super.key, required this.showBanner, required this.child});

  @override
  Widget build(BuildContext context) {
    if (showBanner) {
      return Banner(
        message: "returned".tr,
        color: AppColors.mojoColor,
        location: BannerLocation.topEnd,
        child: child,
      );
    } else {
      return child;
    }
  }
}
