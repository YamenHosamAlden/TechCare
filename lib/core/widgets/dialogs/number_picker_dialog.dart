import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:tech_care_app/app/app_localization.dart';
import 'package:tech_care_app/core/util/app_colors.dart';
import 'package:tech_care_app/features/quality_report/presentation/pages/quality_report_page.dart';

class NumberPickerDialog extends StatefulWidget {
  final String title;
  final DurationHolder durationHolder;

  const NumberPickerDialog({
    super.key,
    required this.title,
    required this.durationHolder,
  });

  static Future<String?> show(
    BuildContext context, {
    required String title,
    required DurationHolder durationHolder
  }) {
    

    return showDialog<String?>(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          title: Center(child: Text(title)),
          alignment: Alignment.center,
          content: NumberPickerDialog(
            title: title,
            durationHolder: durationHolder,
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
                Navigator.pop(context, durationHolder.toString());
                // onConfirm();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  State<NumberPickerDialog> createState() => _NumberPickerDialogState();
}

class _NumberPickerDialogState extends State<NumberPickerDialog> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ListBody(
        children: <Widget>[
          Directionality(
            textDirection: TextDirection.ltr,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text("hour".tr),
                      NumberPicker(
                        value: widget.durationHolder.hours,
                        zeroPad: true,
                        selectedTextStyle: TextStyle(
                          color: AppColors.eucalyptusColor,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        itemHeight: 35,
                        minValue: 0,
                        maxValue: 99,
                        onChanged: (hours) {
                          setState(() {
                            widget.durationHolder.hours = hours;
                          });
                          ;
                        },
                      ),
                    ],
                  ),
                ),
                Text(
                  ":",
                  style: TextStyle(
                    color: AppColors.eucalyptusColor,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text("minute".tr),
                      NumberPicker(
                        itemHeight: 35,
                        selectedTextStyle: TextStyle(
                          color: AppColors.eucalyptusColor,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        value: widget.durationHolder.minutes,
                        zeroPad: true,
                        minValue: 0,
                        maxValue: 59,
                        onChanged: (min) {
                          setState(() {
                            widget.durationHolder.minutes = min;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

