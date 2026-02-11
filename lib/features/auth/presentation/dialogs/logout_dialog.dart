import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_care_app/app/app_localization.dart';
import 'package:tech_care_app/core/widgets/loading_indicator.dart';
import 'package:tech_care_app/dependency_injection.dart';
import 'package:tech_care_app/features/auth/presentation/bloc/logout_bloc/logout_bloc.dart';

class LogoutDialog extends StatelessWidget {
  const LogoutDialog({
    super.key,
  });

  static Future show(BuildContext context) {
    final LogoutBloc logoutBloc = di<LogoutBloc>();
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return BlocProvider.value(
          value: logoutBloc,
          child: AlertDialog(
            title: Center(child: Text('logout'.tr)),
            alignment: Alignment.center,
            content: LogoutDialog(),
            actionsAlignment: MainAxisAlignment.center,
            actions: <Widget>[
              BlocBuilder<LogoutBloc, LogoutState>(
                bloc: logoutBloc,
                builder: (context, state) {
                  return state.isLoading
                      ? Center(child: LoadingIndicator())
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextButton(
                              child: Text('yes'.tr),
                              onPressed: () {
                                logoutBloc.add(LogoutEvent());
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
          Text(
            'log_out_confirm'.tr,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
