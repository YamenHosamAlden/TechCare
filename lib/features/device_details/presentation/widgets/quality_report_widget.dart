import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart' as format;
import 'package:tech_care_app/app/app_localization.dart';
import 'package:tech_care_app/core/util/app_colors.dart';
import 'package:tech_care_app/core/util/app_constants.dart';
import 'package:tech_care_app/core/util/app_strings.dart';
import 'package:tech_care_app/features/device_details/domain/entities/process_report.dart';
import 'package:tech_care_app/features/device_details/presentation/widgets/report_adding_placeholder.dart';

class QualityReportWidget extends StatelessWidget {
  final ProcessReport report;
  const QualityReportWidget({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      key: key,
      duration: Durations.long2,
      switchInCurve: Curves.decelerate,
      transitionBuilder: (child, animation) => SizeTransition(
          sizeFactor: animation,
          axisAlignment: BorderSide.strokeAlignInside,
          child: ScaleTransition(
            alignment: Alignment.topLeft,
            scale: animation,
            child: FadeTransition(opacity: animation, child: child),
          )),
      child: report.isRecentlyAdded
          ? ReportAddingPlaceholder(
              key: GlobalKey(),
            )
          : Container(
              key: ValueKey(report),
              // margin:
              //     EdgeInsets.symmetric(horizontal: AppConstants.mediumPadding),
              padding: EdgeInsets.all(AppConstants.mediumPadding),
              decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(0)),
              child: Column(
                children: [
                  Text(
                    'q_report'.tr,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        report.time,
                      ),
                    ],
                  ),
                  const Gap(AppConstants.mediumPadding),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(report.createdBy,
                            style: Theme.of(context).textTheme.bodyLarge!,
                            textAlign: TextAlign.start),
                      ),
                      const Gap(5),
                      Expanded(
                        child: Text(
                          format.DateFormat('dd/MM/yyyy hh:mm a')
                              .format(report.createdAt),
                          style: Theme.of(context).textTheme.bodyLarge!,
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                  const Gap(AppConstants.mediumPadding),
                  Row(children: [
                    const Gap(AppConstants.mediumPadding),
                    report.isAccepted
                        ? _buildAcceptBadge()
                        : _buildRejectBadge(),
                    _buildSalesReturnBadge(context),
                    Opacity(
                      opacity: 0,
                      child: _buildAcceptBadge(),
                    ),
                    const Gap(AppConstants.mediumPadding),
                  ]),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(AppConstants.mediumPadding),
                    decoration: BoxDecoration(
                        color: report.isAccepted
                            ? AppColors.beige
                            : AppColors.mistyRose,
                        borderRadius: BorderRadius.circular(5)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (report.testDuration != null)
                          Row(
                            children: [
                              Text(
                                "${'test_duration'.tr} : ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 12),
                              ),
                              Text(
                                report.testDuration ?? '',
                                textDirection: TextDirection.ltr,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 12),
                              ),
                            ],
                          ),
                        Text(report.text),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Expanded _buildSalesReturnBadge(BuildContext context) {
    return Expanded(
        child: Padding(
      padding: const EdgeInsets.all(5.0),
      child: report.returnedToUser != null
          ? Text(
              '${'return_to'.tr} (${report.returnedToUser!})',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            )
          : report.returnedToGroup
              ? Text(
                  'return_to_g'.tr,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                )
              : report.salesReturn
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                            height: 25,
                            child:
                                Image.asset(AppStrings.turnBackYellowIconPath)),
                        const Gap(AppConstants.mediumPadding),
                        Text(
                          'sales_return'.tr,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    )
                  : SizedBox(),
    ));
  }

  Container _buildAcceptBadge() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
          color: AppColors.eucalyptusColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(5))),
      child: Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
              color: AppColors.whiteColor,
              shape: BoxShape.circle,
              border: Border.all()),
          child:
              const Icon(Icons.check_rounded, color: Colors.green, size: 20)),
    );
  }

  Container _buildRejectBadge() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
          color: AppColors.mojoColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(5))),
      child: Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
              color: AppColors.whiteColor,
              shape: BoxShape.circle,
              border: Border.all()),
          child: const Icon(Icons.close_rounded, color: Colors.red, size: 20)),
    );
  }
}
