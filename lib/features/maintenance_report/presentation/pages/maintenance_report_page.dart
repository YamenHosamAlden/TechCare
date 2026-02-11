import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:tech_care_app/app/app_localization.dart';
import 'package:tech_care_app/core/entities/translatable_value.dart';
import 'package:tech_care_app/core/util/app_colors.dart';
import 'package:tech_care_app/core/util/app_constants.dart';
import 'package:tech_care_app/core/util/helpers/show_sack_bar.dart';
import 'package:tech_care_app/core/widgets/custom_drop_down_button_form_field.dart';
import 'package:tech_care_app/core/widgets/custom_text_form_field.dart';
import 'package:tech_care_app/core/widgets/loading_indicator.dart';
import 'package:tech_care_app/core/widgets/my_circle_painter.dart';
import 'package:tech_care_app/dependency_injection.dart';
import 'package:tech_care_app/features/maintenance_report/domain/entities/iinstalled_item.dart';
import 'package:tech_care_app/features/maintenance_report/domain/entities/warehouse_item.dart';
import 'package:tech_care_app/features/maintenance_report/presentation/bloc/maintenance_report_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:tech_care_app/features/maintenance_report/presentation/widgets/counter_form_field.dart';

class MaintenanceReportPage extends StatefulWidget {
  final int deviceId;

  static Route<dynamic> route({required int params, RouteSettings? settings}) =>
      MaterialPageRoute<MaintenanceReportPage>(
          settings: settings,
          builder: (context) => MaintenanceReportPage(
                deviceId: params,
              ));

  const MaintenanceReportPage({required this.deviceId, super.key});

  @override
  State<MaintenanceReportPage> createState() => _MaintenanceReportPageState();
}

class _MaintenanceReportPageState extends State<MaintenanceReportPage> {
  late final MaintenanceReportBloc _bloc;
  final _itemFieldsFormKey = GlobalKey<FormState>();
  AutovalidateMode _itemFieldsValidationMode = AutovalidateMode.disabled;
  final _reportFieldFormKey = GlobalKey<FormState>();
  final FocusNode? itemFieldFoucusNode = FocusNode();

  @override
  void initState() {
    _bloc = di<MaintenanceReportBloc>();
    super.initState();
  }

