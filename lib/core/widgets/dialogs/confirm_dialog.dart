import 'package:flutter/material.dart';
import 'package:tech_care_app/app/app_localization.dart';

class ConfirmDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onConfirm;
  const ConfirmDialog(
      {super.key,
      required this.onConfirm,
      required this.message,
      required this.title});

  static Future show(BuildContext context,
          {required String title,
          required String message,
          required VoidCallback onConfirm}) =>
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            title: Center(child: Text(title)),
            alignment: Alignment.center,
            content: ConfirmDialog(
              title: title,
              message: message,
              onConfirm: onConfirm,
            ),
            actionsAlignment: MainAxisAlignment.spaceEvenly,
            actions: <Widget>[
              TextButton(
                child: Text('cancel'.tr),
                onPressed: () {
                  Navigator.pop(
                    context,
                  );
                },
              ),
              TextButton(
                child: Text('confirm'.tr),
                onPressed: () {
                  Navigator.pop(
                    context,
                  );
                  onConfirm();
                },
              ),
            ],
          );
        },
      );

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ListBody(
        children: <Widget>[
          Text(
            message,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
