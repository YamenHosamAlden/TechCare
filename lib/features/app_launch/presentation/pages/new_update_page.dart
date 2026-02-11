import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:tech_care_app/app/app_localization.dart';
import 'package:tech_care_app/core/util/app_colors.dart';
import 'package:tech_care_app/core/util/app_constants.dart';
import 'package:tech_care_app/core/util/app_strings.dart';
import 'package:tech_care_app/core/util/helpers/app_url_launcher.dart';
import 'package:tech_care_app/features/app_launch/domain/entity/version_status.dart';

class NewUpdatePage extends StatefulWidget {
  final VersionStatus versionStatus;

  const NewUpdatePage({
    super.key,
    required this.versionStatus,
  });

  @override
  State<NewUpdatePage> createState() => _NewUpdatePageState();
}

class _NewUpdatePageState extends State<NewUpdatePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PopScope(
        canPop: widget.versionStatus.appStatus != AppStatus.REQUIRED_UPDATE,
        child: Container(
          padding: const EdgeInsets.all(AppConstants.mediumPadding),
          alignment: Alignment.topCenter,
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
          child: SingleChildScrollView(
            padding: EdgeInsets.all(AppConstants.mediumPadding),
            child: Center(
              child: Column(
                children: [
                  Gap(AppConstants.extraLargePadding * 2),
                  Gap(AppConstants.mediumPadding),
                  Image.asset(
                    AppStrings.coloredLogoPath,
                    width: 150,
                  ),
                  Gap(AppConstants.mediumPadding),
                  Text(
                    'V ${widget.versionStatus.newAppVersion}',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(),
                  ),
                  Gap(AppConstants.largePadding),
                  Text('new_update'.tr,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Colors.grey, fontWeight: FontWeight.bold)),
                  Gap(AppConstants.mediumPadding),
                  Text(
                    '${widget.versionStatus.description.getDisplayValue(AppLocalizations.getLocale(context))}',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Gap(AppConstants.extraLargePadding),
                  OutlinedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(
                              Colors.white.withOpacity(.5))),
                      onPressed: () {
                        appUrlLauncher(widget.versionStatus.storeUrl);
                      },
                      child: Row(
                        children: [
                          Icon(Icons.store),
                          Expanded(
                              child: Center(child: Text('go_to_store'.tr))),
                        ],
                      )),
                  widget.versionStatus.platform == AppPlatform.ANDROID
                      ? OutlinedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll(
                                  Colors.white.withOpacity(.5))),
                          onPressed: () {
                            appUrlLauncher(widget.versionStatus.directUrl);
                          },
                          child: Row(
                            children: [
                              Icon(Icons.download),
                              Expanded(
                                  child: Center(
                                      child: Text(
                                          'direct_link'.tr))),
                            ],
                          ),
                        )
                      : SizedBox(),
                  Gap(AppConstants.largePadding),
                  widget.versionStatus.appStatus != AppStatus.REQUIRED_UPDATE
                      ? OutlinedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll(
                                  Colors.white.withOpacity(.5))),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Row(
                            children: [
                              Icon(Icons.arrow_back_ios_new_rounded),
                              Expanded(
                                  child: Center(
                                      child: Text(
                                          'skip'.tr))),
                            ],
                          ))
                      : SizedBox()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
