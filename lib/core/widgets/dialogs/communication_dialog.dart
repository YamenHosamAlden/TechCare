import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:tech_care_app/app/app_localization.dart';
import 'package:tech_care_app/core/util/app_constants.dart';
import 'package:tech_care_app/core/util/app_strings.dart';
import 'package:tech_care_app/core/util/helpers/app_url_launcher.dart';
import 'package:tech_care_app/core/util/helpers/call_phone_number.dart';

class CommunicationDialog extends StatelessWidget {
  final String phone;
  const CommunicationDialog({
    required this.phone,
    super.key,
  });

  static Future show(BuildContext context, {required String phone}) =>
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "communication".tr,
              textAlign: TextAlign.center,
            ),
            content: CommunicationDialog(
              phone: phone,
            ),
            actionsAlignment: MainAxisAlignment.center,
            actions: <Widget>[
              TextButton(
                child: Text('cancel'.tr),
                onPressed: () {
                  Navigator.pop(
                    context,
                  );
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
          Row(
            children: [
              Expanded(
                child: MaterialButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    makePhoneCall(phone);
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image(
                            image: AssetImage(
                          AppStrings.smartPhoneIconPath,
                        )),
                      ),
                      Gap(AppConstants.extraSmallPadding),
                      Text(
                        "phone".tr,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: MaterialButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    if (Platform.isAndroid) {
                      appUrlLauncher("https://wa.me/$phone");
                    } else {
                      appUrlLauncher(
                          "https://api.whatsapp.com/send?phone=$phone");
                    }
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image(
                            image: AssetImage(
                          AppStrings.whatsAppIconPath,
                        )),
                      ),
                      Gap(AppConstants.extraSmallPadding),
                      Text(
                        "whats_app".tr,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
