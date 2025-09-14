import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'sdk_service.dart';

void main() {
  runApp(const SdkDemoApp());
}

class SdkDemoApp extends StatelessWidget {
  const SdkDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Z500C SDK Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2E7D32), // Green theme for POS
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(centerTitle: true, elevation: 2),
        cardTheme: CardThemeData(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
      home: const SdkDemoHomePage(),
    );
  }
}

class SdkDemoHomePage extends StatefulWidget {
  const SdkDemoHomePage({super.key});

  @override
  State<SdkDemoHomePage> createState() => _SdkDemoHomePageState();
}

class _SdkDemoHomePageState extends State<SdkDemoHomePage> {
  String _status = 'Not initialized';
  String _deviceInfo = 'No device info available';
  bool _isLoading = false;
  List<String> _logs = [];

  @override
  void initState() {
    super.initState();
    _listenToSdkEvents();
  }

  void _listenToSdkEvents() {
    SdkService.eventStream.listen((event) {
      setState(() {
        _logs.add('Event: $event');
        if (event == 'SDK_CONNECTED') {
          _status = 'SDK Connected';
        }
      });
    });
  }

  void _addLog(String message) {
    setState(() {
      _logs.add('${DateTime.now().toString().substring(11, 19)}: $message');
    });
  }

  Future<void> _initializeSdk() async {
    setState(() {
      _isLoading = true;
      _status = 'Initializing...';
    });
    _addLog('Initializing SDK...');

    try {
      final result = await SdkService.initializeSdk();
      setState(() {
        _status = 'Initialized';
        _isLoading = false;
      });
      _addLog('SDK Initialization: $result');
    } catch (e) {
      setState(() {
        _status = 'Initialization Failed';
        _isLoading = false;
      });
      _addLog('SDK Initialization Error: $e');
    }
  }

  Future<void> _getDeviceInfo() async {
    _addLog('Getting device info...');
    try {
      final info = await SdkService.getDeviceInfo();
      setState(() {
        _deviceInfo = info;
      });
      _addLog('Device info retrieved successfully');
    } catch (e) {
      _addLog('Error getting device info: $e');
    }
  }

  Future<void> _testCardReader() async {
    _addLog('Testing card reader...');
    try {
      final result = await SdkService.testCardReader();
      _addLog('Card Reader Test: $result');
    } catch (e) {
      _addLog('Card Reader Test Error: $e');
    }
  }

  Future<void> _testPrinter() async {
    _addLog('Testing printer...');
    try {
      final result = await SdkService.testPrinter();
      _addLog('Printer Test: $result');
    } catch (e) {
      _addLog('Printer Test Error: $e');
    }
  }

  Future<void> _testEMV() async {
    _addLog('Testing EMV...');
    try {
      final result = await SdkService.testEMV();
      _addLog('EMV Test: $result');
    } catch (e) {
      _addLog('EMV Test Error: $e');
    }
  }

  Future<void> _disconnectSdk() async {
    _addLog('Disconnecting SDK...');
    try {
      final result = await SdkService.disconnectSdk();
      setState(() {
        _status = 'Disconnected';
      });
      _addLog('SDK Disconnection: $result');
    } catch (e) {
      _addLog('SDK Disconnection Error: $e');
    }
  }

  void _clearLogs() {
    setState(() {
      _logs.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Z500C SDK Demo'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.clear_all),
            onPressed: _clearLogs,
            tooltip: 'Clear Logs',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Status Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'SDK Status',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                _status.contains('Connected') ||
                                    _status.contains('Initialized')
                                ? Colors.green
                                : _status.contains('Failed') ||
                                      _status.contains('Disconnected')
                                ? Colors.red
                                : Colors.orange,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(_status),
                        if (_isLoading) ...[
                          const SizedBox(width: 8),
                          const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Device Info Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.device_hub,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Device Information',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _deviceInfo,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: _getDeviceInfo,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Get Device Info'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // SDK Controls
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.settings,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'SDK Controls',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ElevatedButton.icon(
                          onPressed: _isLoading ? null : _initializeSdk,
                          icon: const Icon(Icons.power_settings_new),
                          label: const Text('Initialize SDK'),
                        ),
                        ElevatedButton.icon(
                          onPressed: _testCardReader,
                          icon: const Icon(Icons.credit_card),
                          label: const Text('Test Card Reader'),
                        ),
                        ElevatedButton.icon(
                          onPressed: _testPrinter,
                          icon: const Icon(Icons.print),
                          label: const Text('Test Printer'),
                        ),
                        ElevatedButton.icon(
                          onPressed: _testEMV,
                          icon: const Icon(Icons.payment),
                          label: const Text('Test EMV'),
                        ),
                        ElevatedButton.icon(
                          onPressed: _disconnectSdk,
                          icon: const Icon(Icons.power_off),
                          label: const Text('Disconnect'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Logs Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.list_alt,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Activity Logs',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        Text(
                          '${_logs.length} entries',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: _logs.isEmpty
                          ? const Center(
                              child: Text(
                                'No logs yet. Try initializing the SDK.',
                                style: TextStyle(color: Colors.grey),
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.all(8),
                              itemCount: _logs.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 2,
                                  ),
                                  child: Text(
                                    _logs[index],
                                    style: const TextStyle(
                                      fontFamily: 'monospace',
                                      fontSize: 12,
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
