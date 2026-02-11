import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_care_app/app/app_localization.dart';
import 'package:tech_care_app/core/widgets/loading_indicator.dart';
import 'package:tech_care_app/dependency_injection.dart';
import 'package:tech_care_app/features/receipts_container_details/presentation/bloc/delete_device_bloc/delete_device_bloc.dart';

class DeleteDeviceConfirmtionDialog extends StatelessWidget {
  final int deviceId;
  const DeleteDeviceConfirmtionDialog({
    required this.deviceId,
    super.key,
  });

  static Future show(BuildContext context, {required int deviceId}) {
    final DeleteDeviceBloc logoutBloc = di<DeleteDeviceBloc>();
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return BlocProvider.value(
          value: logoutBloc,
          child: AlertDialog(
            title: Text('delete'.tr),
            content: DeleteDeviceConfirmtionDialog(
              deviceId: deviceId,
            ),
            actionsAlignment: MainAxisAlignment.spaceAround,
            actions: <Widget>[
              BlocConsumer<DeleteDeviceBloc, DeleteDeviceState>(
                listener: (context, state) {
                  if (state.isComplete) {
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }
                  }
                },
                bloc: logoutBloc,
                builder: (context, state) {
                  return state.isLoading
                      ? Center(child: LoadingIndicator())
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              child: Text('yes'.tr),
                              onPressed: () {
                                logoutBloc
                                    .add(DeleteDeviceEvent(deviceId: deviceId));
                              },
                            ),
                            TextButton(
                              child: Text('no'.tr),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        );
                },
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ListBody(
        children: <Widget>[
          Text('delete_device_confirm'.tr),
        ],
      ),
    );
  }
}
