import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:gap/gap.dart';
import 'package:tech_care_app/app/app_localization.dart';
import 'package:tech_care_app/core/entities/translatable_value.dart';

import 'package:tech_care_app/core/util/app_colors.dart';
import 'package:tech_care_app/core/util/app_constants.dart';
import 'package:tech_care_app/core/util/helpers/list_warraty_status.dart';
import 'package:tech_care_app/core/widgets/app_progress_indicator.dart';
import 'package:tech_care_app/core/widgets/custom_drop_down_button_form_field.dart';

import 'package:tech_care_app/core/widgets/custom_text_form_field.dart';
import 'package:tech_care_app/core/widgets/dialogs/code_scanner_dialog.dart';
import 'package:tech_care_app/core/widgets/error_message_widget.dart';
import 'package:tech_care_app/core/widgets/loading_indicator.dart';
import 'package:tech_care_app/dependency_injection.dart';
import 'package:tech_care_app/features/create_receipt/domain/usecases/check_device_code_from_api_usecase.dart';
import 'package:tech_care_app/features/create_receipt/domain/usecases/load_device_res_usecase.dart';
import 'package:tech_care_app/features/create_receipt/domain/entities/company.dart';
import 'package:tech_care_app/features/create_receipt/domain/entities/device_type.dart';
import 'package:tech_care_app/features/create_receipt/presentation/widgets/image_picker_form_field.dart';
import 'package:tech_care_app/features/message_viewer/domain/usecases/view_snackbar_msg_usecase.dart';
import 'package:tech_care_app/features/receipts_container_details/domain/usecases/edit_device_details_usecase.dart';
import 'package:tech_care_app/features/receipts_container_details/domain/usecases/load_device_details_usecase.dart';
import 'package:tech_care_app/features/receipts_container_details/presentation/bloc/edit_device_bloc/edit_device_bloc.dart';
import 'package:tech_care_app/features/receipts_container_details/presentation/widgets/list_of_removed_images.dart';
import 'package:tech_care_app/routes/app_router.dart';

class EditDeviceDetailsPage extends StatefulWidget {
  final int deviceId;
  static Route<dynamic> route({required int params, RouteSettings? settings}) =>
      MaterialPageRoute(
          settings: settings,
          builder: (context) => EditDeviceDetailsPage(
                deviceId: params,
              ));

  const EditDeviceDetailsPage({
    required this.deviceId,
    super.key,
  });

  @override
  State<EditDeviceDetailsPage> createState() => _EditDeviceDetailsPageState();
}

class _EditDeviceDetailsPageState extends State<EditDeviceDetailsPage> {
  @override
  void initState() {
    VisualDensity.compact;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EditDeviceBloc>(
        create: (context) => EditDeviceBloc(
            editDeviceDetailsUsecase: di<EditDeviceDetailsUsecase>(),
            loadDeviceResUsecase: di<LoadDeviceResUsecase>(),
            loadDeviceDetailsUsecase: di<LoadDeviceDetailsUsecase>(),
            viewSnackBarMsgUsecase: di<ViewSnackBarMsgUsecase>(),
            checkDeviceCodeFromApiUsecase: di<CheckDeviceCodeFromApiUsecase>())
          ..add(LoadDeviceDetails(deviceId: widget.deviceId)),
        child: EditDeviceView(
          deviceId: widget.deviceId,
        ));
  }
}

class EditDeviceView extends StatefulWidget {
  final int deviceId;
  const EditDeviceView({
    required this.deviceId,
    super.key,
  });

  @override
  State<EditDeviceView> createState() => _EditDeviceViewState();
}

class _EditDeviceViewState extends State<EditDeviceView> {
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  late final EditDeviceBloc _bloc;
  AutovalidateMode? autovalidateMode;

  late AutovalidateMode deviceCodeAutovalidateMode;
  late final TextEditingController deviceCodeController;
  late final TextEditingController deviceSerialController;
  late final TextEditingController brandController;

  @override
  void initState() {
    _bloc = BlocProvider.of<EditDeviceBloc>(context);
    deviceCodeController = TextEditingController();
    deviceSerialController = TextEditingController();
    brandController = TextEditingController();
    autovalidateMode = AutovalidateMode.disabled;
    deviceCodeAutovalidateMode = AutovalidateMode.disabled;
    super.initState();
  }

