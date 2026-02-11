import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:tech_care_app/app/app_localization.dart';
import 'package:tech_care_app/core/util/app_colors.dart';
import 'package:tech_care_app/core/util/app_constants.dart';
import 'package:tech_care_app/core/util/helpers/show_sack_bar.dart';
import 'package:tech_care_app/core/widgets/custom_text_form_field.dart';
import 'package:tech_care_app/features/device_details/presentation/bloc/device_details_bloc/device_details_bloc.dart';
import 'package:tech_care_app/routes/app_router.dart';

class UnreceiveDeviceDialog extends StatefulWidget {
  const UnreceiveDeviceDialog({super.key});

  @override
  State<UnreceiveDeviceDialog> createState() => _UnreceiveDeviceDialogState();
}

class _UnreceiveDeviceDialogState extends State<UnreceiveDeviceDialog> {
  late final TextEditingController reasonController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  @override
  void initState() {
    reasonController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    reasonController.dispose();

    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    setState(() {
      autovalidateMode = AutovalidateMode.always;
    });
    if (_formKey.currentState?.validate() ?? false) {
      BlocProvider.of<DeviceDetailsBloc>(context)
          .add(UnreceiveDevice(reason: reasonController.text));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DeviceDetailsBloc, DeviceDetailsState>(
      listenWhen: (previous, current) =>
          previous.deviceUnreceived == false &&
          previous.deviceUnreceived == true,
      listener: (context, state) {
        if (state.deviceUnreceived) {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
        }
      },
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.mediumPadding + 3),
        ),
        backgroundColor: AppColors.alabasterColor,
        contentPadding: EdgeInsets.all(0),
        titlePadding: EdgeInsets.all(0),
        iconPadding: EdgeInsets.all(0),
        content: SingleChildScrollView(
          child: BlocConsumer<DeviceDetailsBloc, DeviceDetailsState>(
            bloc: BlocProvider.of<DeviceDetailsBloc>(context),
            listener: (context, state) {
              if (state.deviceUnreceived) {
                showSnackBar(context,
                    backgroundColor: AppColors.eucalyptusColor,
                    msg: 'device_cancel'.tr);
                AppRouter.navigator.pop();
              }
            },
            builder: (context, state) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close)),
                  ),
                  Container(
                    padding: const EdgeInsets.all(AppConstants.smallPadding),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.martiniqueColor),
                    child: Icon(
                      Icons.warning_rounded,
                      color: AppColors.whiteColor,
                    ),
                  ),
                  Gap(AppConstants.mediumPadding),
                  Text(
                    'unreceive_device'.tr,
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(AppConstants.mediumPadding),
                    child: Form(
                      key: _formKey,
                      autovalidateMode: autovalidateMode,
                      child: CustomTextFormField(
                        controller: reasonController,
                        minLines: 3,
                        maxLines: 100,
                        hintText: 'reason'.tr,
                        validator: (note) => note == null || note.trim().isEmpty
                            ? 'plz_reason'.tr
                            : null,
                      ),
                    ),
                  ),
                  state.unreceivingDevice
                      ? SizedBox(
                          height: 48,
                          child: Center(child: CircularProgressIndicator()))
                      : ElevatedButton(
                          onPressed: _submit, child: Text('submit'.tr)),
                  Gap(AppConstants.mediumPadding),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
