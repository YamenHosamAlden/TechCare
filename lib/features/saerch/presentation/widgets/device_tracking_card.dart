import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:tech_care_app/app/app_localization.dart';
import 'package:tech_care_app/core/util/app_colors.dart';
import 'package:tech_care_app/core/util/app_constants.dart';
import 'package:tech_care_app/core/widgets/highlighted_text.dart';
import 'package:tech_care_app/core/widgets/show_more_button.dart';
import 'package:tech_care_app/features/saerch/domain/entity/device_info.dart';
import 'package:tech_care_app/routes/app_router.dart';
import 'package:tech_care_app/routes/app_routes.dart';
import 'package:tech_care_app/routes/route_params.dart';

class DeviceTrackingCard extends StatelessWidget {
  final DeviceInfo deviceInfo;
  final String? searchTerm;
  const DeviceTrackingCard({
    super.key,
    required this.deviceInfo,
    this.searchTerm,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            children: [
              MaterialButton(
                onPressed: () {
                  AppRouter.navigator.pushNamed(
                      AppRoutes.deviceDetailsPageRoute,
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
                                child: HighlightedText(
                                  text: deviceInfo.deviceCode,
                                  highlightedText: searchTerm,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                              ),
                            ],
                          ),
                          Gap(AppConstants.smallPadding),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildInfo(context,
                                  lable: 'Serial Number',
                                  info: deviceInfo.serialNumber),
                              Gap(AppConstants.smallPadding),
                              _buildInfo(context, lable: 'Qty', info: deviceInfo.qty ?? '-1'),
                            ],
                          ),
                          Gap(AppConstants.smallPadding),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildInfo(context,
                                  lable: 'Type', info: deviceInfo.type.name.tr),
                              Gap(AppConstants.smallPadding),
                              _buildInfo(context,
                                  lable: 'Model', info: deviceInfo.model),
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
                              Info: Text(deviceInfo.statusLable
                                      ?.getDisplayValue(
                                          AppLocalizations.getLocale(
                                              context)) ??
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
                  AppRouter.navigator.pushNamed(
                      AppRoutes.deviceDetailsPageRoute,
                      arguments: DeviceDetailsParams(deviceID: deviceInfo.id));
                },
              ),
            ],
          ),
        ),
        // SizedBox.square(
        //   dimension: 20,
        //   child: OverflowBox(
        //     maxHeight: 50,
        //     maxWidth: 50,
        //     fit: OverflowBoxFit.deferToChild,
        //     child: PopupMenuButton(
        //       padding: EdgeInsets.zero,
        //       iconSize: 20,
        //       icon: Icon(Icons.more_vert_rounded),
        //       itemBuilder: (context) => [
        //         _buildMenuItem(
        //             icon:
        //                 Icon(Icons.edit_rounded, color: AppColors.funBlueColor),
        //             label: 'Edit',
        //             onTap: () {}),
        //         _buildMenuItem(
        //             icon:
        //                 Icon(Icons.delete_rounded, color: AppColors.mojoColor),
        //             label: 'Delete',
        //             onTap: () {}),
        //       ],
        //     ),
        //   ),
        // )
      ],
    );
  }

  // PopupMenuItem<dynamic> _buildMenuItem(
  //     {required Icon icon, required String label, Function()? onTap}) {
  //   return PopupMenuItem(
  //     padding: EdgeInsets.all(AppConstants.smallPadding),
  //     height: 0,
  //     child: Row(
  //       children: [icon, Gap(AppConstants.smallPadding), Text(label)],
  //     ),
  //     onTap: onTap,
  //   );
  // }

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
        HighlightedText(
          text: info,
          highlightedText: searchTerm,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodySmall,
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
