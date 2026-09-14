import 'dart:async' as dart_async;
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app_exception.dart';

/// Central error handler: logs every caught error once with full context, and
/// provides user-facing messages + snackbar helpers.
///
/// Usage in controllers:
/// ```dart
/// try {
///   ...
/// } catch (e, s) {
///   ErrorHandler.handle(e, s, context: 'ProductsController.fetchProducts');
/// }
/// ```
class ErrorHandler {
  ErrorHandler._();

  /// Set to `true` to print full logs (dev builds); keep `false` in release.
  static bool verboseLogging = true;

  /// Optional hook for crash reporting (Sentry/Firebase Crashlytics...).
  /// Assign it in main() if/when a crash reporter is added.
  static void Function(Object error, StackTrace? stackTrace)? reportCallback;

  /// Handle an error: log it once and return the user-facing message.
  static String handle(
    Object error,
    StackTrace? stackTrace, {
    String? context,
    Map<String, dynamic>? details,
  }) {
    final appException = toAppException(
      error,
      context: context,
      stackTrace: stackTrace,
    );

    _log(appException, context, details);

    // Forward to crash reporting if a callback is registered.
    reportCallback?.call(appException, appException.stackTrace ?? stackTrace);

    return appException.userMessage;
  }

  /// Handle an error and immediately show a GetX snackbar with the message.
  static String handleWithSnackbar(
    Object error,
    StackTrace? stackTrace, {
    String? context,
    Map<String, dynamic>? details,
    String title = 'ຜິດພາດ',
  }) {
    final message = handle(
      error,
      stackTrace,
      context: context,
      details: details,
    );
    showSnackbar(message, title: title);
    return message;
  }

  /// Convert any error to an [AppException] (idempotent — already-typed errors
  /// are returned as-is).
  static AppException toAppException(
    Object error, {
    String? context,
    StackTrace? stackTrace,
  }) {
    if (error is AppException) return error;

    if (error is dart_async.TimeoutException) {
      return TimeoutException.withDetails(
        'ການເຊື່ອມຕໍ່ໝົດອາຍຸ',
        originalError: error,
        endpoint: context,
        stackTrace: stackTrace,
      );
    }
    if (error is FormatException) {
      return ParseException.withDetails(
        'ຂໍ້ມູນຈາກເຊີບເວີບໍ່ຖືກຕ້ອງຮູບແບບ',
        originalError: error,
        endpoint: context,
        stackTrace: stackTrace,
      );
    }
    if (error is StateError || error is ArgumentError) {
      return UnknownException.withDetails(
        'ເກີດຂໍ້ຜິດພາດພາຍໃນຂອງແອັບ',
        originalError: error,
        endpoint: context,
        stackTrace: stackTrace,
      );
    }

    return UnknownException.withDetails(
      'ເກີດຂໍ້ຜິດພາດທີ່ບໍ່ຮູ້ຈັກ',
      originalError: error,
      endpoint: context,
      stackTrace: stackTrace,
    );
  }

  /// Show a styled GetX snackbar for an error message.
  static void showSnackbar(String message, {String title = 'ຜິດພາດ'}) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Get.theme.colorScheme.errorContainer,
      colorText: Get.theme.colorScheme.onErrorContainer,
      borderRadius: 8,
      margin: const EdgeInsets.all(12),
      duration: const Duration(seconds: 3),
    );
  }

  static void _log(
    AppException e,
    String? context,
    Map<String, dynamic>? details,
  ) {
    final tag = context ?? 'AppError';
    final body = verboseLogging
        ? '${e.toLogString()}${details != null ? '\n  details   : $details' : ''}'
        : e.toString();
    developer.log(body, name: tag, error: e);
  }
}
