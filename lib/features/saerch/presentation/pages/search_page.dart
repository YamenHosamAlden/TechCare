import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:tech_care_app/app/app_localization.dart';
import 'package:tech_care_app/core/util/app_colors.dart';
import 'package:tech_care_app/core/util/app_constants.dart';
import 'package:tech_care_app/core/widgets/custom_pop_up_menu_button.dart';
import 'package:tech_care_app/core/widgets/custom_text_form_field.dart';
import 'package:tech_care_app/core/widgets/loading_indicator.dart';
import 'package:tech_care_app/dependency_injection.dart';
import 'package:tech_care_app/features/saerch/presentation/bloc/saerch_bloc.dart';
import 'package:tech_care_app/features/saerch/presentation/widgets/device_tracking_card.dart';
import 'package:tech_care_app/features/saerch/presentation/widgets/receipt_container_card.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  static Route<dynamic> route({RouteSettings? settings}) => MaterialPageRoute(
      settings: settings, builder: (context) => const SearchPage());

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late final FocusNode _searchFieldNode;
  late final TextEditingController _searchFieldController;
  late final SaerchBloc _bloc;
  late final ScrollController _scrollController;
  double _dividerOpacity = 0;

  @override
  void initState() {
    _bloc = di<SaerchBloc>();
    _scrollController = ScrollController()
      ..addListener(() {
        _setDividerOpacity();
        if (_scrollController.position.maxScrollExtent ==
            _scrollController.offset) {
          if (_bloc.state.searchType == SearchType.device) {
            _bloc
              ..add(LoadMoreSearchByDevice(term: _searchFieldController.text));
          } else {
            _bloc
              ..add(LoadMoreSearchByReceipt(term: _searchFieldController.text));
          }
        }
      });
    _searchFieldController = TextEditingController();
    _searchFieldNode = FocusNode()
      ..addListener(() {
        print(_searchFieldNode.hasFocus);
      });
    Future.delayed(Durations.medium4, () {
      _searchFieldNode.requestFocus();
    });

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchFieldController.dispose();
    _bloc.close();
    _searchFieldNode.dispose();
    super.dispose();
  }

  void _setDividerOpacity() {
    if (_scrollController.offset > 10 && _dividerOpacity == 0) {
      setState(() {
        _dividerOpacity = 1;
      });
    } else if (_scrollController.offset <= 10 && _dividerOpacity == 1) {
      setState(() {
        _dividerOpacity = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('search'.tr),
          actions: [
            BlocBuilder<SaerchBloc, SaerchState>(
              bloc: _bloc,
              builder: (context, state) {
                return CustomPopupMenuButton<SearchType>(
                  icon: Icon(Icons.settings),
                  initialValue: _bloc.state.searchType,
                  popupMenuItems: [
                    PopupMenuItem<SearchType>(
                      enabled: false,
                      height: 20,
                      child: Text('search_level'.tr),
                    ),
                    _buildMenuItem(
                      label: 'receipt'.tr,
                      value: SearchType.receipt,
                      selectedValue: _bloc.state.searchType,
                    ),
                    _buildMenuItem(
                      label: 'device'.tr,
                      value: SearchType.device,
                      selectedValue: _bloc.state.searchType,
                    ),
                  ],
                  onSelected: (SearchType type) {
                    _bloc.add(ChangeSearchType(searchType: type));
                  },
                );
              },
            ),
          ],
        ),
        body: Column(
          children: [
            _buildSearchField(context),
            AnimatedOpacity(
              opacity: _dividerOpacity,
              duration: Durations.medium4,
              child: Divider(
                thickness: .5,
                height: 0,
              ),
            ),
            Expanded(
              child: BlocBuilder<SaerchBloc, SaerchState>(
                bloc: _bloc,
                builder: (context, state) {
                  print(state.searchType);
                  if (state.loadingResults) {
                    return Center(
                      child: LoadingIndicator(),
                    );
                  } else if (state.searchType == SearchType.receipt) {
                    return state.receipts.isEmpty
                        ? _buildEmptyList()
                        : _buildReceiptsList(state);
                  } else if (state.searchType == SearchType.device) {
                    return state.devices.isEmpty
                        ? _buildEmptyList()
                        : _buildDevicesList(state);
                  }
                  return SizedBox();
                },
              ),
            )
          ],
        ));
  }

  Center _buildEmptyList() {
    return Center(
      child: Text("nothing_to_display".tr),
    );
  }

  Widget _buildReceiptsList(SaerchState state) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Durations.medium2,
      curve: Curves.easeOut,
      builder: (context, value, child) => Padding(
        padding: EdgeInsets.only(top: 200 - 200 * value),
        child: Opacity(opacity: value, child: child),
      ),
      child: ListView.separated(
        controller: _scrollController,
        padding: const EdgeInsets.fromLTRB(
            AppConstants.mediumPadding,
            AppConstants.mediumPadding,
            AppConstants.mediumPadding,
            AppConstants.extraLargePadding * 4),
        itemCount: state.receipts.length + (state.loadMoreReceipts ? 1 : 0),
        separatorBuilder: (context, index) => Gap(AppConstants.mediumPadding),
        itemBuilder: (context, index) {
          if (index == state.receipts.length) {
            return LoadingIndicator();
          }
          return ReceiptContainerCard(
            receiptContainer: state.receipts.elementAt(index),
            searchTerm: state.searchTerm,
          );
        },
      ),
    );
  }

  Widget _buildDevicesList(SaerchState state) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Durations.medium2,
      curve: Curves.easeOut,
      builder: (context, value, child) => Padding(
        padding: EdgeInsets.only(top: 200 - 200 * value),
        child: Opacity(opacity: value, child: child),
      ),
      child: ListView.separated(
        controller: _scrollController,
        padding: const EdgeInsets.fromLTRB(
            AppConstants.mediumPadding,
            AppConstants.mediumPadding,
            AppConstants.mediumPadding,
            AppConstants.extraLargePadding * 4),
        itemCount: state.devices.length + (state.loadMoreDevice ? 1 : 0),
        separatorBuilder: (context, index) => Gap(AppConstants.mediumPadding),
        itemBuilder: (context, index) {
          if (index == state.devices.length) {
            return LoadingIndicator();
          }
          return DeviceTrackingCard(
            deviceInfo: state.devices.elementAt(index),
            searchTerm: state.searchTerm,
          );
        },
      ),
    );
  }

  Widget _buildSearchField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.mediumPadding),
      child: Hero(
        tag: 'search_field',
        child: Row(
          children: [
            Expanded(
              child: CustomTextFormField(
                textInputActio: TextInputAction.search,
                onFieldSubmitted: (p0) {
                  _bloc.add(Search(term: _searchFieldController.text));
                },
                focusNode: _searchFieldNode,
                controller: _searchFieldController,
                hintText: "maintenance_search".tr,
              ),
            ),
            Gap(AppConstants.smallPadding),
            SizedBox.square(
              dimension: 33.5,
              child: IconButton.filled(
                onPressed: () {
                  _searchFieldNode.unfocus();
                  _bloc.add(Search(term: _searchFieldController.text));
                },
                icon: Icon(Icons.search_rounded),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStatePropertyAll(AppColors.martiniqueColor),
                  padding: MaterialStatePropertyAll(EdgeInsets.all(0)),
                  shape: MaterialStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppConstants.extraSmallPadding),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  PopupMenuItem<SearchType> _buildMenuItem({
    required String label,
    required SearchType? value,
    required SearchType? selectedValue,
  }) {
    return PopupMenuItem<SearchType>(
      height: 40,
      value: value,
      child: Row(
        children: [
          Text(label),
          Spacer(),
          selectedValue == value
              ? Icon(
                  Icons.done_rounded,
                  color: AppColors.funBlueColor,
                  size: 15,
                )
              : SizedBox(),
        ],
      ),
    );
  }
}

enum SearchType {
  receipt,
  device;
}
