import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:tech_care_app/app/app_localization.dart';
import 'package:tech_care_app/core/util/app_colors.dart';
import 'package:tech_care_app/core/util/app_constants.dart';
import 'package:tech_care_app/core/widgets/error_message_widget.dart';
import 'package:tech_care_app/core/widgets/loading_indicator.dart';
import 'package:tech_care_app/dependency_injection.dart';
import 'package:tech_care_app/features/receipts_container_details/domain/entities/device_payment_details.dart';
import 'package:tech_care_app/features/receipts_container_details/presentation/bloc/device_payment_details_bloc/device_payment_details_bloc.dart';
import 'package:tech_care_app/routes/app_router.dart';
import 'package:tech_care_app/routes/app_routes.dart';
import 'package:tech_care_app/routes/route_params.dart';

class DevicePaymentDetailsPage extends StatelessWidget {
  final int deviceId;
  DevicePaymentDetailsPage({required this.deviceId, super.key});

  static Route<int> route({required int params, RouteSettings? settings}) =>
      MaterialPageRoute(
          settings: settings,
          builder: (context) => DevicePaymentDetailsPage(
                deviceId: params,
              ));

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di<DevicePaymentDetailsBloc>()
        ..add(LoadDevicePeymentDetails(deviceId: deviceId)),
      child: DevicePaymentDetailsView(
        deviceId: deviceId,
      ),
    );
  }
}

class DevicePaymentDetailsView extends StatelessWidget {
  final int deviceId;
  const DevicePaymentDetailsView({
    required this.deviceId,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('device_payment_details'.tr),
      ),
      body: BlocBuilder<DevicePaymentDetailsBloc, DevicePaymentDetailsState>(
        builder: (context, state) {
          if (state.isLoading) {
            return LoadingIndicator();
          }
          if (state is DevicePaymentDetailsErrorState) {
            return ErrorMessageWidget(
              errorMessage: state.errorMessage!,
              onRetry: () {
                context
                    .read<DevicePaymentDetailsBloc>()
                    .add(LoadDevicePeymentDetails(deviceId: deviceId));
              },
            );
          }
          return RefreshIndicator(
            onRefresh: () async => context
                .read<DevicePaymentDetailsBloc>()
                .add(LoadDevicePeymentDetails(deviceId: deviceId)),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppConstants.mediumPadding),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: _infoView(
                          context,
                          title: "device_code".tr,
                          info: state.devicePaymentDetails!.deviceCode,
                        ),
                      ),
                      TextButton(
                        // color: AppColors.funBlueColor,
                        // shape: RoundedRectangleBorder(
                        //     borderRadius: BorderRadius.circular(
                        //         AppConstants.mediumPadding)),

                        onPressed: () {
                          AppRouter.navigator
                              .pushNamed(AppRoutes.deviceDetailsPageRoute,
                                  arguments: DeviceDetailsParams(
                                    deviceID: deviceId,
                                  ));
                        },
                        child: Text(
                          "show_device".tr,
                          style: TextStyle(color: AppColors.funBlueColor),
                        ),
                      ),
                    ],
                  ),
                  Gap(AppConstants.mediumPadding),
                  // Row(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     Expanded(
                  //         child: _infoView(
                  //       context,
                  //       title: "warranty_status".tr,
                  //       info: "ضمن الكفالة",
                  //     )),
                  //     Gap(AppConstants.smallPadding),
                  //     Expanded(
                  //         child: _infoView(
                  //       context,
                  //       title: "sales_return".tr,
                  //       info: "no".tr,
                  //     ))
                  //   ],
                  // ),
                  // Gap(AppConstants.mediumPadding),
                  _itemsTeble(context, state.devicePaymentDetails!),
                  Gap(AppConstants.mediumPadding),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          child: _infoView(
                        context,
                        title: 'work_duration'.tr,
                        info: state.devicePaymentDetails!.totalTime,
                      )),
                      Gap(AppConstants.smallPadding),
                      Expanded(
                          child: _infoView(
                        context,
                        title: 'op_cost'.tr,
                        info: state.devicePaymentDetails!.operationalCost,
                      ))
                    ],
                  ),
                  const Gap(AppConstants.mediumPadding),
                  RichText(
                    text: TextSpan(
                      text: "${'expected_amount'.tr}. ",
                      children: [
                        TextSpan(
                            text: state.devicePaymentDetails!.totalCost,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: AppColors.eucalyptusColor))
                      ],
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  const Gap(AppConstants.mediumPadding),
                  RichText(
                    text: TextSpan(
                      text: "${'total_payment'.tr}. ",
                      children: [
                        TextSpan(
                            text: state.devicePaymentDetails!.paidAmount,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.eucalyptusColor))
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
          );
        },
      ),
    );
  }

  Widget _itemsTeble(
      BuildContext context, DevicePaymentDetails devicePaymentDetails) {
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
            for (int index = 0;
                index < devicePaymentDetails.usedItem.length;
                index++)
              TableRow(
                decoration: const BoxDecoration(
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(5)),
                    color: AppColors.linkWaterColor),
                children: <Widget>[
                  _buildTableCell(
                      child: Text(
                    devicePaymentDetails.usedItem.elementAt(index).name ?? '',
                    textAlign: TextAlign.center,
                  )),
                  // _buildTableCell(child: Text("HKV-123-VN")),
                  _buildTableCell(
                      child: Text(
                    devicePaymentDetails.usedItem
                        .elementAt(index)
                        .qty
                        .toString(),
                    textAlign: TextAlign.center,
                  )),
                  _buildTableCell(
                      child: Text(
                    devicePaymentDetails.usedItem.elementAt(index).cost,
                    textAlign: TextAlign.center,
                  )),
                ],
              ),
            if (devicePaymentDetails.usedItem.isNotEmpty)
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
                    devicePaymentDetails.itemsCost,
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
        devicePaymentDetails.usedItem.isEmpty
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

  Widget _infoView(
    BuildContext context, {
    required final String title,
    required String info,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(color: AppColors.eucalyptusColor)),
        Row(
          children: [
            // const Gap(10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  info,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
