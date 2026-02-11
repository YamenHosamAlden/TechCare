import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_care_app/app/app_localization.dart';
import 'package:tech_care_app/core/util/app_colors.dart';
import 'package:tech_care_app/core/util/helpers/show_sack_bar.dart';
import 'package:tech_care_app/core/widgets/app_drawer.dart';
import 'package:tech_care_app/core/widgets/custom_text_form_field.dart';
import 'package:tech_care_app/core/widgets/dialogs/code_scanner_dialog.dart';
import 'package:tech_care_app/core/widgets/dialogs/confirm_dialog.dart';
import 'package:tech_care_app/dependency_injection.dart';
import 'package:tech_care_app/features/auth/data/repositories/user_repository_impl.dart';
import 'package:tech_care_app/features/receipts/presentation/bloc/receipts_bloc.dart';
import 'package:tech_care_app/features/receipts/presentation/pages/in_maintenance_view.dart';
import 'package:tech_care_app/features/receipts/presentation/pages/quality_view.dart';
import 'package:tech_care_app/features/receipts/presentation/pages/received_view.dart';
import 'package:tech_care_app/features/receipts/presentation/widgets/receipt_card.dart';
import 'package:tech_care_app/routes/app_router.dart';
import 'package:tech_care_app/routes/app_routes.dart';
import 'package:tech_care_app/routes/route_params.dart';

class ReceiptsPage extends StatefulWidget {
  final int initialIndexOfTapBar;
  const ReceiptsPage({required this.initialIndexOfTapBar, super.key});

  static Route<dynamic> route({required int params, RouteSettings? settings}) =>
      MaterialPageRoute(
          settings: settings,
          builder: (context) => ReceiptsPage(
                initialIndexOfTapBar: params,
              ));

  @override
  State<ReceiptsPage> createState() => _ReceiptsPageState();
}

class _ReceiptsPageState extends State<ReceiptsPage> {
  DateTime? currentBackPressTime;

  void onPopInvoked(bool didPop) {
    DateTime now = DateTime.now();
    if (didPop) {
      return;
    }
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      showSnackBar(context,
          backgroundColor: AppColors.martiniqueColor,
          msg: 'press_again_to_leave_app'.tr);
    } else {
      ConfirmDialog.show(context, title: "note".tr, message: "leave_app".tr,
          onConfirm: () {
        SystemNavigator.pop();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    ;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: onPopInvoked,
      child: BlocProvider<ReceiptsBloc>(
        create: (context) => di<ReceiptsBloc>()..add(LoadAllReceipts()),
        child: ReceiptsView(
          initialIndexOfTapBar: widget.initialIndexOfTapBar,
        ),
      ),
    );
  }
}

class ReceiptsView extends StatefulWidget {
  final int initialIndexOfTapBar;

  const ReceiptsView({required this.initialIndexOfTapBar, super.key});
  static GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  State<ReceiptsView> createState() => _ReceiptsViewState();
}

class _ReceiptsViewState extends State<ReceiptsView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(
        length: 3, initialIndex: widget.initialIndexOfTapBar, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: ReceiptsView.scaffoldKey,
      appBar: _buildAppBar(context),
      floatingActionButton:
          di<UserRepositoryImpl>().user!.permission!.canAddReceipt
              ? FloatingActionButton.small(
                  heroTag: 'add new maintenance',
                  backgroundColor: AppColors.eucalyptusColor,
                  onPressed: () {
                    AppRouter.navigator
                        .pushNamed(AppRoutes.newReceiptPageRoute)
                        .then((value) => value == true
                            ? BlocProvider.of<ReceiptsBloc>(context)
                                .add(ReloadMaintenanceList())
                            : null);
                  },
                  tooltip: "add_maintenance_tooltip".tr,
                  child: const Icon(
                    Icons.add_rounded,
                    color: AppColors.whiteColor,
                    // size: 40,
                  ),
                )
              : null,
      drawer: AppDrawer(),
      body: BlocListener<ReceiptsBloc, ReceiptsState>(
        bloc: BlocProvider.of<ReceiptsBloc>(context),
        listener: (context, state) {
          if (state.setPageIndex != null) {
            _tabController.animateTo(state.setPageIndex!);
          }
        },
        child: TabBarView(
          controller: _tabController,
          physics: BouncingScrollPhysics(),
          children: [
            ReceivedView(),
            InMaintenanceView(),
            QualityView(),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    double tabHeight = 40;
    return AppBar(
      titleSpacing: 0,
      leading: Builder(
        builder: (context) {
          return _buildAppBarBtn(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: Icons.menu_rounded,
          );
        },
      ),
      title: Hero(
        tag: 'search_field',
        child: CustomTextFormField(
            prefixIcon: const Icon(Icons.search_rounded),
            readOnly: true,
            onTap: () =>
                AppRouter.navigator.pushNamed(AppRoutes.searchPageRoute),
            hintText: "maintenance_search".tr),
      ),
      actions: [
        Center(
          child: _buildAppBarBtn(
              onPressed: () async {
                await showDialog<String?>(
                        context: context,
                        builder: (context) => CodeScannerDialog())
                    .then((_deviceCode) {
                  if (_deviceCode != null) {
                    AppRouter.navigator
                        .pushNamed(AppRoutes.deviceDetailsPageRoute,
                            arguments:
                                DeviceDetailsParams(deviceCode: _deviceCode))
                        .then((value) => AppRouter.navigator.pushNamed(
                            AppRoutes.receiptDetailsPageRoute,
                            arguments: ReceiptDetailsParams(
                              deviceCode: _deviceCode,
                              receiptDisplayType: ReceiptDisplayType.display,
                            )));
                    showSnackBar(context,
                        msg: "${'code'.tr}: $_deviceCode",
                        backgroundColor: AppColors.martiniqueColor);
                  }
                });
              },
              icon: Icons.qr_code_rounded),
        ),
      ],
      bottom: TabBar(
        controller: _tabController,
        dividerColor: Colors.white.withOpacity(.0),
        dividerHeight: tabHeight + 2,
        // indicatorPadding: const EdgeInsets.all(0),
        labelPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 2),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: AppColors.whiteColor,
        labelStyle: const TextStyle(fontWeight: FontWeight.w600),
        unselectedLabelColor: AppColors.whiteColor,
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w300),
        indicator: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.martiniqueColor.withOpacity(.6),
                AppColors.martiniqueColor.withOpacity(.8),
                AppColors.martiniqueColor.withOpacity(.4),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(10)),
        tabs: [
          Tab(height: tabHeight, text: "received".tr),
          Tab(height: tabHeight, text: "maintenance".tr),
          Tab(height: tabHeight, text: "quality".tr),
        ],
      ),
    );
  }

  Padding _buildAppBarBtn({
    double padding = 10,
    required void Function()? onPressed,
    required IconData icon,
    String? tooltip,
  }) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: AspectRatio(
        aspectRatio: 1,
        child: IconButton.outlined(
          style: ButtonStyle(
            padding: MaterialStateProperty.all(const EdgeInsets.all(0)),
            shape: MaterialStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
            side: MaterialStateProperty.all(const BorderSide(
              color: AppColors.whiteColor,
            )),
          ),
          icon: Icon(icon),
          onPressed: onPressed,
          tooltip: tooltip,
        ),
      ),
    );
  }
}