  @override
  void dispose() {
    deviceCodeController.dispose();
    deviceSerialController.dispose();
    brandController.dispose();
    _bloc.close();
    super.dispose();
  }

  void editDevice() {
    final isForm1Valid = _formKey.currentState?.validate() ?? false;
    final isForm2Valid = _formKey2.currentState?.validate() ?? false;
    if (isForm1Valid && isForm2Valid) {
      _bloc.add(EditDevice(deviceId: widget.deviceId));
    } else {
      deviceCodeAutovalidateMode = AutovalidateMode.onUserInteraction;
      autovalidateMode = AutovalidateMode.onUserInteraction;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'required_fields_validation_msg'.tr,
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: AppColors.whiteColor),
          ),
          duration: Duration(seconds: 3),
          backgroundColor: AppColors.mojoColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('edit_device'.tr),
      ),
      body: BlocConsumer<EditDeviceBloc, EditDeviceState>(
        bloc: _bloc,
        listenWhen: (previous, current) {
          if (previous.isLoading && !current.isLoading) {
            deviceCodeController.text = current.deviceDetails?.deviceCode ?? '';
            deviceSerialController.text =
                current.deviceDetails?.deviceSerialNumber ?? '';
            brandController.text = current.deviceDetails?.deviceType.name
                    .getDisplayValue(AppLocalizations.getLocale(context)) ??
                '';
          }
          return true;
        },
        listener: (context, state) {
          if (state.editCompleted) {
            AppRouter.navigator.pop(context);
          }
        },
        builder: (context, state) {
          if (state.isLoading) {
            return LoadingIndicator();
          }
          if (state is LoadDeviceDetailsError) {
            return ErrorMessageWidget(
                errorMessage: state.errorMessage,
                onRetry: () {
                  _bloc.add(LoadDeviceDetails(deviceId: widget.deviceId));
                });
          }
          return _buildPageForm(context);
        },
      ),
    );
  }

  Widget _deviceCodeFormField() => Form(
        key: _formKey2,
        autovalidateMode: deviceCodeAutovalidateMode,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'device_code'.tr,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const Gap(AppConstants.smallPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      CustomTextFormField(
                        controller: deviceCodeController,
                        hintText: 'device_code'.tr,
                        onChanged: (deviceCode) {
                          deviceCodeAutovalidateMode =
                              AutovalidateMode.onUserInteraction;
                          _bloc.add(DeviceCodeChanged(deviceCode: deviceCode));
                        },
                        validator: (code) {
                          if (code == null || code.isEmpty) {
                            return 'plz_device_code'.tr;
                          }

                          if (_bloc.state.checkDeviceCodeLoading) {
                            return 'verifying'.tr;
                          }
                          if (_bloc.state.deviceCodeCheckFailed) {
                            return 'validadtion_failed'.tr;
                          }
                          if (_bloc.state.deviceCodeTaken) {
                            return 'device_is_already_taken'.tr;
                          }

                          return null;
                        },
                        inputFormatters: [],
                      ),
                      if (_bloc.state.checkDeviceCodeLoading)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          child: LinearProgressIndicator(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                    ],
                  ),
                ),
                Gap(AppConstants.smallPadding),
                SizedBox.square(
                  dimension: 33.5,
                  child: IconButton.filled(
                    onPressed: () {
                      showDialog<String?>(
                              context: context,
                              builder: (context) => CodeScannerDialog())
                          .then((deviceCode) {
                        if (deviceCode != null) {
                          deviceCodeController.text = deviceCode;
                          _bloc.add(DeviceCodeChanged(deviceCode: deviceCode));
                          deviceCodeAutovalidateMode =
                              AutovalidateMode.onUserInteraction;
                        }
                      });
                    },
                    icon: Icon(Icons.qr_code_scanner_rounded),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(AppColors.martiniqueColor),
                      padding: MaterialStatePropertyAll(EdgeInsets.all(0)),
                      shape: MaterialStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              AppConstants.extraSmallPadding),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (_bloc.state.deviceCodeCheckFailed &&
                !_bloc.state.checkDeviceCodeLoading) ...[
              TextButton(
                  onPressed: () {
                    _bloc.add(CheckDeviceCode());
                  },
                  child: Text('validate_code'.tr))
            ]
          ],
        ),
      );

  SingleChildScrollView _buildPageForm(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppConstants.mediumPadding),
      child: Column(
        children: [
          _deviceCodeFormField(),
          Form(
            key: _formKey,
            autovalidateMode: autovalidateMode,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Gap(AppConstants.mediumPadding),
                Text(
                  'device_info'.tr,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                const Gap(AppConstants.smallPadding),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: CustomTextFormField(
                        hintText: 'serial_number'.tr,
                        controller: deviceSerialController,
                        onChanged: (serial) => _bloc
                            .add(SerialNumberChanged(serialNumber: serial)),
                        validator: (serial) => serial == null || serial.isEmpty
                            ? 'plz_serial_number'.tr
                            : null,
                        inputFormatters: [],
                      ),
                    ),
                    Gap(AppConstants.smallPadding),
                    SizedBox.square(
                      dimension: 33.5,
                      child: IconButton.filled(
                        onPressed: () {
                          showDialog<String?>(
                                  context: context,
                                  builder: (context) => CodeScannerDialog())
                              .then((serial) {
                            if (serial != null) {
                              deviceSerialController.text = serial;
                              _bloc.add(
                                  SerialNumberChanged(serialNumber: serial));
                            }
                          });
                        },
                        icon: Icon(Icons.qr_code_scanner_rounded),
                        style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(
                              AppColors.martiniqueColor),
                          padding: MaterialStatePropertyAll(EdgeInsets.all(0)),
                          shape: MaterialStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  AppConstants.extraSmallPadding),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const Gap(AppConstants.smallPadding),
                TypeAheadField<DeviceType>(
                  hideOnEmpty: true,
                  controller: brandController,
                  suggestionsCallback: (pattern) async {
                    if (pattern.trim().isEmpty) {
                      return _bloc.state.deviceTypes;
                    }
                    return _bloc.state.deviceTypes
                        .where((brand) => brand.name
                            .getDisplayValue(
                                AppLocalizations.getLocale(context))
                            .toLowerCase()
                            .contains(pattern.toLowerCase().trim()))
                        .toList();
                  },
                  builder: (context, controller, focusNode) {
                    return CustomTextFormField(
                      controller: controller,
                      autovalidateMode: autovalidateMode,
                      focusNode: focusNode,
                      hintText: 'brand'.tr,
                      onChanged: (value) {
                        _bloc.add(BrandChanged(brand: value.trim()));
                      },
                      validator: (brand) =>
                          brand == null || brand.trim().isEmpty ? 'plz_brand'.tr : null,
                    );
                  },
                  debounceDuration: Durations.medium4,
                  loadingBuilder: (context) => SizedBox(),
                  itemBuilder: (context, brand) {
                    return ListTile(
                      dense: true,
                      title: Text(
                        brand.name.getDisplayValue(
                            AppLocalizations.getLocale(context)),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    );
                  },
                  onSelected: (brand) {
                    brandController.text = brand.name
                        .getDisplayValue(AppLocalizations.getLocale(context));
                    _bloc.add(BrandChanged(
                        brand: brand.name.getDisplayValue(
                            AppLocalizations.getLocale(context))));
                  },
                  hideKeyboardOnDrag: true,
                ),
                // const Gap(AppConstants.smallPadding),
                // CustomDropDownButtonFormField<DeviceType>(
                //   hintText: 'brand'.tr,
                //   items: _bloc.state.deviceTypes,
                //   value: _bloc.state.deviceDetails?.deviceType,
                //   onChanged: (type) => _bloc.add(TypeChanged(type: type!)),
                //   validator: (type) => type == null ? 'plz_brand'.tr : null,
                // ),
                const Gap(AppConstants.smallPadding),
                CustomTextFormField(
                  hintText: 'model'.tr,
                  initialValue: _bloc.state.deviceDetails?.deviceModel,
                  onChanged: (model) => _bloc.add(ModelChanged(model: model)),
                  validator: (model) =>
                      model == null || model.isEmpty ? 'plz_model'.tr : null,
                ),
                const Gap(AppConstants.smallPadding),
                CustomTextFormField(
                  hintText: 'item_name'.tr,
                  initialValue: _bloc.state.deviceDetails?.deviceName,
                  onChanged: (itemName) =>
                      _bloc.add(ItemNameChanged(itemName: itemName)),
                  // validator: (itemName) => itemName == null || itemName.isEmpty
                  //     ? 'plz_item_name'.tr
                  //     : null,
                ),
                const Gap(AppConstants.smallPadding),
                CustomTextFormField(
                  hintText: 'quantity'.tr,
                  initialValue: _bloc.state.deviceDetails?.deviceQty,
                  onChanged: (qty) => _bloc.add(QtyChanged(qty: qty)),
                  validator: (qty) =>
                      qty == null || qty.isEmpty ? 'plz_quantity'.tr : null,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly, // Only allow digits
                  ],
                  keyboardType: TextInputType.number,
                ),
                const Gap(AppConstants.smallPadding),
                CustomTextFormField(
                  hintText: 'problem_description'.tr,
                  initialValue: _bloc.state.deviceDetails?.problemDescription,
                  minLines: 5,
                  maxLines: 20,
                  onChanged: (problemDescription) => _bloc.add(
                      ProblemDescriptionChanged(
                          problemDescription: problemDescription)),
                  validator: (problem) => problem == null || problem.isEmpty
                      ? 'plz_problem_description'.tr
                      : null,
                ),
                const Gap(AppConstants.smallPadding),
                CustomTextFormField(
                  hintText: 'attachments'.tr,
                  initialValue: _bloc.state.deviceDetails?.deviceAttachments,
                  minLines: 5,
                  maxLines: 20,
                  onChanged: (attachments) =>
                      _bloc.add(AttachmentsChanged(attachments: attachments)),
                ),
                const Gap(AppConstants.mediumPadding),
                Text(
                  'warranty_status'.tr,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                const Gap(AppConstants.smallPadding),
                CustomDropDownButtonFormField<Company>(
                  hintText: 'source_company'.tr,
                  value: _bloc.state.deviceDetails?.company,
                  items: _bloc.state.companies,
                  onChanged: (sourceCompany) => _bloc
                      .add(SourceCompanyChanged(sourceCompany: sourceCompany!)),
                  validator: (company) =>
                      company == null ? 'plz_source_company'.tr : null,
                ),
                const Gap(AppConstants.smallPadding),
                CustomDropDownButtonFormField<TranslatableValue>(
                  hintText: 'warranty_type'.tr,
                  value: _bloc.state.deviceDetails?.deviceWarranty,
                  items: getWarratyStatusChoises(),
                  onChanged: (warrantyType) => _bloc
                      .add(WarrantyTypeChanged(warrantyType: warrantyType!)),
                  validator: (warrantyType) =>
                      warrantyType == null ? 'plz_warranty_type'.tr : null,
                ),
                const Gap(AppConstants.smallPadding),
                CustomTextFormField(
                  hintText: 'reason_for_warranty'.tr,
                  initialValue: _bloc.state.deviceDetails?.warrantyReason,
                  minLines: 5,
                  maxLines: 20,
                  onChanged: (reasonForWarranty) => _bloc.add(
                      ReasonForWarrantyChanged(
                          reasonForWarranty: reasonForWarranty)),
                ),
                const Gap(AppConstants.largePadding),
                Text(
                  'images'.tr,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                if (_bloc.state.deviceDetails!.images.isNotEmpty)
                  const Gap(AppConstants.extraLargePadding),
                ListOfRemovedImages(
                    networkImages: _bloc.state.deviceDetails!.images,
                    removedImage: (image) =>
                        _bloc.add(RemovedImagesChanged(image: image))),
                const Gap(AppConstants.mediumPadding),
                ImagePickerFormField(
                    initialValue: _bloc.state.deviceDetails?.fileImages,
                    onChanged: (List<File> images) =>
                        _bloc.add(NewImagesChanged(images: images))),
                const Gap(AppConstants.extraLargePadding),
                _buildEditBtn(),
                const Gap(AppConstants.extraLargePadding),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditBtn() {
    return SizedBox(
      height: 50,
      child: BlocBuilder<EditDeviceBloc, EditDeviceState>(
        bloc: _bloc,
        builder: (context, state) {
          return AnimatedSwitcher(
            duration: Durations.extralong4,
            child: state.editLoading
                ? Center(
                    child: AppProgressIndicator(
                    progress: state.uploadProgress,
                  ))
                : Center(
                    child: SizedBox(
                      height: 40,
                      child: ElevatedButton(
                        onPressed: editDevice,
                        child: Center(child: Text('edit'.tr)),
                      ),
                    ),
                  ),
          );
        },
      ),
    );
  }
}
