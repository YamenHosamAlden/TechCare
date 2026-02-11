import 'package:flutter/material.dart';


class CustomPopupMenuButton<T> extends StatelessWidget {
  final T? initialValue;
  final List<PopupMenuItem<T>> popupMenuItems;
  final void Function(T)? onSelected;
  final Widget? icon;
  const CustomPopupMenuButton(
      {super.key,
      this.icon,
      this.initialValue,
      required this.popupMenuItems,
      this.onSelected});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<T>(
        icon: icon,
        onSelected: onSelected,
        initialValue: initialValue,
        itemBuilder: (BuildContext context) => popupMenuItems);
  }
}
