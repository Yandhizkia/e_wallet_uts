import 'package:e_wallet_uts/authentication/login.dart';
import 'package:e_wallet_uts/screen/HomeScreen.dart';
import 'package:e_wallet_uts/services/auth_service.dart';
import 'package:e_wallet_uts/widgets/widgets.dart';
import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  AuthService authService = AuthService();
  @override
  void initState() {
    _checkUserSementara;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _checkUserSementara();
    return wAppLoading(context);
  }

  void _checkUserSementara() async {
    bool user = await authService.getLoginStatus(key: "login");
    await Future.delayed(Duration(seconds: 2));
    wPushReplacementTo(context, user ? HomeScreen() : Login());
  }
}
