import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:tech_care_app/app/app_localization.dart';
import 'package:tech_care_app/core/util/helpers/show_sack_bar.dart';
import 'package:tech_care_app/features/message_viewer/presentation/bloc/message_viewer_bloc.dart';
import 'package:tech_care_app/features/message_viewer/presentation/widgets/message_viewer_dialog.dart';
import 'package:tech_care_app/routes/app_routes.dart';
import 'package:tech_care_app/routes/app_router.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tech_care_app/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:tech_care_app/routes/custom_navigator_obsesrver.dart';
import '../core/util/app_themes.dart';
import '../features/user_preferences/presentation/bloc/user_preferences_bloc.dart';

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: BlocBuilder<UserPreferencesBloc, UserPreferencesState>(
        buildWhen: (previous, current) => previous != current,
        builder: (context, userPrefsState) {
          if (userPrefsState is UserPreferencesInitialState) {
            return const MaterialApp(
              key: Key('m2'),
              debugShowCheckedModeBanner: false,
            );
          }

          return GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
            child: MaterialApp(
              navigatorObservers: [CustomNavigatorObserver()],
              navigatorKey: AppRouter.navigatorKey,
              theme: appThemeData[userPrefsState.theme ?? AppTheme.lightTheme],
              locale: userPrefsState.locale,
              supportedLocales: const [
                Locale('en'),
                Locale('ar'),
              ],
              debugShowCheckedModeBanner: false,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              localeResolutionCallback: (locale, supportedLocales) {
                for (Locale supportedLocale in supportedLocales) {
                  if (locale!.languageCode == supportedLocale.languageCode) {
                    return supportedLocale;
                  }
                }
                return supportedLocales.first;
              },
              title: 'TechCare',
              initialRoute: AppRoutes.appLaunchingPageRoute,
              onGenerateRoute: AppRouter.onGenerateRoute,
              builder: (context, child) => MultiBlocListener(
                listeners: [
                  BlocListener<AuthBloc, AuthState>(
                    listenWhen: (previous, current) {
                      return ((current is AuthenticatedState) ||
                          (current is UnauthenticatedState));
                    },
                    listener: (context, authState) {
                      switch (authState) {
                        case AuthenticatedState():
                          AppRouter.navigator.pushNamedAndRemoveUntil(
                            AppRoutes.receiptsPageRoute,
                            arguments: 0,
                            (route) => false,
                          );
                          break;
                        case UnauthenticatedState():
                          AppRouter.navigator.pushNamedAndRemoveUntil(
                            AppRoutes.loginPageRoute,
                            (route) => false,
                          );
                          break;
                        default:
                      }
                    },
                  ),
                  BlocListener<MessageViewerBloc, MessageViewerState>(
                    listenWhen: (previous, current) => true,
                    listener: (context2, state) {
                      switch (state) {
                        case SnackbarMsgState():
                          showSnackBar(AppRouter.navigatorKey.currentContext!,
                              backgroundColor:
                                  state.snackBarMessageConfig.color,
                              msg: state.snackBarMessageConfig.msg
                                  .getDisplayValue(
                                      AppLocalizations.getLocale(context)));
                          break;
                        case DialogMsgState():
                          MessageViewerDialog.show(
                              AppRouter.navigatorKey.currentContext!,
                              dialogMessageConfig: state.dialogMessageConfig);

                          break;

                        default:
                      }
                    },
                  ),
                ],
                child: child!,
              ),
            ),
          );
        },
      ),
    );
  }
}
