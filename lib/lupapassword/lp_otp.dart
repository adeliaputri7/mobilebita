import 'package:flutter/material.dart';
import 'password_reset_page.dart';

class VerifyCodePage extends StatelessWidget {
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
            Text("Check email anda", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text("Masukkan 5 digit kode yang tertera"),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(5, (index) => SizedBox(
                width: 50,
                child: TextField(
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                ),
              )),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PasswordResetPage())),
              child: Text("Verifikasi Kode"),
              style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 50)),
            ),
            TextButton(
              onPressed: () {},
              child: Text("Resend email"),
            )
          ],
        ),
      ),
    );
  }
}