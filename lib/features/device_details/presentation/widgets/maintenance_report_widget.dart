import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:tech_care_app/app/app_localization.dart';
import 'package:tech_care_app/core/util/app_colors.dart';
import 'package:tech_care_app/core/util/app_constants.dart';
import 'package:tech_care_app/features/device_details/domain/entities/process_report.dart';
import 'package:tech_care_app/features/device_details/presentation/widgets/report_adding_placeholder.dart';

class MaintenanceReportWidget extends StatelessWidget {
  final ProcessReport report;
  const MaintenanceReportWidget({required this.report, super.key});

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
              key: key,
              // margin:
              //     EdgeInsets.symmetric(horizontal: AppConstants.mediumPadding),
              padding: EdgeInsets.all(AppConstants.mediumPadding),
              decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(0)),
              child: Column(
                children: [
                  Text(
                    'm_report'.tr,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    report.time,
                  ),
                  const Gap(AppConstants.mediumPadding),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(report.createdBy,
                            style: Theme.of(context).textTheme.bodyLarge),
                      ),
                      const Gap(5),
                      Expanded(
                        child: Text(
                          DateFormat('dd/MM/yyyy hh:mm a')
                              .format(report.createdAt),
                          style: Theme.of(context).textTheme.bodyLarge!,
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                  const Gap(AppConstants.mediumPadding),
                  _itemsTeble(context),
                  report.items?.isEmpty ?? true
                      ? DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: AppColors.whiteColor),
                            color: AppColors.linkWaterColor,
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Text('no_items'.tr),
                            ),
                          ),
                        )
                      : SizedBox(),
                  const Gap(AppConstants.mediumPadding),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(AppConstants.mediumPadding),
                    decoration: BoxDecoration(
                        color: AppColors.aliceBlue,
                        borderRadius: BorderRadius.circular(5)),
                    child: Text(report.text),
                  )
                ],
              ),
            ),
    );
  }

  Table _itemsTeble(BuildContext context) {
    return Table(
      border: TableBorder.all(
          borderRadius: BorderRadius.circular(5), color: AppColors.whiteColor),
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      columnWidths: const <int, TableColumnWidth>{
        0: FractionColumnWidth(.3),
        1: FractionColumnWidth(.5),
        2: FractionColumnWidth(.2),
      },
      children: <TableRow>[
        _buildTableHeader(context),

        for (int i = 0; i < report.items!.length; i++)
          TableRow(
            decoration: BoxDecoration(
                color: AppColors.linkWaterColor,
                borderRadius: i == report.items!.length - 1
                    ? BorderRadius.vertical(bottom: Radius.circular(5))
                    : null),
            children: <Widget>[
              _buildTableCell(
                  child: Text(
                '${report.items!.elementAt(i).number ?? ''}',
                textAlign: TextAlign.center,
              )),
              _buildTableCell(
                  child: Text(
                report.items!.elementAt(i).name,
                textAlign: TextAlign.center,
              )),
              _buildTableCell(
                  child: Text(
                report.items!.elementAt(i).qty.toString(),
                textAlign: TextAlign.center,
              )),
            ],
          ),
        // ...report.items!
        //     .map(
        //       (item) => TableRow(
        //         decoration:
        //             const BoxDecoration(color: AppColors.linkWaterColor),
        //         children: <Widget>[
        //           _buildTableCell(child: Text('${item.number ?? ''}')),
        //           _buildTableCell(child: Text(item.name)),
        //           _buildTableCell(child: Text(item.qty.toString())),
        //         ],
        //       ),
        //     )
        //     .toList()
        // TableRow(
        //   decoration: const BoxDecoration(color: AppColors.linkWaterColor),
        //   children: <Widget>[
        //     _buildTableCell(child: const Text("123123")),
        //     _buildTableCell(child: const Text("VM12-ft13")),
        //     _buildTableCell(child: const Text("2")),
        //   ],
        // ),
        // TableRow(
        //   decoration: const BoxDecoration(
        //       borderRadius: BorderRadius.vertical(bottom: Radius.circular(5)),
        //       color: AppColors.linkWaterColor),
        //   children: <Widget>[
        //     _buildTableCell(child: const Text("98343")),
        //     _buildTableCell(child: const Text("HKV-123-VN")),
        //     _buildTableCell(child: const Text("1")),
        //   ],
        // ),
      ],
    );
  }

  TableRow _buildTableHeader(BuildContext context) {
    return TableRow(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(
              top: Radius.circular(5),
              bottom: report.items?.isEmpty ?? true
                  ? Radius.circular(5)
                  : Radius.circular(0)),
          color: AppColors.linkWaterColor),
      children: <Widget>[
        _buildTableCell(
            child: Text('no.'.tr,
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w600))),
        _buildTableCell(
            child: Text(
          'item_name'.tr,
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.w600),
        )),
        _buildTableCell(
            child: Text(
          'qty'.tr,
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.w600),
        )),
      ],
    );
  }

  Padding _buildTableCell({required Widget child}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 5),
      child: Center(child: child),
    );
  }
}
