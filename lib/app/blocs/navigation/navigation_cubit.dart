import 'package:bloc/bloc.dart';
import 'package:domain/domain.dart';

import '../../routes/routes.dart';

part 'navigation_state.dart';

class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit(
    this._userDataRepo,
  ) : super(NavigationInitial());

  final UserDataRepo _userDataRepo;

  checkUserData() async {
    bool isFirstTimeLogin = await _isFirstTimeLogin();
    if (isFirstTimeLogin) {
      emit(NavigationNextRoute(Routes.onboard));
    } else {
      emit(NavigationNextRoute(Routes.login));
    }
  }

  Future<bool> _isFirstTimeLogin() async {
    return await _userDataRepo
        .isFirstTimeLogin()
        .timeout(const Duration(seconds: 10));
  }
}
