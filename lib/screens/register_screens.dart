import 'package:flutter/material.dart';
import 'package:mobilebita/screens/login_screens.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tombol kembali
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 5),

              const Text(
                'Daftar',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              Row(
                children: [
                  const Text('Jika anda sudah punya akun, anda dapat '),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()),
                      ); // Navigasi ke halaman login
                    },
                    child: const Text(
                      'Login disini !',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 24),

              // Form Input
              _buildTextField(
                  'Username', 'Masukkan username anda', Icons.person),
              _buildTextField('Email', 'Masukkan email anda', Icons.email),
              _buildTextField(
                  'No Telepon', 'Masukkan no telepon anda', Icons.phone),
              _buildTextField(
                  'Jenis Kelamin', 'Masukkan jenis kelamin anda', Icons.people),
              _buildTextField(
                  'Tgl Lahir', 'Masukkan tgl lahir anda', Icons.calendar_today),
              _buildPasswordField('Password', 'Masukkan password anda', true),
              _buildPasswordField(
                  'Confirm Password', 'Konfirmasi password anda', false),

              const SizedBox(height: 30),

              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[400],
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 16),
                  ),
                  onPressed: () {
                    // Aksi saat tombol Sign Up ditekan
                  },
                  child: const Text('Sign up'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Input field umum
  Widget _buildTextField(String label, String hint, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon),
          border: UnderlineInputBorder(),
          enabledBorder: const UnderlineInputBorder(
            borderSide:
                BorderSide(color: Colors.blue), // Garis saat tidak fokus
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 2), // Saat fokus
          ),
        ),
      ),
    );
  }

  // Input field untuk password dengan toggle visibility
  Widget _buildPasswordField(String label, String hint, bool isPasswordField) {
    final obscure = isPasswordField ? _obscurePassword : _obscureConfirm;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        obscureText: obscure,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: const Icon(Icons.lock),
          suffixIcon: IconButton(
            icon: Icon(obscure ? Icons.visibility_off : Icons.visibility),
            onPressed: () {
              setState(() {
                if (isPasswordField) {
                  _obscurePassword = !_obscurePassword;
                } else {
                  _obscureConfirm = !_obscureConfirm;
                }
              });
            },
          ),
          border: UnderlineInputBorder(),
          enabledBorder: const UnderlineInputBorder(
            borderSide:
                BorderSide(color: Colors.blue), // Garis saat tidak fokus
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 2), // Saat fokus
          ),
        ),
      ),
    );
  }
}
