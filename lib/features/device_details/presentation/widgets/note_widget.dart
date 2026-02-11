import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:tech_care_app/app/app_localization.dart';
import 'package:tech_care_app/core/util/app_colors.dart';
import 'package:tech_care_app/core/util/app_constants.dart';
import 'package:tech_care_app/features/device_details/domain/entities/process_report.dart';
import 'package:tech_care_app/features/device_details/presentation/widgets/report_adding_placeholder.dart';

class NoteWidget extends StatelessWidget {
  final ProcessReport note;
  const NoteWidget({super.key, required this.note});

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
        child: note.isRecentlyAdded
            ? ReportAddingPlaceholder(
              key: GlobalKey(),
            )
            : Container(
                key: key,
                // margin: EdgeInsets.symmetric(
                //     horizontal: AppConstants.mediumPadding),
                padding: const EdgeInsets.all(AppConstants.mediumPadding),
                decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    borderRadius: BorderRadius.circular(0)),
                child: Column(
                  children: [
                    Text(
                      'note'.tr,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: AppConstants.mediumPadding),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(note.createdBy,
                                style: Theme.of(context).textTheme.bodyLarge!,
                                textAlign: TextAlign.start),
                          ),
                          const Gap(5),
                          Expanded(
                            child: Text(
                              DateFormat('dd/MM/yyyy hh:mm a')
                                  .format(note.createdAt),
                              style: Theme.of(context).textTheme.bodyLarge!,
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppConstants.mediumPadding),
                      decoration: BoxDecoration(
                          color: AppColors.seashell,
                          borderRadius: BorderRadius.circular(5)),
                      child: Text(note.text),
                    ),
                  ],
                ),
              ));
  }
}
