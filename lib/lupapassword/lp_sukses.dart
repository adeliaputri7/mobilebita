import 'package:flutter/material.dart';
import 'package:mobilebita/screens/login_screens.dart';

class SuccessResetPage extends StatelessWidget {
  const SuccessResetPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.verified, size: 80, color: Colors.blue),
              SizedBox(height: 20),
              Text("Sukses",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              Text(
                  "Selamat! Password anda telah diperbarui. Klik lanjutkan untuk login."),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => LoginPage()),
                  (route) => false,
                ),
                child: Text("Lanjutkan"),
                style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
