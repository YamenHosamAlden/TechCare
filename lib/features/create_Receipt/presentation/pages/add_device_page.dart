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
import 'package:tech_care_app/core/widgets/custom_drop_down_button_form_field.dart';
import 'package:tech_care_app/core/widgets/custom_text_form_field.dart';
import 'package:tech_care_app/core/widgets/dialogs/code_scanner_dialog.dart';
import 'package:tech_care_app/core/widgets/error_message_widget.dart';
import 'package:tech_care_app/core/widgets/loading_indicator.dart';
import 'package:tech_care_app/dependency_injection.dart';
import 'package:tech_care_app/features/create_receipt/domain/usecases/check_device_code_from_api_usecase.dart';
import 'package:tech_care_app/features/create_receipt/domain/usecases/load_device_res_usecase.dart';
import 'package:tech_care_app/features/create_receipt/presentation/bloc/add_device_bloc/add_device_bloc.dart';
import 'package:tech_care_app/features/create_receipt/domain/entities/company.dart';
import 'package:tech_care_app/features/create_receipt/domain/entities/device.dart';
import 'package:tech_care_app/features/create_receipt/domain/entities/device_type.dart';
import 'package:tech_care_app/features/create_receipt/domain/usecases/check_device_code_from_collection_usecase.dart';
import 'package:tech_care_app/features/create_receipt/presentation/bloc/create_reciept_bloc/create_receipt_bloc.dart';
import 'package:tech_care_app/features/create_receipt/presentation/widgets/image_picker_form_field.dart';
import 'package:tech_care_app/routes/app_router.dart';
import 'package:tech_care_app/routes/route_params.dart';

class AddDevicePage extends StatefulWidget {
  final Device? device;
  final int? deviceIndex;
  final int collectionIndex;
  final CreateReceiptBloc createReceiptBloc;

  static Route<dynamic> route(
          {required AddDeviceParams params, RouteSettings? settings}) =>
      MaterialPageRoute(
          settings: settings,
          builder: (context) => AddDevicePage(
                device: params.device,
                deviceIndex: params.deviceIndex,
                collectionIndex: params.collectionIndex,
                createReceiptBloc: params.createReceiptBloc,
              ));

  const AddDevicePage({
    this.device,
    this.deviceIndex,
    required this.collectionIndex,
    required this.createReceiptBloc,
    super.key,
  });

  @override
  State<AddDevicePage> createState() => _AddDevicePageState();
}

class _AddDevicePageState extends State<AddDevicePage> {
  late final bool isEditting;

  @override
  void initState() {
    isEditting = !(widget.device == null && widget.deviceIndex == null);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AddDeviceBloc>(
      create: (context) => AddDeviceBloc(
          checkDeviceCodeFromApiUsecase: di<CheckDeviceCodeFromApiUsecase>(),
          checkDeviceCodeUsecaseFromCollection:
              di<CheckDeviceCodeUsecaseFromCollection>(),
          loadDeviceResUsecase: di<LoadDeviceResUsecase>(),
          device: widget.device,
          collectionList: widget.createReceiptBloc.state.collections)
        ..add(LoadRequiredResources()),
      child: BlocConsumer<AddDeviceBloc, AddDeviceState>(
        listener: (context, state) {
          if (state is DeviceSubmitted) {
            AppRouter.navigator.pop();
            isEditting
                ? widget.createReceiptBloc.add(EditDevice(
                    collectionIndex: widget.collectionIndex,
                    deviceIndex: widget.deviceIndex!,
                    device: state.device,
                  ))
                : widget.createReceiptBloc.add(AddDeviceToCollection(
                    collectionIndex: widget.collectionIndex,
                    device: state.device,
                  ));
          }
        },
        builder: (context, state) {
          return AddDeviceView(isEditting: isEditting);
        },
      ),
    );
  }
}

class AddDeviceView extends StatefulWidget {
  final bool isEditting;
  const AddDeviceView({super.key, this.isEditting = false});

  @override
  State<AddDeviceView> createState() => _AddDeviceViewState();
}

