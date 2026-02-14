import 'dart:async';

import 'package:flutter/material.dart';
import 'package:no_tapjack/no_tapjack.dart';
import 'package:no_tapjack/tapjack_snapshot.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _plugin = NoTapjack.instance;
  StreamSubscription<TapjackSnapshot>? _subscription;
  TapjackSnapshot? _snapshot;
  bool _isListening = false;

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  Future<void> _startListening() async {
    await _plugin.startListening();
    _subscription = _plugin.tapjackStream.listen((snapshot) {
      if (!mounted) return;
      setState(() {
        _snapshot = snapshot;
      });
    });
    setState(() {
      _isListening = true;
    });
  }

  Future<void> _stopListening() async {
    await _plugin.stopListening();
    _subscription?.cancel();
    _subscription = null;
    setState(() {
      _isListening = false;
    });
  }

  Future<void> _enableFilter() async {
    await _plugin.enableFilterTouches();
  }

  Future<void> _disableFilter() async {
    await _plugin.disableFilterTouches();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.red),
      home: Scaffold(
        appBar: AppBar(title: const Text('No Tapjack')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tapjack Status',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 12),
                      _statusRow(
                        'Overlay Detected',
                        _snapshot?.isOverlayDetected ?? false,
                      ),
                      const SizedBox(height: 8),
                      _statusRow(
                        'Partial Overlay',
                        _snapshot?.isPartialOverlay ?? false,
                      ),
                      const SizedBox(height: 8),
                      _statusRow(
                        'Touch Filter Enabled',
                        _snapshot?.isTouchFilterEnabled ?? false,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: FilledButton(
                      onPressed: _isListening ? null : _startListening,
                      child: const Text('Start Listening'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isListening ? _stopListening : null,
                      child: const Text('Stop Listening'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: FilledButton.tonal(
                      onPressed: _isListening ? _enableFilter : null,
                      child: const Text('Enable Filter'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isListening ? _disableFilter : null,
                      child: const Text('Disable Filter'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statusRow(String label, bool active) {
    return Row(
      children: [
        Icon(Icons.circle, size: 12, color: active ? Colors.red : Colors.green),
        const SizedBox(width: 8),
        Text(label, style: Theme.of(context).textTheme.bodyLarge),
        const Spacer(),
        Text(
          active ? 'Yes' : 'No',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: active ? Colors.red : Colors.green,
          ),
        ),
      ],
    );
  }
}
