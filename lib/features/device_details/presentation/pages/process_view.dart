import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:tech_care_app/app/app_localization.dart';
import 'package:tech_care_app/core/util/app_colors.dart';
import 'package:tech_care_app/core/util/app_constants.dart';
import 'package:tech_care_app/features/device_details/domain/entities/process.dart';
import 'package:tech_care_app/features/device_details/domain/entities/process_report.dart';
import 'package:tech_care_app/features/device_details/presentation/widgets/maintenance_report_widget.dart';
import 'package:tech_care_app/features/device_details/presentation/widgets/note_widget.dart';
import 'package:tech_care_app/features/device_details/presentation/widgets/quality_report_widget.dart';
import 'package:tech_care_app/features/device_details/presentation/widgets/timer_widget.dart';

class ProcessView extends StatefulWidget {
  final Process processInfo;
  const ProcessView({super.key, required this.processInfo});

  @override
  State<ProcessView> createState() => _ProcessViewState();
}

class _ProcessViewState extends State<ProcessView> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        0,
        AppConstants.mediumPadding,
        0,
        AppConstants.extraLargePadding * 3,
      ),
      children: [
        TimerWidget(),
        Gap(AppConstants.mediumPadding),

        widget.processInfo.reports!.isEmpty
            ? SizedBox(
                height: MediaQuery.of(context).size.height / 4,
                child: Center(
                  child: Text(
                     'nothing_to_display'.tr),
                ),
              )
            : ListView.separated(
                shrinkWrap: true,
                primary: false,
                separatorBuilder: (context, index) =>
                    Gap(AppConstants.mediumPadding),
                itemCount: widget.processInfo.reports!.length,
                itemBuilder: (context, index) {
                  final report = widget.processInfo.reports!.elementAt(index);
                  switch (widget.processInfo.reports!.elementAt(index).type) {
                    case ProcessReportType.NOTE:
                      return NoteWidget(
                          key: ValueKey(widget.processInfo.reports!
                              .elementAt(index)
                              .toString()
                              .replaceAll(RegExp(r'true|false'), '')),
                          note: report);

                    case ProcessReportType.MAINTENANCE:
                      return MaintenanceReportWidget(
                        key: ValueKey(widget.processInfo.reports!
                            .elementAt(index)
                            .toString()
                            .replaceAll(RegExp(r'true|false'), '')),
                        report: report,
                      );

                    case ProcessReportType.QUALITY:
                      return QualityReportWidget(
                        key: ValueKey(widget.processInfo.reports!
                            .elementAt(index)
                            .toString()
                            .replaceAll(RegExp(r'true|false'), '')),
                        report: report,
                      );

                    default:
                      return Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: AppConstants.mediumPadding),
                        padding: EdgeInsets.all(AppConstants.mediumPadding),
                        decoration: BoxDecoration(
                          color: AppColors.altoColor,
                          borderRadius: BorderRadius.circular(
                            AppConstants.smallPadding,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Unsupported report type',
                          textAlign: TextAlign.center,
                        ),
                      );
                  }
                }),
        // Padding(
        //   padding: const EdgeInsets.symmetric(vertical: 7.5),
        //   child: MaintenanceReportWidget(),
        // ),
        // Padding(
        //   padding: const EdgeInsets.symmetric(vertical: 7.5),
        //   child: QualityReportWidget(),
        // ),
      ],
    );
  }
}
