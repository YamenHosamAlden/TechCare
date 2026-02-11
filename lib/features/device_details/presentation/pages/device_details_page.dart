import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_care_app/app/app_localization.dart';
import 'package:tech_care_app/core/util/app_colors.dart';
import 'package:tech_care_app/core/widgets/error_message_widget.dart';
import 'package:tech_care_app/core/widgets/loading_indicator.dart';
import 'package:tech_care_app/dependency_injection.dart';
import 'package:tech_care_app/features/device_details/presentation/bloc/device_details_bloc/device_details_bloc.dart';
import 'package:tech_care_app/features/device_details/presentation/dialogs/add_note_dialog.dart';
import 'package:tech_care_app/features/device_details/presentation/pages/Device_info_view.dart';
import 'package:tech_care_app/features/device_details/presentation/pages/process_view.dart';
import 'package:tech_care_app/routes/route_params.dart';

class DeviceDetailsPage extends StatefulWidget {
  final int? deviceId;
  final String? deviceCode;
  const DeviceDetailsPage(
      {required this.deviceId, required this.deviceCode, super.key});
  static Route<dynamic> route(
          {required DeviceDetailsParams params, RouteSettings? settings}) =>
      MaterialPageRoute(
          settings: settings,
          builder: (context) => DeviceDetailsPage(
                deviceId: params.deviceID,
                deviceCode: params.deviceCode,
              ));

  @override
  State<DeviceDetailsPage> createState() => _DeviceDetailsPageState();
}

class _DeviceDetailsPageState extends State<DeviceDetailsPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late bool _showFloatingActionButton;

  late final DeviceDetailsBloc _bloc;

  @override
  void initState() {
    _bloc = di<DeviceDetailsBloc>();
    _getDeviceDetails();

    // ..add(GetDeviceInfo(deviceID: widget.deviceId));
    _showFloatingActionButton = false;
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0)
      ..addListener(() {
        if (_tabController.index == 1) {
          setState(() {
            _showFloatingActionButton = true;
          });
        } else {
          setState(() {
            _showFloatingActionButton = false;
          });
        }
      });
    super.initState();
  }

  @override
  void dispose() {
    _bloc.close();
    _tabController.dispose();
    super.dispose();
  }

  _getDeviceDetails() {
    if (widget.deviceCode != null) {
      // print('get device by code');
      _bloc.add(GetDeviceInfo(deviceCode: widget.deviceCode!));
    } else {
      // print('get device by id');
      _bloc.add(GetDeviceInfo(deviceID: widget.deviceId!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DeviceDetailsBloc>.value(
      value: _bloc,
      child: BlocBuilder<DeviceDetailsBloc, DeviceDetailsState>(
        bloc: _bloc,
        buildWhen: (previous, current) {
          if (current.stateType == DeviceDetailsStateType.TICKER) {
            return false;
          }
          return true;
        },
        builder: (context, state) {
          return Scaffold(
            appBar: _buildAppBar(context),
            floatingActionButton: _bloc.state.isLoading ||
                    state is DeviceDetailsErrorState
                ? null
                : _showFloatingActionButton
                    ? FloatingActionButton.small(
                        backgroundColor: AppColors.eucalyptusColor,
                        onPressed: () {
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (dialogContext) => BlocProvider.value(
                                  value: _bloc, child: AddNoteDilaog()));
                        },
                        child: const Icon(
                          Icons.edit,
                          color: AppColors.whiteColor,
                        ),
                      )
                    : null,
            body: _bloc.state.isLoading
                ? LoadingIndicator()
                : state is DeviceDetailsErrorState
                    ? ErrorMessageWidget(
                        errorMessage: state.errorMessage,
                        onRetry: () {
                          _getDeviceDetails();
                        },
                      )
                    : Stack(
                        children: [
                          TabBarView(
                            clipBehavior: Clip.none,
                            controller: _tabController,
                            physics: const BouncingScrollPhysics(),
                            children: [
                              RefreshIndicator(
                                onRefresh: () async {
                                  _getDeviceDetails();
                                },
                                child: DeviceInfoView(
                                  deviceInfo:
                                      _bloc.state.deviceDetails!.deviceInfo,
                                ),
                              ),
                              RefreshIndicator(
                                onRefresh: () async {
                                  _getDeviceDetails();
                                },
                                child: ProcessView(
                                  processInfo:
                                      _bloc.state.deviceDetails!.process,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
          );
        },
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    double tabHeight = 40;
    return AppBar(
      title: Text('device_details'.tr),
      bottom: TabBar(
        controller: _tabController,
        dividerColor: Colors.white.withOpacity(0),
        dividerHeight: tabHeight + 2,
        indicatorPadding: const EdgeInsets.all(0),
        labelPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 2),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: AppColors.whiteColor,
        labelStyle: const TextStyle(fontWeight: FontWeight.w600),
        unselectedLabelColor: AppColors.whiteColor,
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w300),
        indicatorColor: AppColors.martiniqueColor,
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
          Tab(height: tabHeight, text: 'info'.tr),
          Tab(height: tabHeight, text: 'reports'.tr),
        ],
      ),
    );
  }
}
