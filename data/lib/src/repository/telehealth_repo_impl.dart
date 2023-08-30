import 'package:data/src/data_source/remote/list_users_api.dart';
import 'package:data/src/models/app_user_data_model.dart';
import 'package:data/src/repository/base/base_repository.dart';
import 'package:domain/domain.dart';

class TelehealthRepoImpl extends BaseRepository implements TelehealthRepo {
  final AppUserData _appUserData = AppUserDataModel();
  final ListUsersApi _listUsersApi;

  TelehealthRepoImpl(this._listUsersApi);

  @override
  Future<Result<List<AppUserData>>> fetchContactList() async {
    return await safeApiCall<List<AppUserData>>(
      _listUsersApi.get(_appUserData.accessToken!),
      mapper: (data) {
        List<AppUserData> contacts = [];
        List listJson = data as List;
        listJson.forEach((json) {
          AppUserData contact = AppUserData();
          contact.email = json['email'];
          contact.roleId = json['roleId'];
          contact.firstName = json['firstName'];
          contact.lastName = json['lastName'];
          contacts.add(contact);
        });
        return contacts;
      },
    );
  }
}