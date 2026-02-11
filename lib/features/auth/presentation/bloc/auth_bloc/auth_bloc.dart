import 'dart:async';
import 'dart:ffi';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tech_care_app/core/entities/translatable_value.dart';
import 'package:tech_care_app/core/usecases/usecase.dart';
import 'package:tech_care_app/core/util/helpers/map_failure_to_msg.dart';
import 'package:tech_care_app/features/auth/domain/entities/user.dart';
import 'package:tech_care_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:tech_care_app/features/auth/domain/usecases/auth_status_stream_usecase.dart';
import 'package:tech_care_app/features/auth/domain/usecases/check_saved_token_usecase.dart';
import 'package:tech_care_app/features/auth/domain/usecases/get_user_usercase.dart';
import 'package:tech_care_app/features/auth/domain/usecases/logout_usecase.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthStatusStreamUsecase authStatusStreamUsecase;
  final CheckSaveTokenUseCase checkSaveTokenUseCase;
  final LogoutUsecase logoutUsecase;
  final GetUserUsecase getUserUsecase;
  late StreamSubscription<AuthenticationStatus> _autheStatusSubscription;

  AuthBloc({
    required this.logoutUsecase,
    required this.checkSaveTokenUseCase,
    required this.authStatusStreamUsecase,
    required this.getUserUsecase,
  }) : super(AuthInitial()) {
    on<CheckSavedTokenAuthEvent>(_onCheckSavedTokenAuthEvent);
    on<AuthenticationStatusChanged>(_onAuthenticationStatusChanged);
    // on<LogoutEvent>(_onLogoutEvent);

    authStatusStreamUsecase(Void)
        .then((value) => value.fold((l) => null, (authStatusStream) {
              _autheStatusSubscription = authStatusStream
                  .listen((status) => add(AuthenticationStatusChanged(status)));
            }));
  }

  @override
  Future<void> close() {
    _autheStatusSubscription.cancel();
    return super.close();
  }

  Future<void> _onAuthenticationStatusChanged(
    AuthenticationStatusChanged event,
    Emitter<AuthState> emit,
  ) async {
    switch (event.status) {
      case AuthenticationStatus.unauthenticated:
        return emit(UnauthenticatedState());
      case AuthenticationStatus.authenticated:
        emit(AuthLoadingState());
        await getUserUsecase(Void).then((value) {
          value.fold((failure) {
            emit(AuthErrorMsgState(
                errorMsg: mapFailureToMsg(failure)));
          }, (user) {
            emit(AuthenticatedState(user: user));
          });
        });
      case AuthenticationStatus.unknown:
        return emit(AuthLoadingState());
    }
  }

  Future<void> _onCheckSavedTokenAuthEvent(
    CheckSavedTokenAuthEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());
    await checkSaveTokenUseCase(NoParams()).then((value) {
      value.fold(
        (failure) {
          emit(AuthErrorMsgState(errorMsg: mapFailureToMsg(failure)));
        },
        (nan) {},
      );
    });
  }

  // Future<void> _onLogoutEvent(
  //   LogoutEvent event,
  //   Emitter<AuthState> emit,
  // ) async {
  //   await logoutUsecase(NoParams()).then((value) {
  //     value.fold((failure) {
  //       print(failure);
  //     }, (done) {
  //       print("emit unauthenticated state");
  //       emit(UnauthenticatedState());
  //     });
  //   });
  // }
}
