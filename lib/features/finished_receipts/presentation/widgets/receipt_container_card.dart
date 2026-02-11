import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:tech_care_app/core/util/app_colors.dart';
import 'package:tech_care_app/core/util/app_constants.dart';
import 'package:tech_care_app/core/util/app_strings.dart';
import 'package:tech_care_app/core/widgets/custom_phone_view.dart';
import 'package:tech_care_app/core/widgets/dialogs/communication_dialog.dart';
import 'package:tech_care_app/features/saerch/domain/entity/receipt_container.dart';
import 'package:tech_care_app/features/receipts_container_details/presentation/pages/receipts_container_details_page.dart';
import 'package:tech_care_app/routes/app_router.dart';
import 'package:tech_care_app/routes/app_routes.dart';
import 'package:tech_care_app/routes/route_params.dart';

class ReceiptContainerCard extends StatefulWidget {
  final ReceiptContainer receiptContainer;
  final ContainerDisplayType displayType;
  const ReceiptContainerCard({
    super.key,
    required this.receiptContainer,
  }) : displayType = ContainerDisplayType.finished;

  @override
  State<ReceiptContainerCard> createState() => _ReceiptContainerCardState();
}

class _ReceiptContainerCardState extends State<ReceiptContainerCard> {
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      color: AppColors.whiteColor,
      elevation: 0,
      padding: EdgeInsets.all(AppConstants.mediumPadding),
      onPressed: () {
        AppRouter.navigator
            .pushNamed(AppRoutes.receiptsContainerDetailsPageRoute,
                arguments: ContainerDetailsParams(
                  containerId: widget.receiptContainer.id,
                  type: widget.displayType,
                ));
      },
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.smallPadding)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildInfo(
              prefixHeight: 26,
              prefix: Image.asset(AppStrings.barcodeIconPath),
              Info: Text(widget.receiptContainer.receiptNumber,
                  style: Theme.of(context).textTheme.titleSmall)),
          Gap(AppConstants.smallPadding),
          Row(
            children: [
              Expanded(
                child: _buildInfo(
                    prefixHeight: 26,
                    prefix: Image.asset(AppStrings.personIconPath),
                    Info: Text(widget.receiptContainer.customerName,
                        style: Theme.of(context).textTheme.titleSmall)),
              ),
              Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(100),
                  onTap: () => CommunicationDialog.show(context,
                      phone: widget.receiptContainer.customerPhone),
                  child: _buildInfo(
                      prefixHeight: 26,
                      prefix: Image.asset(AppStrings.phoneIconPath),
                      Info: CustomPhoneView(
                          phone: widget.receiptContainer.customerPhone,
                          style: Theme.of(context).textTheme.titleSmall)),
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
                  '${widget.receiptContainer.priority.tr}' +
                      ((widget.receiptContainer.priorityShippingNumber == null
                          ? ''
                          : ' - ${widget.receiptContainer.priorityShippingNumber}')),
                  style: Theme.of(context).textTheme.titleSmall)),
          Gap(AppConstants.smallPadding),
          _buildInfo(
            prefixHeight: 26,
            prefix: Image.asset(AppStrings.datetimeIconPath),
            Info: Text(
              DateFormat('dd/MM/yyyy hh:mm a')
                  .format(widget.receiptContainer.date),
              style: Theme.of(context).textTheme.titleSmall!,
            ),
          ),
        ],
      ),
    );
  }
}

Row _buildInfo(
    {double? prefixHeight = 20, required Widget prefix, required Widget Info}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      SizedBox(height: prefixHeight, width: 20, child: prefix),
      Gap(AppConstants.extraSmallPadding),
      Expanded(child: Info),
    ],
  );
}
