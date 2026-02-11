import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:tech_care_app/app/app_localization.dart';
import 'package:tech_care_app/core/util/app_constants.dart';
import 'package:tech_care_app/core/util/app_strings.dart';
import 'package:tech_care_app/core/widgets/loading_indicator.dart';
import 'package:tech_care_app/core/widgets/page_place_holder.dart';
import 'package:tech_care_app/features/receipts/presentation/bloc/receipts_bloc.dart';
import 'package:tech_care_app/features/receipts/presentation/widgets/receipt_card.dart';

class InMaintenanceView extends StatefulWidget {
  const InMaintenanceView({super.key});

  @override
  State<InMaintenanceView> createState() => ReeceiveViewdState();
}

class ReeceiveViewdState extends State<InMaintenanceView> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.position.maxScrollExtent ==
            _scrollController.offset) {
          BlocProvider.of<ReceiptsBloc>(context)
            ..add(LoadMoreMaintenanceReceipts());
        }
      });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReceiptsBloc, ReceiptsState>(
      bloc: BlocProvider.of<ReceiptsBloc>(context),
      builder: (context, state) {
        if (state.loadingMaintenance) {
          return LoadingIndicator();
        }

        if (state.maintenanceList.isEmpty) {
          return PagePlaceHolder(
            imagePath: AppStrings.maintenanceImagePath,
            msg: 'no_receipts'.tr,
            onRetry: (){
               BlocProvider.of<ReceiptsBloc>(context)
                      ..add(ReloadMaintenanceList());
            },
          );

       
        }
        return TweenAnimationBuilder(
          tween: Tween<double>(begin: 0, end: 1),
          duration: Durations.medium2,
          curve: Curves.easeOut,
          builder: (context, value, child) => Padding(
            padding: EdgeInsets.only(top: 200 - 200 * value),
            child: Opacity(opacity: value, child: child),
          ),
          child: RefreshIndicator(
            onRefresh: () async {
              BlocProvider.of<ReceiptsBloc>(context)
                ..add(ReloadMaintenanceList());
            },
            child: ListView.separated(
              controller: _scrollController,
              physics: AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(
                  AppConstants.mediumPadding,
                  AppConstants.mediumPadding,
                  AppConstants.mediumPadding,
                  AppConstants.extraLargePadding * 4),
              separatorBuilder: (context, index) =>
                  const Gap(AppConstants.mediumPadding),
              itemCount: state.maintenanceList.length +
                  (state.loadingMoreMaintenance ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == state.maintenanceList.length) {
                  return LoadingIndicator();
                }
                return ReceiptCard(
                  receipt: state.maintenanceList.elementAt(index),
                  receiptDisplayType: ReceiptDisplayType.maintenance,
                );
              },
            ),
          ),
        );
      },
    );
  }
}
