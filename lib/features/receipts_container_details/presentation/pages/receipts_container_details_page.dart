import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:tech_care_app/app/app_localization.dart';
import 'package:tech_care_app/core/util/app_colors.dart';
import 'package:tech_care_app/core/util/app_constants.dart';
import 'package:tech_care_app/core/util/app_strings.dart';
import 'package:tech_care_app/core/util/helpers/app_url_launcher.dart';
import 'package:tech_care_app/core/widgets/custom_phone_view.dart';
import 'package:tech_care_app/core/widgets/custom_pop_up_menu_button.dart';
import 'package:tech_care_app/core/widgets/dialogs/communication_dialog.dart';
import 'package:tech_care_app/core/widgets/error_message_widget.dart';
import 'package:tech_care_app/core/widgets/loading_indicator.dart';
import 'package:tech_care_app/dependency_injection.dart';
import 'package:tech_care_app/features/receipts_container_details/domain/entities/device_info.dart';
import 'package:tech_care_app/features/receipts_container_details/domain/entities/payment.dart';
import 'package:tech_care_app/features/receipts_container_details/presentation/bloc/receipts_container_details_bloc/receipts_container_details_bloc.dart';
import 'package:tech_care_app/features/receipts_container_details/presentation/widgets/device_card.dart';
import 'package:tech_care_app/routes/app_router.dart';
import 'package:tech_care_app/routes/app_routes.dart';
import 'package:tech_care_app/routes/route_params.dart';

class ReceiptsContainerDetailsPage extends StatefulWidget {
  final int containerId;
  final ContainerDisplayType displayType;
  const ReceiptsContainerDetailsPage(
      {super.key, required this.containerId, required this.displayType});

  static Route<dynamic> route(
          {required ContainerDetailsParams params, RouteSettings? settings}) =>
      MaterialPageRoute(
          settings: settings,
          builder: (context) => ReceiptsContainerDetailsPage(
                containerId: params.containerId,
                displayType: params.type,
              ));

  @override
  State<ReceiptsContainerDetailsPage> createState() =>
      _ReceiptsContainerDetailsPageState();
}

