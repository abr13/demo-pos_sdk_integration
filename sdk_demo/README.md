# Z500C SDK Flutter Demo

This Flutter application demonstrates how to integrate the Z500C POS (Point of Sale) SDK with a Flutter app using platform channels.

## Overview

The Z500C SDK is a comprehensive payment terminal SDK that provides functionality for:
- **EMV**: Credit/debit card processing
- **ICC**: Integrated Circuit Card (chip card) operations  
- **MCR**: Magnetic Card Reader
- **NFC/PICC**: Contactless payment
- **PCI**: Payment Card Industry compliance
- **Print**: Receipt printing
- **System**: Device management

## Architecture

### Flutter Side
- **SdkService**: Dart class that provides a clean API for SDK operations
- **Platform Channels**: MethodChannel for function calls, EventChannel for SDK events
- **UI**: Modern Material 3 design with real-time status updates and logging

### Android Side
- **SdkService**: Application class that manages SDK lifecycle and connections
- **MainActivity**: Handles platform channel communication
- **SDK Integration**: Uses posPayKernel for service binding and module access

## Project Structure

```
sdk_demo/
├── lib/
│   ├── main.dart              # Main Flutter app with UI
│   └── sdk_service.dart       # Flutter SDK service wrapper
├── android/
│   └── app/
│       ├── libs/              # SDK libraries
│       │   ├── PayLib-debug.aar
│       │   └── zxing-core-3.3.0.jar
│       ├── src/main/java/com/example/sdk_demo/
│       │   ├── MainActivity.java    # Platform channel handler
│       │   └── SdkService.java      # SDK service manager
│       └── src/main/java/com/ctk/sdk/
│           ├── ByteUtil.java        # SDK utility classes
│           └── DebugLogUtil.java
└── README.md
```

## Features

### SDK Management
- **Initialize SDK**: Connect to the payment service
- **Device Info**: Get device and SDK status information
- **Disconnect**: Properly disconnect from the SDK

### Testing Functions
- **Card Reader Test**: Test magnetic stripe and chip card reading
- **Printer Test**: Test receipt printing functionality
- **EMV Test**: Test EMV payment processing

### Real-time Monitoring
- **Status Indicator**: Visual status of SDK connection
- **Activity Logs**: Real-time logging of all SDK operations
- **Event Stream**: Listen to SDK connection events

## Setup Instructions

### Prerequisites
- Flutter SDK (3.8.1 or higher)
- Android Studio
- Z500C compatible device or emulator

### Installation

1. **Clone/Copy the project**:
   ```bash
   cd sdk_demo
   ```

2. **Install Flutter dependencies**:
   ```bash
   flutter pub get
   ```

3. **Build and run**:
   ```bash
   flutter run
   ```

### SDK Integration Details

#### Android Configuration
The app is configured with:
- **Min SDK**: 24 (Android 7.0)
- **Target SDK**: 30 (Android 11)
- **Compile SDK**: 34 (Android 14) - Required for Flutter dependencies
- **Permissions**: All necessary POS device permissions
- **Dependencies**: Required Android libraries for SDK integration
- **Language**: Java (not Kotlin) for SDK compatibility

#### Platform Channels
- **Method Channel**: `com.example.sdk_demo/sdk`
  - `initializeSdk()`: Initialize the SDK
  - `getDeviceInfo()`: Get device information
  - `testCardReader()`: Test card reader
  - `testPrinter()`: Test printer
  - `testEMV()`: Test EMV functionality
  - `disconnectSdk()`: Disconnect SDK

- **Event Channel**: `com.example.sdk_demo/sdk_events`
  - `SDK_CONNECTED`: SDK connection established

## Usage

1. **Launch the app** on a Z500C compatible device
2. **Initialize SDK** by tapping the "Initialize SDK" button
3. **Monitor status** in the status card (green = connected, red = error)
4. **Test functionality** using the various test buttons
5. **View logs** in the activity logs section
6. **Get device info** to see SDK and device details

## SDK Modules

### Core Modules
- **SysBaseOpt**: Basic system operations
- **ReadCardOptV2**: Card reading operations
- **PinpadOpt**: PIN pad operations
- **PedOpt**: PIN entry device operations
- **PrinterOpt**: Receipt printing
- **TaxOpt**: Tax operations
- **EMVOptV2**: EMV payment processing
- **SysCardOpt**: System card operations

### Device Support
The SDK supports multiple device variants:
- CS30G, CM30C, CM30TC, CM30T
- CS50, CS50C
- CS20, CS20C
- CS10F

## Error Handling

The app includes comprehensive error handling:
- **Platform Exceptions**: Caught and displayed in logs
- **SDK Errors**: Properly handled with user feedback
- **Connection Issues**: Automatic retry mechanisms
- **Permission Errors**: Clear error messages

## Development Notes

### Adding New SDK Functions
1. Add method to `SdkService.java` (Android)
2. Add method call handler in `MainActivity.java`
3. Add corresponding method in `sdk_service.dart` (Flutter)
4. Update UI to call the new function

### Debugging
- Check Android logs: `flutter logs`
- Monitor SDK events in the app's activity logs
- Use the status indicator to verify SDK connection

## Troubleshooting

### Common Issues
1. **SDK not connecting**: Ensure device has proper permissions
2. **Build errors**: Check that all SDK files are in `android/app/libs/`
3. **Runtime errors**: Verify device compatibility with Z500C SDK
4. **Compile SDK errors**: Ensure compileSdk is set to 34 for Flutter compatibility
5. **Kotlin conflicts**: Use Java implementation for SDK compatibility

### Permissions Required
- `READ_EXTERNAL_STORAGE`
- `WRITE_EXTERNAL_STORAGE`
- `READ_PHONE_STATE`
- `INTERNET`
- `ACCESS_NETWORK_STATE`
- `BLUETOOTH`
- `BLUETOOTH_ADMIN`
- `NFC`
- `WAKE_LOCK`
- `VIBRATE`
- `CAMERA`

## License

This demo app is provided as an example of Z500C SDK integration with Flutter. Please refer to the Z500C SDK documentation for licensing terms.

## Support

For SDK-specific issues, refer to the Z500C SDK documentation:
- Smart Pos EMV-SDK Instruction_v1.0.2.pdf
- Smart Pos PCI-SDK Instruction V1.0.12.pdf
- Smart Pos SDK_instruction_ForV2_V1.0.9.pdf