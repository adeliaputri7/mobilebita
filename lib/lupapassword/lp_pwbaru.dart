import 'package:flutter/material.dart';
import 'success_reset_page.dart';

class PasswordResetPage extends StatelessWidget {
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
            Text("Password reset", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text("Password anda telah sukses di reset. Klik konfirmasi untuk membuat password baru"),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SuccessResetPage())),
              child: Text("Konfirmasi"),
              style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 50)),
            ),
          ],
        ),
      ),
    );
  }
}