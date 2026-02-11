import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:tech_care_app/app/app_localization.dart';
import 'package:tech_care_app/core/entities/translatable_value.dart';
import 'package:tech_care_app/core/util/app_constants.dart';
import 'package:tech_care_app/core/util/helpers/list_of_priorty.dart';
import 'package:tech_care_app/core/util/helpers/show_sack_bar.dart';
import 'package:tech_care_app/core/util/input_Formatters/phone_input_formatter.dart';
import 'package:tech_care_app/core/util/input_validators/phone_number_validator.dart';
import 'package:tech_care_app/core/widgets/app_progress_indicator.dart';
import 'package:tech_care_app/core/widgets/custom_drop_down_button_form_field.dart';
import 'package:tech_care_app/core/widgets/custom_text_form_field.dart';
import 'package:tech_care_app/dependency_injection.dart';
import 'package:tech_care_app/features/message_viewer/domain/usecases/view_snackbar_msg_usecase.dart';
import 'package:tech_care_app/features/receipts_container_details/domain/entities/container_details.dart';
import 'package:tech_care_app/features/receipts_container_details/domain/usecases/edit_receipt_details_usecase.dart';
import 'package:tech_care_app/features/receipts_container_details/presentation/bloc/edit_receipt_bloc/edit_receipt_bloc.dart';
import 'package:tech_care_app/features/receipts_container_details/presentation/widgets/edit_phone_bottom_sheet.dart';
import 'package:tech_care_app/routes/app_router.dart';
import 'package:tech_care_app/routes/route_params.dart';

class EditContainerDetailsPage extends StatefulWidget {
  final ContainerDetails containerDetails;

  const EditContainerDetailsPage({super.key, required this.containerDetails});

  static Route<dynamic> route(
          {required ReceiptContainerDetailsParams params,
          RouteSettings? settings}) =>
      MaterialPageRoute(
          settings: settings,
          builder: (context) => EditContainerDetailsPage(
                containerDetails: params.containerDetails,
              ));

  @override
  State<EditContainerDetailsPage> createState() =>
      _EditContainerDetailsPageState();
}

