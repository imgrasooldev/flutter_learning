import 'package:bloc/bloc.dart';
import 'package:flutter_learning/features/auth/repository/auth_repository.dart';

import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<LoginEvent>((e, emit) async {
      emit(AuthLoading());
      try {
        emit(AuthSuccess(await authRepository.login(e.email, e.password)));
      } catch (ex) {
        emit(AuthFailure(ex.toString()));
      }
    });

    on<LogoutEvent>((e, emit) async {
      await authRepository.logout();
      emit(AuthInitial());
    });
  }
}
