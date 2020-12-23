class CanceledByUserException implements Exception {
  const CanceledByUserException();

  @override
  String toString() => 'CanceledByUserException';
}
