import 'dart:async';

import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:gap/gap.dart';
// import 'package:tech_care_app/app/app_localization.dart';
import 'package:tech_care_app/core/util/app_colors.dart';
// import 'package:tech_care_app/core/util/app_constants.dart';
import 'package:tech_care_app/core/util/app_strings.dart';
import 'package:tech_care_app/core/widgets/dots_loading_indicator.dart';
// import 'package:tech_care_app/features/user_preferences/presentation/bloc/user_preferences_bloc.dart';

// class ChangeLanguageDialog extends StatelessWidget {
//   const ChangeLanguageDialog({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Padding(
//         padding: EdgeInsets.all(AppConstants.mediumPadding),
//         child: Material(
//           clipBehavior: Clip.antiAlias,
//           color: AppColors.whiteColor,
//           borderRadius: BorderRadius.circular(AppConstants.mediumPadding + 3),
//           child: SizedBox(
//             width: 500,
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Align(
//                   alignment: Alignment.centerRight,
//                   child: IconButton(
//                       padding: EdgeInsets.zero,
//                       onPressed: () {
//                         Navigator.canPop(context)
//                             ? Navigator.pop(context)
//                             : null;
//                       },
//                       icon: const Icon(Icons.close)),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(
//                       horizontal: AppConstants.largePadding),
//                   child: Column(
//                     children: [
//                       CircleAvatar(
//                         radius: 25,
//                         child: Icon(
//                           Icons.language_rounded,
//                           size: 35,
//                           color: AppColors.martiniqueColor,
//                         ),
//                       ),
//                       Gap(AppConstants.mediumPadding),
//                       Text(
//                         'change_lang_confirmation'.tr
//                         ,
//                         style: Theme.of(context).textTheme.titleMedium,
//                         textAlign: TextAlign.center,
//                       ),
//                       Gap(AppConstants.largePadding),
//                       ElevatedButton(
//                           onPressed: () {
//                             Navigator.canPop(context)
//                                 ? Navigator.pop(context)
//                                 : null;
//                             Navigator.of(context).push(MaterialPageRoute(
//                               builder: (context) => languageChangingPage(),
//                             ));
//                             AppLocalizations.of(context)!.locale.languageCode ==
//                                     'en'
//                                 ? BlocProvider.of<UserPreferencesBloc>(context)
//                                     .add(UserPreferredLanguageChanged(
//                                         locale: Locale('ar')))
//                                 : BlocProvider.of<UserPreferencesBloc>(context)
//                                     .add(UserPreferredLanguageChanged(
//                                         locale: Locale('en')));
//                           },
//                           child: Center(child: Text('yes'.tr))),
//                       Gap(AppConstants.largePadding)
//                     ],
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

class languageChangingPage extends StatefulWidget {
  const languageChangingPage({super.key});
 static Route<dynamic> route({RouteSettings? settings}) => MaterialPageRoute(
      settings: settings, builder: (context) => languageChangingPage());
  @override
  State<languageChangingPage> createState() => _languageChangingPageState();
}

class _languageChangingPageState extends State<languageChangingPage> {
  late final Timer _timer;
  @override
  void initState() {
    _timer = Timer(Durations.extralong4 * 1.5, () {
      Navigator.canPop(context) ? Navigator.pop(context) : null;
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.martiniqueColor,
            // AppColors.eucalyptusColor,
            AppColors.eucalyptusColor,
          ],
        )),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(),
            Image.asset(AppStrings.earthImagePath),
            DotsLoadingIndicator(
              count: 4,
              activeColor: AppColors.whiteColor,
              inactiveColor: AppColors.whiteColor.withOpacity(0.2),
            ),
            Text(
              'Changing Language',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(color: AppColors.whiteColor),
            ),
            SizedBox(),
          ],
        ),
      ),
    );
  }
}
