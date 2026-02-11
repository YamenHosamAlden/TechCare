import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_care_app/app/app_localization.dart';
import 'package:tech_care_app/core/util/app_colors.dart';
import 'package:tech_care_app/core/util/app_strings.dart';
import 'package:tech_care_app/core/widgets/dots_loading_indicator.dart';
import 'package:tech_care_app/core/widgets/my_circle_painter.dart';
import 'package:tech_care_app/dependency_injection.dart';
import 'package:tech_care_app/features/app_launch/presentation/bloc/app_launch_bloc.dart';
import 'package:tech_care_app/features/app_launch/presentation/pages/new_update_page.dart';
import 'package:tech_care_app/features/app_launch/presentation/pages/updating_service_page.dart';
import 'package:tech_care_app/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:tech_care_app/routes/app_router.dart';
import 'package:tech_care_app/routes/app_routes.dart';



class AppLaunchingPage extends StatefulWidget {
  const AppLaunchingPage({super.key});

  static Route<dynamic> route({RouteSettings? settings}) => MaterialPageRoute(
      settings: settings, builder: (context) => const AppLaunchingPage());

  @override
  State<AppLaunchingPage> createState() => _AppLaunchingPageState();
}

class _AppLaunchingPageState extends State<AppLaunchingPage> {
  final Duration _animationDuration = const Duration(seconds: 1);
  final Curve _curve = Curves.easeInOut;

  late final AppLaunchBloc _appLaunchBloc;

  @override
  void initState() {
    _appLaunchBloc = di<AppLaunchBloc>();

    _appLaunchBloc.add(AppLaunchInitialEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, authState) {
        switch (authState) {
          case AuthErrorMsgState():
            showDialog<void>(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return PopScope(
                  canPop: false,
                  child: AlertDialog(
                    title:
                        Text('error'.tr),
                    content: SingleChildScrollView(
                      child: ListBody(
                        children: <Widget>[
                          Text(authState.errorMsg.getDisplayValue(
                              AppLocalizations.getLocale(context))),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: Text(
                            'retry'.tr),
                        onPressed: () {
                          BlocProvider.of<AuthBloc>(context)
                              .add(CheckSavedTokenAuthEvent());
                          Navigator.pop(context);
                        },
                      ),
                      TextButton(
                        child: Text(
                           'try_login'.tr),
                        onPressed: () {
                          AppRouter.navigator.pushNamedAndRemoveUntil(
                              AppRoutes.loginPageRoute, (_) => false);
                        },
                      ),
                    ],
                  ),
                );
              },
            );
            break;

          default:
        }
      },
      child: BlocListener<AppLaunchBloc, AppLaunchState>(
        bloc: _appLaunchBloc,
        listenWhen: (previous, current) {
          print('new state');
          return true;
        },
        listener: (context, state) {
          switch (state) {
            // case AppLaunchingErorr():
            //   ErrorDialog.show(context,
            //       errorMessage: state.errorMsg
            //           .getDisplayValue(AppLocalizations.getLocale(context)),
            //       reTry: () {
            //     _appLaunchBloc.add(AppLaunchInitialEvent());
            //   });

            //   break;
            case UpdatingService():
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UpdatingServicePage(),
                  ));
              break;

            case NewUpdate():
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        NewUpdatePage(versionStatus: state.versionStatus),
                  )).then((value) => _appLaunchBloc.add(SkipUpdateEvent()));
              ;
              break;

            case AppLaunchingComplete():
              BlocProvider.of<AuthBloc>(context)
                  .add(CheckSavedTokenAuthEvent());
              break;
          }
        },
        child: Scaffold(
          body: SafeArea(
            bottom: false,
            child: Stack(
              children: [
                _drawBackground(),
                TweenAnimationBuilder<double>(
                  duration: _animationDuration,
                  tween: Tween(begin: 0, end: 1),
                  child: Align(
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Expanded(
                            child: Row(
                          children: [
                            const Spacer(),
                            Expanded(
                              flex: 2,
                              child: Center(
                                child: Container(
                                    margin: const EdgeInsets.all(10),
                                    width: 200,
                                    // height: 30,
                                    child: Hero(
                                        tag: 'logo',
                                        child: Image.asset(
                                            AppStrings.coloredLogoPath))),
                              ),
                            ),
                            const Spacer()
                          ],
                        )),
                        Expanded(
                            child: Row(
                          children: [
                            const Spacer(),
                            Expanded(
                                flex: 4,
                                child: Image.asset(AppStrings.amicoImagePath,
                                    scale: 2.3)),
                            const Spacer(),
                          ],
                        )),
                        Expanded(
                            child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              DotsLoadingIndicator(
                                count: 4,
                                activeColor: Colors.white,
                                inactiveColor: Colors.white.withOpacity(0.2),
                              ),
                              TweenAnimationBuilder<double>(
                                duration: _animationDuration * 3,
                                tween: Tween(begin: 0, end: 1),
                                builder: (BuildContext context, dynamic value,
                                    Widget? child) {
                                  return AnimatedOpacity(
                                    opacity: value.floor().toDouble(),
                                    duration: _animationDuration,
                                    curve: _curve,
                                    child: child,
                                  );
                                },
                                child: Text(
                                 "app_launching_checks".tr,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(color: AppColors.whiteColor),
                                ),
                              ),
                              const SizedBox(),
                            ],
                          ),
                        )),
                      ],
                    ),
                  ),
                  builder: (context, value, child) => AnimatedOpacity(
                    opacity: value.floor().toDouble(),
                    duration: _animationDuration,
                    curve: _curve,
                    child: child,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  double _percentageOfScreenLength(double screenheight, double screenWidth) {
    final screenAspectRatio = screenheight / screenWidth;

    if (screenAspectRatio > 2) {
      return 0;
    }
    return -(2 - screenAspectRatio) * screenWidth;
  }

  TweenAnimationBuilder<double> _drawBackground() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenheight = MediaQuery.of(context).size.height;

    final desiredRadius = screenWidth * 1.4;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: _animationDuration,
      curve: _curve,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Stack(
            children: [
              _drawCircle(
                  desiredRadius,
                  AppColors.eucalyptusColor.withOpacity(.5),
                  0.0 + _percentageOfScreenLength(screenheight, screenWidth)),
              _drawCircle(
                  desiredRadius,
                  AppColors.eucalyptusColor.withOpacity(.75),
                  (-desiredRadius / 4) * value +
                      _percentageOfScreenLength(screenheight, screenWidth)),
              _drawCircle(
                  desiredRadius,
                  AppColors.eucalyptusColor,
                  (-desiredRadius / 2) * value +
                      _percentageOfScreenLength(screenheight, screenWidth)),
            ],
          ),
        );
      },
    );
  }

  Widget _drawCircle(double radius, Color color, double bottomAlignment) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: bottomAlignment,
      child: CustomPaint(
        painter: MyCirclePainter(radius, color),
        child: ClipRect(
          child: SizedBox(
            width: radius,
            height: radius,
          ),
        ),
      ),
    );
  }
}
