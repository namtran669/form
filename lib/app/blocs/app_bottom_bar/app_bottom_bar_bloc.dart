import 'package:flutter_bloc/flutter_bloc.dart';

enum BottomBarIndex {
  home,
  patient,
  queries,
  chat,
  profile,
}

class AppBottomBarBloc extends BlocBase<BottomBarIndex> {
  AppBottomBarBloc() : super(BottomBarIndex.home);

  BottomBarIndex get currentIndex => state;

  changeTab(BottomBarIndex index) {
    emit(index);
  }

  reset() {
    emit(BottomBarIndex.home);
  }
}
