import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io' show Platform;

Widget wAppLoading(BuildContext context) {
  return Scaffold(
    backgroundColor: Color(0xff108489),
    body: Center(
      child: Platform.isIOS
          ? CupertinoActivityIndicator(color: Colors.white)
          : CircularProgressIndicator(color: Colors.white),
    ),
  );
}

Widget wAuthTitle(String title, String subtitle) {
  return Container(
    width: double.infinity,
    padding: EdgeInsets.only(bottom: 15),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        Text(subtitle, style: TextStyle(fontSize: 15)),
      ],
    ),
  );
}

Widget wTextDivider({required String text}) {
  return Row(
    children: [
      Expanded(child: Divider()),
      Padding(
        padding: const EdgeInsets.all(10),
        child: Text(
          text,
          style: TextStyle(fontSize: 12, color: Colors.black87),
        ),
      ),
      Expanded(child: Divider()),
    ],
  );
}

Widget wInputSubmit({required String title, required VoidCallback onPressed}) {
  return SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      style: ButtonStyle(
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(25),
          ),
        ),
        backgroundColor: WidgetStatePropertyAll(Color(0xff108489)),
        foregroundColor: WidgetStatePropertyAll(Colors.white),
      ),
      onPressed: onPressed,
      child: Text(title),
    ),
  );
}

Widget wElevatedButtonIcon({
  required String text,
  required IconData icon,
  required double size,
  required VoidCallback onPressed,
}) {
  return SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        shape: WidgetStatePropertyAll(BeveledRectangleBorder()),
        foregroundColor: WidgetStatePropertyAll(Color(0xff108489)),
        backgroundColor: WidgetStatePropertyAll(Colors.transparent),
        shadowColor: WidgetStatePropertyAll(Colors.transparent),
        textStyle: WidgetStatePropertyAll(TextStyle(fontSize: size)),
        iconSize: WidgetStatePropertyAll(size + 5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [Icon(icon), SizedBox(width: 10), Text(text)],
      ),
    ),
  );
}

Future<void> wPushTo(BuildContext context, Widget route) async {
  Navigator.push(context, MaterialPageRoute(builder: (context) => route));
}

Future<void> wPushReplacementTo(BuildContext context, Widget route) async {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => route),
  );
}

Future<void> wShowInfo(BuildContext context, Widget widget, double height) {
  return showModalBottomSheet(
    context: context,
    builder: (context) {
      return SizedBox(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * height,
        child: widget,
      );
    },
    showDragHandle: true,
  );
}

Widget wElevatedButton({required VoidCallback onPressed,required IconData icon}) {
  return ElevatedButton.icon(
    onPressed: onPressed,
    label: Text("Logout", style: TextStyle(fontWeight: FontWeight.bold)),
    icon: Icon(icon),
    style: ButtonStyle(
      elevation: WidgetStatePropertyAll(2),
      backgroundColor: WidgetStatePropertyAll(Colors.white),
      foregroundColor: WidgetStatePropertyAll(Color(0xff108489)),
    ),
  );
}

Future<void> wShowToast({required String msg}) {
  return Fluttertoast.showToast(
    msg: msg,
    backgroundColor: Colors.black,
    textColor: Colors.white,
    toastLength: Toast.LENGTH_LONG,
  );
}

Widget wProfileDetail({
  required String label,
  required String value,
  required IconData icon,
  required double size,
}) {
  return SizedBox(
    width: double.infinity,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(icon, size: 3 * size, color: Colors.white),
        SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: size,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              value,
              style: TextStyle(fontSize: size, color: Colors.white),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget wTextWarning({required String text, required bool show}) {
  return SizedBox(
    child: Text(
      show ? text : "",
      style: TextStyle(
        color: const Color.fromARGB(255, 177, 36, 26),
        fontSize: 12.5,
      ),
    ),
  );
}

Widget wTextLink({
  required String text,
  required String textLink,
  required GestureTapCallback onTap,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(text, style: TextStyle(color: Color(0xff108489))),
      GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(5),
          color: Colors.transparent,
          child: Text(
            textLink,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xff108489),
            ),
          ),
        ),
      ),
    ],
  );
}
