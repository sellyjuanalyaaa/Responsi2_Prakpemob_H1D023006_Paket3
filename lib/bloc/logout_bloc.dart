import 'package:responsi2mobilepaket3h1d023006/helpers/user_info.dart';

class LogoutBloc {
  static Future<void> logout() async {
    await UserInfo().logout();
  }
}
