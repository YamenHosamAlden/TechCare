import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tech_care_app/core/entities/translatable_value.dart';
import 'package:tech_care_app/core/util/helpers/map_failure_to_msg.dart';
import 'package:tech_care_app/features/auth/domain/usecases/login_usecase.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUsecase loginUsecase;

  LoginBloc({required this.loginUsecase}) : super(LoginInitial()) {
    on<LoginFormSubmittedEvent>(_loginFormSubmittedEvent);
  }

  Future<void> _loginFormSubmittedEvent(
    LoginFormSubmittedEvent event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoadingState());
  

    await loginUsecase(
            Params(userName: event.userNamr, passWord: event.passWord))
        .then(
      (value) => value.fold(
        (failure) {
          // late final TranslatableValue errorMsg;
          // switch (failure) {
          //   case InternetConnectionFailure():
          //     errorMsg = TranslatableValue(translations: {
          //       'ar': 'لا يوجد اتصال بالانترنت',
          //       'en': 'No internet connection',
          //     });
          //     break;
          //   case LoginFailure():
          //     errorMsg = failure.msg;
          //     break;
          //   case ServerFailure():
          //     errorMsg = TranslatableValue(translations: {
          //       'ar': 'حدث خطأ في الخادم',
          //       'en': 'Server Error',
          //     });
          //     break;
          //   case UnknownFailure():
          //     errorMsg = TranslatableValue(translations: {
          //       'ar': 'حدث خطأ غير معروف',
          //       'en': 'Unknown Error',
          //     });
          //     break;
          // }
          emit(LoginErrorMsgState(
            errorMsg: mapFailureToMsg(failure),
          ));
        },
        (Void) {
          emit(LoginInitial());
        },
      ),
    );
  }
}
