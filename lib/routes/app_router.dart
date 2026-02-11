import 'package:flutter/material.dart';
import 'package:tech_care_app/features/create_receipt/presentation/pages/add_device_page.dart';
import 'package:tech_care_app/features/create_receipt/presentation/pages/new_receipt_page.dart';
import 'package:tech_care_app/features/device_details/presentation/pages/device_details_page.dart';
import 'package:tech_care_app/features/device_details/presentation/pages/device_info_view.dart';
import 'package:tech_care_app/features/finished_receipts/presentation/pages/finished_receipts_page.dart';
import 'package:tech_care_app/features/finished_receipts/presentation/pages/finishing_report_page.dart';
import 'package:tech_care_app/features/maintenance_report/presentation/pages/maintenance_report_page.dart';
import 'package:tech_care_app/features/quality_report/presentation/pages/quality_report_page.dart';
import 'package:tech_care_app/features/receipt_details/presentation/pages/receipt_details_page.dart';
import 'package:tech_care_app/features/receipts/presentation/pages/receipts_page.dart';
import 'package:tech_care_app/features/receipts_container_details/presentation/pages/device_payment_details_page.dart';
import 'package:tech_care_app/features/receipts_container_details/presentation/pages/edit_device_details_page.dart';
import 'package:tech_care_app/features/receipts_container_details/presentation/pages/edit_receipts_container_details_page.dart';
import 'package:tech_care_app/features/receipts_container_details/presentation/pages/receipts_container_details_page.dart';
import 'package:tech_care_app/features/recently_receipts/presentation/pages/recently_receipts_page.dart';
import 'package:tech_care_app/features/saerch/presentation/pages/search_page.dart';
import 'package:tech_care_app/features/user_preferences/presentation/dialogs/change_language_dialog.dart';
import 'package:tech_care_app/routes/app_routes.dart';
import 'package:tech_care_app/features/app_launch/presentation/pages/app_launching_page.dart';
import 'package:tech_care_app/features/auth/presentation/pages/login_page.dart';
import 'package:tech_care_app/routes/route_params.dart';

import 'route_error_page.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static NavigatorState get navigator => navigatorKey.currentState!;

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    // Getting agrs passed in while calling Navigastor.pushNamed
    final args = settings.arguments;

    switch (settings.name) {
      case AppRoutes.appLaunchingPageRoute:
        return AppLaunchingPage.route(settings: settings);

      case AppRoutes.loginPageRoute:
        return LoginPage.route(settings: settings);

      case AppRoutes.receiptsPageRoute:
        return _routeArgsHandler<int>(ReceiptsPage.route, args, settings);

      case AppRoutes.searchPageRoute:
        return SearchPage.route(settings: settings);

      case AppRoutes.newReceiptPageRoute:
        return NewReceiptPage.route(settings: settings);

      case AppRoutes.newReceiptAddDevicePageRoute:
        return _routeArgsHandler<AddDeviceParams>(
            AddDevicePage.route, args, settings);

      case AppRoutes.receiptDetailsPageRoute:
        return _routeArgsHandler<ReceiptDetailsParams>(
            ReceiptDetailsPage.route, args, settings);

      case AppRoutes.deviceDetailsPageRoute:
        return _routeArgsHandler<DeviceDetailsParams>(
            DeviceDetailsPage.route, args, settings);

      case AppRoutes.maintenanceReportPageRoute:
        return _routeArgsHandler<int>(
            MaintenanceReportPage.route, args, settings);

      case AppRoutes.qualityReportPageRoute:
        return _routeArgsHandler<int>(QualityReportPage.route, args, settings);

      case AppRoutes.imagePreviewPageRoute:
        return ImagePreviewPage.route(settings: settings);

      case AppRoutes.receiptsContainerDetailsPageRoute:
        return _routeArgsHandler<ContainerDetailsParams>(
            ReceiptsContainerDetailsPage.route, args, settings);

      case AppRoutes.finishedReceiptsPageRoute:
        return FinishedReceiptsPage.route(settings: settings);

      case AppRoutes.recentlyAddedReceiptsPageRoute:
        return AddedReceiptsPage.route(settings: settings);

      case AppRoutes.finishingReportPageRoute:
        return _routeArgsHandler<int>(
            finishingReportPage.route, args, settings);

      case AppRoutes.editContainerReceiptPageRoute:
        return _routeArgsHandler<ReceiptContainerDetailsParams>(
            EditContainerDetailsPage.route, args, settings);

      case AppRoutes.editDeviceDetailsPageRoute:
        return _routeArgsHandler<int>(
            EditDeviceDetailsPage.route, args, settings);

      case AppRoutes.devicePaymentDetailsPage:
        return _routeArgsHandler<int>(
            DevicePaymentDetailsPage.route, args, settings);

      case AppRoutes.languageChangingPageRoute:
        return languageChangingPage.route();

      default:
        return RouteErrorPage.routeError();
    }
  }
}

Route<dynamic> _routeArgsHandler<T>(
    Route<dynamic> Function({required T params, RouteSettings? settings})
        routeCaller,
    Object? args,
    RouteSettings? settings) {
  if (args is T) {
    return routeCaller(params: args, settings: settings);
  } else {
    return RouteErrorPage.routeArgumentsError();
  }
}
