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

  /// The User not found by application.
  notFoundCustomer,

  /// The Twitter login completed with an error.
  error,
}

///
const METHOD_NAME = 'torico/flutter_torico_id_login';

///
class ToricoIdLogin {
  static const _channel = const MethodChannel(METHOD_NAME);
  static final _eventChannel = EventChannel('$METHOD_NAME/event');
  static final _eventStream = _eventChannel.receiveBroadcastStream();

  /// OAuth Request URL
  final String url;

  /// Callback URLs (https or DeepLink...)
  final String redirectURI;

  final String deviceId;

  ToricoIdLogin({
    @required this.url,
    @required this.redirectURI,
    @required this.deviceId,
  })  : assert(url != null),
        assert(redirectURI != null),
        assert(deviceId != null);

  Future<AuthResult> login() async {
    if (!Platform.isAndroid && !Platform.isIOS) {
      throw UnsupportedError('Not supported by this os.');
    }

    try {
      final _url = Uri.parse(url).replace(
        queryParameters: {
          'redirect_uri': redirectURI,
          'device_id': deviceId,
        },
      );
      debugPrint(_url.toString());
      String resultURI = '';
      if (Platform.isIOS) {
        resultURI = await _channel.invokeMethod('authentication', {
          'url': _url.toString(),
          'redirectURI': redirectURI,
        });
      } else if (Platform.isAndroid) {
        final uri = Uri.parse(redirectURI);
        await _channel.invokeMethod('setScheme', uri.scheme);
        final completer = Completer<String>();
        final subscribe = _eventStream.listen((data) async {
          if (data['type'] == 'url') {
            completer.complete(data['url']?.toString());
          }
        });
        final browser = ChromeCustomTab(
          onClose: () {
            if (!completer.isCompleted) {
              completer.complete(null);
            }
          },
        );
        await browser.open(url: _url.toString());
        resultURI = await completer.future;
        subscribe.cancel();
      }
      if (resultURI == null) {
        throw CanceledByUserException();
      }
      // login_token, is_tester を受け取り返す
      final queries = Uri.splitQueryString(Uri.parse(resultURI).query);

      // next があれば未登録
      if (queries['next'] != null) {
        throw NotFoundCustomerException(
          url: queries['next'],
          message: queries['error'],
        );
      }

      if (queries['error'] != null) {
        throw Exception(queries['error']);
      }

      return AuthResult(
        queries['login_token'],
        int.parse(queries['is_tester']),
        ToricoIDLoginStatus.loggedIn,
      );
    } on NotFoundCustomerException catch (e) {
      return AuthResult(
        null,
        null,
        ToricoIDLoginStatus.notFoundCustomer,
        message: e.message,
        url: e.url,
      );
    } on CanceledByUserException catch (e) {
      return AuthResult(
        null,
        null,
        ToricoIDLoginStatus.cancelledByUser,
        message: 'ログインをキャンセルしました',
      );
    } on Exception catch (e) {
      return AuthResult(
        null,
        null,
        ToricoIDLoginStatus.error,
        message: e.toString(),
      );
    }
  }
}
