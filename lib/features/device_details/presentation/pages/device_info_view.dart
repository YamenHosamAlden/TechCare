import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tech_care_app/app/app_localization.dart';
import 'package:tech_care_app/core/util/app_colors.dart';
import 'package:tech_care_app/core/util/app_constants.dart';
import 'package:tech_care_app/core/util/app_strings.dart';
import 'package:tech_care_app/features/device_details/domain/entities/device_info.dart';
import 'package:tech_care_app/features/device_details/presentation/bloc/device_details_bloc/device_details_bloc.dart';
import 'package:tech_care_app/features/device_details/presentation/dialogs/unreceive_device_dialog.dart';
import 'package:tech_care_app/routes/app_router.dart';
import 'package:tech_care_app/routes/app_routes.dart';
import 'package:tech_care_app/routes/route_params.dart';

class DeviceInfoView extends StatefulWidget {
  final DeviceInfo deviceInfo;
  const DeviceInfoView({super.key, required this.deviceInfo});

  @override
  State<DeviceInfoView> createState() => _DeviceInfoViewState();
}

class _DeviceInfoViewState extends State<DeviceInfoView> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppConstants.mediumPadding),
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.qr_code_rounded),
            const Gap(AppConstants.smallPadding),
            Expanded(
              child: Text(
                widget.deviceInfo.deviceCode,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            PopupMenuButton(
              icon: const Icon(Icons.open_in_new_rounded),
              itemBuilder: (context) => [
                PopupMenuItem(
                    // child: Text('device_collection'.tr),
                    child: Text('device_receipt'.tr),
                    height: 40,
                    onTap: () => AppRouter.navigator.pushNamed(
                        AppRoutes.receiptDetailsPageRoute,
                        arguments: ReceiptDetailsParams(
                            receiptID: widget.deviceInfo.receiptId))),
                // PopupMenuItem(
                //     child: Text('device_receipt'.tr),
                //     height: 40,
                //     onTap: () => AppRouter.navigator.pushNamed(
                //         AppRoutes.receiptDetailsPageRoute,
                //         arguments: ReceiptDetailsParams(
                //             receiptID: widget.deviceInfo.receiptId))),
              ],
            )
          ],
        ),
        if (widget.deviceInfo.assignName != null) ...[
          const Gap(AppConstants.mediumPadding),
          _buildTag(
              prefix: _buildPrefix(color: Colors.blue),
              Info: Text(widget.deviceInfo.assignName ?? '')),
        ],
        const Gap(AppConstants.mediumPadding),
        _buildTag(
            prefix: _buildPrefix(color: Colors.green),
            Info: Text(widget.deviceInfo.statusLable
                    ?.getDisplayValue(AppLocalizations.getLocale(context)) ??
                '')),
        const Gap(AppConstants.extraLargePadding),
        widget.deviceInfo.images.isEmpty
            ? Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(.6), BlendMode.darken),
                        image: AssetImage(
                          AppStrings.placeHolderImagePath,
                        )),
                    color: AppColors.altoColor,
                    borderRadius:
                        BorderRadius.circular(AppConstants.smallPadding)),
                padding: EdgeInsets.all(AppConstants.extraLargePadding * 2.5),
                child: Center(
                    child: Text(
                  'no_imgs'.tr,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(color: AppColors.whiteColor),
                )),
              )
            : CarouselSlider.builder(
                itemCount: widget.deviceInfo.images.length,
                itemBuilder: (context, index, realIndex) => _deviceImageWidget(
                    context,
                    imagesPath: widget.deviceInfo.images,
                    index: index),
                options: CarouselOptions(
                  disableCenter: true,
                  initialPage: 0,
                  enableInfiniteScroll: false,
                  enlargeCenterPage: true,
                  height: MediaQuery.of(context).size.height / 4,
                  viewportFraction: 0.9,
                  clipBehavior: Clip.none,
                  enlargeFactor: .3,
                ),
              ),
        const Gap(AppConstants.extraLargePadding),
        InfoContainer(
          label: 'device_info'.tr,
          infoList: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    child: InfoView(
                  title: 'serial_number'.tr,
                  info: widget.deviceInfo.serialNumber ?? '',
                )),
                Gap(AppConstants.smallPadding),
                Expanded(
                    child: InfoView(
                  title: 'qty'.tr,
                  info: widget.deviceInfo.qty ?? '',
                ))
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    child: InfoView(
                  title: 'brand'.tr,
                  info: widget.deviceInfo.type!.name.tr,
                )),
                Gap(AppConstants.smallPadding),
                Expanded(
                  child: InfoView(
                      title: 'model'.tr, info: widget.deviceInfo.model ?? ''),
                )
              ],
            ),
            InfoView(
                title: 'item_name'.tr, info: widget.deviceInfo.itemName ?? ''),
            InfoView(
                title: 'problem_description'.tr,
                info: widget.deviceInfo.problemDescription ?? ''),
            InfoView(
                title: 'attachments'.tr,
                info: widget.deviceInfo.attachments ?? ''),
          ],
        ),
        const Gap(AppConstants.largePadding),
        InfoContainer(
          label: 'warranty_status'.tr,
          infoList: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    child: InfoView(
                        title: 'source_company'.tr,
                        info: widget.deviceInfo.sourceCompany ?? '')),
                Gap(AppConstants.smallPadding),
                Expanded(
                    child: InfoView(
                        title: 'warranty_type'.tr,
                        info: widget.deviceInfo.warrantyType?.getDisplayValue(
                                AppLocalizations.getLocale(context)) ??
                            ''))
              ],
            ),
            InfoView(
                title: 'reason_for_warranty'.tr,
                info: widget.deviceInfo.reasonForWarranty ?? ''),
          ],
        ),
        const Gap(20),
        const Gap(AppConstants.largePadding),
        BlocProvider.of<DeviceDetailsBloc>(context)
                .state
                .hideDeviceActoiinsButtons
            ? SizedBox()
            : ElevatedButton(
                style: Theme.of(context).elevatedButtonTheme.style!.copyWith(
                        backgroundColor: MaterialStateProperty.all(
                      AppColors.mojoColor,
                    )),
                onPressed: () {
                  showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (dialogContext) => BlocProvider.value(
                          value: BlocProvider.of<DeviceDetailsBloc>(context),
                          child: UnreceiveDeviceDialog()));
                },
                child: Text('cancel'.tr)),
        const Gap(20),
      ],
    );
  }

  Widget _deviceImageWidget(BuildContext context,
      {required List<String> imagesPath, required int index}) {
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: imagesPath.elementAt(index),
          progressIndicatorBuilder: (context, url, progress) =>
              Shimmer.fromColors(
            baseColor: AppColors.silverColor,
            highlightColor: AppColors.alabasterColor,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.silverColor,
                borderRadius: BorderRadius.circular(AppConstants.smallPadding),
              ),
            ),
          ),
          imageBuilder: (context, imageProvider) => Hero(
            tag: imagesPath.elementAt(index),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.imagePreviewPageRoute,
                    arguments: {'index': index, 'images': imagesPath});
              },
              child: Container(
                width: double.infinity,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  color: AppColors.silverColor,
                  // border:
                  //     Border.all(color: AppColors.silverChaliceColor),
                  borderRadius:
                      BorderRadius.circular(AppConstants.smallPadding),
                ),
                child: Image(
                  fit: BoxFit.cover,
                  image: imageProvider,
                ),
              ),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.silverColor,
              // borderRadius:
              //     BorderRadius.circular(AppConstants.smallPadding),
            ),
            child: Icon(
              Icons.error,
            ),
          ),
        ),
        Hero(
          tag: imagesPath.elementAt(index),
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.imagePreviewPageRoute,
                  arguments: {'index': index, 'images': imagesPath});
            },
            child: Container(
              width: double.infinity,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                color: AppColors.silverColor,
                // border:
                //     Border.all(color: AppColors.silverChaliceColor),
                borderRadius: BorderRadius.circular(AppConstants.smallPadding),
              ),
              child: Image(
                fit: BoxFit.cover,
                image: NetworkImage(imagesPath.elementAt(index)),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Icon _buildPrefix({required Color color}) {
    return Icon(
      Icons.circle,
      size: 10,
      color: color,
    );
  }

  Row _buildTag({
    double? prefixHeight = 20,
    required Widget prefix,
    required Widget Info,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: prefixHeight,
          width: 10,
          child: prefix,
        ),
        Gap(AppConstants.extraSmallPadding),
        Info,
        Gap(AppConstants.mediumPadding),
      ],
    );
  }
}

