import 'package:e_wallet_uts/authentication/forgot_password.dart';
import 'package:e_wallet_uts/authentication/register.dart';
import 'package:e_wallet_uts/services/auth_service.dart';
import 'package:e_wallet_uts/splash.dart';
import 'package:e_wallet_uts/widgets/widgets.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  String? error;
  bool _show = false;
  bool _obscureText = true;
  bool _isLoading = false;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  Widget _inputEmail() {
    return TextFormField(
      controller: _email,
      maxLength: 64,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(left: 0),
        helperText: "",

        hintText: "Email",
        counterText: "",
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.email, color: Colors.grey),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Email harus diisi";
        } else {
          final domains = ["gmail.com", "yahoo.com", "outlook.com"];
          final email = value.split("@");
          if (!value.contains("@") ||
              email[0].isEmpty ||
              email.length != 2 ||
              !domains.contains(email[1])) {
            return "Email harus valid";
          } else {
            return null;
          }
        }
      },
      autovalidateMode: AutovalidateMode.onUnfocus,
    );
  }

  Widget _inputPhone() {
    return TextFormField(
      controller: _phone,
      maxLength: 13,
      decoration: InputDecoration(
        hintText: "Nomor HP",
        helperText: "",
        border: OutlineInputBorder(),
        counterText: "",
        contentPadding: EdgeInsets.only(left: 0),
        prefixIcon: Icon(Icons.phone_iphone, color: Colors.grey),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Nomor HP harus diisi";
        } else if (!RegExp(r"^08[0-9]+$").hasMatch(value) ||
            value.length < 10) {
          return "Nomor HP harus valid";
        } else {
          return null;
        }
      },
      autovalidateMode: AutovalidateMode.onUnfocus,
    );
  }

  Widget _inputPassword() {
    return TextFormField(
      controller: _password,
      obscureText: _obscureText,
      maxLength: 16,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(left: 0),
        hintText: "password",
        helperText: "",
        counterText: "",
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.lock, color: Colors.grey),
        suffixIcon: IconButton(
          onPressed: () {
            setState(() => _obscureText = !_obscureText);
          },
          icon: Icon(
            _obscureText ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey,
          ),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Password harus diisi';
        } else if (value.length < 8) {
          return 'Minimal 8 karakter';
        } else {
          return null;
        }
      },
      autovalidateMode: AutovalidateMode.onUnfocus,
    );
  }

  Widget _forgotPassword() {
    return GestureDetector(
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
          child: Text(
            "Lupa Password?",
            style: TextStyle(
              color: Color(0xff108489),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ForgotPassword()),
        );
      },
    );
  }

  void _showMessage() async {
    setState(() {
      _show = true;
    });
    await Future.delayed(Duration(seconds: 3));
    setState(() {
      _show = false;
    });
  }

  Future<void> _loginAccount() async {
    if (_formkey.currentState!.validate()) {
      AuthService authService = AuthService();
      String phone = await authService.getUserData(key: "phone");
      String email = await authService.getUserData(key: "email");
      String password = await authService.getUserData(key: "password");
      if (_email.text == email &&
          _password.text == password &&
          _phone.text == phone) {
        authService.setLoginStatus(key: "login", value: true);
        wPushReplacementTo(context, Splash());
      } else {
        _showMessage();
      }
    } else {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: _isLoading
          ? wAppLoading(context)
          : Scaffold(
              appBar: AppBar(backgroundColor: Color(0xff108489)),
              backgroundColor: Color(0xff108489),
              resizeToAvoidBottomInset: false,
              body: Center(
                child: Container(
                  height: 550,
                  margin: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(25),
                    color: Colors.white,
                  ),
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.person, size: 50),
                        wAuthTitle("Login", "Masukkan email dan password"),
                        Form(
                          key: _formkey,
                          child: Column(
                            children: [
                              _inputPhone(),
                              _inputEmail(),
                              _inputPassword(),
                            ],
                          ),
                        ),
                        _forgotPassword(),
                        wInputSubmit(title: "Login", onPressed: _loginAccount),
                        wTextWarning(
                          text: "Nomor HP, Email atau Password Salah",
                          show: _show,
                        ),
                        wTextLink(
                          text: "Belum punya akun?",
                          textLink: "Register",
                          onTap: () {
                            wPushTo(context, Register());
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
