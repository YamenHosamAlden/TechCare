import 'package:flutter/material.dart';

import 'package:gap/gap.dart';
import 'package:tech_care_app/app/app_localization.dart';
import 'package:tech_care_app/core/util/app_colors.dart';
import 'package:tech_care_app/core/util/app_constants.dart';
import 'package:tech_care_app/core/widgets/custom_pop_up_menu_button.dart';
import 'package:tech_care_app/core/widgets/show_more_button.dart';
import 'package:tech_care_app/features/receipt_details/domain/entities/device_info.dart';
import 'package:tech_care_app/features/receipts_container_details/presentation/dialogs/delete_device_confirmation_dialog.dart';
import 'package:tech_care_app/routes/app_router.dart';
import 'package:tech_care_app/routes/app_routes.dart';
import 'package:tech_care_app/routes/route_params.dart';

class DeviceCard extends StatelessWidget {
  final DeviceInfo deviceInfo;
  const DeviceCard({
    super.key,
    required this.deviceInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MaterialButton(
          onPressed: () {
            AppRouter.navigator.pushNamed(AppRoutes.deviceDetailsPageRoute,
                arguments: DeviceDetailsParams(deviceID: deviceInfo.id));
          },
          elevation: 0,
          padding: EdgeInsets.zero,
          color: AppColors.linkWaterColor,
          clipBehavior: Clip.hardEdge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              AppConstants.extraSmallPadding,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(
                  AppConstants.smallPadding,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.qr_code_scanner_rounded, size: 15),
                        Gap(AppConstants.extraSmallPadding),
                        Expanded(
                          child: Text(
                            deviceInfo.deviceCode,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        CustomPopupMenuButton<String>(
                          icon: Icon(
                            Icons.adaptive.more,
                            size: 18,
                          ),
                          popupMenuItems: [
                            PopupMenuItem(
                              height: 30,
                              onTap: () {
                                AppRouter.navigator.pushNamed(
                                    AppRoutes.editDeviceDetailsPageRoute,
                                    arguments: deviceInfo.id);
                              },
                              child: Text('edit'.tr),
                            ),
                            PopupMenuItem(
                                height: 30,
                                onTap: () {
                                  DeleteDeviceConfirmtionDialog.show(context,
                                      deviceId: deviceInfo.id!);
                                },
                                child: Text('delete'.tr))
                          ],
                        )
                      ],
                    ),
                    Gap(AppConstants.smallPadding),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfo(context,
                            lable: 'serial_number'.tr,
                            info: deviceInfo.serialNumber),
                        Gap(AppConstants.smallPadding),
                        _buildInfo(context,
                            lable: 'qty'.tr, info: deviceInfo.qty.toString()),
                      ],
                    ),
                    Gap(AppConstants.smallPadding),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfo(context,
                            lable: 'brand'.tr, info: deviceInfo.type.name.tr),
                        Gap(AppConstants.smallPadding),
                        _buildInfo(context,
                            lable: 'model'.tr, info: deviceInfo.model),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(AppConstants.smallPadding),
                color: AppColors.whiteColor,
                child: Wrap(
                  children: [
                    deviceInfo.assignName == null
                        ? SizedBox()
                        : _buildTag(
                            prefix: _buildPrefix(color: Colors.blue),
                            Info: Text(deviceInfo.assignName!)),
                    _buildTag(
                        prefix: _buildPrefix(color: Colors.green),
                        Info: Text(deviceInfo.statusLable?.getDisplayValue(
                                AppLocalizations.getLocale(context)) ??
                            '')),
                    // _buildTag(
                    //     prefix: _buildPrefix(color: Colors.red),
                    //     Info: Text("---")), // sales return
                  ],
                ),
              )
            ],
          ),
        ),
        ShowMoreButton(
          onPressed: () {
            AppRouter.navigator.pushNamed(AppRoutes.deviceDetailsPageRoute,
                arguments: DeviceDetailsParams(deviceID: deviceInfo.id));
          },
        ),
      ],
    );
  }

  Icon _buildPrefix({required Color color}) {
    return Icon(
      Icons.circle,
      size: 10,
      color: color,
    );
  }

  Expanded _buildInfo(BuildContext context,
      {required String lable, required String info}) {
    return Expanded(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          lable,
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        Gap(AppConstants.extraSmallPadding),
        Text(
          info,
        ),
      ],
    ));
  }

  Row _buildTag(
      {double? prefixHeight = 20,
      required Widget prefix,
      required Widget Info}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: prefixHeight,
          width: 10,
          child: prefix,
        ),
        Gap(AppConstants.extraSmallPadding),
        Info,
        Gap(AppConstants.mediumPadding),
      ],
    );
  }
}
