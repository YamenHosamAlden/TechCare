import 'package:flutter/material.dart';
import 'package:tech_care_app/app/app_localization.dart';
import 'package:tech_care_app/core/util/app_colors.dart';
import 'package:tech_care_app/core/util/app_constants.dart';
import 'package:tech_care_app/core/widgets/dialogs/confirm_dialog.dart';
import 'package:tech_care_app/core/widgets/dialogs/image_viewer_dialog.dart';

class ListOfRemovedImages extends StatefulWidget {
  final List<String> networkImages;
  final Function(String) removedImage;

  const ListOfRemovedImages(
      {required this.removedImage, required this.networkImages, super.key});

  @override
  State<ListOfRemovedImages> createState() => _ListOfRemovedImagesState();
}

class _ListOfRemovedImagesState extends State<ListOfRemovedImages> {
  @override
  Widget build(BuildContext context) {
    return widget.networkImages.isNotEmpty
        ? GridView.builder(
            padding: const EdgeInsets.all(0),
            primary: false,
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 100,
              mainAxisSpacing: AppConstants.extraLargePadding,
              crossAxisSpacing: AppConstants.smallPadding,
            ),
            itemCount: widget.networkImages.length,
            itemBuilder: (context, index) => _buildImageWidget(
              context,
              networkImage: widget.networkImages.elementAt(index),
              onRemoveBtnPressed: () {
                ConfirmDialog.show(context, onConfirm: () {
                  setState(() {
                    widget.removedImage(widget.networkImages.elementAt(index));
                    widget.networkImages.removeAt(index);
                  });
                }, message: "remove_image_confirm".tr, title: "note".tr);
              },
            ),
          )
        : SizedBox.shrink();
  }

  Widget _buildImageWidget(BuildContext context,
          {required final String networkImage,
          required final void Function() onRemoveBtnPressed}) =>
      InkWell(
        onTap: () => showDialog(
          context: context,
          builder: (BuildContext context) =>
              ImageViewerDialog(imageNetwork: networkImage),
        ),
        child: TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 700),
            tween: Tween(begin: 0, end: 1),
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: AppColors.whiteColor,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(networkImage),
                        ),
                      ),
                    ),
                    Positioned(
                        top: -25,
                        left: 0,
                        right: 0,
                        child: Center(
                            child: FloatingActionButton.small(
                          heroTag: networkImage,
                          onPressed: onRemoveBtnPressed,
                          child: const Icon(Icons.remove,
                              color: AppColors.mojoColor),
                        )))
                  ],
                ),
              );
            }),
      );
}
