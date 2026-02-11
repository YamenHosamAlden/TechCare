import 'package:flutter/material.dart';
import 'package:tech_care_app/app/app_localization.dart';
import 'package:tech_care_app/core/interface/%20ilanguage%D9%80dependent%D9%80display.dart';
import 'package:tech_care_app/features/message_viewer/domain/entities/dialog_message_config.dart';

class MessageViewerDialog extends StatelessWidget {
  final DialogMessageConfig dialogMessageConfig;
  const MessageViewerDialog({super.key, required this.dialogMessageConfig});

  static Future show(BuildContext context,
          {required DialogMessageConfig dialogMessageConfig}) =>
      showDialog(
        context: context,
        barrierDismissible: dialogMessageConfig.dismissible,
        builder: (context) {
          return AlertDialog(
            title: _getTitle(context, dialogMessageConfig: dialogMessageConfig),
            content: MessageViewerDialog(
              dialogMessageConfig: dialogMessageConfig,
            ),
            actions: <Widget>[
              dialogMessageConfig.onRetry == null
                  ? SizedBox()
                  : TextButton(
                      child: Text('retry'.tr), 
                      onPressed: () {
                        dialogMessageConfig.onRetry!();
                        Navigator.pop(context);
                      },
                    ),
            ],
          );
        },
      );

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: dialogMessageConfig.dismissible,
      child: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(dialogMessageConfig.msg!
                .getDisplayValue(AppLocalizations.getLocale(context))),
          ],
        ),
      ),
    );
  }

  static Widget? _getTitle(BuildContext context,
      {required DialogMessageConfig dialogMessageConfig}) {
    if (dialogMessageConfig.title != null) {
      return Text(IlanguageDependentDisplay.getDisplayString(
          context, dialogMessageConfig.title));
    }
    switch (dialogMessageConfig.dialogType) {
      case DialogType.error:
        return Text('error'.tr);

      default:
        return null;
    }
  }
}
