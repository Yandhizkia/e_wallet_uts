import 'package:e_wallet_uts/authentication/verification.dart';
import 'package:e_wallet_uts/widgets/widgets.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _email = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  bool _isLoading = false;

  Widget _inputEmail() {
    return SizedBox(
      child: TextFormField(
        controller: _email,
        decoration: InputDecoration(
          hintText: "Email",
          helperText: "Enter your email",
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Email harus diisi";
          } else if (!value.contains("@gmail.com")) {
            return "Email harus valid";
          }
        },
      ),
    );
  }

  Widget _inputSubmit() {
    return wInputSubmit(
      title: "Send",
      onPressed: () {
        if (_formkey.currentState!.validate()) {
          wShowInfo(context, Verification(email: _email.text), 0.5);
        } else {
          return;
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: _isLoading
          ? wAppLoading(context)
          : Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                iconTheme: IconThemeData(color: Colors.black),
              ),
              resizeToAvoidBottomInset: false,
              body: Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    wAuthTitle(
                      "Lupa Password?",
                      "Masukkan email anda untuk ubah password",
                    ),
                    Form(key: _formkey, child: _inputEmail()),
                    SizedBox(height: 25),
                    _inputSubmit(),
                  ],
                ),
              ),
            ),
    );
  }
}
