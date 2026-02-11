import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:tech_care_app/app/app_localization.dart';
import 'package:tech_care_app/core/entities/translatable_value.dart';
import 'package:tech_care_app/core/util/app_colors.dart';
import 'package:tech_care_app/core/util/app_constants.dart';
import 'package:tech_care_app/core/util/app_strings.dart';
import 'package:tech_care_app/core/widgets/blur_card.dart';
import 'package:tech_care_app/core/widgets/custom_text_form_field.dart';
import 'package:tech_care_app/core/widgets/my_circle_painter.dart';
import 'package:tech_care_app/dependency_injection.dart';
import 'package:tech_care_app/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:tech_care_app/features/auth/presentation/bloc/login_bloc/login_bloc.dart';
import 'package:tech_care_app/features/user_preferences/presentation/bloc/user_preferences_bloc.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  static Route<dynamic> route({RouteSettings? settings}) => MaterialPageRoute(
      settings: settings, builder: (context) => const LoginPage());

  void _showErrorSnackbar(BuildContext context,
      {required TranslatableValue errorMsg}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: Durations.extralong4,
      backgroundColor: AppColors.mojoColor,
      content: Text(
        errorMsg.tr,
        style: Theme.of(context)
            .textTheme
            .titleMedium!
            .copyWith(color: AppColors.whiteColor),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginBloc>(
        create: (Context) => di<LoginBloc>(),
        child: MultiBlocListener(
          listeners: [
            BlocListener<AuthBloc, AuthState>(
              listener: (context, AuthState authState) {
                switch (authState) {
                  case AuthErrorMsgState():
                    _showErrorSnackbar(context, errorMsg: authState.errorMsg);
                    break;
                  default:
                }
              },
            ),
            BlocListener<LoginBloc, LoginState>(
              listener: (context, LoginState loginState) {
                switch (loginState) {
                  case LoginErrorMsgState():
                    _showErrorSnackbar(context, errorMsg: loginState.errorMsg);
                    break;
                  default:
                }
              },
            ),
          ],
          child: LoginView(),
        ));
  }
}

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController userName;
  late final TextEditingController passWord;
  AutovalidateMode? autovalidateMode;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    userName = TextEditingController();
    passWord = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    userName.dispose();
    passWord.dispose();
    super.dispose();
  }

  bool _validateForm() {
    autovalidateMode = AutovalidateMode.onUserInteraction;
    return _formKey.currentState!.validate();
  }

  void _login() {
    setState(() {
      FocusManager.instance.primaryFocus!.unfocus();
    });

    if (_validateForm())
      BlocProvider.of<LoginBloc>(context).add(
        LoginFormSubmittedEvent(
            userNamr: userName.text.trim(), passWord: passWord.text),
      );
  }

  bool passwordObscureText = true;

  void showPassword() {
    setState(() {
      passwordObscureText = !passwordObscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenheight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            _drawBackground(),
            SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: screenheight / 4,
                    child: Row(
                      children: [
                        const Spacer(),
                        Expanded(
                          flex: 2,
                          child: Center(
                            child: Container(
                                margin: const EdgeInsets.all(
                                    AppConstants.mediumPadding),
                                width: 200,
                                child: Hero(
                                    tag: 'logo',
                                    child: Image.asset(
                                        AppStrings.coloredLogoPath))),
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.mediumPadding),
                    child: Form(
                      key: _formKey,
                      autovalidateMode: autovalidateMode,
                      child: AnimatedSwitcher(
                        switchInCurve: Curves.easeOutBack,
                        switchOutCurve: Curves.easeOut,
                        duration: const Duration(milliseconds: 1000),
                        reverseDuration: const Duration(milliseconds: 1000),
                        transitionBuilder: (child, animation) => FadeTransition(
                          opacity: animation,
                          child: ScaleTransition(
                            scale: animation
                                .drive(Tween<double>(begin: 0, end: 1)),
                            child: child,
                          ),
                        ),
                        layoutBuilder: (currentChild, previousChildren) =>
                            Stack(
                          alignment: Alignment.topCenter,
                          children: [
                            ...previousChildren,
                            currentChild!,
                          ],
                        ),
                        child: BlureCard(
                          key:
                              Key(Localizations.localeOf(context).languageCode),
                          blur: 5,
                          color: AppColors.martiniqueColor.withOpacity(.3),
                          borderRadius: 10,
                          child: Center(
                              child: Padding(
                            padding: const EdgeInsets.fromLTRB(
                                AppConstants.mediumPadding,
                                AppConstants.mediumPadding,
                                AppConstants.mediumPadding,
                                AppConstants.mediumPadding),
                            child: Column(
                              children: [
                                const Gap(30),
                                Text(
                                  "login_welcome".tr,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineLarge!
                                      .copyWith(
                                          color: AppColors.whiteColor,
                                          height: 0),
                                ),
                                const Gap(30),
                                Text(
                                  "login_welcome_sub".tr,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .copyWith(
                                          color: AppColors.whiteColor,
                                          height: 0),
                                ),
                                const Gap(30),
                                CustomTextFormField(
                                  controller: userName,
                                  textInputActio: TextInputAction.next,
                                  prefixIcon: const Icon(Icons.person),
                                  hintText: 'login_username'.tr,
                                  validator: (userName) {
                                    if (userName == null ||
                                        userName.trim().isEmpty) {
                                      return 'plz_enter_username'.tr;
                                    }
                                    return null;
                                  },
                                ),
                                const Gap(15),
                                CustomTextFormField(
                                  controller: passWord,
                                  obscureText: passwordObscureText,
                                  textInputActio: TextInputAction.done,
                                  suffixIcon: IconButton(
                                      onPressed: showPassword,
                                      icon: Icon(passwordObscureText
                                          ? Icons.visibility_off
                                          : Icons.visibility)),
                                  onEditingComplete: () {
                                    _login();
                                  },
                                  prefixIcon: const Icon(Icons.lock),
                                  hintText: 'login_password'.tr,
                                  validator: (password) {
                                    if (password == null || password.isEmpty) {
                                      return 'plz_enter_password'.tr;
                                    }
                                    return null;
                                  },
                                ),
                                const Gap(30),
                                BlocBuilder<AuthBloc, AuthState>(
                                  builder: (context, authstate) {
                                    return BlocBuilder<LoginBloc, LoginState>(
                                        builder: (context, loginState) =>
                                            SizedBox(
                                              height: 50,
                                              child: Center(
                                                child: loginState
                                                            is LoginLoadingState ||
                                                        authstate
                                                            is AuthLoadingState
                                                    ? const CircularProgressIndicator()
                                                    : ElevatedButton(
                                                        onPressed: () {
                                                          _login();
                                                        },
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                              child: Text(
                                                                "login_btn".tr,
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                              ),
                                            ));
                                  },
                                ),
                                const Gap(30),
                                Directionality(
                                  textDirection: TextDirection.ltr,
                                  child: BlocBuilder<UserPreferencesBloc,
                                      UserPreferencesState>(
                                    builder: (context, state) {
                                      return LanguageSwiper(
                                        initialTab: _getLangTab(state.locale),
                                        onChange: (tab) {
                                          setState(() {
                                            switch (tab) {
                                              case 0:
                                                BlocProvider.of<
                                                            UserPreferencesBloc>(
                                                        context)
                                                    .add(
                                                        const UserPreferredLanguageChanged(
                                                            locale:
                                                                Locale('en')));
                                                break;
                                              case 1:
                                                BlocProvider.of<
                                                            UserPreferencesBloc>(
                                                        context)
                                                    .add(
                                                        const UserPreferredLanguageChanged(
                                                            locale:
                                                                Locale('ar')));
                                                break;
                                              default:
                                            }
                                          });
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          )),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  int _getLangTab(Locale? locale) {
    switch (locale.toString()) {
      case 'en':
        return 0;
      case 'ar':
        return 1;

      default:
        return 1;
    }
  }

  double _percentageOfScreenLength(double screenheight, double screenWidth) {
    final screenAspectRatio = screenheight / screenWidth;

    if (screenAspectRatio > 2) {
      return 0;
    }
    return -(2 - screenAspectRatio) * screenWidth;
  }

  Widget _drawBackground() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenheight = MediaQuery.of(context).size.height;

    final desiredRadius = screenWidth * 1.4;

    return Stack(
      children: [
        _drawCircle(desiredRadius, AppColors.eucalyptusColor.withOpacity(.5),
            0.0 + _percentageOfScreenLength(screenheight, screenWidth)),
        _drawCircle(
            desiredRadius,
            AppColors.eucalyptusColor.withOpacity(.75),
            (-desiredRadius / 4) +
                _percentageOfScreenLength(screenheight, screenWidth)),
        _drawCircle(
            desiredRadius,
            AppColors.eucalyptusColor,
            (-desiredRadius / 2) +
                _percentageOfScreenLength(screenheight, screenWidth)),
      ],
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

class LanguageSwiper extends StatefulWidget {
  final void Function(int) onChange;
  final int initialTab;
  const LanguageSwiper(
      {super.key, required this.onChange, required this.initialTab});

  @override
  State<LanguageSwiper> createState() => _LanguageSwiperState();
}

class _LanguageSwiperState extends State<LanguageSwiper>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  int? seletedTab;
  // int changingTimes = 0;
  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _tabController.index = widget.initialTab;
    // _tabController.addListener(() {
    //   if (changingTimes % 2 == 0) {

    //     widget.onChange(_tabController.index);
    //   }
    //   changingTimes++;
    // });
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(0),
      height: 37,
      child: TabBar(
          onTap: (tab) {
            if (seletedTab != tab) {
              seletedTab = tab;
              widget.onChange(tab);
            }
          },
          controller: _tabController,
          dividerHeight: 0,
          indicatorSize: TabBarIndicatorSize.tab,
          labelColor: AppColors.whiteColor,
          labelStyle: const TextStyle(fontWeight: FontWeight.w600),
          unselectedLabelColor: AppColors.whiteColor.withOpacity(.7),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w400),
          indicator: BoxDecoration(
              color: AppColors.whiteColor.withOpacity(.05),
              borderRadius: BorderRadius.circular(5)),
          tabs: const [
            Tab(
              text: "English",
            ),
            Tab(
              text: 'العربية',
            ),
          ]),
    );
  }
}
