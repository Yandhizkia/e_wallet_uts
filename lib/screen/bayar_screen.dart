import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'input_nominal_screen.dart';

class BayarScreen extends StatefulWidget {
  final double saldo;
  final void Function(double newSaldo, double amount) onBayar;

  const BayarScreen({super.key, required this.saldo, required this.onBayar});

  @override
  State<BayarScreen> createState() => _BayarScreenState();
}

class _BayarScreenState extends State<BayarScreen> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _ambilFoto() async {
    final XFile? foto = await _picker.pickImage(source: ImageSource.camera);

    if (!mounted) return;

    if (foto != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => InputNominalScreen(
            qrData: "saya ingin membayar${DateTime.now()}",
            saldo: widget.saldo,
            onBayar: widget.onBayar,
          ),
        ),
      );
    } else {
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, _ambilFoto);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Text(
          "Membuka kamera...",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}
