import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app/routes/app_pages.dart';
import 'app/core/theme/app_theme.dart';
import 'app/core/constants/api_constants.dart';
import 'app/core/errors/app_exception.dart';
import 'app/core/errors/error_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Catch all framework/widget errors (layout overflows, build errors...).
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    ErrorHandler.handle(
      details.exception,
      details.stack,
      context: 'FlutterError',
      details: {
        'library': details.library,
        if (details.context != null) 'context': details.context.toString(),
      },
    );
  };

  // Catch errors not caught by any try/catch (async zones).
  PlatformDispatcher.instance.onError = (error, stack) {
    ErrorHandler.handle(error, stack, context: 'UnhandledZoneError');
    return true;
  };

  // ກຳນົດຄ່າເລີ່ມຕົ້ນຂອງ API
  await ApiConstants.loadConstants;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Admin Dashboard',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      // darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      defaultTransition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
      builder: (context, child) {
        // Keep the app responsive even when a widget error occurs.
        ErrorWidget.builder = (FlutterErrorDetails details) =>
            _buildErrorWidget(details);
        return child ?? const SizedBox.shrink();
      },
    );
  }

  /// Friendly in-place error widget instead of the grey/red error screen,
  /// showing a short hint (full details go to the log via ErrorHandler).
  Widget _buildErrorWidget(FlutterErrorDetails details) {
    final message =
        details.exception is AppException
            ? (details.exception as AppException).userMessage
            : 'ເກີດຂໍ້ຜິດພາດໃນການສະແດງຜົນ';
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
