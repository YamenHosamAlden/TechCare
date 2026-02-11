import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:tech_care_app/core/entities/translatable_value.dart';
import 'package:tech_care_app/core/interface/%20ilanguage%D9%80dependent%D9%80display.dart';

class DeviceType extends Equatable implements IlanguageDependentDisplay {
  final int id;
  final TranslatableValue name;

  DeviceType({required this.id, required this.name});

  @override
  List<Object?> get props => [id, name];

  @override
  String toString() => name.getDisplayValue(Locale('en')).toString();

  @override
  String getDisplayValue(Locale locale) => name.getDisplayValue(locale);

  DeviceType copyWith({int? id, TranslatableValue? name}) {
    return DeviceType(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }
}
