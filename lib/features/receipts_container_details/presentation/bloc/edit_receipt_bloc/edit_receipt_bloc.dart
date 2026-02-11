import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tech_care_app/core/entities/translatable_value.dart';
import 'package:tech_care_app/core/util/app_colors.dart';
import 'package:tech_care_app/core/util/helpers/map_failure_to_msg.dart';
import 'package:tech_care_app/features/message_viewer/domain/entities/snackbar_message_config.dart';
import 'package:tech_care_app/features/message_viewer/domain/usecases/view_snackbar_msg_usecase.dart';
import 'package:tech_care_app/features/receipts_container_details/domain/entities/container_details.dart';
import 'package:tech_care_app/features/receipts_container_details/domain/usecases/edit_receipt_details_usecase.dart';

part 'edit_receipt_event.dart';
part 'edit_receipt_state.dart';

class EditReceiptBloc extends Bloc<EditReceiptEvent, EditReceiptState> {
  EditReceiptDetailsUsecase editReceiptDetailsUsecase;
  ViewSnackBarMsgUsecase viewSnackBarMsgUsecase;

  EditReceiptBloc(
      {required this.editReceiptDetailsUsecase,
      required this.viewSnackBarMsgUsecase,
      ContainerDetails? containerDetails})
      : super(EditReceiptState.init(containerDetails: containerDetails)) {
    on<EditReceiptDetailsEvent>(_onEditReceiptDetails);
    on<CustomerNameChanged>(_onCustomerNameChanged);
    on<CustomerPhoneChanged>(_onCustomerPhoneChanged);
    on<PriorityChanged>(_onPriorityChanged);
    on<ShippingNumberChanged>(_onShippingNumberChanged);
    on<UploadProgress>(_onUploadProgress);
    on<CountryCodeChanged>(_onCountryCodeChanged);
  }
  FutureOr<void> _onCustomerNameChanged(
      CustomerNameChanged event, Emitter<EditReceiptState> emit) async {
    emit(state.copyWith(
        containerDetails: state.containerDetails!
            .copyWith(customerName: event.customerName)));
  }

  FutureOr<void> _onCustomerPhoneChanged(
      CustomerPhoneChanged event, Emitter<EditReceiptState> emit) {
    emit(state.copyWith(
        containerDetails: state.containerDetails!
            .copyWith(customerPhone: event.customerPhone)));
  }

  FutureOr<void> _onPriorityChanged(
      PriorityChanged event, Emitter<EditReceiptState> emit) {
    emit(state.copyWith(
        containerDetails: state.containerDetails
            ?.copyWith(priority: event.priority, priorityShippingNumber: '')));
  }

  FutureOr<void> _onShippingNumberChanged(
      ShippingNumberChanged event, Emitter<EditReceiptState> emit) {
    emit(state.copyWith(
      containerDetails: state.containerDetails
          ?.copyWith(priorityShippingNumber: event.shippingNumber),
    ));
  }

  FutureOr<void> _onEditReceiptDetails(
      EditReceiptDetailsEvent event, Emitter<EditReceiptState> emit) async {
    print("what is the state.containerDetails :${state.containerDetails}");
    emit(state.copyWith(isLoading: true));
    await editReceiptDetailsUsecase(ContainerDetailsParams(
      containerDetails: event.containerDetails,
      onSendProgress: (progress, total) {
        this.add(UploadProgress(progress: progress / total));
      },
    )).then((value) {
      value.fold((failure) {
        viewSnackBarMsgUsecase(
            SnackBarMessageConfig(msg: mapFailureToMsg(failure)));
        emit(state.copyWith(isLoading: false));
      }, (v) {
        viewSnackBarMsgUsecase(SnackBarMessageConfig(
            color: AppColors.eucalyptusColor,
            msg: TranslatableValue.fromTranslations(
                translations: Translation(
                    en: "The receipt has been modified",
                    ar: "تم تعديل الوصل"))));
        emit(state.copyWith(
          isLoading: false,
          editCompleted: true,
        ));
      });
    });
  }

  FutureOr<void> _onUploadProgress(
      UploadProgress event, Emitter<EditReceiptState> emit) {
    emit(state.copyWith(uploadProgress: event.progress));
  }

  FutureOr<void> _onCountryCodeChanged(
      CountryCodeChanged event, Emitter<EditReceiptState> emit) {
    emit(state.copyWith(countryCode: event.countryCode));
  }

  
}
