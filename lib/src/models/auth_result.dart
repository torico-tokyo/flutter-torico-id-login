import '../torico_id_login.dart';

class AuthResult {
  final String _loginToken;
  final int _isTester;
  final ToricoIDLoginStatus _status;
  final String _message;
  final String _url;

  /// ログイントークン
  String get loginToken => _loginToken;

  /// テスターフラグ
  int get isTester => _isTester;

  /// ステータス
  ToricoIDLoginStatus get status => _status;

  /// エラーメッセージ
  String get message => _message;

  /// 未登録時の会員登録サイトURL
  String get url => _url;

  AuthResult(
    String loginToken,
    int isTester,
    ToricoIDLoginStatus status, {
    String message = '',
    String url = '',
  })  : _loginToken = loginToken,
        _isTester = isTester,
        _status = status,
        _message = message,
        _url = url;
}
