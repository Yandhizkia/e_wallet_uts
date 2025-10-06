import 'package:flutter/material.dart';

class Verification extends StatefulWidget {
  const Verification({super.key, required email});

  @override
  VerificationState createState() => VerificationState();
}

class VerificationState extends State<Verification> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Email Telah Dikirim",style: TextStyle(color: Color(0xff108489)),), centerTitle: true,foregroundColor: Colors.transparent,),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.mark_email_read, size: 50),
            SizedBox(height: 30,),
            Container(
              padding: EdgeInsets.all(10),
              child: Text(
                "Password sudah bisa diganti melalui email",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
            SizedBox(height: 30),
            Text("Email belum diterima?"),
            TextButton(
              child: Text(
                _isLoading ? 'Sending...' : 'Resend',
                style: TextStyle(color: Color(0xff108489), fontSize: 15),
              ),
              onPressed: () async {
                setState(() => _isLoading = true);
                await Future.delayed(Duration(seconds: 2));
                setState(() {
                  _isLoading = false;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Email terkirim!",style: TextStyle(fontWeight: FontWeight.bold),),
                    backgroundColor: Color(0xff108489),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
