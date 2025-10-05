import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransferScreen extends StatefulWidget {
  final double saldo;
  final ValueChanged<double> onTransfer;

  const TransferScreen({
    Key? key,
    required this.saldo,
    required this.onTransfer,
  }) : super(key: key);

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  final _nomorController = TextEditingController();
  final _jumlahController = TextEditingController();
  final _catatanController = TextEditingController();
  String _jenisTransfer = 'Sesama BAYAR-in';

  final _formatCurrency =
      NumberFormat.currency(locale: 'id_ID', symbol: '', decimalDigits: 0);

  void _isiNominal(double value) {
    _jumlahController.text = _formatCurrency.format(value);
  }

  void _kirimTransfer() {
    // Hapus titik sebelum parse
    final clean = _jumlahController.text.replaceAll('.', '');
    final jumlah = double.tryParse(clean) ?? 0;

    if (_nomorController.text.isEmpty) {
      _showSnack('Nomor penerima wajib diisi');
      return;
    }
    if (jumlah <= 0 || jumlah > widget.saldo) {
      _showSnack('Jumlah tidak valid atau saldo tidak cukup');
      return;
    }

    widget.onTransfer(widget.saldo - jumlah);
    Navigator.pop(context);
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Widget _quickAmount(double amount) {
    return OutlinedButton(
      onPressed: () => _isiNominal(amount),
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        side: BorderSide(color: Colors.lightBlue.shade400),
      ),
      child: Text(
        _formatCurrency.format(amount),
        style: const TextStyle(fontSize: 14, color: Colors.lightBlue),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transfer'),
        backgroundColor: Colors.lightBlue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Info Saldo
            Text(
              'Saldo Tersedia: Rp${_formatCurrency.format(widget.saldo)}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 25),

            // Nomor penerima
            const Text('No. Penerima',
                style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            TextField(
              controller: _nomorController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: 'Masukkan nomor HP / rekening',
                prefixIcon: const Icon(Icons.person),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Jumlah transfer + tombol nominal cepat
            const Text('Jumlah Transfer',
                style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            TextField(
              controller: _jumlahController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Masukkan nominal',
                prefixIcon: const Icon(Icons.payments),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              children: [
                _quickAmount(10000),
                _quickAmount(100000),
                _quickAmount(1000000),
              ],
            ),
            const SizedBox(height: 20),

            // Catatan
            const Text('Catatan (Opsional)',
                style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            TextField(
              controller: _catatanController,
              maxLines: 2,
              decoration: InputDecoration(
                hintText: 'Misal: Uang makan siang',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Jenis Transfer
            const Text('Jenis Transfer',
                style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButton<String>(
                value: _jenisTransfer,
                isExpanded: true,
                underline: const SizedBox(),
                items: const [
                  DropdownMenuItem(
                    value: 'Sesama BAYAR-in',
                    child: Text('Sesama BAYAR-in'),
                  ),
                  DropdownMenuItem(
                    value: 'Antar Bank',
                    child: Text('Antar Bank'),
                  ),
                ],
                onChanged: (val) => setState(() => _jenisTransfer = val!),
              ),
            ),
            const SizedBox(height: 40),

            // Tombol Kirim
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _kirimTransfer,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.lightBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Kirim Sekarang',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
