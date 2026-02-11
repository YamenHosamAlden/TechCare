import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tech_care_app/core/util/app_colors.dart';
import 'package:tech_care_app/core/util/app_constants.dart';
import 'package:tech_care_app/core/widgets/dialogs/image_viewer_dialog.dart';
import 'package:tech_care_app/core/widgets/dialogs/pick_image_dialog.dart';

class ImagePickerFormField extends FormField<List<File>> {
  ImagePickerFormField({
    Key? key,
    List<File>? initialValue,
    ImagePickerInputController? controller,
    ValueChanged<List<File>>? onChanged,
    FormFieldValidator<List<File>>? validator,
    AutovalidateMode? autovalidateMode,
    FormFieldSetter<List<File>>? onSaved,
  }) : super(
          key: key,
          initialValue: controller?.value ?? (initialValue ?? []),
          validator: validator,
          autovalidateMode: autovalidateMode ?? AutovalidateMode.disabled,
          onSaved: onSaved,
          builder: (FormFieldState<List<File>> state) {
            void onChangedHandler(List<File> value) {
              state.didChange(value);
              if (onChanged != null) {
                onChanged(value);
              }
            }

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ImagePickerField(
                    initialValue: initialValue,
                    controller: controller,
                    side: state.hasError
                        ? const BorderSide(color: Colors.red, width: 2)
                        : BorderSide.none,
                    onChanged: onChangedHandler,
                  ),
                  if (state.hasError) ...[
                    Text(
                      state.errorText ?? 'Invalid input',
                      style: const TextStyle(fontSize: 15, color: Colors.red),
                    ),
                  ],
                ],
              ),
            );
          },
        );
}

class ImagePickerField extends StatefulWidget {
  const ImagePickerField({
    Key? key,
    this.initialValue,
    this.controller,
    this.onChanged,
    this.side = BorderSide.none,
  }) : super(key: key);

  final List<File>? initialValue;
  final ImagePickerInputController? controller;
  final ValueChanged<List<File>>? onChanged;
  final BorderSide side;

  @override
  State<ImagePickerField> createState() => _ImagePickerFieldState();
}

class _ImagePickerFieldState extends State<ImagePickerField> {
  late ImagePickerInputController controller;

  @override
  void initState() {
    super.initState();
    controller = widget.controller ??
        ImagePickerInputController(initialValue: widget.initialValue ?? []);
    controller.addListener(_onValueChanged);
  }

  void _onValueChanged() {
    widget.onChanged?.call(controller.value);
  }

  @override
  void didUpdateWidget(covariant ImagePickerField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      controller.removeListener(_onValueChanged);
      controller =
          widget.controller ?? ImagePickerInputController(initialValue: []);
      controller.addListener(_onValueChanged);
    }
  }

  @override
  void dispose() {
    controller.removeListener(_onValueChanged);
    if (widget.controller == null) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<File>>(
      valueListenable: controller,
      builder: (_, List<File> imageFiles, child) => GridView.builder(
        padding: const EdgeInsets.all(0),
        primary: false,
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 100,
          mainAxisSpacing: AppConstants.extraLargePadding,
          crossAxisSpacing: AppConstants.smallPadding,
        ),
        itemCount: imageFiles.length + 1,
        itemBuilder: (context, index) => index == imageFiles.length
            ? _addImageBtn()
            : _buildImageWidget(
                imageFile: imageFiles.elementAt(index),
                onRemoveBtnPressed: () => controller.removeImageAt(index),
              ),
      ),
      child: Row(
        children: [
          _addImageBtn(),
        ],
      ),
    );
  }

  Widget _buildImageWidget(
      {required File imageFile, required void Function() onRemoveBtnPressed}) {
    return InkWell(
      onTap: () => showDialog(
        context: context,
        builder: (BuildContext context) =>
            ImageViewerDialog(imageFile: imageFile),
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
                        image: FileImage(imageFile),
                      ),
                    ),
                  ),
                  Positioned(
                      top: -25,
                      left: 0,
                      right: 0,
                      child: Center(
                          child: FloatingActionButton.small(
                        heroTag: ObjectKey(imageFile.path),
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

  Widget _addImageBtn() => MaterialButton(
        height: 85,
        minWidth: 85,
        splashColor: AppColors.altoColor,
        color: AppColors.altoColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        onPressed: () async {
          ImagePickerDialog.show(
            context,
            pickImageFromGallery: (fileImage) async {
              controller.addImageFile(fileImage!);
            },
            pickImageFromCamera: (fileImage) {
              controller.addImageFile(fileImage!);
            },
          );
          // controller.addImageFile(_image);
        },
        child: const Icon(
          Icons.add_a_photo_rounded,
          color: Colors.blueGrey,
        ),
      );
}

class ImagePickerInputController extends ValueNotifier<List<File>> {
  ImagePickerInputController({required List<File> initialValue})
      : super(initialValue);

  void addImageFile(File imageFile) {
    value.add(imageFile);
    notifyListeners();
  }

  void removeImageAt(int index) {
    value.removeAt(index);
    notifyListeners();
  }
}
