import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class UserPreferences extends Equatable {
  final Locale locale;

  UserPreferences({required this.locale});

  @override
  List<Object?> get props => [locale];
}
