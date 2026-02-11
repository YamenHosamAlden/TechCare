import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:tech_care_app/app/app_localization.dart';
import 'package:tech_care_app/core/entities/translatable_value.dart';
import 'package:tech_care_app/core/util/app_colors.dart';
import 'package:tech_care_app/core/util/app_constants.dart';
import 'package:tech_care_app/core/util/helpers/app_url_launcher.dart';
import 'package:tech_care_app/core/util/helpers/list_of_priorty.dart';
import 'package:tech_care_app/core/util/helpers/show_sack_bar.dart';
import 'package:tech_care_app/core/util/input_Formatters/phone_input_formatter.dart';
import 'package:tech_care_app/core/util/input_validators/phone_number_validator.dart';
import 'package:tech_care_app/core/widgets/custom_country_code_picker.dart';
import 'package:tech_care_app/core/widgets/custom_drop_down_button_form_field.dart';
import 'package:tech_care_app/core/widgets/custom_text_form_field.dart';
import 'package:tech_care_app/core/widgets/app_progress_indicator.dart';
import 'package:tech_care_app/core/widgets/dialogs/receipt_created_dialog.dart';
import 'package:tech_care_app/core/widgets/error_message_widget.dart';
import 'package:tech_care_app/core/widgets/loading_indicator.dart';
import 'package:tech_care_app/dependency_injection.dart';
import 'package:tech_care_app/features/create_receipt/presentation/bloc/create_reciept_bloc/create_receipt_bloc.dart';
import 'package:tech_care_app/features/create_receipt/presentation/widgets/receipt_collection.dart';
import 'package:tech_care_app/routes/app_router.dart';

class NewReceiptPage extends StatefulWidget {
  const NewReceiptPage({super.key});

  static Route<dynamic> route({RouteSettings? settings}) => MaterialPageRoute(
      settings: settings, builder: (context) => const NewReceiptPage());

  @override
  State<NewReceiptPage> createState() => _NewReceiptPageState();
}

class _NewReceiptPageState extends State<NewReceiptPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<CreateReceiptBloc>(
      create: (context) => di<CreateReceiptBloc>()..add(LoadPageResources()),
      child: NewReceiptView(),
    );
  }
}

class NewReceiptView extends StatefulWidget {
  const NewReceiptView({super.key});

  @override
  State<NewReceiptView> createState() => _NewReceiptViewState();
}

class _NewReceiptViewState extends State<NewReceiptView> {
  final _formKey = GlobalKey<FormState>();
  AutovalidateMode? autovalidateMode = AutovalidateMode.disabled;
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  final _animationCurve = Curves.easeInOut;
  final _animationDuration = Durations.medium4;

  void submittReceipt() {
    if (_formKey.currentState!.validate()) {
      final _bloc = BlocProvider.of<CreateReceiptBloc>(context);
      if (_bloc.state.collections
          .any((collection) => collection.devices.isEmpty)) {
        showSnackBar(context, msg: 'empty_collections_validation_msg'.tr);
      } else {
        _bloc.add(NewReceiptSubmitted());
      }
    } else {
      autovalidateMode = AutovalidateMode.onUserInteraction;
      showSnackBar(context, msg: 'required_fields_validation_msg'.tr);
    }
  }

