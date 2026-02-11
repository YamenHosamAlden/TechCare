import 'package:flutter/material.dart';
import 'package:tech_care_app/app/app_localization.dart';
import 'package:tech_care_app/core/util/app_colors.dart';
import 'package:tech_care_app/core/util/app_constants.dart';
import 'package:tech_care_app/features/quality_report/domain/entity/maintenance_summary.dart';

class MaintenanceSummaryCard extends StatefulWidget {
  final MaintenanceSummary summary;
  const MaintenanceSummaryCard({
    super.key,
    required this.summary,
  });

  @override
  _ExpandableCardDemoState createState() => _ExpandableCardDemoState();
}

class _ExpandableCardDemoState extends State<MaintenanceSummaryCard> {
  late CrossFadeState _crossFadeState;
  final Duration _animationDuration = Durations.medium4;
  final Curve _animationCurve = Curves.easeInOut;

  @override
  void initState() {
    _crossFadeState = CrossFadeState.showFirst;
    super.initState();
  }

  void _toggleCard() {
    setState(() {
      _crossFadeState = _crossFadeState == CrossFadeState.showFirst
          ? CrossFadeState.showSecond
          : CrossFadeState.showFirst;
    });
  }

  bool get _isCalculated => (widget.summary.warrantyType.object == 'in' ||
          widget.summary.warrantyType.object == 're')
      ? true
      : false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      // margin: EdgeInsets.only(bottom: AppConstants.mediumPadding),
      duration: _animationDuration,
      curve: _animationCurve,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(AppConstants.smallPadding),
          boxShadow: _crossFadeState == CrossFadeState.showFirst
              ? []
              : [
                  BoxShadow(
                      blurRadius: AppConstants.extraSmallPadding,
                      color: AppColors.altoColor)
                ]),
      child: MaterialButton(
        elevation: 0,
        padding: EdgeInsets.zero,
        onPressed: () {
          _toggleCard();
        },
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppConstants.mediumPadding),
              child: Column(
                children: [
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Text(
                  //       widget.device.deviceCode,
                  //       style: Theme.of(context).textTheme.titleMedium,
                  //     ),
                  //     FloatingActionButton.small(
                  //       backgroundColor: AppColors.alabasterColor,
                  //       elevation: 2,
                  //       heroTag: 'goto${widget.device.id}',
                  //       onPressed: () {
                  //         AppRouter.navigator.pushNamed(
                  //             AppRoutes.deviceDetailsPageRoute,
                  //             arguments: DeviceDetailsParams(
                  //                 deviceID: widget.device.id));
                  //       },
                  //       child: Icon(
                  //         Icons.arrow_forward_rounded,
                  //         color: AppColors.eucalyptusColor,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  Row(
                    children: [
                      Expanded(
                        child: _infoView(
                          context,
                          title: "warranty_status".tr,
                          info: widget.summary.warrantyType.getDisplayValue(
                              AppLocalizations.getLocale(context)),
                        ),
                      ),
                      // Expanded(
                      //   child: _infoView(
                      //     context,
                      //     title: "sales_return".tr,
                      //     info:
                      //         widget.device.isSalesReturn ? "yes".tr : "no".tr,
                      //   ),
                      // )
                    ],
                  ),
                ],
              ),
            ),
            AnimatedCrossFade(
              sizeCurve: _animationCurve,
              firstChild: SizedBox(
                width: double.infinity,
              ),
              secondChild: Column(
                children: [
                  _itemsTeble(),
                  Padding(
                    padding: const EdgeInsets.all(AppConstants.mediumPadding),
                    child: Row(
                      children: [
                        Expanded(
                          child: _infoView(
                            context,
                            title: 'work_duration'.tr,
                            info: widget.summary.time,
                          ),
                        ),
                        Expanded(
                          child: _infoView(
                            context,
                            title: 'op_cost'.tr,
                            info: widget.summary.totalOpeationalCost,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              crossFadeState: _crossFadeState,
              duration: _animationDuration,
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.mediumPadding),
                  child: Row(
                    children: [
                      RichText(
                        text: TextSpan(
                          text: "${'cost'.tr}. ",
                          children: [
                            TextSpan(
                                text: widget.summary.totalCost,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                      fontWeight: FontWeight.w900,
                                      decorationStyle:
                                          TextDecorationStyle.solid,
                                      decorationThickness: 2,
                                      decoration: _isCalculated
                                          ? TextDecoration.lineThrough
                                          : null,
                                      color: AppColors.eucalyptusColor,
                                    ))
                          ],
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                ),
                AnimatedRotation(
                  duration: _animationDuration,
                  curve: _animationCurve,
                  alignment: Alignment.center,
                  turns: _crossFadeState == CrossFadeState.showFirst ? 0 : .5,
                  child: SizedBox.square(
                      dimension: 40,
                      child: Icon(
                        Icons.keyboard_arrow_down_rounded,
                      )),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _infoView(BuildContext context,
      {required String title, required String info}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context)
                .textTheme
                .titleSmall!
                .copyWith(color: AppColors.eucalyptusColor)),
        Padding(
          padding: const EdgeInsets.only(top: AppConstants.smallPadding),
          child: Text(
            info,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        )
      ],
    );
  }

  Widget _itemsTeble() {
    return Column(
      children: [
        Table(
          border: TableBorder.all(
              borderRadius:
                  BorderRadius.circular(AppConstants.extraSmallPadding),
              color: AppColors.whiteColor),
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          columnWidths: const <int, TableColumnWidth>{
            // 0: FractionColumnWidth(.25),
            0: FractionColumnWidth(.50),
            1: FractionColumnWidth(.15),
            2: FractionColumnWidth(.35),
          },
          children: <TableRow>[
            _buildTableHeader(),
            // for (int index = 0; index <  widget.device.items.length; index++)
            for (int index = 0; index < widget.summary.items.length; index++)
              TableRow(
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                        bottom:
                            Radius.circular(AppConstants.extraSmallPadding)),
                    color: AppColors.linkWaterColor),
                children: <Widget>[
                  _buildTableCell(
                      child: Text(
                    widget.summary.items.elementAt(index).name ?? '',
                    textAlign: TextAlign.center,
                  )),
                  _buildTableCell(
                      child: Text(
                    widget.summary.items.elementAt(index).qty.toString(),
                    textAlign: TextAlign.center,
                  )),
                  _buildTableCell(
                      child: Text(
                    widget.summary.items.elementAt(index).price,
                    textAlign: TextAlign.center,
                  )),
                ],
              ),
            if (widget.summary.items.isNotEmpty)
              TableRow(
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                        bottom:
                            Radius.circular(AppConstants.extraSmallPadding)),
                    color: AppColors.linkWaterColor),
                children: <Widget>[
                  _buildTableCell(child: SizedBox()),
                  _buildTableCell(child: SizedBox()),
                  _buildTableCell(
                      child: Text(
                    widget.summary.totalItemsCost,
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontWeight: FontWeight.bold),
                  )),
                ],
              ),
          ],
        ),
        widget.summary.items.isEmpty
            ? DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(AppConstants.extraSmallPadding),
                  border: Border.all(color: AppColors.whiteColor),
                  color: AppColors.linkWaterColor,
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: AppConstants.smallPadding),
                    child: Text('no_items'.tr),
                  ),
                ),
              )
            : SizedBox.shrink()
      ],
    );
  }

  TableRow _buildTableHeader() {
    return TableRow(
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppConstants.extraSmallPadding)),
          color: AppColors.linkWaterColor),
      children: <Widget>[
        // _buildTableCell(
        //     child: const Text("NO.",
        //         style: TextStyle(fontWeight: FontWeight.w600))),
        _buildTableCell(
            child: Text(
          "${'item_name'.tr}",
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.w600),
        )),
        _buildTableCell(
            child: Text(
          "${'qty'.tr}",
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.w600),
        )),
        _buildTableCell(
            child: Text(
          "${'price'.tr}",
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