class _EditContainerDetailsPageState extends State<EditContainerDetailsPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  AutovalidateMode? autovalidateMode = AutovalidateMode.disabled;
  late EditReceiptBloc _bloc;

  @override
  void initState() {
    _bloc = EditReceiptBloc(
        containerDetails: widget.containerDetails,
        editReceiptDetailsUsecase: di<EditReceiptDetailsUsecase>(),
        viewSnackBarMsgUsecase: di<ViewSnackBarMsgUsecase>());

    super.initState();
  }

  void submittReceipt() {
    if (_formKey.currentState!.validate()) {
      _bloc.add(EditReceiptDetailsEvent(
          containerDetails: _bloc.state.containerDetails!));
    } else {
      autovalidateMode = AutovalidateMode.onUserInteraction;
      showSnackBar(context, msg: 'required_fields_validation_msg'.tr);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _bloc,
      child: Scaffold(
          appBar: AppBar(
            title: Text(
              'edit_receipt'.tr,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          body: BlocListener<EditReceiptBloc, EditReceiptState>(
            bloc: _bloc,
            listener: (context, state) {
              if (state.editCompleted) {
                AppRouter.navigator.pop(context);
              }
            },
            child: Form(
              key: _formKey,
              autovalidateMode: autovalidateMode,
              child: ListView(
                padding: EdgeInsets.all(AppConstants.mediumPadding),
                children: [
                  _buildCustomerInfo(
                    context,
                  ),
                  Gap(AppConstants.mediumPadding),
                  _buildPriorityInfo(context),
                  Gap(AppConstants.mediumPadding),
                  _buildEditBtn()
                ],
              ),
            ),
          )),
    );
  }

  Widget _buildCustomerInfo(
    BuildContext context,
  ) {
    return BlocBuilder<EditReceiptBloc, EditReceiptState>(
      bloc: _bloc,
      builder: (context, state) {
        print(
            "phone number change ${state.countryCode} ${state.containerDetails!.customerPhone}");
        return Column(children: [
          Text(
            'customer_info'.tr,
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          Gap(AppConstants.smallPadding),
          CustomTextFormField(
            initialValue: state.containerDetails!.customerName,
            hintText: 'customer_name'.tr,
            onChanged: (name) =>
                _bloc.add(CustomerNameChanged(customerName: name)),
            validator: (customerName) {
              if (customerName!.isEmpty) {
                return 'plz_customer_name'.tr;
              }
              return null;
            },
          ),
          const Gap(AppConstants.smallPadding),
          CustomTextFormField(
            readOnly: true,
            textDirection: TextDirection.ltr,
            textAlign: AppLocalizations.isDirectionRTL(context)
                ? TextAlign.end
                : TextAlign.start,
            // enabled: false,
            onTap: () {
              editPhoneBottomSheet(context, bloc: _bloc);
            },
            controller: TextEditingController(
                text: state.containerDetails!.customerPhone),
            suffixIcon: IconButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                editPhoneBottomSheet(context, bloc: _bloc);
              },
              icon: Icon(
                Icons.edit,
              ),
            ),
            hintText: 'customer_phone_number'.tr,
            onChanged: (phone) =>
                _bloc.add(CustomerPhoneChanged(customerPhone: phone)),
            validator: (phoneNumber) {
              if (phoneNumber == null || phoneNumber.isEmpty) {
                return 'plz_customer_phone'.tr;
              } else if (!isPhoneNumber(phoneNumber)) {
                return 'plz_valid_phone'.tr;
              }
              return null;
            },
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
              ArabicNumberTextInputFormatter(),
            ],
          ),
        ]);
      },
    );
  }

  Widget _buildPriorityInfo(
    BuildContext context,
  ) {
    return BlocBuilder<EditReceiptBloc, EditReceiptState>(
      bloc: _bloc,
      builder: (context, state) {
        return Column(children: [
          Text(
            'priority'.tr,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          Gap(AppConstants.smallPadding),
          CustomDropDownButtonFormField<TranslatableValue>(
            hintText: 'priority'.tr,
            value: state.containerDetails?.priority,
            items: listOfPriorty(),
            onChanged: (priority) {
              _bloc.add(PriorityChanged(priority: priority!));
            },
            validator: (priority) =>
                priority == null ? 'plz_priority'.tr : null,
          ),
          const Gap(AppConstants.smallPadding),
          AnimatedSwitcher(
            duration: Durations.medium2,
            switchInCurve: Curves.easeInOut,
            switchOutCurve: Curves.easeInOut,
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(
                opacity: animation,
                child: SizeTransition(
                  sizeFactor: animation,
                  axisAlignment: -1.0,
                  child: child,
                ),
              );
            },
            child: state.containerDetails?.priority.object == 'Shipping'
                ? CustomTextFormField(
                    initialValue:
                        state.containerDetails?.priorityShippingNumber,
                    hintText: 'shipping_number'.tr,
                    onChanged: (number) => _bloc
                        .add(ShippingNumberChanged(shippingNumber: number)),
                    validator: (priority) =>
                        priority == null || priority.isEmpty
                            ? 'plz_shipping_num'.tr
                            : null,
                  )
                : SizedBox(),
          ),
        ]);
      },
    );
  }

  Widget _buildEditBtn() {
    return SizedBox(
      height: 50,
      child: BlocBuilder<EditReceiptBloc, EditReceiptState>(
        bloc: _bloc,
        builder: (context, state) {
          return AnimatedSwitcher(
            duration: Durations.extralong4,
            child: state.isLoading
                ? Center(
                    child: AppProgressIndicator(
                    progress: state.uploadProgress,
                  ))
                : Center(
                    child: SizedBox(
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _bloc.add(EditReceiptDetailsEvent(
                                containerDetails: state.containerDetails!));
                          }
                        },
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
