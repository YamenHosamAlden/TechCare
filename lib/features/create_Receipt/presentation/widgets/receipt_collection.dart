import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:tech_care_app/app/app_localization.dart';
import 'package:tech_care_app/core/util/app_colors.dart';
import 'package:tech_care_app/core/util/app_constants.dart';
import 'package:tech_care_app/core/widgets/custom_drop_down_button_form_field.dart';
import 'package:tech_care_app/features/create_receipt/domain/entities/collection.dart';
import 'package:tech_care_app/features/create_receipt/domain/entities/employee.dart';
import 'package:tech_care_app/features/create_receipt/domain/entities/maintenance_group.dart';
import 'package:tech_care_app/features/create_receipt/presentation/bloc/create_reciept_bloc/create_receipt_bloc.dart';
import 'package:tech_care_app/features/create_receipt/presentation/widgets/expandable_device_info_card.dart';
import 'package:tech_care_app/routes/app_router.dart';
import 'package:tech_care_app/routes/app_routes.dart';
import 'package:tech_care_app/routes/route_params.dart';

class ReceiptCollection extends StatefulWidget {
  final buildDeleteButton;
  final int collectionIndex;
  final Collection collection;
  final Function()? onDelete;

  const ReceiptCollection({
    super.key,
    required this.collectionIndex,
    required this.collection,
    this.buildDeleteButton = true,
    this.onDelete,
  });

  @override
  State<ReceiptCollection> createState() => _ReceiptCollectionState();
}

class _ReceiptCollectionState extends State<ReceiptCollection> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final _animationDuration = Durations.medium4;

  @override
  Widget build(BuildContext context) {
    final createReceiptBloc = BlocProvider.of<CreateReceiptBloc>(context);
    return ListView(
      primary: false,
      shrinkWrap: true,
      padding: EdgeInsets.only(bottom: AppConstants.mediumPadding),
      children: [
        ListTile(
          dense: true,
          contentPadding: EdgeInsets.all(0),
          title: RichText(
            text: TextSpan(
              text:
                  '${'collection'.tr} - ',
              style: Theme.of(context).textTheme.titleMedium,
              children: <TextSpan>[
                TextSpan(text: (widget.collectionIndex + 1).toString()),
              ],
            ),
          ),
          trailing: AnimatedScale(
            scale: widget.buildDeleteButton ? 1 : 0,
            curve: Curves.easeInOut,
            duration: Durations.medium4,
            child: IconButton(
              icon: Icon(
                Icons.delete_rounded,
                color: AppColors.mojoColor,size: 20,
              ),
              onPressed: () {
                widget.onDelete == null ? null : widget.onDelete!();
                createReceiptBloc.add(DeleteCollectionEvent(
                    elementIndex: widget.collectionIndex));
              },
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: AppColors.altoColor)),
          child: ListView(
            padding: EdgeInsets.all(AppConstants.smallPadding),
            primary: false,
            shrinkWrap: true,
            children: [
              CustomDropDownButtonFormField<MaintenanceGroup>(
                hintText: 'group'.tr,
                value: widget.collection.maintenanceGroup,
                items: createReceiptBloc.state.maintenanceGroups,
                onChanged: (MaintenanceGroup? maintenanceGroup) {
                  createReceiptBloc.add(SelectCollectionGroup(
                      collectionIndex: widget.collectionIndex,
                      maintenanceGroup: maintenanceGroup!));
                },
                validator: (group) => group == null
                    ? 'plz_group'.tr
                    : null,
              ),
              const Gap(AppConstants.smallPadding),
              CustomDropDownButtonFormField<Employee>(
                hintText: 'assign_to'.tr,
                value: widget.collection.employee ?? null,
                items: widget.collection.maintenanceGroup?.employees ?? [],
                onChanged: (Employee? employee) {
                  createReceiptBloc.add(SelectCollectionEmployee(
                      collectionIndex: widget.collectionIndex,
                      employee: employee!));
                },
              ),
              ListTile(
                dense: true,
                contentPadding: EdgeInsets.all(0),
                title: RichText(
                  text: TextSpan(
                    text:
                        '${'devices'.tr} ',
                    style: Theme.of(context).textTheme.titleMedium,
                    children: <TextSpan>[
                      TextSpan(
                          text:
                              '(${widget.collection.devices.length.toString()})'),
                    ],
                  ),
                ),
              ),
              AnimatedList(
                key: _listKey,
                primary: false,
                shrinkWrap: true,
                initialItemCount: widget.collection.devices.length,
                itemBuilder: (context, index, animation) {
                  final device = widget.collection.devices.elementAt(index);
                  return SizeTransition(
                    key: ObjectKey(device),
                    sizeFactor: animation,
                    child: ExpandableDeviceCardInfoCard(
                        deviceIndex: index,
                        device: device,
                        onEdit: (_index) {
                          AppRouter.navigator.pushNamed(
                            AppRoutes.newReceiptAddDevicePageRoute,
                            arguments: AddDeviceParams(
                                device: widget.collection.devices
                                    .elementAt(index)
                                    .copyWith(),
                                deviceIndex: index,
                                collectionIndex: widget.collectionIndex,
                                createReceiptBloc: createReceiptBloc),
                          );
                        },
                        onDelete: (_index) {
                          _listKey.currentState!.removeItem(
                              duration: _animationDuration,
                              _index,
                              (context, animation) => FadeTransition(
                                    key: ObjectKey(device),
                                    opacity: animation.drive(
                                      Tween<double>(begin: 0, end: 1).chain(
                                          CurveTween(curve: Curves.easeInOut)),
                                    ),
                                    child: SizeTransition(
                                        sizeFactor: animation.drive(
                                          Tween<double>(begin: 0, end: 1).chain(
                                              CurveTween(
                                                  curve: Curves.easeInOut)),
                                        ),
                                        child: IgnorePointer(
                                          ignoring: true,
                                          child: ExpandableDeviceCardInfoCard(
                                            deviceIndex: _index,
                                            device: device,
                                          ),
                                        )),
                                  ));
                          Future.delayed(_animationDuration, () {
                            createReceiptBloc.add(DeleteDevice(
                                collectionIndex: widget.collectionIndex,
                                deviceIndex: _index));
                          });
                        }),
                  );
                },
              ),
              Center(
                child: TextButton.icon(
                    style: ButtonStyle(
                        foregroundColor: MaterialStatePropertyAll(
                            AppColors.martiniqueColor)),
                    onPressed: () async {
                      AppRouter.navigator.pushNamed(
                          AppRoutes.newReceiptAddDevicePageRoute,
                          arguments: AddDeviceParams(
                              collectionIndex: widget.collectionIndex,
                              createReceiptBloc: createReceiptBloc));
                    },
                    icon: Icon(Icons.add_box_outlined),
                    label: Text(
                        'add_device'.tr)),
              )
            ],
          ),
        ),
      ],
    );
  }
}
