part of 'create_receipt_bloc.dart';

class CreateReceiptState extends Equatable {
  final String? customerName;
  final String? customerPhone;
  final TranslatableValue? priority;
  final String? shippingNumber;
  final List<Collection> collections;
  final List<MaintenanceGroup> maintenanceGroups;
  final bool isPageLoading;
  final bool isLoading;
  final double? uploadProgress;
  final TranslatableValue? errorMsg;
  final TranslatableValue? errorStateMsg;
  final String countryCode;

  CreateReceiptState({
    this.customerName,
    this.customerPhone,
    this.priority,
    this.shippingNumber,
    this.isLoading = false,
    this.isPageLoading = false,
    this.uploadProgress,
    List<Collection>? collections,
    List<MaintenanceGroup>? maintenanceGroups,
    this.errorMsg,
    this.errorStateMsg,
    this.countryCode='+963',
  })  : this.collections = collections ?? [],
        this.maintenanceGroups = maintenanceGroups ?? [];

  factory CreateReceiptState.initial() =>
      CreateReceiptState(isPageLoading: true, collections: [Collection()]);

  CreateReceiptState copyWith(
          {String? customerName,
          String? customerPhone,
          TranslatableValue? priority,
          String? shippingNumber,
          List<Collection>? collections,
          List<MaintenanceGroup>? maintenanceGroups,
          bool? isPageLoading,
          bool? isLoading,
          double? uploadProgress,
          bool removeProgress = false,
          TranslatableValue? errorMsg,
          TranslatableValue? errorStateMsg,
          String? countryCode}) =>
      CreateReceiptState(
        customerName: customerName ?? this.customerName,
        customerPhone: customerPhone ?? this.customerPhone,
        priority: priority ?? this.priority,
        shippingNumber: shippingNumber ?? this.shippingNumber,
        collections: collections ?? List.of(this.collections),
        maintenanceGroups: maintenanceGroups ?? this.maintenanceGroups,
        isPageLoading: isPageLoading ?? this.isPageLoading,
        isLoading: isLoading ?? this.isLoading,
        uploadProgress:
            removeProgress ? null : uploadProgress ?? this.uploadProgress,
        countryCode: countryCode ?? this.countryCode,
        errorMsg: errorMsg,
        errorStateMsg: errorStateMsg,
      );

  @override
  List<Object?> get props => [
        customerName,
        customerPhone,
        priority,
        shippingNumber,
        collections,
        collections.length,
        maintenanceGroups,
        isPageLoading,
        isLoading,
        uploadProgress,
        errorMsg,
        errorStateMsg,
        countryCode,
      ];
}

class ReceiptCreated extends CreateReceiptState {
  final String receiptUrl;

  ReceiptCreated({required this.receiptUrl});
}
