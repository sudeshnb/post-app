import 'package:flutter/widgets.dart';
import 'package:poetic_app/features/models/user.dart';
import 'package:poetic_app/features/resources/auth_methods.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  final AuthMethods _authMethods = AuthMethods();

  User get getUser => _user != null ? _user! : empty;

  Future<void> refreshUser() async {
    User user = await _authMethods.getUserDetails();
    _user = user;
    notifyListeners();
  }
}

User empty = const User(
  username: 'username',
  uid: 'uid',
  photoUrl: 'photoUrl',
  email: 'email',
  bio: 'bio',
  followers: [],
  following: [],
  languages: [],
  accountType: 'accountType',
  status: 'online',
  country: 'country',
  // gender: 'gender',
  interst: [],
  phoneNo: 'phoneNo',
  token: '',
  socialLinks: [
    {'facebook': ''},
    {'twitter': ''},
    {'instagram': ''},
    {'isShow': true}
  ],
  people: [],
);
