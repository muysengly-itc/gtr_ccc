import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

void main() {
  runApp(const Register());
}

class Register extends StatelessWidget {
  const Register({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)),
      home: const BarcodeScannerPage(),
    );
  }
}

class BarcodeScannerPage extends StatefulWidget {
  const BarcodeScannerPage({super.key});
  @override
  State<BarcodeScannerPage> createState() => _BarcodeScannerPageState();
}

class _BarcodeScannerPageState extends State<BarcodeScannerPage> {
  MobileScannerController controller = MobileScannerController();

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Barcode Scanner Page")),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              width: 400,
              height: 400,
              child: MobileScanner(
                fit: BoxFit.contain,
                controller: controller,
                onDetect: (result) {
                  if (result.barcodes.isNotEmpty) {
                    String? code = result.barcodes.first.rawValue;
                    Navigator.of(context).pop(code ?? '');
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
