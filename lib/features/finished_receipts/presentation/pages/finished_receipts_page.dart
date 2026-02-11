import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:tech_care_app/app/app_localization.dart';
import 'package:tech_care_app/core/util/app_constants.dart';
import 'package:tech_care_app/core/util/app_strings.dart';
import 'package:tech_care_app/core/widgets/error_message_widget.dart';
import 'package:tech_care_app/core/widgets/loading_indicator.dart';
import 'package:tech_care_app/core/widgets/page_place_holder.dart';
import 'package:tech_care_app/dependency_injection.dart';
import 'package:tech_care_app/features/finished_receipts/presentation/finished_receipts_bloc/finished_receipts_bloc.dart';
import 'package:tech_care_app/features/finished_receipts/presentation/widgets/receipt_container_card.dart';

class FinishedReceiptsPage extends StatefulWidget {
  const FinishedReceiptsPage({super.key});

  @override
  State<FinishedReceiptsPage> createState() => _FinishedReceiptsPageState();

  static Route<dynamic> route({RouteSettings? settings}) => MaterialPageRoute(
      settings: settings, builder: (context) => FinishedReceiptsPage());
}

class _FinishedReceiptsPageState extends State<FinishedReceiptsPage> {
  late final ScrollController _scrollController;

  late final FinishedReceiptsBloc _bloc;

  @override
  void initState() {
    _bloc = di<FinishedReceiptsBloc>();
    _bloc.add(LoadFinishedReceiptsList());
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.position.maxScrollExtent ==
            _scrollController.offset) {
          _bloc..add(LoadMoreFinishedReceipts());
        }
      });

    super.initState();
  }

  @override
  void dispose() {
    _bloc.close();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('f_receipts'.tr),
        ),
        body: BlocBuilder<FinishedReceiptsBloc, FinishedReceiptsState>(
          bloc: _bloc,
          builder: (context, state) {
            if (state.isLoading) {
              return Center(
                child: LoadingIndicator(),
              );
            }
            if (state is FinishedReceiptsErrorState) {
              return ErrorMessageWidget(
                errorMessage: state.errorMessage,
                onRetry: () {
                  _bloc.add(ReloadFinishedReceipts());
                },
              );
            }
            if (state.finishedReceiptsList.isEmpty) {
              return PagePlaceHolder(
                imagePath: AppStrings.receiveImagePath,
                msg: 'no_receipts'.tr,
                onRetry: () {
                  _bloc.add(ReloadFinishedReceipts());
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
                  _bloc.add(ReloadFinishedReceipts());
                },
                child: ListView.separated(
                  controller: _scrollController,
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(
                      AppConstants.mediumPadding,
                      AppConstants.mediumPadding,
                      AppConstants.mediumPadding,
                      AppConstants.extraLargePadding * 4),
                  itemCount: state.finishedReceiptsList.length +
                      (state.loadMore ? 1 : 0),
                  separatorBuilder: (context, index) =>
                      Gap(AppConstants.mediumPadding),
                  itemBuilder: (context, index) {
                    if (index == state.finishedReceiptsList.length) {
                      return LoadingIndicator();
                    }
                    return ReceiptContainerCard(
                      receiptContainer:
                          state.finishedReceiptsList.elementAt(index),
                    );
                  },
                ),
              ),
            );
          },
        ));
  }
}
