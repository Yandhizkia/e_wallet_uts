import 'package:flutter/material.dart';
import 'HomeScreen.dart'; 

class HistoryScreen extends StatelessWidget {
  final List<Transaction> history;

  const HistoryScreen({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff108489),
        title: const Text("Riwayat Transaksi"),
      ),
      body: history.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.history, size: 80, color: Colors.grey),
                  SizedBox(height: 20),
                  Text("Belum ada transaksi",
                      style: TextStyle(fontSize: 16, color: Colors.black54)),
                ],
              ),
            )
          : ListView.builder(
              itemCount: history.length,
              itemBuilder: (context, index) {
                final trx = history[index];
                return ListTile(
                  leading: Icon(
                    trx.type == "Top Up"
                        ? Icons.add
                        : trx.type == "Transfer"
                            ? Icons.send
                            : Icons.payment,
                    color: Colors.teal,
                  ),
                  title: Text(trx.type),
                  subtitle: Text(
                    "${trx.date.day}/${trx.date.month}/${trx.date.year} "
                    "${trx.date.hour}:${trx.date.minute}",
                  ),
                  trailing: Text(
                    "Rp ${trx.amount.toStringAsFixed(0)}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                );
              },
            ),
    );
  }
}
