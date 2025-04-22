import 'package:flutter/material.dart';

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
              const SizedBox(height: 10),

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
                      // Arahkan ke halaman login
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

              _buildTextField('Username', 'Masukkan username anda', Icons.person),
              _buildTextField('Email', 'Masukkan email anda', Icons.email),
              _buildTextField('No Telepon', 'Masukkan  no telepon anda', Icons.phone),
              _buildTextField('Jenis Kelamin', 'Masukkan jenis kelamin anda', Icons.people),
              _buildTextField('Tgl Lahir', 'Masukkan tgl lahir anda', Icons.calendar_today),
              _buildPasswordField('Password', 'Masukkan password anda', true),
              _buildPasswordField('Confirm Password', 'Konfirmasi password anda', false),

              const SizedBox(height: 30),

              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[400],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  ),
                  onPressed: () {
                    // aksi Sign Up
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

  Widget _buildTextField(String label, String hint, IconData icon) {
    return
