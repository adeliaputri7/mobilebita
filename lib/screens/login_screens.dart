import 'package:flutter/material.dart';
import 'package:mobilebita/screens/register_screens.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _rememberMe = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 60),
            const Text(
              'Login',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text('Jika anda belum punya akun, anda dapat '),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RegisterPage()),
                    ); // Navigasi ke halaman daftar
                  },
                  child: const Text(
                    'Daftar disini !',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 24),
            const Text("Email"),
            const SizedBox(height: 4),
            const TextField(
              decoration: InputDecoration(
                hintText: 'Masukkan email anda',
                prefixIcon: Icon(Icons.email),
                border: UnderlineInputBorder(),
                enabledBorder: UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: Colors.blue), // Garis saat tidak fokus
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: Colors.blue, width: 2), // Saat fokus
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text("Password"),
            const SizedBox(height: 4),
            const TextField(
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Masukkan password anda',
                prefixIcon: Icon(Icons.lock),
                suffixIcon: Icon(Icons.visibility_off),
                border: UnderlineInputBorder(),
                enabledBorder: UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: Colors.blue), // Garis saat tidak fokus
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: Colors.blue, width: 2), // Saat fokus
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: _rememberMe,
                      onChanged: (value) {
                        setState(() {
                          _rememberMe = value ?? false;
                        });
                      },
                    ),
                    const Text("Ingat Saya"),
                  ],
                ),
                const Text(
                  "Lupa Password ?",
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6495ED),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 5,
                ),
                child: const Text(
                  'Login',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Center(
              child: Text(
                'Atau lanjutkan dengan',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: Image.asset(
                'assets/logo_google.png',
                width: 48,
                height: 48,
              ),
            )
          ],
        ),
      ),
    );
  }
}
