import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'TopUp.dart';
import 'transfer_file.dart';
import 'bayar_screen.dart';
import 'history_screen.dart';

class Transaction {
  final String type;
  final double amount;
  final DateTime date;

  Transaction({required this.type, required this.amount, required this.date});
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double saldo = 0;
  final formatCurrency = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );
  List<Transaction> history = [];

  void _topUp(double amount) {
    setState(() {
      saldo += amount;
      history.add(
        Transaction(type: "Top Up", amount: amount, date: DateTime.now()),
      );
    });
  }

  void _showTopUpDialog() {
    showDialog(
      context: context,
      builder: (_) => TopUp(onTopUp: _topUp),
    );
  }

  void _updateSaldo(double newSaldo) {
    setState(() {
      saldo = newSaldo;
      history.add(
        Transaction(type: "Transfer", amount: newSaldo, date: DateTime.now()),
      );
    });
  }

  void _transfer(double amount) {
    setState(() {
      saldo -= amount;
      history.add(
        Transaction(type: "Transfer", amount: amount, date: DateTime.now()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(
                top: 50,
                left: 20,
                right: 20,
                bottom: 30,
              ),
              decoration: const BoxDecoration(
                color: Color(0xff108489),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        "BAYAR-in",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 5,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Saldo",
                          style: TextStyle(color: Colors.black54, fontSize: 14),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          formatCurrency.format(saldo),
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TopUp(
                                      onTopUp: (amount) {
                                        _topUp(amount);
                                      },
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.add),
                              label: const Text(
                                "Top Up",
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xff108489),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),

                            ElevatedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => TransferScreen(
                                      saldo: saldo,
                                      onTransfer: _updateSaldo,
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.send),
                              label: const Text(
                                "Transfer",
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xff108489),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GridView.count(
                crossAxisCount: 4,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _menuItem(Icons.add_card, "Top Up"),
                  _menuItem(Icons.send, "Transfer"),
                  _menuItem(Icons.payment, "Bayar"),
                  _menuItem(Icons.history, "History"),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _menuItem(IconData icon, String title) {
    return InkWell(
      onTap: () {
        if (title == "Top Up") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TopUp(
                onTopUp: (amount) {
                  _topUp(amount);
                },
              ),
            ),
          );
        } else if (title == "Bayar") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BayarScreen(
                saldo: saldo,
                onBayar: (newSaldo, amount) {
                  setState(() {
                    saldo = newSaldo;
                    history.add(
                      Transaction(
                        type: "Bayar",
                        amount: amount,
                        date: DateTime.now(),
                      ),
                    );
                  });
                },
              ),
            ),
          );
        } else if (title == "History") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HistoryScreen(history: history),
            ),
          );
        } else if (title == "Transfer") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  TransferScreen(saldo: saldo, onTransfer: _transfer),
            ),
          );
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Color(0xff108489).withOpacity(0.1),
            child: Icon(icon, color: Color(0xff108489), size: 28),
          ),
          const SizedBox(height: 6),
          Text(title, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