class InfoView extends StatelessWidget {
  final String title;
  final String info;
  const InfoView({
    super.key,
    required this.title,
    required this.info,
  });

  @override
  Widget build(BuildContext context) {
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
        )
      ],
    );
  }
}

class InfoContainer extends StatelessWidget {
  final String label;
  final List<Widget> infoList;
  const InfoContainer({
    super.key,
    required this.label,
    required this.infoList,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.fade,
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            const Gap(AppConstants.smallPadding),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.only(top: AppConstants.mediumPadding),
                primary: false,
                shrinkWrap: true,
                itemCount: infoList.length,
                separatorBuilder: (context, index) => const Divider(
                  height: 25,
                  endIndent: 100,
                  thickness: .5,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return infoList.elementAt(index);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class ImagePreviewPage extends StatefulWidget {
  const ImagePreviewPage(
      {required this.images, super.key, required this.initialPage});
  final int initialPage;
  final List<String> images;

  static Route<dynamic> route({RouteSettings? settings}) => MaterialPageRoute(
      settings: settings,
      builder: (context) => ImagePreviewPage(
            images:
                (settings?.arguments as Map<String, dynamic>)['images'] ?? [],
            initialPage: (settings?.arguments as Map<String, dynamic>)['index'],
          ));

  @override
  State<ImagePreviewPage> createState() => _ImagePreviewPageState();
}

class _ImagePreviewPageState extends State<ImagePreviewPage> {
  late PageController pageController;

  @override
  void initState() {
    pageController = PageController(initialPage: widget.initialPage);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('Image Preview'),
      ),
      backgroundColor: Colors.black,
      body: PageView.builder(
          controller: pageController,
          itemCount: widget.images.length,
          itemBuilder: (context, index) {
            return Center(
              child: Hero(
                tag: widget.images.elementAt(index),
                child: CachedNetworkImage(
                  imageUrl: widget.images.elementAt(index),
                  progressIndicatorBuilder: (context, url, progress) => Center(
                    child: CircularProgressIndicator(),
                  ),
                  imageBuilder: (context, imageProvider) => Image(
                    image: imageProvider,
                    fit: BoxFit.contain,
                  ),
                  errorWidget: (context, url, error) => Center(
                    child: Icon(
                      Icons.error,
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }
}
