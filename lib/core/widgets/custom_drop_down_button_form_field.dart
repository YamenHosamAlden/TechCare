import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:tech_care_app/core/interface/%20ilanguage%D9%80dependent%D9%80display.dart';

class CustomDropDownButtonFormField<T> extends StatelessWidget {
  final List<T> items;
  final T? value;
  final String? label;
  final TextStyle? labelStyle;
  final String hintText;
  final void Function(T?)? onChanged;
  final String? Function(T?)? validator;

  const CustomDropDownButtonFormField({
    super.key,
    required this.items,
    this.value,
    this.onChanged,
    this.validator,
    this.label,
    this.labelStyle,
    required this.hintText,
  });

  // String getDisplayString(BuildContext context, dynamic param) {
  //   if (param is IlanguageDependentDisplay) {
  //     return param.getDisplayValue(AppLocalizations.getLocale(context));
  //   } else {
  //     return param.toString();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...label == null
            ? []
            : [
                Text(
                  label.toString(),
                  style: labelStyle,
                ),
                const Gap(10),
              ],
        DropdownButtonFormField<T>(
          value: value,
          selectedItemBuilder: (context) => items
              .map<Widget>((e) => Text(
                    IlanguageDependentDisplay.getDisplayString(context, e),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                  ))
              .toList(),
          isExpanded: true,
          decoration: InputDecoration(
            hintText: hintText,
            hintMaxLines: 1,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
          ),
          items: items
              .map<DropdownMenuItem<T>>(
                (e) => DropdownMenuItem(
                  value: e,
                  child: Text(
                    IlanguageDependentDisplay.getDisplayString(context, e),
                    // e is TranslatableValue
                    //     ? e.getValue(AppLocalizations.getLocale(context))
                    //     : e.toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                  ),
                ),
              )
              .toList(),
          onChanged: onChanged,
          validator: validator,
          disabledHint: Text(
            hintText,
            style: const TextStyle(
              fontSize: 14,
              height: 1,
              color: Colors.grey,
              fontWeight: FontWeight.w400,
            ),
          ),
        )
      ],
    );
  }
}
