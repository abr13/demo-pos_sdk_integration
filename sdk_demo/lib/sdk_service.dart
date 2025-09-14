import 'package:flutter/services.dart';

class SdkService {
  static const MethodChannel _channel = MethodChannel(
    'com.example.sdk_demo/sdk',
  );
  static const EventChannel _eventChannel = EventChannel(
    'com.example.sdk_demo/sdk_events',
  );

  static Stream<String>? _eventStream;
  static bool _isInitialized = false;

  /// Initialize the SDK
  static Future<String> initializeSdk() async {
    try {
      final String result = await _channel.invokeMethod('initializeSdk');
      _isInitialized = true;
      return result;
    } on PlatformException catch (e) {
      return 'Failed to initialize SDK: ${e.message}';
    }
  }

  /// Get device information
  static Future<String> getDeviceInfo() async {
    try {
      final String result = await _channel.invokeMethod('getDeviceInfo');
      return result;
    } on PlatformException catch (e) {
      return 'Failed to get device info: ${e.message}';
    }
  }

  /// Test card reader functionality
  static Future<String> testCardReader() async {
    try {
      final String result = await _channel.invokeMethod('testCardReader');
      return result;
    } on PlatformException catch (e) {
      return 'Failed to test card reader: ${e.message}';
    }
  }

  /// Test printer functionality
  static Future<String> testPrinter() async {
    try {
      final String result = await _channel.invokeMethod('testPrinter');
      return result;
    } on PlatformException catch (e) {
      return 'Failed to test printer: ${e.message}';
    }
  }

  /// Test EMV functionality
  static Future<String> testEMV() async {
    try {
      final String result = await _channel.invokeMethod('testEMV');
      return result;
    } on PlatformException catch (e) {
      return 'Failed to test EMV: ${e.message}';
    }
  }

  /// Disconnect the SDK
  static Future<String> disconnectSdk() async {
    try {
      final String result = await _channel.invokeMethod('disconnectSdk');
      _isInitialized = false;
      return result;
    } on PlatformException catch (e) {
      return 'Failed to disconnect SDK: ${e.message}';
    }
  }

  /// Get SDK events stream
  static Stream<String> get eventStream {
    _eventStream ??= _eventChannel.receiveBroadcastStream().cast<String>();
    return _eventStream!;
  }

  /// Check if SDK is initialized
  static bool get isInitialized => _isInitialized;
}
