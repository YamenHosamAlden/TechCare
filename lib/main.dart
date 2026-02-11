import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_care_app/app/app.dart';
import 'package:tech_care_app/core/config/server_config.dart';
import 'package:tech_care_app/core/util/app_colors.dart';
import 'package:tech_care_app/core/util/helpers/bloc_observable.dart';
import 'dependency_injection.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = BlocObservable();
  setDeviceOrientation();
  systemNavigationBarColor();

  await ServerConfig.init();
  await di.init();
  

  runApp(const App());
}

void setDeviceOrientation() {
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  );
}

void systemNavigationBarColor() {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      systemNavigationBarColor: AppColors.eucalyptusColor,
    ),
  );
}
