import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tech_care_app/app/app_localization.dart';
import 'package:tech_care_app/core/util/app_colors.dart';
import 'package:tech_care_app/core/util/app_constants.dart';
import 'package:tech_care_app/core/widgets/custom_drop_down_button_form_field.dart';
import 'package:tech_care_app/core/widgets/custom_text_form_field.dart';
import 'package:tech_care_app/core/widgets/dialogs/communication_dialog.dart';
import 'package:tech_care_app/core/widgets/dialogs/number_picker_dialog.dart';
import 'package:tech_care_app/core/widgets/error_message_widget.dart';
import 'package:tech_care_app/core/widgets/loading_indicator.dart';
import 'package:tech_care_app/core/widgets/my_circle_painter.dart';
import 'package:tech_care_app/dependency_injection.dart';
import 'package:tech_care_app/features/quality_report/domain/entity/external_item.dart';
import 'package:tech_care_app/features/quality_report/domain/entity/group_user.dart';
import 'package:tech_care_app/features/quality_report/presentation/bloc/quality_report_bloc.dart';
import 'package:tech_care_app/features/quality_report/presentation/widgets/acceptance_status_widget.dart';
import 'package:tech_care_app/features/quality_report/presentation/widgets/maintenance_summary_card.dart';

class QualityReportPage extends StatefulWidget {
  final int deviceId;
  static Route<dynamic> route({required int params, RouteSettings? settings}) =>
      MaterialPageRoute(
          settings: settings,
          builder: (context) => QualityReportPage(
                deviceId: params,
              ));
  const QualityReportPage({super.key, required this.deviceId});

  @override
  State<QualityReportPage> createState() => _QualityReportPageState();
}

class _QualityReportPageState extends State<QualityReportPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di<QualityReportBloc>()
        ..add(LoadQualityReportFeed(deviceId: widget.deviceId)),
      child: QualityReportView(deviceId: widget.deviceId),
    );
  }
}

class QualityReportView extends StatefulWidget {
  final int deviceId;
  const QualityReportView({required this.deviceId, super.key});

  @override
  State<QualityReportView> createState() => _QualityReportViewState();
}

class _QualityReportViewState extends State<QualityReportView> {
  late final QualityReportBloc _bloc;
  final _qualityReportFormKey = GlobalKey<FormState>();
  final _ExternalItemsFormKey = GlobalKey<FormState>();
  AutovalidateMode qualityReportAutovalidateMode = AutovalidateMode.disabled;
  AutovalidateMode externalItemsAutovalidateMode = AutovalidateMode.disabled;

  late final TextEditingController testDuration;
  late final TextEditingController report;
  late final TextEditingController fixedCost;
  late final PageController? _pageController;
  bool _pageControllerInitialized = false;

  List<ExternalItem> pricedExternalitems = [];
  DurationHolder durationHolder = DurationHolder();

  @override
  void initState() {
    _bloc = BlocProvider.of<QualityReportBloc>(context);
    report = TextEditingController();
    fixedCost = TextEditingController(text: '0');
    testDuration = TextEditingController(text: '00 : 00');

    super.initState();
  }

  @override
  void dispose() {
    _bloc.close();
    testDuration.dispose();
    report.dispose();
    fixedCost.dispose();
    _pageController?.dispose();
    super.dispose();
  }

