import 'package:e_wallet_uts/screen/profile.dart';
import 'package:e_wallet_uts/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'TopUp.dart';
import 'transfer_file.dart';
import 'bayar_screen.dart';
import 'history_screen.dart';

class Transaction {
  final String type;
  final double amount;
  final DateTime date;

  Transaction({required this.type, required this.amount, required this.date});

  Map<String, dynamic> toMap() {
    return {'type': type, 'amount': amount, 'date': date.toIso8601String()};
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      type: map['type'],
      amount: map['amount'],
      date: DateTime.parse(map['date']),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double saldo = 0;
  bool _isBalanceVisible = true;
  List<Transaction> history = [];

  final formatCurrency = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('saldo', saldo);

    List<String> encodedHistory = history
        .map((trx) => jsonEncode(trx.toMap()))
        .toList();
    await prefs.setStringList('history', encodedHistory);
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final savedSaldo = prefs.getDouble('saldo') ?? 0.0;
    final savedHistory = prefs.getStringList('history') ?? [];

    setState(() {
      saldo = savedSaldo;
      history = savedHistory
          .map((e) => Transaction.fromMap(jsonDecode(e)))
          .toList();
    });
  }

  void _topUp(double amount) {
    setState(() {
      saldo += amount;
      history.add(
        Transaction(type: "Top Up", amount: amount, date: DateTime.now()),
      );
    });
    _saveData();
  }

  void _transfer(double amount) {
    setState(() {
      saldo -= amount;
      history.add(
        Transaction(type: "Transfer", amount: amount, date: DateTime.now()),
      );
    });
    _saveData();
  }

  void _bayar(double newSaldo, double amount) {
    setState(() {
      saldo = newSaldo;
      history.add(
        Transaction(type: "Bayar", amount: amount, date: DateTime.now()),
      );
    });
    _saveData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF0A7075),
                    Color(0xFF108489),
                    Color(0xFF1A9EA3),
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF108489).withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "BAYAR-in",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: IconButton(
                              onPressed: () => wPushTo(context, Profile()),
                              icon: Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 28),

                      // Kartu Saldo
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Total Saldo",
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _isBalanceVisible = !_isBalanceVisible;
                                    });
                                  },
                                  child: Icon(
                                    _isBalanceVisible
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    color: Colors.white.withOpacity(0.9),
                                    size: 20,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _isBalanceVisible
                                  ? formatCurrency.format(saldo)
                                  : "Rp ••••••••",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 24),
                            Row(
                              children: [
                                Expanded(
                                  child: _actionButton(
                                    icon: Icons.add_circle_outline,
                                    label: "Top Up",
                                    onTap: () {
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
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _actionButton(
                                    icon: Icons.send_outlined,
                                    label: "Transfer",
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => TransferScreen(
                                            saldo: saldo,
                                            onTransfer: _transfer,
                                          ),
                                        ),
                                      );
                                    },
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
              ),
            ),

            const SizedBox(height: 24),

            // MENU GRID
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: GridView.count(
                crossAxisCount: 4,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: [
                  _menuItem(
                    icon: Icons.add_card,
                    title: "Top Up",
                    color: const Color(0xFF10B981),
                  ),
                  _menuItem(
                    icon: Icons.send,
                    title: "Transfer",
                    color: const Color(0xFF3B82F6),
                  ),
                  _menuItem(
                    icon: Icons.qr_code_scanner,
                    title: "Bayar",
                    color: const Color(0xFFEC4899),
                  ),
                  _menuItem(
                    icon: Icons.history,
                    title: "History",
                    color: const Color(0xFFF59E0B),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // TRANSAKSI TERAKHIR
            if (history.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Transaksi Terakhir",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    HistoryScreen(history: history),
                              ),
                            );
                          },
                          child: const Text(
                            "Lihat Semua",
                            style: TextStyle(
                              color: Color(0xFF108489),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ...history.reversed.take(3).map(_transactionItem),
                  ],
                ),
              ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _actionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: const Color(0xFF108489), size: 20),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF108489),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _menuItem({
    required IconData icon,
    required String title,
    required Color color,
  }) {
    return InkWell(
      onTap: () {
        if (title == "Top Up") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TopUp(onTopUp: _topUp)),
          );
        } else if (title == "Transfer") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  TransferScreen(saldo: saldo, onTransfer: _transfer),
            ),
          );
        } else if (title == "Bayar") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BayarScreen(saldo: saldo, onBayar: _bayar),
            ),
          );
        } else if (title == "History") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HistoryScreen(history: history),
            ),
          );
        }
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 26),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF374151),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _transactionItem(Transaction trx) {
    IconData icon;
    Color iconColor;

    switch (trx.type) {
      case "Top Up":
        icon = Icons.add_circle;
        iconColor = const Color(0xFF10B981);
        break;
      case "Transfer":
        icon = Icons.send;
        iconColor = const Color(0xFF3B82F6);
        break;
      case "Bayar":
        icon = Icons.payment;
        iconColor = const Color(0xFFEC4899);
        break;
      default:
        icon = Icons.receipt;
        iconColor = const Color(0xFF6B7280);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  trx.type,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "${trx.date.day}/${trx.date.month}/${trx.date.year} • ${trx.date.hour}:${trx.date.minute.toString().padLeft(2, '0')}",
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Text(
            formatCurrency.format(trx.amount),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: trx.type == "Top Up"
                  ? const Color(0xFF10B981)
                  : const Color(0xFF1F2937),
            ),
          ),
        ],
      ),
    );
  }
}
