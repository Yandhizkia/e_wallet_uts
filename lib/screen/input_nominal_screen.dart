import 'package:flutter/material.dart';

class InputNominalScreen extends StatefulWidget {
  final String qrData;
  final double saldo;
  final ValueChanged<double> onBayar;

  const InputNominalScreen({
    super.key,
    required this.qrData,
    required this.saldo,
    required this.onBayar,
  });

  @override
  State<InputNominalScreen> createState() => _InputNominalScreenState();
}

class _InputNominalScreenState extends State<InputNominalScreen> {
  final TextEditingController _nominalController = TextEditingController();

  void _konfirmasi() {
    final nominal = double.tryParse(_nominalController.text) ?? 0;
    if (nominal <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Masukkan nominal yang valid")),
      );
      return;
    }
    if (nominal > widget.saldo) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Saldo tidak cukup")),
      );
      return;
    }

    widget.onBayar(widget.saldo - nominal);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Pembayaran Rp$nominal berhasil ke ${widget.qrData}")),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Input Nominal"),
        backgroundColor: const Color(0xff108489),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("QR Data: ${widget.qrData}"),
            const SizedBox(height: 20),
            TextField(
              controller: _nominalController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Nominal Pembayaran",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _konfirmasi,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff108489),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text("Konfirmasi Bayar"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
