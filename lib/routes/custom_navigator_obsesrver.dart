import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tech_care_app/routes/app_routes.dart';

class CustomNavigatorObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    print('pushed rout : ${route.settings.name}');
    print('pushed rout : ${previousRoute?.settings.name}');
    super.didPush(route, previousRoute);
    if (route.settings.name == AppRoutes.receiptsPageRoute) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
      ));
    }
    if (route.settings.name == AppRoutes.imagePreviewPageRoute) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.black,
      ));
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    print('poped : ${route.settings.name}');
    print('poped : ${previousRoute?.settings.name}');

    super.didPop(route, previousRoute);
    if (route.settings.name == AppRoutes.imagePreviewPageRoute) {
      print("image preview poped");

      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.white, // Default or previous color
        ),
      );
    }
  }
}
