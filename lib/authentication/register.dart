import 'package:e_wallet_uts/authentication/login.dart';
import 'package:e_wallet_uts/services/auth_service.dart';
import 'package:e_wallet_uts/widgets/widgets.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _username = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmpassword = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  bool _obscureText = true;
  bool _show = false;
  bool _isLoading = false;

  Widget _inputUsername() {
    return TextFormField(
      controller: _username,
      maxLength: 16,
      decoration: InputDecoration(
        hintText: "Nama",
        helperText: "",
        counterText: "",
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.only(left: 0),
        prefixIcon: Icon(Icons.person,color: Colors.grey),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Nama harus diisi";
        } else {
          return null;
        }
      },
      autovalidateMode: AutovalidateMode.onUnfocus,
    );
  }

  Widget _inputEmail() {
    return TextFormField(
      controller: _email,
      maxLength: 64,
      decoration: InputDecoration(
        hintText: "Email",
        helperText: "",
        border: OutlineInputBorder(),
        counterText: "",
        contentPadding: EdgeInsets.only(left: 0),
        prefixIcon: Icon(Icons.email,color: Colors.grey),
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
        hintText: " password",
        helperText: "",
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.only(left: 0),
        counterText: "",
        prefixIcon: Icon(Icons.lock,color: Colors.grey),
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
          return "Password harus diisi";
        } else if (value.length < 8) {
          return "Password minimal 8 huruf/angka";
        } else {
          return null;
        }
      },
      autovalidateMode: AutovalidateMode.onUnfocus,
    );
  }

  Widget _confirmPassword() {
    return TextFormField(
      controller: _confirmpassword,
      obscureText: _obscureText,
      maxLength: 16,
      decoration: InputDecoration(
        hintText: "confirm password",
        helperText: "",
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.only(left: 0),
        counterText: "",
        prefixIcon: Icon(Icons.lock,color: Colors.grey),
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
          return "Konfirmasi password";
        } else if (value != _password.text) {
          return "Password tidak sama";
        } else {
          return null;
        }
      },
      autovalidateMode: AutovalidateMode.onUnfocus,
    );
  }

  void _createAccount() async {
    if (_formkey.currentState!.validate()) {
      AuthService authService = AuthService();
      authService.setUserData(key: "name", value: _username.text);
      authService.setUserData(key: "phone", value: _phone.text);
      authService.setUserData(key: "email", value: _email.text);
      authService.setUserData(key: "password", value: _password.text);
      await Future.delayed(Duration(seconds: 2));
      wPushReplacementTo(context, Login());
    } else {
      _showMessage();
    }
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

  @override
  Widget build(BuildContext context) {
    wAppLoading(context);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: _isLoading
          ? wAppLoading(context)
          : Scaffold(
              appBar: AppBar(
                foregroundColor: Colors.white,
                backgroundColor: Color(0xff108489),
                elevation: 0,
              ),
              backgroundColor: Color(0xff108489),
              resizeToAvoidBottomInset: false,
              body: Center(
                child: Container(
                  height: 600,
                  margin: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Colors.white,
                  ),
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.person, size: 50),
                        wAuthTitle(
                          "Register",
                          "Isi data berikut untuk membuat akun baru",
                        ),
                        SizedBox(height: 15),
                        Form(
                          key: _formkey,
                          child: Column(
                            children: [
                              _inputUsername(),
                              _inputPhone(),
                              _inputEmail(),
                              _inputPassword(),
                              _confirmPassword(),
                            ],
                          ),
                        ),
                        SizedBox(height: 5),
                        wInputSubmit(
                          title: "Register",
                          onPressed: _createAccount,
                        ),
                        wTextWarning(
                          text: "Nama, Email, dan Password Harus Diisi",
                          show: _show,
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
