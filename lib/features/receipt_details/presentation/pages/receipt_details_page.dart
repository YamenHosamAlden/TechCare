import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:tech_care_app/app/app_localization.dart';
import 'package:tech_care_app/core/util/app_colors.dart';
import 'package:tech_care_app/core/util/app_constants.dart';
import 'package:tech_care_app/core/util/app_strings.dart';
import 'package:tech_care_app/core/widgets/custom_phone_view.dart';
import 'package:tech_care_app/core/widgets/dialogs/communication_dialog.dart';
import 'package:tech_care_app/core/widgets/error_message_widget.dart';
import 'package:tech_care_app/core/widgets/loading_indicator.dart';
import 'package:tech_care_app/dependency_injection.dart';
import 'package:tech_care_app/features/receipt_details/domain/entities/device_info.dart';
import 'package:tech_care_app/features/receipt_details/domain/entities/receipt_details.dart';
import 'package:tech_care_app/features/receipt_details/presentation/bloc/receipt_details_bloc.dart';
import 'package:tech_care_app/core/widgets/dialogs/codes_validation_scanner_dialog.dart';
import 'package:tech_care_app/features/receipt_details/presentation/widgets/device_card.dart';
import 'package:tech_care_app/features/receipts/presentation/widgets/receipt_card.dart';
import 'package:tech_care_app/routes/app_router.dart';
import 'package:tech_care_app/routes/app_routes.dart';
import 'package:tech_care_app/routes/route_params.dart';

class ReceiptDetailsPage extends StatefulWidget {
  final int? receiptID;
  final String? deviceCode;
  final ReceiptDisplayType receiptDisplayType;
  const ReceiptDetailsPage(
      {super.key,
      required this.receiptID,
      required this.deviceCode,
      required this.receiptDisplayType});

  static Route<dynamic> route(
          {required ReceiptDetailsParams params, RouteSettings? settings}) =>
      MaterialPageRoute(
        settings: settings,
        builder: (context) => ReceiptDetailsPage(
          receiptID: params.receiptID,
          deviceCode: params.deviceCode,
          receiptDisplayType: params.receiptDisplayType,
        ),
      );

  @override
  State<ReceiptDetailsPage> createState() => _ReceiptDetailsPageState();
}

class _ReceiptDetailsPageState extends State<ReceiptDetailsPage> {
  late final ReceiptDetailsBloc _bloc;

  @override
  void initState() {
    _bloc = di<ReceiptDetailsBloc>();
    _getReceiptDetails();
    super.initState();
  }

