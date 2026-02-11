import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:tech_care_app/core/entities/translatable_value.dart';

class DialogMessageConfig extends Equatable {
  final VoidCallback? onRetry;
  final DialogType? dialogType;
  final TranslatableValue? title;
  final TranslatableValue? msg;
  final bool dismissible;

  const DialogMessageConfig({
    this.title,
    this.msg,
    this.dialogType,
    this.onRetry,
    this.dismissible = true,
  });

  @override
  List<Object?> get props => [
        onRetry,
        msg,
        title,
        dialogType,
        dismissible,
      ];
}

enum DialogType {
  error,
}