  @override
  Widget build(BuildContext context) {
    final _bloc = BlocProvider.of<CreateReceiptBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'new_receipt'.tr,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocConsumer<CreateReceiptBloc, CreateReceiptState>(
        listener: (context, state) async {
          if (state is ReceiptCreated) {
            appUrlLauncher(state.receiptUrl);
            // printHtml(state.receiptHtml);

            ReceiptCreatedDialog.show(
              context,
              onPrint: () => appUrlLauncher(state.receiptUrl),
            ).then((value) => AppRouter.navigator.pop(true));
          }
          if (state.errorMsg != null) {
            showSnackBar(context,
                msg: state.errorMsg!
                    .getDisplayValue(AppLocalizations.getLocale(context)));
          }
        },
        buildWhen: (previous, current) {
          if (current is ReceiptCreated) {
            return false;
          }
          return true;
        },
        builder: (context, state) {
          return state.isPageLoading
              ? Center(child: LoadingIndicator())
              : state.errorStateMsg != null
                  ? ErrorMessageWidget(
                      errorMessage: state.errorStateMsg!,
                      onRetry: () {
                        _bloc.add(LoadPageResources());
                      })
                  : Form(
                      key: _formKey,
                      autovalidateMode: autovalidateMode,
                      child: ListView(
                        padding: EdgeInsets.all(AppConstants.mediumPadding),
                        children: [
                          ..._buildCustomerInfo(context, _bloc),
                          Gap(AppConstants.mediumPadding),
                          ..._buildPriorityInfo(context, _bloc),
                          Gap(AppConstants.largePadding),
                          ..._buildCollections(context, _bloc, state),
                          Gap(AppConstants.extraLargePadding),
                          _buildCreateBtn(state),
                          Gap(AppConstants.extraLargePadding),
                        ],
                      ),
                    );
        },
      ),
    );
  }

  SizedBox _buildCreateBtn(CreateReceiptState state) {
    return SizedBox(
      height: 50,
      child: AnimatedSwitcher(
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
                    onPressed: submittReceipt,
                    child: Center(child: Text('create'.tr)),
                  ),
                ),
              ),
      ),
    );
  }

  List<Widget> _buildCustomerInfo(
      BuildContext context, CreateReceiptBloc _bloc) {
    return [
      Text(
        'customer_info'.tr,
        style: Theme.of(context)
            .textTheme
            .titleMedium!
            .copyWith(fontWeight: FontWeight.bold),
      ),
      Gap(AppConstants.smallPadding),
      CustomTextFormField(
        initialValue: _bloc.state.customerName,
        hintText: 'customer_name'.tr,
        onChanged: (name) => _bloc.add(CustomerNameChanged(customerName: name)),
        validator: (customerName) {
          if (customerName!.isEmpty) {
            return 'plz_customer_name'.tr;
          }
          return null;
        },
      ),
      const Gap(AppConstants.smallPadding),
      Directionality(
        textDirection: TextDirection.rtl,
        child: CustomTextFormField(
          initialValue: _bloc.state.customerPhone,
          hintTextDirection: AppLocalizations.getTextDirection(context),
          textAlign: TextAlign.end,
          suffixIcon: CustomCountryCodePicker(
              initialSelection: '+963',
              onChanged: (code) =>
                  _bloc.add(CountryCodeChanged(countryCode: code))),
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
      ),
    ];
  }

  List<Widget> _buildPriorityInfo(
      BuildContext context, CreateReceiptBloc _bloc) {
    return [
      Text(
        'priority'.tr,
        style: Theme.of(context).textTheme.titleMedium!.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
      Gap(AppConstants.smallPadding),
      CustomDropDownButtonFormField<TranslatableValue>(
        value: _bloc.state.priority,
        hintText: 'priority'.tr,
        items: listOfPriorty(),
        onChanged: (priority) =>
            _bloc.add(PriorityChanged(priority: priority!)),
        validator: (priority) => priority == null ? 'plz_priority'.tr : null,
      ),
      const Gap(AppConstants.smallPadding),
      AnimatedSwitcher(
        duration: Durations.medium2,
        switchInCurve: _animationCurve,
        switchOutCurve: _animationCurve,
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
        child: _bloc.state.priority?.object == 'Shipping'
            ? CustomTextFormField(
                initialValue: _bloc.state.shippingNumber,
                hintText: 'shipping_number'.tr,
                onChanged: (number) =>
                    _bloc.add(ShippingNumberChanged(shippingNumber: number)),
                validator: (priority) => priority == null || priority.isEmpty
                    ? 'plz_shipping_num'.tr
                    : null,
              )
            : SizedBox(),
      ),
    ];
  }

  List<Widget> _buildCollections(
      BuildContext context, CreateReceiptBloc _bloc, CreateReceiptState state) {
    return [
      RichText(
        text: TextSpan(
          text: '${'collections'.tr} ',
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontWeight: FontWeight.bold),
          children: <TextSpan>[
            TextSpan(
                text: "(${state.collections.length.toString()})",
                style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      Gap(AppConstants.mediumPadding),
      AnimatedList(
        key: _listKey,
        primary: false,
        shrinkWrap: true,
        initialItemCount: state.collections.length,
        itemBuilder: (context, index, animation) {
          return FadeTransition(
            opacity: animation.drive(
              Tween<double>(begin: 0, end: 1)
                  .chain(CurveTween(curve: Curves.easeInOut)),
            ),
            child: SizeTransition(
              sizeFactor: animation.drive(
                Tween<double>(begin: 0, end: 1)
                    .chain(CurveTween(curve: _animationCurve)),
              ),
              child: ReceiptCollection(
                key: ObjectKey(state.collections.elementAt(index)),
                buildDeleteButton: state.collections.length > 1,
                collectionIndex: index,
                collection: state.collections.elementAt(index),
                onDelete: () {
                  _listKey.currentState?.removeItem(
                      duration: _animationDuration,
                      index,
                      (context, animation) =>
                          removeItemBuilder(context, index, animation, state));
                },
              ),
            ),
          );
        },
      ),
      Row(children: [
        TextButton.icon(
          style: ButtonStyle(
              foregroundColor:
                  MaterialStatePropertyAll(AppColors.martiniqueColor)),
          onPressed: () {
            _bloc.add(AddCollectionEvent());
            _listKey.currentState?.insertItem(
                duration: _animationDuration, state.collections.length);
          },
          icon: Icon(Icons.add_box_outlined),
          label: Text('add_collection'.tr),
        ),
      ]),
    ];
  }

  Widget removeItemBuilder(BuildContext context, int index,
      Animation<double> animation, CreateReceiptState state) {
    return FadeTransition(
      opacity: animation.drive(
        Tween<double>(begin: 0, end: 1)
            .chain(CurveTween(curve: Curves.easeInOut)),
      ),
      child: SizeTransition(
        sizeFactor: animation.drive(
          Tween<double>(begin: 0, end: 1)
              .chain(CurveTween(curve: _animationCurve)),
        ),
        child: IgnorePointer(
          ignoring: true,
          child: ReceiptCollection(
            key: ObjectKey(state.collections.elementAt(index)),
            buildDeleteButton: state.collections.length > 1,
            collectionIndex: index,
            collection: state.collections.elementAt(index),
          ),
        ),
      ),
    );
  }
}
