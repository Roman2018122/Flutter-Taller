class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final Map<String, dynamic>? validationErrors;

  const ApiException({
    required this.message,
    this.statusCode,
    this.validationErrors,
  });

  @override
  String toString() => message;
}
