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
import 'package:tech_care_app/features/recently_receipts/presentation/bloc/recently_receipts_bloc.dart';
import 'package:tech_care_app/features/recently_receipts/presentation/widgets/recently_receipts_container.dart';

class AddedReceiptsPage extends StatefulWidget {
  const AddedReceiptsPage({super.key});

  @override
  State<AddedReceiptsPage> createState() => _AddedReceiptsPageState();

  static Route<dynamic> route({RouteSettings? settings}) => MaterialPageRoute(
      settings: settings, builder: (context) => AddedReceiptsPage());
}

class _AddedReceiptsPageState extends State<AddedReceiptsPage> {
  late final RecentlyReceiptsBloc _bloc;
  late final ScrollController _scrollController;

  @override
  void initState() {
    _bloc = di<RecentlyReceiptsBloc>();
    _bloc.add(GetRecentlyReceipts());
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.position.maxScrollExtent ==
            _scrollController.offset) {
          _bloc..add(LoadMoreRecentlyReceipts());
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
          title: Text('recently_added_receipts'.tr),
          // actions: [
          //   BlocBuilder<RecentlyReceiptsBloc, RecentlyReceiptsState>(
          //     bloc: _bloc,
          //     builder: (context, state) {
          //       return !state.isLoading
          //           ? IconButton(
          //               onPressed: () {
          //                 _bloc.add(ReloadRecentlyReceipts());
          //               },
          //               icon: Padding(
          //                 padding: const EdgeInsets.all(10.0),
          //                 child: Icon(
          //                   Icons.replay_rounded,
          //                 ),
          //               ),
          //             )
          //           : SizedBox.shrink();
          //     },
          //   ),
          // ],
        ),
        body: BlocBuilder<RecentlyReceiptsBloc, RecentlyReceiptsState>(
          bloc: _bloc,
          builder: (context, state) {
            if (state.isLoading) {
              return Center(
                child: LoadingIndicator(),
              );
            }
            if (state is RecentlyReceiptsErrorState) {
              return ErrorMessageWidget(
                errorMessage: state.errorMessage,
                onRetry: () {
                  _bloc.add(ReloadRecentlyReceipts());
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
                  _bloc.add(ReloadRecentlyReceipts());
                },
                child: state.recentlyReceiptsList.isNotEmpty
                    ? ListView.separated(
                        controller: _scrollController,
                        padding: const EdgeInsets.fromLTRB(
                            AppConstants.mediumPadding,
                            AppConstants.mediumPadding,
                            AppConstants.mediumPadding,
                            AppConstants.extraLargePadding * 4),
                        itemCount: state.recentlyReceiptsList.length +
                            (state.loadMore ? 1 : 0),
                        separatorBuilder: (context, index) =>
                            Gap(AppConstants.mediumPadding),
                        itemBuilder: (context, index) {
                          if (index == state.recentlyReceiptsList.length) {
                            return LoadingIndicator();
                          }
                          return RecentlyReceiptsContainer(
                              receiptContainer:
                                  state.recentlyReceiptsList[index]);
                        },
                      )
                    : PagePlaceHolder(
                        imagePath: AppStrings.receiveImagePath,
                        msg: 'no_receipts'.tr,
                        onRetry: () {
                          _bloc.add(ReloadRecentlyReceipts());
                        },
                      ),
              ),
            );
          },
        ));
  }
}