class _ReceiptsContainerDetailsPageState
    extends State<ReceiptsContainerDetailsPage> {
  late final ReceiptsContainerDetailsBloc _bloc;

  @override
  void initState() {
    _bloc = di<ReceiptsContainerDetailsBloc>();
    _getContainerDetails();

    super.initState();
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  _getContainerDetails() {
    _bloc.add(LoadContainerDetails(
      containerId: widget.containerId,
      displayType: widget.displayType,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReceiptsContainerDetailsBloc,
        ReceiptsContainerDetailsState>(
      bloc: _bloc,
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text('receipt_details'.tr),
            // actions: state.pageLoading
            //     ? []
            //     : [
            //         IconButton(
            //           onPressed: () {
            //             _getContainerDetails();
            //           },
            //           icon: Padding(
            //             padding: const EdgeInsets.all(10.0),
            //             child: Icon(
            //               Icons.replay_rounded,
            //             ),
            //           ),
            //         ),
            //       ],
          ),
          body: state.pageLoading
              ? Center(child: LoadingIndicator())
              : state is ReceiptsContainerDetailsErrorState
                  ? ErrorMessageWidget(
                      onRetry: () {
                        _getContainerDetails();
                      },
                      errorMessage: state.errorMessage)
                  : RefreshIndicator(
                      onRefresh: () async {
                        _getContainerDetails();
                      },
                      child: ListView(
                        padding: EdgeInsets.all(AppConstants.mediumPadding),
                        children: [
                          _buildContainerMainInfo(state),
                          Gap(AppConstants.largePadding),
                          ..._buildPaymentsInfo(state),
                          Gap(AppConstants.largePadding),
                          ..._buildContainerDevices(context,
                              devices: state.containerDetails?.devices ?? []),
                        ],
                      ),
                    ),
        );
      },
    );
  }

  Widget _buildContainerMainInfo(ReceiptsContainerDetailsState state) {
    return Container(
      padding: EdgeInsets.all(AppConstants.mediumPadding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppConstants.mediumPadding),
        color: AppColors.whiteColor,
      ),
      child: Material(
        color: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildInfo(
                      prefixHeight: 26,
                      prefix: Image.asset(AppStrings.barcodeIconPath),
                      Info: Text(state.containerDetails?.receiptNumber ?? '',
                          style: Theme.of(context).textTheme.titleSmall)),
                ),
                CustomPopupMenuButton<String>(
                  icon: Icon(
                    Icons.adaptive.more,
                    size: 18,
                  ),
                  popupMenuItems: [
                    PopupMenuItem(
                      height: 25,
                      onTap: () {
                        AppRouter.navigator.pushNamed(
                          AppRoutes.editContainerReceiptPageRoute,
                          arguments: ReceiptContainerDetailsParams(
                              containerDetails: state.containerDetails!),
                        );
                      },
                      child: Text('edit'.tr),
                    ),

                    PopupMenuItem(
                      height: 25,
                      onTap: () {
                        appUrlLauncher(
                            state.containerDetails!.receiptPrintingUrl);
                      },
                      child: Text('print_receipt'.tr),
                    ),
                    // PopupMenuItem(
                    //     onTap: () {

                    //     },
                    //     child: Text(
                    //         'delete'.tr))
                  ],
                )
              ],
            ),
            Gap(AppConstants.smallPadding),
            Row(
              children: [
                Expanded(
                  child: _buildInfo(
                      prefixHeight: 26,
                      prefix: Image.asset(AppStrings.personIconPath),
                      Info: Text(state.containerDetails?.customerName ?? '',
                          style: Theme.of(context).textTheme.titleSmall)),
                ),
                Expanded(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(100),
                    onTap: () => CommunicationDialog.show(context,
                        phone: state.containerDetails?.customerPhone ?? ''),
                    child: _buildInfo(
                        prefixHeight: 26,
                        prefix: Image.asset(AppStrings.phoneIconPath),
                        Info: CustomPhoneView(
                          phone: state.containerDetails?.customerPhone ?? '',
                          style: Theme.of(context).textTheme.titleSmall,
                        )),
                  ),
                ),
              ],
            ),
            Gap(AppConstants.smallPadding),
            Divider(
              thickness: .5,
              height: 0,
              endIndent: 100,
            ),
            Gap(AppConstants.smallPadding),
            _buildInfo(
                prefixHeight: 26,
                prefix: Image.asset(AppStrings.priorityIconPath),
                Info: Text(
                    '${state.containerDetails?.priority.tr}' +
                        ((state.containerDetails?.priorityShippingNumber == null
                            ? ''
                            : ' - ${state.containerDetails?.priorityShippingNumber}')),
                    style: Theme.of(context).textTheme.titleSmall)),
            Gap(AppConstants.smallPadding),
            _buildInfo(
              prefixHeight: 26,
              prefix: Image.asset(AppStrings.datetimeIconPath),
              Info: Text(
                DateFormat('dd/MM/yyyy hh:mm a')
                    .format(state.containerDetails?.date ?? DateTime.now()),
                style: Theme.of(context).textTheme.titleSmall!,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildPaymentsInfo(ReceiptsContainerDetailsState state) {
    return [
      RichText(
        text: TextSpan(
          text: '${'payments'.tr} ',
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontWeight: FontWeight.bold),
          children: <TextSpan>[
            TextSpan(
                text: '(${state.containerDetails!.payments.length})',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      Gap(AppConstants.mediumPadding),
      ClipRRect(
        borderRadius: BorderRadius.circular(AppConstants.mediumPadding),
        clipBehavior: Clip.hardEdge,
        child: Material(
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: Column(
                children: state.containerDetails!.payments
                    .map<ExpansionTile>(_buildPaymentWidget)
                    .toList()),
          ),
        ),
      ),
    ];
  }

  ExpansionTile _buildPaymentWidget(Payment payment) {
    return ExpansionTile(
      dense: true,
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      expandedAlignment: Alignment.centerLeft,
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            payment.amount,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: AppColors.eucalyptusColor, fontWeight: FontWeight.bold),
          ),
          Spacer(),
          Text(
            DateFormat('dd/MM/yyyy').format(payment.date),
          ),
        ],
      ),
      subtitle: Text("${'expected_amount'.tr} ${payment.expectedCost}",
          style: TextStyle(color: Colors.black54)),
      children: [
        SizedBox(width: double.infinity),
        Text(
          'note'.tr,
          style: TextStyle(color: Colors.black54),
        ),
        Gap(AppConstants.extraSmallPadding),
        Text(
          payment.note ?? '',
        ),
        const Gap(AppConstants.mediumPadding),
        Text(
          'devices'.tr,
          style: TextStyle(color: Colors.black54),
        ),
        const Gap(AppConstants.extraSmallPadding),
        Wrap(
            spacing: AppConstants.smallPadding,
            runSpacing: AppConstants.extraSmallPadding,
            children: payment.devices
                .map(
                  (device) => FilledButton(
                    style: ButtonStyle(
                        padding: MaterialStatePropertyAll(EdgeInsets.symmetric(
                            horizontal: AppConstants.mediumPadding)),
                        backgroundColor: MaterialStateProperty.all(
                            AppColors.funBlueColor.withOpacity(.85))),
                    child: Text(device.deviceCode),
                    onPressed: () {
                      AppRouter.navigator.pushNamed(
                          AppRoutes.devicePaymentDetailsPage,
                          arguments: device.id);
                    },
                  ),
                )
                .toList()),
      ],
    );
  }

  Row _buildInfo(
      {double? prefixHeight = 20,
      required Widget prefix,
      required Widget Info}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: prefixHeight, width: 20, child: prefix),
        Gap(AppConstants.extraSmallPadding),
        Expanded(child: Info),
      ],
    );
  }

  List<Widget> _buildContainerDevices(BuildContext context,
      {required List<DeviceInfo> devices}) {
    return [
      Row(
        children: [
          Expanded(
            child: RichText(
              text: TextSpan(
                text: 'devices'.tr,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontWeight: FontWeight.bold),
                children: <TextSpan>[
                  TextSpan(
                      text: '(${devices.length})',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
          widget.displayType == ContainerDisplayType.finished &&
                  devices.isNotEmpty
              ? TextButton(
                  onPressed: () {
                    AppRouter.navigator.pushNamed(
                      AppRoutes.finishingReportPageRoute,
                      arguments: widget.containerId,
                    );
                  },
                  child: Text(
                    'finish'.tr,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: AppColors.eucalyptusColor),
                  ))
              : SizedBox(),
        ],
      ),
      Gap(AppConstants.mediumPadding),
      ListView.separated(
        primary: false,
        shrinkWrap: true,
        itemCount: devices.length,
        itemBuilder: (context, index) =>
            DeviceCard(deviceInfo: devices.elementAt(index)),
        separatorBuilder: (context, index) => Gap(AppConstants.mediumPadding),
      )
    ];
  }
}

enum ContainerDisplayType {
  all,
  finished,
}
