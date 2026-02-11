import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:tech_care_app/app/app_localization.dart';
import 'package:tech_care_app/core/util/app_colors.dart';
import 'package:tech_care_app/core/util/app_constants.dart';
import 'package:tech_care_app/core/widgets/app_progress_indicator.dart';
import 'package:tech_care_app/features/device_details/domain/entities/process.dart';
import 'package:tech_care_app/features/device_details/presentation/bloc/device_details_bloc/device_details_bloc.dart';
import 'package:tech_care_app/routes/app_router.dart';
import 'package:tech_care_app/routes/app_routes.dart';

class TimerWidget extends StatelessWidget {
  const TimerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeviceDetailsBloc, DeviceDetailsState>(
      bloc: BlocProvider.of<DeviceDetailsBloc>(context),
      builder: (context, state) {
        return Container(
          // margin: EdgeInsets.symmetric(horizontal: AppConstants.mediumPadding),
          // clipBehavior: Clip.antiAlias,
          width: double.infinity,
          decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(0)),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Padding(
                padding: const EdgeInsets.all(AppConstants.mediumPadding),
                child: Row(
                  children: [
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'elapsed_time'.tr,
                          style: TextStyle(color: AppColors.eucalyptusColor),
                        ),
                        Text(
                          Duration(seconds: state.duration ?? 0)
                              .toString()
                              .split('.')
                              .first,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium!
                              .copyWith(fontWeight: FontWeight.w600),
                        ),
                      ],
                    )),
                    AnimatedSwitcher(
                        transitionBuilder: (child, animation) => FadeTransition(
                              opacity: animation,
                              child: ScaleTransition(
                                scale: animation,
                                child: child,
                              ),
                            ),
                        duration: Durations.medium2,
                        child: state.hideDeviceActoiinsButtons
                            ? SizedBox()
                            : state.timerStatus == TimerStatus.running
                                ? Row(
                                    children: [
                                      FloatingActionButton.small(
                                        heroTag: 'pause',
                                        elevation: 2,
                                        onPressed: () {
                                          BlocProvider.of<DeviceDetailsBloc>(
                                                  context)
                                              .add(PauseTimer());
                                          // AppRouter.navigator
                                          //     .pushNamed(AppRoutes.maintenanceReportPageRoute);
                                        },
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        backgroundColor: AppColors.silverColor,
                                        child: const Icon(
                                          Icons.pause_rounded,
                                          color: AppColors.martiniqueColor,
                                        ),
                                      ),
                                      const Gap(5),
                                      FloatingActionButton.small(
                                        heroTag: 'stop',
                                        elevation: 2,
                                        onPressed: () =>
                                            _redirectToReport(context, state),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        backgroundColor: AppColors.silverColor,
                                        child: const Icon(
                                          Icons.stop_rounded,
                                          color: AppColors.mojoColor,
                                        ),
                                      ),
                                    ],
                                  )
                                : state.timerStatus == TimerStatus.paused
                                    ? Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 27),
                                        child: FloatingActionButton.small(
                                          heroTag: 'start',
                                          elevation: 2,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          onPressed: () {
                                            BlocProvider.of<DeviceDetailsBloc>(
                                                    context)
                                                .add(StartTimer());
                                          },
                                          backgroundColor:
                                              AppColors.silverColor,
                                          child: const Icon(
                                              Icons.arrow_right_rounded,
                                              color: AppColors.martiniqueColor,
                                              size: 40),
                                        ),
                                      )
                                    : Icon(
                                        Icons.error_outline_rounded,
                                        color: AppColors.mojoColor,
                                      )),
                  ],
                ),
              ),
              state.timerLoading
                  ? SizedBox(height: 2, child: AppProgressIndicator())
                  : SizedBox(),
            ],
          ),
        );
      },
    );
  }

  void _redirectToReport(BuildContext context, DeviceDetailsState state) {
    switch (
        state.deviceDetails?.deviceInfo.status!.getDisplayValue(Locale('en'))) {
      case 'maintenance':
        AppRouter.navigator.pushNamed(AppRoutes.maintenanceReportPageRoute,
            arguments: state.deviceDetails!.deviceInfo.id);
        break;
      case 'quality':
        AppRouter.navigator.pushNamed(AppRoutes.qualityReportPageRoute,
            arguments: state.deviceDetails!.deviceInfo.id);
      default:
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            alignment: Alignment.center,
            icon: Icon(Icons.warning_rounded, color: AppColors.mojoColor),
            content: Text(
              'Unkown expected Stage: ${state.deviceDetails?.deviceInfo.status!.getDisplayValue(Locale('en'))}',
              textAlign: TextAlign.center,
            ),
            iconPadding: EdgeInsets.all(AppConstants.mediumPadding),
            backgroundColor: AppColors.alabasterColor,
            contentPadding:
                EdgeInsets.symmetric(horizontal: AppConstants.mediumPadding),
            buttonPadding: EdgeInsets.all(0),
            actionsPadding: EdgeInsets.all(AppConstants.mediumPadding),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              OutlinedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('close'.tr),
              ),
            ],
          ),
        );
    }
  }
}
