import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:tech_care_app/app/app_localization.dart';
import 'package:tech_care_app/core/util/app_colors.dart';
import 'package:tech_care_app/core/util/app_constants.dart';
import 'package:tech_care_app/core/util/helpers/show_sack_bar.dart';
import 'package:tech_care_app/core/widgets/custom_text_form_field.dart';
import 'package:tech_care_app/core/widgets/dialogs/codes_validation_scanner_dialog.dart';
import 'package:tech_care_app/core/widgets/error_message_widget.dart';
import 'package:tech_care_app/core/widgets/loading_indicator.dart';
import 'package:tech_care_app/dependency_injection.dart';
import 'package:tech_care_app/features/finished_receipts/presentation/finishing_report_bloc/finishing_report_bloc.dart';
import 'package:tech_care_app/features/finished_receipts/presentation/widgets/device_card_details.dart';
import 'package:tech_care_app/routes/app_routes.dart';

class finishingReportPage extends StatefulWidget {
  final int containerId;

  const finishingReportPage({super.key, required this.containerId});

  static Route<dynamic> route({required int params, RouteSettings? settings}) =>
      MaterialPageRoute(
          settings: settings,
          builder: (context) => finishingReportPage(
                containerId: params,
              ));

  @override
  State<finishingReportPage> createState() => _finishingReportPageState();
}

class _finishingReportPageState extends State<finishingReportPage> {
  late final FinishingReportBloc _bloc;
  late final GlobalKey<FormState> _formKey;
  AutovalidateMode? _formAutovalidateMode;
  late String _note;

  @override
  void initState() {
    _bloc = di<FinishingReportBloc>();
    _formKey = GlobalKey<FormState>();
    _note = '';
    _onLoadFinishingReport();
    super.initState();
  }

  @override
  void dispose() {
    _bloc.close();
    _formKey.currentState?.dispose();
    super.dispose();
  }

