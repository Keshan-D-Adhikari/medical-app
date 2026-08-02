import 'package:flutter/foundation.dart';

/// Runtime configuration, resolved once at startup.
class AppConfig {
  const AppConfig._();

  /// Base URL of the Express backend.
  ///
  /// Override at build/run time:
  ///   flutter run --dart-define=API_BASE_URL=http://192.168.1.5:8080
  ///
  /// The default is only meant for local development. `localhost` resolves to
  /// the device itself, so an Android emulator has to reach the host through
  /// the 10.0.2.2 alias instead. A physical device needs the machine's LAN IP,
  /// which cannot be guessed — pass it with --dart-define.
  static const String _override = String.fromEnvironment('API_BASE_URL');

  static String get apiBaseUrl {
    if (_override.isNotEmpty) return _override;
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:8080';
    }
    return 'http://localhost:8080';
  }

  static const Duration requestTimeout = Duration(seconds: 15);
}
