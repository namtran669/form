import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'language_state.dart';

class LanguageCubit extends Cubit<Locale> {
  late Locale locale;
  LanguageCubit() : super(const Locale('en'));


  void getCurrentLocale() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // String langCode = prefs.getString('lang') ?? '';
    locale = const Locale('langCode');
    emit(locale);
  }

  void changeLang(String data) async {
    locale = Locale(data);
    emit(locale);
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // await prefs.setString('lang', data);
  }
}