class _AddDeviceViewState extends State<AddDeviceView> {
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  late AutovalidateMode autovalidateMode;
  late AutovalidateMode deviceCodeAutovalidateMode;
  late final AddDeviceBloc addDeviceBloc;
  late final TextEditingController deviceCodeController;
  late final TextEditingController deviceSerialController;
  late final TextEditingController brandController;

  @override
  void initState() {
    addDeviceBloc = BlocProvider.of<AddDeviceBloc>(context);
    deviceCodeController =
        TextEditingController(text: addDeviceBloc.state.device.deviceCode);
    deviceSerialController =
        TextEditingController(text: addDeviceBloc.state.device.serialNumber);
    brandController =
        TextEditingController(text: addDeviceBloc.state.device.brand);

    autovalidateMode = AutovalidateMode.disabled;
    deviceCodeAutovalidateMode = AutovalidateMode.disabled;
    super.initState();
  }

  @override
  void dispose() {
    deviceCodeController.dispose();
    deviceSerialController.dispose();
    addDeviceBloc.close();
    super.dispose();
  }

  void submittDevice() {
    final isForm1Valid = _formKey.currentState?.validate() ?? false;
    final isForm2Valid = _formKey2.currentState?.validate() ?? false;

    if (isForm1Valid && isForm2Valid) {
      addDeviceBloc.add(SubmitDeviceEvent());
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
        title: Text(widget.isEditting ? 'edit_device'.tr : 'new_device'.tr),
      ),
      body: addDeviceBloc.state.isLoading
          ? LoadingIndicator()
          : addDeviceBloc.state.errorStateMsg != null
              ? ErrorMessageWidget(
                  errorMessage: addDeviceBloc.state.errorStateMsg!,
                  onRetry: () {
                    addDeviceBloc.add(LoadRequiredResources());
                  })
              : _buildPageForm(context),
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
                        // ..text = addDeviceBloc.state.device.deviceCode ?? '',
                        hintText: 'device_code'.tr,
                        onChanged: (deviceCode) {
                          deviceCodeAutovalidateMode =
                              AutovalidateMode.onUserInteraction;
                          addDeviceBloc
                              .add(DeviceCodeChanged(deviceCode: deviceCode));
                        },
                        validator: (code) {
                          if (code == null || code.isEmpty) {
                            return 'plz_device_code'.tr;
                          }

                          if (addDeviceBloc.state.checkDeviceCodeLoading) {
                            return 'verifying'.tr;
                          }
                          if (addDeviceBloc.state.deviceCodeCheckFailed) {
                            return 'validadtion_failed'.tr;
                          }
                          if (addDeviceBloc.state.deviceCodeTaken) {
                            return 'device_is_already_taken'.tr;
                          }

                          return null;
                        },
                        inputFormatters: [],
                      ),
                      const Gap(AppConstants.smallPadding),
                      if (addDeviceBloc.state.checkDeviceCodeLoading)
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
                          addDeviceBloc
                              .add(DeviceCodeChanged(deviceCode: deviceCode));
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
            if (addDeviceBloc.state.deviceCodeCheckFailed &&
                !addDeviceBloc.state.checkDeviceCodeLoading) ...[
              TextButton(
                  onPressed: () {
                    addDeviceBloc.add(CheckDeviceCode());
                  },
                  child: Text('validate_code'.tr))
            ]
          ],
        ),
      );

  SingleChildScrollView _buildPageForm(
    BuildContext context,
  ) {
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
                        // ..text =
                        //     addDeviceBloc.state.device.serialNumber ?? '',
                        // initialValue: addDeviceBloc.state.device.serialNumber,
                        onChanged: (serial) => addDeviceBloc
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
                              addDeviceBloc.add(
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
                      return addDeviceBloc.state.deviceTypes;
                    }
                    return addDeviceBloc.state.deviceTypes
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
                        addDeviceBloc.add(BrandChanged(brand: value.trim()));
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
                    addDeviceBloc.add(BrandChanged(
                        brand: brand.name.getDisplayValue(
                            AppLocalizations.getLocale(context))));
                  },
                  hideKeyboardOnDrag: true,
                ),
                // const Gap(AppConstants.smallPadding),
                // CustomDropDownButtonFormField<DeviceType>(
                //   hintText: 'brand'.tr,
                //   items: addDeviceBloc.state.deviceTypes,
                //   value: addDeviceBloc.state.device.type,
                //   onChanged: (type) =>
                //       addDeviceBloc.add(TypeChanged(type: type!)),
                //   validator: (type) => type == null ? 'plz_brand'.tr : null,
                // ),
                const Gap(AppConstants.smallPadding),
                CustomTextFormField(
                  hintText: 'model'.tr,
                  initialValue: addDeviceBloc.state.device.model,
                  onChanged: (model) =>
                      addDeviceBloc.add(ModelChanged(model: model)),
                  validator: (model) =>
                      model == null || model.isEmpty ? 'plz_model'.tr : null,
                ),
                const Gap(AppConstants.smallPadding),
                CustomTextFormField(
                  hintText: 'item_name'.tr,
                  initialValue: addDeviceBloc.state.device.itemName,
                  onChanged: (itemName) =>
                      addDeviceBloc.add(ItemNameChanged(itemName: itemName)),
                  // validator: (itemName) => itemName == null || itemName.isEmpty
                  //     ? 'plz_item_name'.tr
                  //     : null,
                ),
                const Gap(AppConstants.smallPadding),
                CustomTextFormField(
                  hintText: 'quantity'.tr,
                  initialValue: addDeviceBloc.state.device.qty,
                  onChanged: (qty) => addDeviceBloc.add(QtyChanged(qty: qty)),
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
                  initialValue: addDeviceBloc.state.device.problemDescription,
                  minLines: 5,
                  maxLines: 20,
                  onChanged: (problemDescription) => addDeviceBloc.add(
                      ProblemDescriptionChanged(
                          problemDescription: problemDescription)),
                  validator: (problem) => problem == null || problem.isEmpty
                      ? 'plz_problem_description'.tr
                      : null,
                ),
                const Gap(AppConstants.smallPadding),
                CustomTextFormField(
                  hintText: 'attachments'.tr,
                  initialValue: addDeviceBloc.state.device.attachments,
                  minLines: 5,
                  maxLines: 20,
                  onChanged: (attachments) => addDeviceBloc
                      .add(AttachmentsChanged(attachments: attachments)),
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
                CustomDropDownButtonFormField<TranslatableValue>(
                  hintText: 'warranty_type'.tr,
                  value: addDeviceBloc.state.device.warrantyType,
                  items: getWarratyStatusChoises(),
                  onChanged: (warrantyType) => addDeviceBloc
                      .add(WarrantyTypeChanged(warrantyType: warrantyType!)),
                  validator: (warrantyType) =>
                      warrantyType == null ? 'plz_warranty_type'.tr : null,
                ),
                const Gap(AppConstants.smallPadding),
                CustomDropDownButtonFormField<Company>(
                  hintText: 'source_company'.tr,
                  value: addDeviceBloc.state.device.sourceCompany,
                  items: addDeviceBloc.state.companies,
                  onChanged: (sourceCompany) => addDeviceBloc
                      .add(SourceCompanyChanged(sourceCompany: sourceCompany!)),
                  validator: (company) {
                    // if (addDeviceBloc.state.device.warrantyType?.object == "in")
                    //   return 'plz_source_company'.tr;
                    return company == null ? 'plz_source_company'.tr : null;
                    // return null;
                  },
                ),
                const Gap(AppConstants.smallPadding),
                CustomTextFormField(
                  hintText: 'reason_for_warranty'.tr,
                  initialValue: addDeviceBloc.state.device.reasonForWarranty,
                  minLines: 5,
                  maxLines: 20,
                  onChanged: (reasonForWarranty) => addDeviceBloc.add(
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
                const Gap(AppConstants.mediumPadding),
                ImagePickerFormField(
                  initialValue: addDeviceBloc.state.device.images,
                  onChanged: (List<File> images) =>
                      addDeviceBloc.add(ImagesChanged(images: images)),
                ),
                const Gap(AppConstants.extraLargePadding),
                ElevatedButton(
                    onPressed: () {
                      submittDevice();
                    },
                    child: Center(child: Text('create'.tr))),
                const Gap(AppConstants.extraLargePadding),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
