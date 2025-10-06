import 'package:e_wallet_uts/services/auth_service.dart';
import 'package:e_wallet_uts/services/storage_service.dart';
import 'package:e_wallet_uts/splash.dart';
import 'package:e_wallet_uts/widgets/image_picker_widget.dart';
import 'package:e_wallet_uts/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final AuthService authService = AuthService();
  final ImageFile _imageFile = ImageFile();
  File? _imageProfile;
  String _username = "", _phone = "", _email = "";
  bool _isSet = false;

  @override
  Widget build(BuildContext context) {
    _loadImage();
    _setImageProfile();
    _isSet ? "" : _setProfileDetail();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff108489),
        foregroundColor: Colors.white,
      ),
      backgroundColor: Color(0xff108489),
      body: Center(
        child: Container(
          margin: EdgeInsets.fromLTRB(25, 50, 25, 100),
          padding: EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(25),
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
            children: [
              Text(
                "Profil Pengguna",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 25),
                decoration: BoxDecoration(
                  border: Border.all(width: 1.5, color: Colors.white),
                  shape: BoxShape.circle,
                ),
                child: _imageProfile == null
                    ? CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white.withOpacity(0.1),
                        child: Icon(
                          Icons.person,
                          size: 80,
                          color: Colors.white,
                        ),
                      )
                    : CircleAvatar(
                        radius: 50,
                        foregroundImage: FileImage(_imageProfile!),
                      ),
              ),
              TextButton(
                onPressed: () {
                  wShowInfo(context, ImagePickerWidget(), 0.3);
                },
                child: Text(
                  "Edit",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  wProfileDetail(
                    label: "Nama",
                    value: _username,
                    icon: Icons.person,
                    size: 15,
                  ),
                  SizedBox(height: 10),
                  wProfileDetail(
                    label: "Nomor HP",
                    value: _phone,
                    icon: Icons.phone_android,
                    size: 15,
                  ),
                  SizedBox(height: 10),
                  wProfileDetail(
                    label: "Email",
                    value: _email,
                    icon: Icons.email,
                    size: 15,
                  ),
                  SizedBox(height: 25),
                  wElevatedButton(
                    onPressed: _showLogoutDialog,
                    icon: MdiIcons.logout,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _setImageProfile() {
    setState(() => _imageProfile = _imageFile.getImageFile());
  }

  Future<void> _setProfileDetail() async {
    String username = await authService.getUserData(key: "name");
    String phone = await authService.getUserData(key: "phone");
    String email = await authService.getUserData(key: "email");
    setState(() {
      _username = username;
      _phone = phone;
      _email = email;
      _isSet = true;
    });
  }

  Future<void> _loadImage() async {
    final StorageService storageService = StorageService();
    final file = await storageService.loadImage();
    setState(() {
      _imageFile.setImageFile(file);
    });
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Konfirmasi Logout"),
          content: Text("Konfirmasi bahwa anda ingin logout."),
          contentTextStyle: TextStyle(color: Colors.black),
          actions: [
            ElevatedButton(
              onPressed: () async {
                authService.setLoginStatus(key: "login", value: false);
                wShowToast(msg: "Berhasil Logout");
                await Future.delayed(Duration(seconds: 1));
                wPushReplacementTo(context, Splash());
              },
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Color(0xff108489)),
                foregroundColor: WidgetStatePropertyAll(Colors.white),
              ),
              child: Text("Konfirmasi"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Color(0xff108489)),
                foregroundColor: WidgetStatePropertyAll(Colors.white),
              ),
              child: Text("Batal"),
            ),
          ],
        );
      },
    );
  }
}
