import 'package:flutter/material.dart';
import 'verify_code_page.dart';

class ForgotPasswordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            SizedBox(height: 20),
            Text("Lupa Password", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text("Masukkan email anda untuk reset password"),
            SizedBox(height: 20),
            TextField(decoration: InputDecoration(hintText: "Masukkan email anda")),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => VerifyCodePage())),
              child: Text("Reset Password"),
              style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 50)),
            ),
          ],
        ),
      ),
    );
  }
}