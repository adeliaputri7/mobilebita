import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart';
import 'login_screens.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _birthController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();
  DateTime? _selectedDate;
  String? _selectedGender;
  final List<String> _genderOptions = ['Laki-laki', 'Perempuan'];

  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _isLoading = false; // Loading state

  // Enhanced notification methods
  void _showSuccessNotification(String message) {
    Get.snackbar(
      "✅ Berhasil!",
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green[600],
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
      icon: const Icon(Icons.check_circle, color: Colors.white, size: 28),
      shouldIconPulse: false,
      animationDuration: const Duration(milliseconds: 500),
    );
  }

  void _showErrorNotification(String title, String message) {
    Get.snackbar(
      "❌ $title",
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red[600],
      colorText: Colors.white,
      duration: const Duration(seconds: 4),
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
      icon: const Icon(Icons.error, color: Colors.white, size: 28),
      shouldIconPulse: false,
      animationDuration: const Duration(milliseconds: 500),
    );
  }

  void _showWarningNotification(String title, String message) {
    Get.snackbar(
      "⚠️ $title",
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.orange[600],
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
      icon: const Icon(Icons.warning, color: Colors.white, size: 28),
      shouldIconPulse: false,
      animationDuration: const Duration(milliseconds: 500),
    );
  }

  void _showLoadingDialog() {
    Get.dialog(
      WillPopScope(
        onWillPop: () async => false, // Prevent closing
        child: const AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text("Mendaftarkan akun..."),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  void _hideLoadingDialog() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }

  Future<void> _registerUser() async {
    // Validation checks with specific error messages
    if (_usernameController.text.isEmpty) {
      _showWarningNotification(
          "Validasi Gagal", "Username tidak boleh kosong.");
      return;
    }

    if (_emailController.text.isEmpty) {
      _showWarningNotification("Validasi Gagal", "Email tidak boleh kosong.");
      return;
    }

    if (!_emailController.text.contains('@') ||
        !_emailController.text.contains('.')) {
      _showWarningNotification("Email Tidak Valid",
          "Format email tidak sesuai (contoh: user@example.com).");
      return;
    }

    if (_phoneController.text.isEmpty) {
      _showWarningNotification(
          "Validasi Gagal", "Nomor telepon tidak boleh kosong.");
      return;
    }

    if (_phoneController.text.length < 10) {
      _showWarningNotification(
          "Nomor Tidak Valid", "Nomor telepon minimal 10 digit.");
      return;
    }

    if (_selectedGender == null) {
      _showWarningNotification(
          "Validasi Gagal", "Pilih jenis kelamin terlebih dahulu.");
      return;
    }

    if (_birthController.text.isEmpty) {
      _showWarningNotification(
          "Validasi Gagal", "Tanggal lahir tidak boleh kosong.");
      return;
    }

    if (_passwordController.text.isEmpty) {
      _showWarningNotification(
          "Validasi Gagal", "Password tidak boleh kosong.");
      return;
    }

    if (_passwordController.text.length < 6) {
      _showWarningNotification(
          "Password Lemah", "Password minimal 6 karakter.");
      return;
    }

    if (_confirmController.text.isEmpty) {
      _showWarningNotification(
          "Validasi Gagal", "Konfirmasi password tidak boleh kosong.");
      return;
    }

    if (_passwordController.text != _confirmController.text) {
      _showErrorNotification("Password Tidak Cocok",
          "Password dan konfirmasi password tidak sama.");
      return;
    }

    // Start loading
    setState(() {
      _isLoading = true;
    });
    _showLoadingDialog();

    try {
      final url = Uri.parse(
          'https://bisiktangan.my.id/api/register'); // Fixed URL with port

      final response = await http
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: json.encode({
              'name': _usernameController.text.trim(),
              'email': _emailController.text.trim().toLowerCase(),
              'no_hp': _phoneController.text.trim(),
              'jenis_kelamin': _selectedGender,
              'tgl_lahir': _birthController.text,
              'password': _passwordController.text,
              'password_confirmation': _confirmController.text,
            }),
          )
          .timeout(const Duration(seconds: 30)); // Add timeout

      _hideLoadingDialog();

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseBody = json.decode(response.body);

        _showSuccessNotification(
            "Registrasi berhasil! Selamat datang ${_usernameController.text}!");

        // Clear all fields
        _clearAllFields();

        // Navigate to login after short delay
        Future.delayed(const Duration(seconds: 2), () {
          Get.off(() => const LoginPage());
        });
      } else {
        // Handle different error status codes
        String errorMessage = "Terjadi kesalahan pada server.";

        try {
          final body = json.decode(response.body);

          if (body['message'] != null) {
            errorMessage = body['message'];
          } else if (body['errors'] != null) {
            // Handle validation errors from Laravel
            Map<String, dynamic> errors = body['errors'];
            List<String> errorList = [];
            errors.forEach((key, value) {
              errorList.addAll(List<String>.from(value));
            });
            errorMessage = errorList.join('\n');
          }
        } catch (e) {
          errorMessage = "Server error: ${response.statusCode}";
        }

        _showErrorNotification("Registrasi Gagal", errorMessage);
      }
    } catch (e) {
      _hideLoadingDialog();

      String errorMessage = "Koneksi gagal. Periksa jaringan internet Anda.";

      if (e.toString().contains('TimeoutException')) {
        errorMessage = "Koneksi timeout. Server tidak merespons.";
      } else if (e.toString().contains('SocketException')) {
        errorMessage =
            "Tidak dapat terhubung ke server. Periksa koneksi internet.";
      }

      _showErrorNotification("Kesalahan Koneksi", errorMessage);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _clearAllFields() {
    _usernameController.clear();
    _emailController.clear();
    _phoneController.clear();
    _passwordController.clear();
    _confirmController.clear();
    _birthController.clear();
    setState(() {
      _selectedGender = null;
      _selectedDate = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
              const SizedBox(height: 5),
              const Text('Daftar',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Text('Jika anda sudah punya akun, anda dapat'),
                  GestureDetector(
                    onTap: () => Get.to(() => const LoginPage()),
                    child: const Text(
                      'Login disini !',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildTextField('Username', Icons.person, _usernameController),
              _buildTextField('Email', Icons.email, _emailController),
              _buildTextField('No Telepon', Icons.phone, _phoneController),
              const Text("Jenis Kelamin"),
              const SizedBox(height: 4),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.people),
                  border: UnderlineInputBorder(),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2),
                  ),
                ),
                value: _selectedGender,
                items: _genderOptions.map((String gender) {
                  return DropdownMenuItem<String>(
                    value: gender,
                    child: Text(gender),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              const Text("Tanggal Lahir"),
              const SizedBox(height: 4),
              GestureDetector(
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime(2000),
                    firstDate: DateTime(1950),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    setState(() {
                      _selectedDate = picked;
                      _birthController.text =
                          '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
                    });
                  }
                },
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: _birthController,
                    decoration: const InputDecoration(
                      labelText: "Tanggal Lahir",
                      prefixIcon: Icon(Icons.calendar_today),
                      border: UnderlineInputBorder(),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildPasswordField('Password', _passwordController, true),
              _buildPasswordField(
                  'Confirm Password', _confirmController, false),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _isLoading ? Colors.grey : Colors.blue[400],
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 16),
                  ),
                  onPressed: _isLoading ? null : _registerUser,
                  child: _isLoading
                      ? const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            ),
                            SizedBox(width: 8),
                            Text('Mendaftar...'),
                          ],
                        )
                      : const Text('Sign up'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label, IconData icon, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: const UnderlineInputBorder(),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 2),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField(
      String label, TextEditingController controller, bool isMain) {
    final obscure = isMain ? _obscurePassword : _obscureConfirm;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: const Icon(Icons.lock),
          suffixIcon: IconButton(
            icon: Icon(obscure ? Icons.visibility_off : Icons.visibility),
            onPressed: () {
              setState(() {
                if (isMain) {
                  _obscurePassword = !_obscurePassword;
                } else {
                  _obscureConfirm = !_obscureConfirm;
                }
              });
            },
          ),
          border: const UnderlineInputBorder(),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 2),
          ),
        ),
      ),
    );
  }
}
