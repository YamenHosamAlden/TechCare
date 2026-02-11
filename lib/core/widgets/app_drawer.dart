import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tech_care_app/app/app_localization.dart';
import 'package:tech_care_app/core/util/app_colors.dart';
import 'package:tech_care_app/core/widgets/dialogs/confirm_dialog.dart';
import 'package:tech_care_app/features/auth/domain/entities/user.dart';
import 'package:tech_care_app/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:tech_care_app/features/auth/presentation/dialogs/logout_dialog.dart';
import 'package:tech_care_app/features/receipts/presentation/pages/receipts_page.dart';
import 'package:tech_care_app/features/user_preferences/presentation/bloc/user_preferences_bloc.dart';
import 'package:tech_care_app/routes/app_router.dart';
import 'package:tech_care_app/routes/app_routes.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  void initState() {
    ;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: ListView(
          physics: ClampingScrollPhysics(),
          children: [
            Builder(builder: (context) {
              if (BlocProvider.of<AuthBloc>(context).state
                  is AuthenticatedState) {
                final User _user = (BlocProvider.of<AuthBloc>(context).state
                        as AuthenticatedState)
                    .user;

                return UserAccountsDrawerHeader(
                    decoration: BoxDecoration(
                      color: AppColors.eucalyptusColor.withOpacity(.5),
                    ),
                    currentAccountPicture: CachedNetworkImage(
                      imageUrl: _user.img ?? '',
                      imageBuilder: (context, imageProvider) =>
                      
                      CircleAvatar(
                        backgroundColor: AppColors.martiniqueColor,
                        backgroundImage: imageProvider,
                        //  NetworkImage(_user.img ?? ''),
                        child: _user.img == null
                            ? Text(getAlias(_user.name),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.whiteColor,
                                    ))
                            : null,
                      ),
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) =>
                                     Shimmer.fromColors(
                        baseColor: AppColors.martiniqueColor,
                        highlightColor: AppColors.funBlueColor,
                        child: CircleAvatar(
                          backgroundColor: AppColors.martiniqueColor,
                        ),
                      ),
                      errorWidget: (context, url, error) => CircleAvatar(
                        backgroundColor: AppColors.martiniqueColor,
                        child: Text(getAlias(_user.name),
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.whiteColor,
                                )),
                      ),
                    ),
                    accountName: Text(
                      _user.name,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.martiniqueColor,
                          ),
                    ),
                    accountEmail: Text('${_user.role} - ${_user.branchName}',
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  fontWeight: FontWeight.normal,
                                  color: AppColors.martiniqueColor,
                                )));
              }
              return SizedBox();
            }),
            ListTile(
              dense: true,
              leading: Icon(Icons.done_all_rounded),
              title: Text('finished_receipts'.tr),
              onTap: () {
                ReceiptsView.scaffoldKey.currentState!.closeDrawer();

                AppRouter.navigator
                    .pushNamed(AppRoutes.finishedReceiptsPageRoute);
              },
            ),
            _buildDivider(),
            ListTile(
              dense: true,
              leading: Icon(Icons.receipt_long),
              title: Text('recently_added_receipts'.tr),
              onTap: () {
                ReceiptsView.scaffoldKey.currentState!.closeDrawer();

                AppRouter.navigator
                    .pushNamed(AppRoutes.recentlyAddedReceiptsPageRoute);
              },
            ),
            _buildDivider(),
            ListTile(
              dense: true,
              leading: Icon(Icons.language_rounded),
              title: Text('language'.tr),
              onTap: () {
                ReceiptsView.scaffoldKey.currentState!.closeDrawer();
                ConfirmDialog.show(
                  AppRouter.navigator.context,
                  title: "language".tr,
                  message: 'change_lang_confirmation'.tr,
                  onConfirm: () {
                    AppRouter.navigator
                        .pushNamed(AppRoutes.languageChangingPageRoute);
                    AppLocalizations.of(AppRouter.navigator.context)
                                ?.locale
                                .languageCode ==
                            'en'
                        ? BlocProvider.of<UserPreferencesBloc>(
                                AppRouter.navigator.context)
                            .add(UserPreferredLanguageChanged(
                                locale: Locale('ar')))
                        : BlocProvider.of<UserPreferencesBloc>(
                                AppRouter.navigator.context)
                            .add(UserPreferredLanguageChanged(
                                locale: Locale('en')));
                  },
                );
              },
            ),
            _buildDivider(),
            ListTile(
              dense: true,
              leading: Icon(Icons.logout_rounded),
              title: Text('logout'.tr),
              onTap: () {
                ReceiptsView.scaffoldKey.currentState!.closeDrawer();
                LogoutDialog.show(
                  context,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  String getAlias(String word) {
    String alias = '';
    for (String w in word.split(' ')) {
      alias += w.toUpperCase().split('').first;
    }
    return alias;
  }

  Divider _buildDivider() => Divider(
        height: 0,
        indent: 20,
        endIndent: 20,
        color: AppColors.altoColor,
      );
}
