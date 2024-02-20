import 'package:flutter/widgets.dart';
import 'package:newapp/models/user.dart';
import 'package:newapp/resources/local_db/auth_methods.dart';

class UserProvider with ChangeNotifier {
  late User _user;
  AuthMethods _authMethods = AuthMethods();

  User get getUser => _user;

  Future<void> refreshUser() async {
    User? user = await _authMethods.getUserDetails();
    _user = user!;
    notifyListeners();
  }

}
