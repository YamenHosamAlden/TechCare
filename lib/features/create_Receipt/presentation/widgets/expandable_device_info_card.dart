import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:tech_care_app/app/app_localization.dart';
import 'package:tech_care_app/core/util/app_colors.dart';
import 'package:tech_care_app/core/util/app_constants.dart';
import 'package:tech_care_app/core/widgets/dialogs/image_viewer_dialog.dart';
import 'package:tech_care_app/features/create_receipt/domain/entities/device.dart';

class ExpandableDeviceCardInfoCard extends StatefulWidget {
  final int deviceIndex;
  final Device device;
  final void Function(int)? onDelete;
  final void Function(int)? onEdit;

  const ExpandableDeviceCardInfoCard({
    super.key,
    required this.deviceIndex,
    required this.device,
    this.onDelete,
    this.onEdit,
  });

  @override
  _ExpandableCardDemoState createState() => _ExpandableCardDemoState();
}

class _ExpandableCardDemoState extends State<ExpandableDeviceCardInfoCard> {
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

  @override
  Widget build(BuildContext context) {
    final _device = widget.device;
    return AnimatedContainer(
      margin: EdgeInsets.only(bottom: AppConstants.mediumPadding),
      duration: _animationDuration,
      curve: _animationCurve,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(AppConstants.extraSmallPadding),
          boxShadow: _crossFadeState == CrossFadeState.showFirst
              ? []
              : [
                  BoxShadow(
                      blurRadius: AppConstants.extraSmallPadding,
                      color: AppColors.altoColor)
                ]),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(
              AppConstants.smallPadding,
              0,
              AppConstants.smallPadding,
              AppConstants.smallPadding,
            ),
            decoration: BoxDecoration(color: AppColors.linkWaterColor),
            child: Column(
              children: [
                _buildCardHeader(context),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfo(context,
                        lable: 'serial_number'.tr,
                        info: _device.serialNumber ?? '-'),
                    Gap(AppConstants.smallPadding),
                    _buildInfo(context,
                        lable: 'quantity'.tr, info: _device.qty ?? '-'),
                  ],
                ),
                Gap(AppConstants.smallPadding),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfo(context,
                        lable: 'brand'.tr, info: _device.brand ?? '-'),
                    Gap(AppConstants.smallPadding),
                    _buildInfo(context,
                        lable: 'model'.tr, info: _device.model ?? '-'),
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
            secondChild: Container(
              child: Container(
                  padding: EdgeInsets.all(AppConstants.smallPadding),
                  width: double.infinity,
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfo(context,
                              lable: 'item_name'.tr,
                              info: _device.itemName ?? '-'),
                          Gap(AppConstants.smallPadding),
                          _buildInfo(context,
                              lable: 'source_company'.tr,
                              info: _device.sourceCompany?.name ?? '-'),
                        ],
                      ),
                      Gap(AppConstants.smallPadding),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfo(context,
                              lable: 'warranty_status'.tr,
                              info: _device.warrantyType?.getDisplayValue(
                                      AppLocalizations.getLocale(context)) ??
                                  '-'),
                        ],
                      ),
                      Gap(AppConstants.smallPadding),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfo(
                            context,
                            lable: 'reason_for_warranty'.tr,
                            info: _device.reasonForWarranty ?? '-',
                          ),
                        ],
                      ),
                      Gap(AppConstants.smallPadding),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfo(context,
                              lable: 'problem_description'.tr,
                              info: _device.problemDescription ?? '-'),
                        ],
                      ),
                      Gap(AppConstants.smallPadding),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfo(
                            context,
                            lable: 'attachments'.tr,
                            info: _device.attachments ?? '-',
                          ),
                        ],
                      ),
                      Gap(AppConstants.smallPadding),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'images'.tr,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          Gap(AppConstants.smallPadding),
                          _device.images.isEmpty
                              ? Row(
                                  children: [
                                    Expanded(child: Text('no_imgs'.tr)),
                                  ],
                                )
                              : GridView.builder(
                                  padding: const EdgeInsets.all(0),
                                  primary: false,
                                  shrinkWrap: true,
                                  gridDelegate:
                                      const SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 50,
                                    mainAxisSpacing: 10,
                                    crossAxisSpacing: 10,
                                  ),
                                  itemCount: _device.images.length,
                                  itemBuilder: (context, index) => InkWell(
                                    onTap: () => showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          ImageViewerDialog(
                                              imageFile: _device.images
                                                  .elementAt(index)),
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: AppColors.altoColor,
                                        image: DecorationImage(
                                            image: FileImage(_device.images
                                                .elementAt(index)),
                                            fit: BoxFit.cover),
                                        borderRadius: BorderRadius.circular(
                                          AppConstants.extraSmallPadding,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ],
                  )),
            ),
            crossFadeState: _crossFadeState,
            duration: _animationDuration,
          ),
          SizedBox(
            height: 40,
            child: MaterialButton(
              hoverElevation: 0,
              elevation: 0,
              height: 30,
              padding: EdgeInsets.zero,
              onPressed: () {
                _toggleCard();
              },
              child: Center(
                child: AnimatedRotation(
                  duration: _animationDuration,
                  curve: _animationCurve,
                  alignment: Alignment.center,
                  turns: _crossFadeState == CrossFadeState.showFirst ? 0 : .5,
                  child: SizedBox.square(
                    dimension: 40,
                    child: IconButton(
                        onPressed: () {
                          _toggleCard();
                        },
                        icon: Icon(
                          Icons.keyboard_arrow_down_rounded,
                        )),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Expanded _buildInfo(BuildContext context,
      {required String lable, required String info}) {
    return Expanded(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          lable,
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        Gap(AppConstants.extraSmallPadding),
        Text(
          info,
        ),
      ],
    ));
  }

  Row _buildCardHeader(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.qr_code_scanner_rounded, size: 15),
        Gap(AppConstants.extraSmallPadding),
        Expanded(
            child: Text(
          (widget.device.deviceCode ?? ''),
          overflow: TextOverflow.ellipsis,
        )),
        SizedBox.square(
          dimension: 40,
          child: IconButton(
              onPressed: () => widget.onEdit != null
                  ? widget.onEdit!(widget.deviceIndex)
                  : null,
              icon: Icon(Icons.edit_rounded,
                  color: AppColors.funBlueColor, size: 20)),
        ),
        SizedBox.square(
          dimension: 40,
          child: IconButton(
              onPressed: () => widget.onDelete != null
                  ? widget.onDelete!(widget.deviceIndex)
                  : null,
              icon: Icon(Icons.delete, color: AppColors.mojoColor, size: 20)),
        ),
      ],
    );
  }
}
