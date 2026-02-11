import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:tech_care_app/core/util/app_colors.dart';
import 'package:tech_care_app/core/util/app_constants.dart';

class CustomDropDownBtn<T> extends StatelessWidget {
  final List<T> items;
  final T? value;
  final String? label;
  final TextStyle? labelStyle;
  final String hintText;
  final void Function(T?)? onChanged;

  const CustomDropDownBtn({
    super.key,
    required this.items,
    this.value,
    this.onChanged,
    this.label,
    this.labelStyle,
    required this.hintText,
  });

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
        Container(
          decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius:
                  BorderRadius.circular(AppConstants.extraSmallPadding)),
          child: DropdownButton<T>(
            value: value,
            isDense: true,
            selectedItemBuilder: (context) => items
                .map<Widget>((e) => Text(
                      e.toString(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                      ),
                    ))
                .toList(),
            isExpanded: true,
            borderRadius: BorderRadius.circular(AppConstants.extraSmallPadding),
            hint: Text(
              'Group',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                height: 1,
                color: Colors.grey,
                fontWeight: FontWeight.w400,
                fontSize: 14,
              ),
            ),
            underline: SizedBox(),
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
            
            items: items
                .map<DropdownMenuItem<T>>(
                  (e) => DropdownMenuItem(
                    value: e,
                    child: Text(
                      e.toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                      ),
                    ),
                  ),
                )
                .toList(),
            onChanged: onChanged,
          ),
        )
      ],
    );
  }
}
