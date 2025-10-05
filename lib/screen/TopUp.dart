import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TopUp extends StatefulWidget {
  final Function(double) onTopUp;

  const TopUp({super.key, required this.onTopUp});

  @override
  _TopUpState createState() => _TopUpState();
}

class _TopUpState extends State<TopUp> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final formatCurrency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  final List<int> rekomendasi = [10000, 20000, 50000, 100000];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Top Up"),
        backgroundColor: Color(0xff108489),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            TextField(
              controller: phoneController,
              decoration: const InputDecoration(
                labelText: "Nomor HP",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 20),


            TextField(
              controller: amountController,
              decoration: const InputDecoration(
                labelText: "Nominal",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),


            Text(
              "Rekomendasi Nominal",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 10),

            Column(
              children: rekomendasi.map((nominal) {
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        amountController.text = nominal.toString();
                      });
                    },
                    child: Text(formatCurrency.format(nominal)),
                  ),
                );
              }).toList(),
            ),

            const Spacer(),


            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final phone = phoneController.text;
                  final amount = double.tryParse(amountController.text) ?? 0;

                  if (phone.isNotEmpty && amount > 0) {
                    widget.onTopUp(amount);
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff108489),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text("Konfirmasi Top Up"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
