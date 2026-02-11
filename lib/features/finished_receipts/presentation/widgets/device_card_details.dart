import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:tech_care_app/app/app_localization.dart';
import 'package:tech_care_app/core/util/app_colors.dart';
import 'package:tech_care_app/core/util/app_constants.dart';
import 'package:tech_care_app/core/util/helpers/round_num.dart';
import 'package:tech_care_app/core/widgets/custom_text_form_field.dart';
import 'package:tech_care_app/features/finished_receipts/domain/entities/device_delivery_report.dart';
import 'package:tech_care_app/features/finished_receipts/presentation/finishing_report_bloc/finishing_report_bloc.dart';
import 'package:tech_care_app/routes/app_router.dart';
import 'package:tech_care_app/routes/app_routes.dart';
import 'package:tech_care_app/routes/route_params.dart';

class DeviceCardDetails extends StatefulWidget {
  final DeviceDeliveryReport device;
  final FinishingReportBloc bloc;
  // final void Function(String?)? onAmountFieldSaved;
  // final void Function(String?)? onAmountFieldChanged;

  const DeviceCardDetails({
    super.key,
    required this.bloc,
    required this.device,
    // required this.onAmountFieldSaved,
    // required this.onAmountFieldChanged,
  });

  @override
  _ExpandableCardDemoState createState() => _ExpandableCardDemoState();
}

class _ExpandableCardDemoState extends State<DeviceCardDetails> {
  late CrossFadeState _crossFadeState;
  final Duration _animationDuration = Durations.medium4;
  final Curve _animationCurve = Curves.easeInOut;
  late final FocusNode _focusNode;
  late final TextEditingController _amountController;