  _getReceiptDetails() {
    if (widget.deviceCode != null) {
      print('get receipt by device code');
      _bloc.add(GetReceiptDetailsByDeviceCode(
          deviceCode: widget.deviceCode!,
          receiptDisplayType: widget.receiptDisplayType));
    } else {
      print('get receipt by receipt id');

      _bloc.add(GetReceiptDetailsByReceiptId(
          receiptId: widget.receiptID!,
          receiptDisplayType: widget.receiptDisplayType));
    }
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _bloc,
      child: BlocConsumer<ReceiptDetailsBloc, ReceiptDetailsState>(
        bloc: _bloc,
        listener: (BuildContext context, ReceiptDetailsState state) {
          if (state is ReceiptReceivedState) {
            // Navigator.popUntil(context,
            //     (route) => route.settings.name == AppRoutes.receiptsPageRoute);
            AppRouter.navigator.popUntil(
                (route) => route.settings.name == AppRoutes.receiptsPageRoute);
            AppRouter.navigator.pushNamed(AppRoutes.receiptDetailsPageRoute,
                arguments: ReceiptDetailsParams(
                  receiptID: widget.receiptID,
                  receiptDisplayType: ReceiptDisplayType.received,
                ));
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text('receipt_details'.tr),
              // actions: state.isLoading
              //     ? []
              //     : [
              //         IconButton(
              //           onPressed: () {
              //             _getReceiptDetails();
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
            body: state.isLoading
                ? LoadingIndicator()
                : state is ReceiptDetailsErrorState
                    ? ErrorMessageWidget(
                        errorMessage: state.errorMessage,
                      )
                    : RefreshIndicator(
                        onRefresh: () async {
                          _getReceiptDetails();
                        },
                        child: ListView(
                          padding: EdgeInsets.all(AppConstants.mediumPadding),
                          children: [
                            _buildReceiptInfo(context,
                                receiptDetails: state.receiptDetails!),
                            Gap(AppConstants.largePadding),
                            ..._buildReceiptDevices(context,
                                devices: state.receiptDetails?.device ?? []),
                          ],
                        ),
                      ),
          );
        },
      ),
    );
  }

  _buildReceiptInfo(BuildContext context,
      {required ReceiptDetails receiptDetails}) {
    return Container(
      padding: EdgeInsets.all(AppConstants.mediumPadding),
      decoration: BoxDecoration(
          color: AppColors.whiteColor, borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMainInfo(
            context,
            receiptNumber: receiptDetails.receiptNumber,
            createdAt: receiptDetails.createdAt,
            createdBy: receiptDetails.createdBy,
          ),
          Divider(
            height: AppConstants.mediumPadding * 2,
            endIndent: 100,
            color: AppColors.altoColor,
          ),
          _buildSubInfo(
            customerName: receiptDetails.customerName,
            customerPhone: receiptDetails.customerPhone,
            priority: receiptDetails.priority
                .getDisplayValue(AppLocalizations.getLocale(context)),
            shippingNumber: receiptDetails.shippingNumber,
            groupName: receiptDetails.groupName,
            assignTo: receiptDetails.assignTo,
          ),
        ],
      ),
    );
  }

  Row _buildInfo({
    double? prefixHeight = 20,
    required Widget prefix,
    required Widget Info,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: prefixHeight,
          width: 20,
          child: prefix,
        ),
        Gap(AppConstants.extraSmallPadding),
        Expanded(child: Info),
      ],
    );
  }

  _buildMainInfo(
    BuildContext context, {
    required String receiptNumber,
    required DateTime createdAt,
    required String createdBy,
  }) {
    return Column(
      children: [
        _buildInfo(
            prefixHeight: 26,
            prefix: Image.asset(AppStrings.barcodeIconPath),
            Info: Text(receiptNumber,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontWeight: FontWeight.bold))),
        Gap(AppConstants.smallPadding),
        _buildInfo(
            prefixHeight: 26,
            prefix: Image.asset(AppStrings.datetimeIconPath),
            Info: Text(DateFormat('dd/MM/yyyy hh:mm a').format(createdAt),
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontWeight: FontWeight.bold))),
        Gap(AppConstants.smallPadding),
        _buildInfo(
            prefixHeight: 26,
            prefix: Image.asset(AppStrings.personIconPath),
            Info: Text(createdBy,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontWeight: FontWeight.bold))),
      ],
    );
  }

  Widget _buildSubInfo({
    required String customerName,
    required String customerPhone,
    required String priority,
    required String? shippingNumber,
    required String groupName,
    required String? assignTo,
  }) {
    final prefix = Icon(
      Icons.circle,
      size: 10,
      color: AppColors.linkWaterColor,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'customer_info'.tr,
          style: TextStyle(color: AppColors.eucalyptusColor),
        ),
        Gap(AppConstants.smallPadding),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                child: _buildInfo(prefix: prefix, Info: Text(customerName))),
            Gap(AppConstants.smallPadding),
            Expanded(
                child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                        borderRadius: BorderRadius.circular(100),
                        onTap: () => CommunicationDialog.show(context,
                            phone: customerPhone),
                        child: _buildInfo(
                            prefix: prefix,
                            Info: CustomPhoneView(phone: customerPhone))))),
          ],
        ),
        Gap(AppConstants.mediumPadding),
        Text(
          'priority'.tr,
          style: TextStyle(color: AppColors.eucalyptusColor),
        ),
        Gap(AppConstants.smallPadding),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildInfo(prefix: prefix, Info: Text(priority))),
            ...shippingNumber == null
                ? []
                : [
                    Gap(AppConstants.smallPadding),
                    Expanded(
                        child: _buildInfo(
                            prefix: prefix, Info: Text(shippingNumber)))
                  ],
          ],
        ),
        Gap(AppConstants.mediumPadding),
        Text(
          'assignment'.tr,
          style: TextStyle(color: AppColors.eucalyptusColor),
        ),
        Gap(AppConstants.smallPadding),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildInfo(prefix: prefix, Info: Text(groupName))),
            ...assignTo == null || assignTo.isEmpty
                ? []
                : [
                    Gap(AppConstants.smallPadding),
                    Expanded(
                        child: _buildInfo(prefix: prefix, Info: Text(assignTo)))
                  ],
          ],
        ),
      ],
    );
  }

  List<Widget> _buildReceiptDevices(BuildContext context,
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
          widget.receiptDisplayType == ReceiptDisplayType.received ||
                  widget.receiptDisplayType == ReceiptDisplayType.display
              ? SizedBox()
              : TextButton(
                  onPressed: () {
                    showDialog<List<String>?>(
                      context: context,
                      builder: (context) => CodesValidationScannerDialog(
                        codes: _getRceivableDevicesCodes(devices),
                      ),
                    ).then((scannedCodes) {
                      if (scannedCodes?.isNotEmpty ?? false) {
                        _bloc.add(ReceiveDevices(
                          devicesCodes: scannedCodes!,
                          receiptDisplayType: widget.receiptDisplayType,
                        ));
                      }
                    });
                  },
                  child: Text(
                    'receive'.tr,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: AppColors.eucalyptusColor),
                  ),
                )
        ],
      ),
      Gap(AppConstants.mediumPadding),
      ListView.separated(
        primary: false,
        shrinkWrap: true,
        itemBuilder: (context, index) => DeviceCard(
          deviceInfo: devices.elementAt(index),
        ),
        separatorBuilder: (context, index) => Gap(AppConstants.mediumPadding),
        itemCount: devices.length,
      )
    ];
  }

  List<String> _getRceivableDevicesCodes(List<DeviceInfo> devices) {
    return devices
        .where((device) => device.assignId == null)
        .map((device) => device.deviceCode)
        .toList();
  }
}
