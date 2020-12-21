import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

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

  ///
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
    try {
      final _url = Uri.parse(url).replace(
        queryParameters: {
          'client_id': '',
          'redirect_uri': '',
          'auto_provider': '',
          'refer': '',
        },
      );
      if (Platform.isIOS) {
        _channel.invokeMethod('authentication', {
          'url': url,
          'redirectURI': redirectURI,
        });
      } else if (Platform.isAndroid) {
        final completer = Completer<String>();
        final browser = ChromeCustomTab(onClose: () {
          if (!completer.isCompleted) {
            completer.complete(null);
          }
        });
        await browser.open(url: 'https://google.com');
      } else {
        throw UnsupportedError('Not supported by this os.');
      }
    } on Exception catch (e) {
      print(e);
    }
  }
}