  _submitReport() {
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      qualityReportAutovalidateMode = AutovalidateMode.always;
    });
    final bool isFormValid = _qualityReportFormKey.currentState!.validate();
    print('************ $isFormValid ************');
    if (isFormValid) {
      pricedExternalitems.clear();
      _qualityReportFormKey.currentState!.save();
      _bloc.add(SubmitQualityReport(
        deviceId: widget.deviceId,
        report: report.text,
        fixedCost: fixedCost.text,
        testDuration: testDuration.text,
      ));
    }
  }

  _submitExternalItems() {
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      externalItemsAutovalidateMode = AutovalidateMode.always;
    });

    if (_ExternalItemsFormKey.currentState!.validate()) {
      pricedExternalitems.clear();
      _ExternalItemsFormKey.currentState!.save();
      _bloc.add(SubmitExternalItems(
        deviceId: widget.deviceId,
        pricedExternalItems: pricedExternalitems,
      ));
    }
  }

  int currentStep = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('q_report'.tr),
      ),
      body: BlocConsumer<QualityReportBloc, QualityReportState>(
        listenWhen: (previous, current) {
          if (previous.pageLoading &&
              !current.pageLoading &&
              !_pageControllerInitialized) {
            _pageController = PageController(
                initialPage: current.externalItemsPricingCompleted ? 1 : 0);
            _pageControllerInitialized = true;
            return false;
          } else if (current.externalItemsPricingCompleted &&
              current.submittingExternalItems) {
            if (_pageController?.page != 1) {
              _pageController?.animateToPage(1,
                  duration: Durations.long2, curve: Curves.easeInOut);
              return false;
            }
          }
          return true;
        },
        listener: (context, state) {
          if (state.reportSubmitted == true) {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          }
        },
        buildWhen: (previous, current) {
          // if (previous.loadingsummary && !current.loadingsummary) {
          //   return false;
          // }
          if (current.reportSubmitted == true) {
            return false;
          }
          return true;
        },
        bloc: _bloc,
        builder: (context, state) {
          if (state.pageLoading) {
            return Center(
              child: LoadingIndicator(),
            );
          }
          if (state.errorMsg != null) {
            return ErrorMessageWidget(
              onRetry: () {
                _bloc.add(LoadQualityReportFeed(deviceId: widget.deviceId));
              },
              errorMessage: state.errorMsg!,
            );
          }

          return Stack(
            children: [
              _drawBackground(context),
              PageView(
                controller: _pageController,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  _buildExternalItemsPricingForm(state),
                  _buildQualityReportForm(state, context),
                ],
              )
            ],
          );
        },
      ),
    );
  }

  Widget _buildExternalItemsPricingForm(
    QualityReportState state,
  ) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppConstants.mediumPadding),
      child: Form(
        key: _ExternalItemsFormKey,
        autovalidateMode: externalItemsAutovalidateMode,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('external_items_pricing'.tr,
                style: Theme.of(context).textTheme.titleLarge),
            _buildExternalItems(state),
            const Gap(AppConstants.extraLargePadding),
            state.submittingExternalItems
                ? Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: () {
                      _submitExternalItems();
                    },
                    child: Center(child: Text('submit'.tr)),
                  )
          ],
        ),
      ),
    );
  }

  Widget _buildQualityReportForm(
      QualityReportState state, BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        AppConstants.mediumPadding,
        AppConstants.mediumPadding,
        AppConstants.mediumPadding,
        AppConstants.extraLargePadding * 2,
      ),
      child: Form(
        key: _qualityReportFormKey,
        autovalidateMode: qualityReportAutovalidateMode,
        child: Column(
          children: [
            AcceptanceStatusWidget(
              onChanged: (acceptance) {
                if (!acceptance) {
                  testDuration.text = '';
                }
                _bloc.add(ChangeAcceptanceStatus(acceptanceStatus: acceptance));
              },
            ),
            const Gap(AppConstants.largePadding),
            AnimatedCrossFade(
              firstChild: _buildAcceptedForm(
                state: state,
                customerNotified: state.customerNotified,
                salesReturn: state.salesReturn,
                phoneNumber: state.feed!.customer_phone,
              ),
              secondChild: _buildRejectedForm(
                returnToGroup: state.returnToGroup,
              ),
              crossFadeState: state.acceptanceStatus
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              duration: Durations.medium2,
              alignment: Alignment.topCenter,
              sizeCurve: Curves.easeInOut,
            ),
            const Gap(AppConstants.mediumPadding),
            CustomTextFormField(
              controller: report,
              labelStyle: Theme.of(context).textTheme.titleMedium,
              label: 'report'.tr,
              hintText: 'report'.tr,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'plz_report'.tr;
                }
                return null;
              },
              minLines: 5,
              maxLines: 20,
            ),
            const Gap(AppConstants.extraLargePadding),
            state.submittingReport
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: state.maintenanceSummary == null
                        ? null
                        : () {
                            _submitReport();
                          },
                    child: Center(child: Text('create'.tr)),
                  )
          ],
        ),
      ),
    );
  }

  ListView _buildExternalItems(QualityReportState state) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(vertical: AppConstants.extraLargePadding),
      shrinkWrap: true,
      primary: false,
      itemCount: state.feed!.externalItems.length,
      itemBuilder: (context, index) => //Text('external item'),
          Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: CustomTextFormField(
              labelStyle: Theme.of(context).textTheme.titleMedium,
              label: index == 0 ? 'ex_items'.tr : null,
              initialValue: state.feed!.externalItems.elementAt(index).name,
              readOnly: true,
            ),
          ),
          Gap(AppConstants.smallPadding),
          Expanded(
            child: CustomTextFormField(
              onSaved: (price) {
                pricedExternalitems.add(state.feed!.externalItems
                    .elementAt(index)
                    .copyWith(price: double.parse(price ?? '0')));
              },
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                  RegExp(r'^\d*\.?\d*$'),
                )
              ],
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              labelStyle: Theme.of(context).textTheme.titleMedium,
              label: index == 0 ? 'price'.tr : null,
              validator: (value) => (value?.isEmpty ?? true) || value == '.'
                  ? 'required'.tr
                  : null,
            ),
          ),
        ],
      ),
      separatorBuilder: (context, index) => Gap(AppConstants.smallPadding),
    );
  }

  Widget _buildAcceptedForm({
    required bool salesReturn,
    required bool customerNotified,
    required QualityReportState state,
    required String phoneNumber,
  }) {
    return Column(
      key: Key("accepted"),
      children: [
        _buildMaintenanceSummary(),
        Gap(AppConstants.largePadding),
        CustomTextFormField(
          onTap: () {
            NumberPickerDialog.show(
              context,
              durationHolder: durationHolder,
              title: 'test_duration'.tr,
            ).then((value) {
              if (value != null) {
                testDuration.text = value;
              }
            });
          },
          readOnly: true,
          controller: testDuration,
          labelStyle: Theme.of(context).textTheme.titleMedium,
          textAlign: AppLocalizations.isDirectionRTL(context)
              ? TextAlign.end
              : TextAlign.start,
          textDirection: TextDirection.ltr,
          inputFormatters: [
            TextInputFormatter.withFunction((oldValue, newValue) {
              final text = newValue.text;
              if (text.isEmpty) {
                return newValue;
              }
              final regex = RegExp(r'^\d*:?([0-5]?[0-9]?)?$');
              if (regex.hasMatch(text)) {
                return newValue;
              }
              return oldValue;
            })
          ],
          label: 'test_duration'.tr,
          hintText: "00:00",
          validator: (value) {
            if (_bloc.state.acceptanceStatus &&
                (value == null || value.isEmpty)) {
              return 'plz_test_duration'.tr;
            }
            return null;
          },
        ),
        const Gap(AppConstants.mediumPadding),
        CustomTextFormField(
          enabled: !(state.maintenanceSummary == null ||
              state.maintenanceSummary?.warrantyType.object == 'in' ||
              state.maintenanceSummary?.warrantyType.object == 're'),
          controller: fixedCost,
          labelStyle: Theme.of(context).textTheme.titleMedium,
          label: 'fixed_cost'.tr,
          hintText: 'fixed_cost'.tr,
          inputFormatters: [
            FilteringTextInputFormatter.allow(
              RegExp(r'^\d*\.?\d*$'),
            )
          ],
          validator: (value) {
            if (_bloc.state.acceptanceStatus &&
                (value == null || value.isEmpty)) {
              return 'plz_fixed_cost'.tr;
            }
            return null;
          },
        ),
        const Gap(AppConstants.mediumPadding),
        _buildCheckboxTile(context,
            title: 'sales_return'.tr, value: salesReturn, onChanged: (value) {
          _bloc.add(SalesReturnStatusChanged(isSalesReturn: value ?? false));
        }),
        const Gap(AppConstants.mediumPadding),
        Row(
          children: [
            Expanded(
              child: _buildCheckboxTile(context,
                  title: 'customer_notified'.tr,
                  value: customerNotified, onChanged: (value) {
                _bloc.add(CustomerNotified(isNotified: value ?? false));
              }),
            ),
            Gap(AppConstants.smallPadding),
            IconButton.filled(
              onPressed: () {
                CommunicationDialog.show(context, phone: phoneNumber);
              },
              icon: Icon(Icons.call),
              style: ButtonStyle(
                backgroundColor:
                    MaterialStatePropertyAll(AppColors.martiniqueColor),
                padding: MaterialStatePropertyAll(
                    EdgeInsets.all(AppConstants.smallPadding + 2)),
                shape: MaterialStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(AppConstants.extraSmallPadding),
                  ),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }

  BlocBuilder<QualityReportBloc, QualityReportState>
      _buildMaintenanceSummary() {
    return BlocBuilder<QualityReportBloc, QualityReportState>(
        bloc: _bloc,
        builder: (context, state) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'maintenacne_summary'.tr,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Gap(AppConstants.smallPadding),
                AnimatedSwitcher(
                  duration: Durations.medium2,
                  child: state.loadingsummary
                      ? _buildSummaryShimmer()
                      : state.summaryErrorState
                          ? Container(
                              padding:
                                  EdgeInsets.all(AppConstants.mediumPadding),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      AppConstants.smallPadding),
                                  color: AppColors.mistyRose),
                              width: double.infinity,
                              height: 145,
                              child: Center(
                                  child: OutlinedButton.icon(
                                      onPressed: () {
                                        _bloc.add(LoadMaintenanceSummary(
                                            deviceId: widget.deviceId));
                                      },
                                      icon: Icon(
                                        Icons.refresh_rounded,
                                        color: AppColors.mojoColor,
                                      ),
                                      label: Text(
                                        'error'.tr + ', ' + 'retry'.tr,
                                        style: TextStyle(
                                            color: AppColors.mojoColor),
                                      ))),
                            )
                          : MaintenanceSummaryCard(
                              summary: state.maintenanceSummary!,
                            ),
                ),
              ],
            ));
  }

  Center _buildSummaryShimmer() {
    return Center(
      child: Shimmer.fromColors(
        baseColor: AppColors.altoColor.withOpacity(.6),
        highlightColor: Colors.white,
        child: Container(
          padding: EdgeInsets.all(AppConstants.mediumPadding),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppConstants.smallPadding),
              color: AppColors.altoColor),
          width: double.infinity,
          height: 145,
        ),
      ),
    );
  }

  Widget _buildRejectedForm({required bool returnToGroup}) {
    return Column(
      key: Key("rejected"),
      children: [
        _buildCheckboxTile(context,
            title: 'return_to_g'.tr, value: returnToGroup, onChanged: (value) {
          _bloc.add(ReturnToGroup(isReturnToGroup: value ?? false));
        }),
        AnimatedSwitcher(
          duration: Durations.medium2,
          child: returnToGroup
              ? SizedBox(
                  key: Key('place_holder'),
                )
              : Column(
                  children: [
                    const Gap(AppConstants.mediumPadding),
                    CustomDropDownButtonFormField<GroupUser>(
                      labelStyle: Theme.of(context).textTheme.titleMedium,
                      label: 'return_to'.tr,
                      items: _bloc.state.feed!.users,
                      hintText: 'select_person'.tr,
                      validator: (person) {
                        if (person == null &&
                            _bloc.state.acceptanceStatus == false) {
                          return 'plz_select_person'.tr;
                        }
                        return null;
                      },
                      onChanged: (person) {
                        _bloc.add(SelectUser(user: person!));
                      },
                    ),
                  ],
                ),
          transitionBuilder: (child, animation) => Align(
            alignment: Alignment.topCenter,
            child: FadeTransition(
              opacity: animation,
              child: SizeTransition(
                sizeFactor: animation,
                child: child,
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildCheckboxTile(BuildContext context,
      {required String title,
      required bool value,
      required void Function(bool?)? onChanged}) {
    return Align(
      alignment: Alignment.center,
      child: Material(
        color: Colors.transparent,
        child: ListTileTheme(
          data: ListTileThemeData(
            tileColor: Colors.white,
            contentPadding: EdgeInsets.all(0),
            horizontalTitleGap: 0,
          ),
          child: CheckboxListTile(
            shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(AppConstants.extraSmallPadding)),
            contentPadding: EdgeInsets.zero,
            title: Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            value: value,
            onChanged: onChanged,
            dense: true,
            controlAffinity: ListTileControlAffinity.leading,
          ),
        ),
      ),
    );
  }

  Widget _drawBackground(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenheight = MediaQuery.of(context).size.height;

    final desiredRadius = screenWidth * 1.4;

    return Stack(
      children: [
        _drawCircle(
          desiredRadius,
          AppColors.eucalyptusColor.withOpacity(.1),
          (-desiredRadius / 4) +
              _percentageOfScreenLength(screenheight, screenWidth),
        ),
      ],
    );
  }

  Widget _drawCircle(double radius, Color color, double bottomAlignment) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: bottomAlignment,
      child: CustomPaint(
        painter: MyCirclePainter(radius, color),
        child: ClipRect(
          child: SizedBox(
            width: radius,
            height: radius,
          ),
        ),
      ),
    );
  }

  double _percentageOfScreenLength(double screenheight, double screenWidth) {
    final screenAspectRatio = screenheight / screenWidth;

    if (screenAspectRatio > 2) {
      return 0;
    }
    return -(2 - screenAspectRatio) * screenWidth;
  }
}

class DurationHolder {
  int minutes = 0;
  int hours = 0;

  @override
  String toString() {
    return '${hours.toString().padLeft(2, '0')} : ${minutes.toString().padLeft(2, '0')}';
  }
}
