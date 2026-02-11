import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart' as date;
import 'package:tech_care_app/app/app_localization.dart';
import 'package:tech_care_app/core/util/app_colors.dart';
import 'package:tech_care_app/core/util/app_constants.dart';
import 'package:tech_care_app/core/util/app_strings.dart';
import 'package:tech_care_app/core/widgets/dialogs/communication_dialog.dart';
import 'package:tech_care_app/core/widgets/highlighted_text.dart';
import 'package:tech_care_app/features/receipts_container_details/presentation/pages/receipts_container_details_page.dart';
import 'package:tech_care_app/features/saerch/domain/entity/receipt_container.dart';
import 'package:tech_care_app/routes/app_router.dart';
import 'package:tech_care_app/routes/app_routes.dart';
import 'package:tech_care_app/routes/route_params.dart';

class ReceiptContainerCard extends StatefulWidget {
  final String? searchTerm;
  final ReceiptContainer receiptContainer;
  final ContainerDisplayType displayType;
  const ReceiptContainerCard({
    super.key,
    required this.receiptContainer,
    this.searchTerm,
  }) : displayType = ContainerDisplayType.all;

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
            // Info: Text(widget.receiptContainer.receiptNumber,
            //     style: Theme.of(context).textTheme.titleSmall)
            Info: HighlightedText(
              text: widget.receiptContainer.receiptNumber,
              highlightedText: widget.searchTerm,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Gap(AppConstants.smallPadding),
          Row(
            children: [
              Expanded(
                child: _buildInfo(
                  prefixHeight: 26,
                  prefix: Image.asset(AppStrings.personIconPath),
                  Info: HighlightedText(
                    text: widget.receiptContainer.customerName,
                    highlightedText: widget.searchTerm,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),

                  // Text(widget.receiptContainer.customerName,
                  //     style: Theme.of(context).textTheme.titleSmall),
                ),
              ),
              Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(100),
                  onTap: () => CommunicationDialog.show(context,
                      phone: widget.receiptContainer.customerPhone),
                  child: _buildInfo(
                    prefixHeight: 26,
                    prefix: Image.asset(AppStrings.phoneIconPath),
                    Info: Directionality(
                      textDirection: TextDirection.ltr,
                      child: Align(
                        alignment: AppLocalizations.isDirectionRTL(context)
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: HighlightedText(
                          text: widget.receiptContainer.customerPhone,
                          highlightedText: widget.searchTerm,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
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
            Info: HighlightedText(
              text: '${widget.receiptContainer.priority.tr}' +
                  ((widget.receiptContainer.priorityShippingNumber == null
                      ? ''
                      : ' - ${widget.receiptContainer.priorityShippingNumber}')),
              highlightedText: widget.searchTerm,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(fontWeight: FontWeight.bold),
            ),

            // Text(
            //     '${widget.receiptContainer.priority.getDisplayValue(AppLocalizations.of(context)!.locale)}' +
            //         ((widget.receiptContainer.priorityShippingNumber == null
            //             ? ''
            //             : ' - ${widget.receiptContainer.priorityShippingNumber}')),
            //     style: Theme.of(context).textTheme.titleSmall)
          ),
          Gap(AppConstants.smallPadding),
          _buildInfo(
            prefixHeight: 26,
            prefix: Image.asset(AppStrings.datetimeIconPath),
            Info: Text(
              date.DateFormat('dd/MM/yyyy hh:mm a')
                  .format(widget.receiptContainer.date),
              style: Theme.of(context).textTheme.titleMedium!,
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