  @override
  void initState() {
    _crossFadeState = CrossFadeState.showFirst;
    _focusNode = FocusNode();
    _amountController = TextEditingController(text: widget.device.fixedCost);
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        num amount;
        try {
          amount = num.parse(_amountController.text.trim());
          amount = roundNum(amount, 2);
          _amountController.text = amount.toString();
        } catch (e) {
          amount = 0;
          _amountController.text = '';
        }
        widget.bloc.add(UpdateDeviceAmountReceived(
            deviceId: widget.device.id, amount: amount));
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _toggleCard() {
    setState(() {
      _crossFadeState = _crossFadeState == CrossFadeState.showFirst
          ? CrossFadeState.showSecond
          : CrossFadeState.showFirst;
    });
  }

  bool get _isCalculated => (widget.device.warrantyType.object == 'in' ||
          widget.device.warrantyType.object == 're')
      ? true
      : false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      margin: EdgeInsets.only(bottom: AppConstants.mediumPadding),
      duration: _animationDuration,
      curve: _animationCurve,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(AppConstants.mediumPadding),
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
              padding: const EdgeInsets.all(AppConstants.smallPadding),
              child: Column(
                children: [
                  _buildCardHeader(context),
                  Row(
                    children: [
                      Expanded(
                        child: _infoView(
                          context,
                          title: "warranty_status".tr,
                          info: widget.device.warrantyType.getDisplayValue(
                              AppLocalizations.getLocale(context)),
                        ),
                      ),
                      Expanded(
                        child: _infoView(
                          context,
                          title: "sales_return".tr,
                          info:
                              widget.device.isSalesReturn ? "yes".tr : "no".tr,
                        ),
                      )
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
                    padding: const EdgeInsets.all(AppConstants.smallPadding),
                    child: Row(
                      children: [
                        Expanded(
                          child: _infoView(
                            context,
                            title: 'work_duration'.tr,
                            info: widget.device.time,
                          ),
                        ),
                        Expanded(
                          child: _infoView(
                            context,
                            title: 'op_cost'.tr,
                            info: widget.device.totalOpeationalCost,
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
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.smallPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _infoView(context,
                            title: 'cost'.tr,
                            info: widget.device.totalCost,
                            linethrough: !_isCalculated),
                      ),
                      Expanded(
                        child: _infoView(
                          context,
                          title: 'fixed_cost'.tr,
                          info: widget.device.fixedCost,
                        ),
                      ),
                    ],
                  ),
                  _buildAmountReceived(context),
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
        ),
      ),
    );
  }

  Row _buildAmountReceived(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: AppConstants.smallPadding),
          child: Text("${'amount_received'.tr}. ",
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontWeight: FontWeight.w700)),
        ),
        Gap(AppConstants.smallPadding),
        Expanded(
          child: CustomTextFormField(
            controller: _amountController,
            focusNode: _focusNode,
            hintText: '0.0',
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            labelStyle: Theme.of(context).textTheme.titleMedium,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.w900,
                decorationStyle: TextDecorationStyle.solid,
                decorationThickness: 2,
                color: AppColors.eucalyptusColor),
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                RegExp(r'^\d*\.?\d*$'),
              )
            ],
            validator: (value) =>
                (value?.isEmpty ?? true) || value == '.' ? 'required'.tr : null,
            //   onSaved: widget.onAmountFieldSaved,
            //   onChanged: widget.onAmountFieldChanged,
          ),
        ),
      ],
    );
  }

  Row _buildCardHeader(BuildContext context) {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Icon(Icons.qr_code_rounded, size: 22),
        Gap(AppConstants.extraSmallPadding),
        Expanded(
          child: Text(
            widget.device.deviceCode,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        FloatingActionButton.small(
          backgroundColor: AppColors.alabasterColor,
          elevation: 2,
          heroTag: 'goto${widget.device.id}',
          onPressed: () {
            AppRouter.navigator.pushNamed(AppRoutes.deviceDetailsPageRoute,
                arguments: DeviceDetailsParams(deviceID: widget.device.id));
          },
          child: Icon(
            Icons.arrow_forward_rounded,
            color: AppColors.eucalyptusColor,
          ),
        ),
      ],
    );
  }

  RichText _buildDeviceCostInfo(BuildContext context,
      {required String title, required String? cost}) {
    return RichText(
      text: TextSpan(
        text: title,
        children: [
          TextSpan(
              text: cost,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.w900,
                  decorationStyle: TextDecorationStyle.solid,
                  decorationThickness: 2,
                  decoration: _isCalculated ? TextDecoration.lineThrough : null,
                  color: AppColors.eucalyptusColor))
        ],
        style: Theme.of(context)
            .textTheme
            .titleMedium!
            .copyWith(fontWeight: FontWeight.w700),
      ),
    );
  }

  Widget _infoView(BuildContext context,
      {required String title, required String info, bool linethrough = false}) {
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
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  decoration: linethrough ? TextDecoration.lineThrough : null,
                ),
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
              borderRadius: BorderRadius.circular(5),
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
            for (int index = 0; index < widget.device.items.length; index++)
              TableRow(
                decoration: const BoxDecoration(
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(5)),
                    color: AppColors.linkWaterColor),
                children: <Widget>[
                  _buildTableCell(
                      child: Text(
                    widget.device.items.elementAt(index).name ?? '',
                    textAlign: TextAlign.center,
                  )),
                  // _buildTableCell(child: Text("HKV-123-VN")),
                  _buildTableCell(
                      child: Text(
                    widget.device.items.elementAt(index).qty.toString(),
                    textAlign: TextAlign.center,
                  )),
                  _buildTableCell(
                      child: Text(
                    widget.device.items.elementAt(index).price,
                    textAlign: TextAlign.center,
                  )),
                ],
              ),
            if (widget.device.items.isNotEmpty)
              TableRow(
                decoration: const BoxDecoration(
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(5)),
                    color: AppColors.linkWaterColor),
                children: <Widget>[
                  _buildTableCell(child: SizedBox()),
                  _buildTableCell(child: SizedBox()),
                  _buildTableCell(
                      child: Text(
                    widget.device.totalItemsCost,
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
        widget.device.items.isEmpty
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
            : SizedBox.shrink()
      ],
    );
  }

  TableRow _buildTableHeader() {
    return TableRow(
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(5)),
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
