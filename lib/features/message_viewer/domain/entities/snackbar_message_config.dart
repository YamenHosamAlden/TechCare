import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:tech_care_app/core/entities/translatable_value.dart';
import 'package:tech_care_app/core/util/app_colors.dart';

class SnackBarMessageConfig extends Equatable {
  final TranslatableValue msg;
  final Color color;

  SnackBarMessageConfig({this.color = AppColors.mojoColor, required this.msg});

  @override
  List<Object?> get props => [msg, color];
}
