import '../torico_id_login.dart';

class AuthResult {
  final String _loginToken;
  final int _isTester;
  final ToricoIDLoginStatus _status;
  final String _message;

  String get loginToken => _loginToken;
  int get isTester => _isTester;
  ToricoIDLoginStatus get status => _status;
  String get message => _message;

  AuthResult(
    String loginToken,
    int isTester,
    ToricoIDLoginStatus status,
    String message,
  )   : _loginToken = loginToken,
        _isTester = isTester,
        _status = status,
        _message = message;
}
