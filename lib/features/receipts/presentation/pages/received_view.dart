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

class ReceivedView extends StatefulWidget {
  const ReceivedView({super.key});

  @override
  State<ReceivedView> createState() => ReeceiveViewdState();
}

class ReeceiveViewdState extends State<ReceivedView> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.position.maxScrollExtent ==
            _scrollController.offset) {
          BlocProvider.of<ReceiptsBloc>(context)
            ..add(LoadMoreReceivedReceipts());
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
        if (state.loadingReceived) {
          return LoadingIndicator();
        }

        if (state.receivedList.isEmpty) {
          return PagePlaceHolder(
            imagePath: AppStrings.receiveImagePath,
            msg: 'no_receipts'.tr,
            onRetry: () {
              BlocProvider.of<ReceiptsBloc>(context)..add(ReloadReceivedList());
            },
          );
        }

        return TweenAnimationBuilder(
          tween: Tween<double>(begin: 0, end: 1),
          duration: Durations.medium2,
          curve: Curves.easeOut,
          builder: (context, value, child) => Padding(
            padding: EdgeInsets.only(top: 200 - 200 * value),
            child: Opacity(
              opacity: value,
              child: child,
            ),
          ),
          child: RefreshIndicator(
            onRefresh: () async {
              BlocProvider.of<ReceiptsBloc>(context)..add(ReloadReceivedList());
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
              itemCount: state.receivedList.length +
                  (state.loadingMoreReceived ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == state.receivedList.length) {
                  return LoadingIndicator();
                }
                return ReceiptCard(
                  receipt: state.receivedList.elementAt(index),
                  receiptDisplayType: ReceiptDisplayType.received,
                );
              },
            ),
          ),
        );
      },
    );
  }
}

