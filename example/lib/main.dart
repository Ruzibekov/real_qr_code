import 'package:flutter/material.dart';
import 'package:real_qr_code/real_qr_code.dart';

void main() => runApp(const ExampleApp());

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: const QrDemoScreen(),
    );
  }
}

class QrDemoScreen extends StatelessWidget {
  const QrDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(title: const Text('Real QR Code')),
      body: const Center(
        child: RealQrCode(
          data: 'https://flutter.dev',
          size: 304,
          centerSpaceSize: 80,
          borderRadius: 16,
          logo: Icon(
            Icons.flutter_dash,
            size: 48,
            color: Color(0xFF027DFD),
          ),
        ),
      ),
    );
  }
}
