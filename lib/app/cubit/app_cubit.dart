import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit({
    required AuthenticationRepository authenticationRepository,
  })  : _authenticationRepository = authenticationRepository,
        super(const AppState(isAuthenticated: false)) {
    _userSubscription = _authenticationRepository.user.listen(
      (user) {
        user.isNotEmpty
            ? emit(AppState(isAuthenticated: true, user: user))
            : emit(const AppState(isAuthenticated: false, user: User.empty));
      },
    );
  }

  final AuthenticationRepository _authenticationRepository;
  late final StreamSubscription<User> _userSubscription;

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
