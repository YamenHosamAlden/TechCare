part of 'saerch_bloc.dart';

class SaerchState extends Equatable {
  final SearchType searchType;
  final int page;
  final List<ReceiptContainer> receipts;
  final List<DeviceInfo> devices;
  final bool loadingResults;
  final bool loadMoreDevice;
  final bool loadMoreReceipts;
  final String? searchTerm;

  const SaerchState({
    required this.searchType,
    required this.receipts,
    required this.devices,
    this.searchTerm,
    this.loadingResults = false,
    this.loadMoreDevice = false,
    this.loadMoreReceipts = false,
    this.page = 1,
  });

  SaerchState.initial()
      : this(
            searchType: SearchType.receipt,
            receipts: [],
            devices: [],
            loadMoreDevice: false,
            loadMoreReceipts: false);

  SaerchState copyWith({
    SearchType? searchType,
    List<ReceiptContainer>? receipts,
    List<DeviceInfo>? devices,
    String? searchTerm,
    bool? loadingResults,
    bool? loadMoreDevice,
    bool? loadMoreReceipts,
    int? page,
  }) {
    return SaerchState(
      searchType: searchType ?? this.searchType,
      receipts: receipts ?? this.receipts,
      devices: devices ?? this.devices,
      loadingResults: loadingResults ?? this.loadingResults,
      searchTerm: searchTerm ?? this.searchTerm,
      page: page ?? this.page,
      loadMoreDevice: loadMoreDevice ?? this.loadMoreDevice,
      loadMoreReceipts: loadMoreReceipts ?? this.loadMoreReceipts,
    );
  }

  @override
  List<Object?> get props => [
        searchType,
        receipts,
        devices,
        loadingResults,
        searchTerm,
        page,
        loadMoreDevice,
        loadMoreReceipts
      ];
}
