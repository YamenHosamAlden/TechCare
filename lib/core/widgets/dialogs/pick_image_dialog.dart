import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tech_care_app/app/app_localization.dart';
import 'package:tech_care_app/core/util/helpers/compress_image.dart';

class ImagePickerDialog extends StatelessWidget {
  final void Function(File?) pickImageFromGallery;
  final void Function(File?) pickImageFromCamera;

  const ImagePickerDialog({
    required this.pickImageFromGallery,
    required this.pickImageFromCamera,
    super.key,
  });

  static Future show(
    BuildContext context, {
    required void Function(File?) pickImageFromCamera,
    required void Function(File?) pickImageFromGallery,
  }) =>
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "choose_image".tr,
              textAlign: TextAlign.center,
            ),
            content: ImagePickerDialog(
              pickImageFromCamera: pickImageFromCamera,
              pickImageFromGallery: pickImageFromGallery,
            ),
            actionsAlignment: MainAxisAlignment.center,
            actions: <Widget>[
              TextButton(
                child: Text('cancel'.tr),
                onPressed: () {
                  Navigator.pop(
                    context,
                  );
                },
              ),
            ],
          );
        },
      );

  Future<File?> pickImage({required ImageSource imageSource}) async {
    XFile? image = await ImagePicker().pickImage(source: imageSource);
    if (image == null) return null;
    File _image = File(image.path);
    File? compressedImage = await compressImage(_image);
    return compressedImage ?? _image;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ListBody(
        children: <Widget>[
          Row(
            children: [
              Expanded(
                child: MaterialButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    File? image =
                        await pickImage(imageSource: ImageSource.gallery);

                    pickImageFromGallery(image);
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.photo,
                        size: 25,
                      ),
                      Text(
                        "gallery".tr,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: MaterialButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    File? image =
                        await pickImage(imageSource: ImageSource.camera);

                    pickImageFromCamera(image);
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.camera,
                        size: 25,
                      ),
                      Text(
                        "camera".tr,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
