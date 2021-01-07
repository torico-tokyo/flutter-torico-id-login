class CanceledByUserException implements Exception {
  const CanceledByUserException();

  @override
  String toString() => 'CanceledByUserException';
}

class NotFoundCustomerException implements Exception {
  final String _url;
  final String _message;

  String get url => _url;
  String get message => _message;

  const NotFoundCustomerException({
    String url,
    String message,
  })  : _url = url,
        _message = message;

  @override
  String toString() => 'NotFoundCustomerException';
}
