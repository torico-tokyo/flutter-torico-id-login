import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_torico_id_login/src/exceptions.dart';
import 'package:flutter_torico_id_login/src/models/auth_result.dart';

import 'chrome_custom_tab.dart';

/// The status after a TORICO-ID login flow has completed.
enum ToricoIDLoginStatus {
  /// The login was successful and the user is now logged in.
  loggedIn,

  /// The user cancelled the login flow.
  cancelledByUser,

  /// The Twitter login completed with an error.
  error,
}

///
const METHOD_NAME = 'torico/flutter_torico_id_login';

///
class ToricoIdLogin {
  static const MethodChannel _channel = const MethodChannel(METHOD_NAME);

  /// OAuth Request URL
  final String url;

  /// Callback URLs (https or DeepLink...)
  final String redirectURI;

  /// Client ID
  final String clientId;

  ToricoIdLogin({
    @required this.url,
    @required this.redirectURI,
    @required this.clientId,
  })  : assert(url != null),
        assert(redirectURI != null),
        assert(clientId != null);

  Future<void> login() async {
    if (!Platform.isAndroid && !Platform.isIOS) {
      throw UnsupportedError('Not supported by this os.');
    }

    try {
      final _url = Uri.parse(url).replace(
        queryParameters: {
          'client_id': clientId,
          'redirect_uri': redirectURI,
          'auto_provider': '',
          'refer': '',
        },
      );
      print(_url.toString());
      String resultURI = '';
      if (Platform.isIOS) {
        resultURI = await _channel.invokeMethod('authentication', {
          'url': _url.toString(),
          'redirectURI': redirectURI,
        });
      } else if (Platform.isAndroid) {
        final completer = Completer<String>();
        final browser = ChromeCustomTab(
          onClose: () {
            if (!completer.isCompleted) {
              completer.complete(null);
            }
          },
        );
        await browser.open(url: 'https://google.com');
      }
      if (resultURI == null) {
        throw CanceledByUserException();
      }

      debugPrint(resultURI);

      // login_token, is_tester を受け取り返す
      final queries = Uri.splitQueryString(Uri.parse(resultURI).query);
      if (queries['error'] != null) {
        throw Exception(queries['error']);
      }
      return AuthResult(
        queries['login_token'],
        queries['is_tester'] ?? 0,
        ToricoIDLoginStatus.loggedIn,
        '',
      );
    } on CanceledByUserException catch (e) {
      return AuthResult(
        null,
        null,
        ToricoIDLoginStatus.cancelledByUser,
        e.toString(),
      );
    } on Exception catch (e) {
      return AuthResult(
        null,
        null,
        ToricoIDLoginStatus.error,
        e.toString(),
      );
    }
  }
}