  _onLoadFinishingReport() {
    _bloc.add(GetFinishingReport(containerId: widget.containerId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FinishingReportBloc, FinishingReportState>(
      bloc: _bloc,
      listenWhen: (previous, current) => current.finished,
      listener: (context, state) {
        if (state.finished) {
          showSnackBar(
            context,
            msg: 'checkout_done_sucfuly'.tr,
            backgroundColor: AppColors.eucalyptusColor,
          );
          if (Navigator.canPop(context)) {
            Navigator.of(context).popUntil((route) =>
                route.settings.name == AppRoutes.finishedReceiptsPageRoute);
          }
        }
      },
      builder: (context, state) {
        return Scaffold(
            appBar: AppBar(
              title: Text('f_report'.tr),
            ),
            body: state.isLoading
                ? Center(
                    child: LoadingIndicator(),
                  )
                : state is FinishingReportErrorState
                    ? ErrorMessageWidget(
                        errorMessage: state.errorMessage,
                        onRetry: () {
                          _onLoadFinishingReport();
                        },
                      )
                    : RefreshIndicator(
                        onRefresh: () async => _onLoadFinishingReport(),
                        child: Form(
                          key: _formKey,
                          autovalidateMode: _formAutovalidateMode,
                          child: ListView(
                            padding: const EdgeInsets.all(
                                AppConstants.mediumPadding),
                            children: <Widget>[
                              RichText(
                                text: TextSpan(
                                  text: "${'receipt_no'.tr} ",
                                  children: [
                                    TextSpan(
                                        text: state
                                            .finishingReport!.receiptNumber)
                                  ],
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(fontWeight: FontWeight.w900),
                                ),
                              ),
                              const Gap(AppConstants.smallPadding),
                              RichText(
                                text: TextSpan(
                                  text: "${'customer_name'.tr}: ",
                                  children: [
                                    TextSpan(
                                        text:
                                            state.finishingReport!.customerName)
                                  ],
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                              const Gap(AppConstants.extraSmallPadding),
                              RichText(
                                text: TextSpan(
                                  text: "${'customer_phone_number'.tr}: ",
                                  children: [
                                    TextSpan(
                                        text: state
                                            .finishingReport!.customerPhone)
                                  ],
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                              const Gap(AppConstants.extraSmallPadding),
                              RichText(
                                text: TextSpan(
                                  text: "${'priority'.tr}: ",
                                  children: [
                                    TextSpan(
                                        text: state.finishingReport!.priority
                                            .getDisplayValue(
                                                AppLocalizations.of(context)!
                                                    .locale)),
                                    TextSpan(
                                        text: state.finishingReport!
                                                    .shippingNumber ==
                                                null
                                            ? ''
                                            : ' - '),
                                    TextSpan(
                                        text: state
                                            .finishingReport!.shippingNumber),
                                  ],
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                              const Gap(AppConstants.extraSmallPadding),
                              RichText(
                                text: TextSpan(
                                  text: "${'date'.tr}: ",
                                  children: [
                                    TextSpan(
                                      text: DateFormat('dd/MM/yyyy hh:mm a')
                                          .format(state.finishingReport!.date),
                                    )
                                  ],
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                              const Gap(30),
                              Text(
                                '${'devices'.tr}',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                              const Gap(AppConstants.mediumPadding),
                              Column(
                                children: state.finishingReport!.devices
                                    .map(
                                      (device) => DeviceCardDetails(
                                        bloc: _bloc,
                                        device: device,
                                      ),
                                    )
                                    .toList(),
                              ),
                              const Gap(AppConstants.mediumPadding),
                              RichText(
                                text: TextSpan(
                                  text: "${'work_duration'.tr}. ",
                                  children: [
                                    TextSpan(text: state.finishingReport!.time)
                                  ],
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                              const Gap(AppConstants.mediumPadding),
                              RichText(
                                text: TextSpan(
                                  text: "${'op_cost'.tr}. ",
                                  children: [
                                    TextSpan(
                                        text: state.finishingReport!
                                            .totalOperationalCost)
                                  ],
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                              const Gap(AppConstants.mediumPadding),
                              RichText(
                                text: TextSpan(
                                  text: "${'total_cost'.tr}. ",
                                  children: [
                                    TextSpan(
                                        text: state.finishingReport!.finalCost)
                                  ],
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                              const Gap(AppConstants.mediumPadding),
                              RichText(
                                text: TextSpan(
                                  text: "${'total_fixed_cost'.tr}. ",
                                  children: [
                                    TextSpan(
                                        text: state
                                            .finishingReport!.totalFixedCost)
                                  ],
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                              const Gap(AppConstants.mediumPadding),
                              _buildCostInfo(
                                  context,
                                  state,
                                  "${'total_amount'.tr}. ",
                                  state.checkoutFormData?.totalAmount
                                          .toString() ??
                                      '0'),
                              const Gap(AppConstants.extraLargePadding),
                              CustomTextFormField(
                                label: 'note'.tr,
                                hintText: 'note'.tr,
                                onSaved: (note) {
                                  _note = note ?? '';
                                },
                                labelStyle:
                                    Theme.of(context).textTheme.titleMedium,
                                minLines: 5,
                                maxLines: 10,
                              ),
                              const Gap(AppConstants.extraLargePadding),
                              state.checkoutLoading
                                  ? Center(child: CircularProgressIndicator())
                                  : ElevatedButton(
                                      onPressed: () {
                                        _checkout();
                                      },
                                      child: Text("${'finish'.tr}")),
                              Gap(AppConstants.extraLargePadding),
                            ],
                          ),
                        ),
                      ));
      },
    );
  }

  Row _buildCostInfo(BuildContext context, FinishingReportState state,
      String lable, String cost) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          lable,
          // "${'total_payment'.tr}. ",
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontWeight: FontWeight.w700),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // if (state.finishingReport!.prefinalCost !=
              //     state.finishingReport!.finalCost)
              // Text(state.finishingReport!.prefinalCost,
              //     style: Theme.of(context).textTheme.titleMedium!.copyWith(
              //         decorationThickness: 2,
              //         decorationStyle: TextDecorationStyle.solid,
              //         decoration: TextDecoration.lineThrough,
              //         fontWeight: FontWeight.w900,
              // color: AppColors.eucalyptusColor)),
              // Text(state.finishingReport!.finalCost,
              AnimatedSwitcher(
                duration: Durations.medium2,
                switchInCurve: Curves.easeInOut,
                switchOutCurve: Curves.easeInOut,
                transitionBuilder: (child, animation) => FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position:
                        Tween<Offset>(begin: Offset(0, .5), end: Offset(0, 0))
                            .animate(animation),
                    child: child,
                  ),
                ),
                layoutBuilder: (currentChild, previousChildren) => Stack(
                  alignment: AppLocalizations.isDirectionRTL(context)
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  children: <Widget>[
                    ...previousChildren,
                    if (currentChild != null) currentChild,
                  ],
                ),
                child: Text(cost,
                    key: Key(cost),
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.w900,
                        color: AppColors.eucalyptusColor)),
              )
            ],
          ),
        )
      ],
    );
  }

  Future<bool> _validateCodes(
      BuildContext context, FinishingReportState state) {
    return showDialog<List<String>?>(
      context: context,
      builder: (context) => CodesValidationScannerDialog(
        codes: state.finishingReport!.devices
            .map((device) => device.deviceCode)
            .toList(),
      ),
    ).then<bool>((codes) {
      if (codes == null || codes.isEmpty) {
        return false;
      }
      return true;
    });
  }

  void _checkout() {
    _formKey.currentState?.save();
    print(_note);
    setState(() {
      _formAutovalidateMode = AutovalidateMode.always;
    });
    if (_formKey.currentState?.validate() ?? false) {
      _bloc.add(Checkout(note: _note));
    } else {
      showSnackBar(context, msg: 'required_fields_validation_msg'.tr);
    }
  }
}

  // Future<bool> _showCheckoutDialog() {
  //   return showDialog<List<String>?>(
  //       context: context,
  //       barrierDismissible: false,
  //       builder: (context) => BlocProvider.value(
  //             value: _bloc,
  //             child: CheckoutDialog(),
  //           )).then<bool>((codes) {
  //     if (codes == null || codes.isEmpty) {
  //       return false;
  //     }
  //     return true;
  //   });
  // }
// }