  @override
  void dispose() {
    itemFieldFoucusNode?.dispose();
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('m_report'.tr),
      ),
      body: Stack(
        children: [
          _drawBackground(context),
          SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.mediumPadding),
            child: Center(
              child:
                  BlocConsumer<MaintenanceReportBloc, MaintenanceReportState>(
                listener: (context, state) {
                  if (state.reportCreated) {
                    showSnackBar(context,
                        msg: 'report_created_sucfuly'.tr,
                        backgroundColor: AppColors.eucalyptusColor);
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }
                  }
                },
                buildWhen: (previous, current) {
                  if (current.reportCreated == true) {
                    return false;
                  }
                  return true;
                },
                bloc: _bloc,
                builder: (context, state) {
                  return Column(
                    children: [
                      CustomDropDownButtonFormField<TranslatableValue>(
                        label: 'item_src'.tr,
                        value: TranslatableValue.fromTranslations(
                            object: ItemsSource.WAREHOUSE,
                            translations:
                                Translation(ar: 'المستودع', en: 'Warehouse')),
                        items: [
                          TranslatableValue.fromTranslations(
                              object: ItemsSource.WAREHOUSE,
                              translations:
                                  Translation(ar: 'المستودع', en: 'Warehouse')),
                          TranslatableValue.fromTranslations(
                              object: ItemsSource.EXTERNAL,
                              translations:
                                  Translation(ar: 'خارجي', en: 'External')),
                        ],
                        hintText: 'item_src'.tr,
                        onChanged: (value) {
                          _bloc.add(
                            ChangeItemsSource(
                                itemsSource: (value!.object) as ItemsSource),
                          );
                        },
                      ),
                      const Gap(AppConstants.mediumPadding),
                      Form(
                        key: _itemFieldsFormKey,
                        child: Column(
                          children: [
                            AnimatedSwitcher(
                              duration: Durations.medium2,
                              switchInCurve: Curves.easeInOut,
                              switchOutCurve: Curves.easeInOut,
                              transitionBuilder:
                                  (Widget child, Animation<double> animation) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: child,
                                );
                              },
                              child: _bloc.state.itemsSource ==
                                      ItemsSource.WAREHOUSE
                                  ? TypeAheadField<WarehouseItem>(
                                      focusNode: itemFieldFoucusNode,
                                      hideOnEmpty: true,
                                      controller: state.warehouseItemNameField,
                                      suggestionsCallback: (pattern) async {
                                        if (pattern.trim().isEmpty) {
                                          return [];
                                        }
                                        return await _bloc.getSuggestedItems(
                                            widget.deviceId, pattern);
                                      },
                                      builder:
                                          (context, controller, focusNode) {
                                        return CustomTextFormField(
                                          controller: controller,
                                          autovalidateMode:
                                              _itemFieldsValidationMode,
                                          focusNode: focusNode,
                                          label: 'item_name'.tr,
                                          hintText: 'item_name'.tr,
                                          onChanged: (value) {
                                            _bloc.add(
                                                RemoveSelectedWarehouseItem());
                                          },
                                          validator: (val) {
                                            if (state.selectedWarehouseItem ==
                                                null) {
                                              return 'plz_select_item'.tr;
                                            }
                                            return null;
                                          },
                                        );
                                      },
                                      debounceDuration: Durations.medium4,
                                      loadingBuilder: (context) => state
                                              .warehouseItemNameField
                                              .text
                                              .isEmpty
                                          ? SizedBox()
                                          : Container(
                                              padding: EdgeInsets.all(
                                                  AppConstants.smallPadding),
                                              width: double.infinity,
                                              height: 63,
                                              child: FittedBox(
                                                  child: LoadingIndicator())),
                                      itemBuilder: (context, item) {
                                        return ListTile(
                                          title: Text(
                                            item.itemName,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                          ),
                                          subtitle: Text(
                                            item.itemNumber.toString(),
                                          ),
                                        );
                                      },
                                      onSelected: (WarehouseItem item) {
                                        state.warehouseItemNameField.text =
                                            item.itemName;
                                        itemFieldFoucusNode!.unfocus();
                                        _bloc.add(
                                            SelectWarehouseItem(item: item));
                                      },
                                      hideKeyboardOnDrag: true,
                                    )
                                  : CustomTextFormField(
                                      controller:
                                          _bloc.state.externalItemNameField,
                                      autovalidateMode:
                                          _itemFieldsValidationMode,
                                      label: 'item_name'.tr,
                                      hintText: 'item_name'.tr,
                                      validator: (val) {
                                        if (val == null || val.isEmpty) {
                                          return 'plz_item_name'.tr;
                                        }
                                        return null;
                                      },
                                    ),
                            ),
                            const Gap(AppConstants.mediumPadding),
                            _buildTableActions(
                              context,
                              // errorState: true,
                              // counter: state.counter,
                              // onIncrement: () {
                              //   _bloc.add(IncrementCounter());
                              // },
                              // onDencrement: () {
                              //   _bloc.add(DecrementCounter());
                              // },
                              onSubmit: () {
                                if (_itemFieldsFormKey.currentState!
                                    .validate()) {
                                  setState(() {
                                    _itemFieldsValidationMode =
                                        AutovalidateMode.disabled;
                                  });
                                  _bloc.add(AddItem());
                                } else {
                                  setState(() {
                                    _itemFieldsValidationMode =
                                        AutovalidateMode.onUserInteraction;
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      Gap(AppConstants.mediumPadding),
                      _itemsTeble(),
                      const Gap(AppConstants.mediumPadding),
                      Form(
                        key: _reportFieldFormKey,
                        child: CustomTextFormField(
                          label: 'report'.tr,
                          hintText: 'report'.tr,
                          minLines: 5,
                          onChanged: (report) =>
                              _bloc.add(ChangeReportText(report: report)),
                          maxLines: 20,
                          validator: (report) {
                            if (report == null || report.isEmpty) {
                              return 'plz_report'.tr;
                            }
                            return null;
                          },
                        ),
                      ),
                      const Gap(AppConstants.mediumPadding),
                      state.isloading
                          ? CircularProgressIndicator()
                          : ElevatedButton(
                              onPressed: () {
                                FocusManager.instance.primaryFocus?.unfocus();

                                if (_reportFieldFormKey.currentState!
                                    .validate()) {
                                  _bloc.add(
                                      SubmitReport(deviceId: widget.deviceId));
                                }
                              },
                              child: Center(child: Text("submit".tr)))
                    ],
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  Row _buildTableActions(
    BuildContext context, {
    // required void Function()? onIncrement,
    // required void Function()? onDencrement,
    required void Function()? onSubmit,
  }) {
    return Row(
      children: [
        CounterFormFeild(
          autovalidateMode: _itemFieldsValidationMode,
          controller: _bloc.state.counterController,
          validator: (value) {
            if (value == null || value <= 0) {
              return '';
            }
            return null;
          },
        ),
        // SizedBox.square(
        //   dimension: 40,
        //   child: FloatingActionButton.small(
        //     heroTag: 'increment',
        //     shape:
        //         RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        //     backgroundColor: AppColors.martiniqueColor,
        //     splashColor: AppColors.eucalyptusColor.withOpacity(.5),P
        //     onPressed: onIncrement,
        //     elevation: 0,
        //     child: Icon(Icons.add_rounded, color: AppColors.whiteColor),
        //   ),
        // ),
        // Gap(AppConstants.smallPadding),
        // Container(
        //   alignment: Alignment.center,
        //   height: 40,
        //   width: 40,
        //   decoration: BoxDecoration(
        //     color: AppColors.whiteColor,
        //     border: errorState! ? Border.all(color: AppColors.mojoColor) : null,
        //     borderRadius: BorderRadius.circular(5),
        //   ),
        //   child: Text(counter.toString(),
        //       style: Theme.of(context)
        //           .textTheme
        //           .bodyLarge!
        //           .copyWith(fontWeight: FontWeight.w700)),
        // ),
        // Gap(AppConstants.smallPadding),
        // SizedBox.square(
        //   dimension: 40,
        //   child: FloatingActionButton.small(
        //     heroTag: 'decrement',
        //     shape:
        //         RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        //     backgroundColor: AppColors.martiniqueColor,
        //     splashColor: AppColors.eucalyptusColor.withOpacity(.5),
        //     onPressed: onDencrement,
        //     elevation: 0,
        //     child: Icon(Icons.remove_rounded, color: AppColors.whiteColor),
        //   ),
        // ),
        Spacer(),
        SizedBox.square(
          dimension: 40,
          child: FloatingActionButton.small(
            heroTag: 'add_item',
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            backgroundColor: AppColors.martiniqueColor,
            splashColor: AppColors.eucalyptusColor.withOpacity(.5),
            onPressed: onSubmit,
            elevation: 0,
            child: Icon(Icons.add_card_rounded, color: AppColors.whiteColor),
          ),
        ),
      ],
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

  Widget _itemsTeble() {
    List<InstalledItem> items = _bloc.state.maintenanceReport.installedItems;
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
      child: Table(
        border: TableBorder.all(
            borderRadius: BorderRadius.circular(5),
            color: AppColors.silverColor),
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        columnWidths: const <int, TableColumnWidth>{
          0: FractionColumnWidth(.25),
          1: FractionColumnWidth(.45),
          2: FractionColumnWidth(.2),
          3: FractionColumnWidth(.1),
        },
        children: <TableRow>[
          _buildTableHeader(),
          for (int i = 0; i < items.length; i++)
            TableRow(
              decoration: const BoxDecoration(color: AppColors.linkWaterColor),
              children: <Widget>[
                _buildTableCell(
                    child: Text(
                  (items.elementAt(i).itemNumber?.toString() ?? ''),
                  textAlign: TextAlign.center,
                )),
                _buildTableCell(
                    child: Text((items.elementAt(i).itemName.toString()),
                        textAlign: TextAlign.center)),
                _buildTableCell(
                    child: Text((items.elementAt(i).qty.toString()),
                        textAlign: TextAlign.center)),
                FittedBox(
                  fit: BoxFit.cover,
                  child: IconButton(
                      onPressed: () {
                        _bloc.add(RemoveItem(itemIndex: i));
                      },
                      icon: Icon(Icons.remove_circle_rounded,
                          color: AppColors.mojoColor)),
                ),
              ],
            ),
        ],
      ),
    );
  }

  TableRow _buildTableHeader() {
    return TableRow(
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(5)),
          color: AppColors.linkWaterColor),
      children: <Widget>[
        _buildTableCell(
            child:
                Text('no.'.tr, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w600))),
        _buildTableCell(
            child: Text(
          'item_name'.tr, textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.w600),
        )),
        _buildTableCell(
            child: Text(
          'qty'.tr, textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.w600),
        )),
        _buildTableCell(child: const SizedBox()),
      ],
    );
  }

  Padding _buildTableCell({required Widget child}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 5),
      child: Center(child: child),
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
