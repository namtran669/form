import 'package:domain/domain.dart';

abstract class TelehealthRepo {
  Future<Result<List<AppUserData>>> fetchContactList();
}