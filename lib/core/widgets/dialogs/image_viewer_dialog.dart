import 'package:flutter/material.dart';
import 'dart:io';

import 'package:gap/gap.dart';
import 'package:tech_care_app/app/app_localization.dart';
import 'package:tech_care_app/core/util/app_constants.dart';
import 'package:tech_care_app/core/util/app_strings.dart';

class ImageViewerDialog extends StatefulWidget {
  final File? imageFile;
  final String? imageNetwork;
  ImageViewerDialog({this.imageFile, this.imageNetwork});

  @override
  State<ImageViewerDialog> createState() => _ImageViewerDialogState();
}

class _ImageViewerDialogState extends State<ImageViewerDialog> {
  double? imageSize;

  @override
  void initState() {
    widget.imageFile?.length().then((value) => setState(() {
          imageSize = value / 1024;
        }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 16,
      child: Container(
        // padding: EdgeInsets.all(AppConstants.extraSmallPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.imageFile == null && widget.imageNetwork == null) ...[
              LimitedBox(
                maxHeight: MediaQuery.of(context).size.height * 2 / 3,
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(0)),
                  child: Image.asset(AppStrings.qualityImagePath),
                ),
              ),
            ] else if (widget.imageFile != null) ...[
              LimitedBox(
                maxHeight: MediaQuery.of(context).size.height * 2 / 3,
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(0)),
                  child: Image.file(widget.imageFile!),
                ),
              ),
              Gap(AppConstants.mediumPadding),
              Text(
                  '${'img_size'.tr}: ${imageSize?.toStringAsFixed(2) ?? '...'} KB'),
            ] else ...[
              LimitedBox(
                maxHeight: MediaQuery.of(context).size.height * 2 / 3,
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(0)),
                  child: Image.network(widget.imageNetwork!),
                ),
              ),
            ],
            Gap(AppConstants.smallPadding),
            OutlinedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('close'.tr),
            ),
            Gap(AppConstants.smallPadding),
          ],
        ),
      ),
    );
  }
}
