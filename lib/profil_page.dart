import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/login_screens.dart';
import 'package:mobilebita/profile.dart';

class User {
  final String name;
  final String email;
  final String? phone;
  final String? profileImage;
  final String? address;
  final String? birthDate;

  User({
    required this.name,
    required this.email,
    this.phone,
    this.profileImage,
    this.address,
    this.birthDate,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    final userData = json['user'] ?? json;
    return User(
      name: userData['name'] ?? 'User',
      email: userData['email'] ?? '',
      phone: userData['phone'],
      profileImage: userData['profile_image'],
      address: userData['address'],
      birthDate: userData['birth_date'],
    );
  }
}

class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  late Future<User> futureUser;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    futureUser = fetchUser();
  }

  Future<User> fetchUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null || token.isEmpty) {
        throw Exception('Token tidak ditemukan');
      }

      final response = await http.get(
        Uri.parse('https://bisiktangan.my.id/api/user'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return User.fromJson(jsonResponse);
      } else if (response.statusCode == 401) {
        await _handleTokenExpired();
        throw Exception('Token tidak valid atau expired');
      } else {
        throw Exception('Gagal memuat data user');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _handleTokenExpired() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Get.snackbar("Session Expired", "Silakan login kembali",
        backgroundColor: Colors.orange, colorText: Colors.white);
    Get.offAll(() => const LoginPage());
  }

  Future<void> _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Konfirmasi"),
        content: const Text("Apakah Anda yakin ingin keluar?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Batal")),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text("Keluar"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() => _isLoading = true);
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token != null) {
        try {
          await http.post(
            Uri.parse('https://bisiktangan.my.id/api/logout'),
            headers: {
              'Authorization': 'Bearer $token',
              'Accept': 'application/json',
            },
          ).timeout(const Duration(seconds: 10));
        } catch (_) {}
      }

      await prefs.clear();
      Get.snackbar("Berhasil", "Anda telah keluar",
          backgroundColor: Colors.green, colorText: Colors.white);
      Get.offAll(() => const LoginPage());
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profil")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            FutureBuilder<User>(
              future: futureUser,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return _buildProfileCardLoading();
                } else if (snapshot.hasError) {
                  return _buildProfileCardError();
                } else if (snapshot.hasData) {
                  return _buildProfileCard(snapshot.data!);
                }
                return const SizedBox.shrink();
              },
            ),
            const SizedBox(height: 24),
            _buildMenuList(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard(User user) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue.shade700,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: user.profileImage != null
                    ? NetworkImage(user.profileImage!)
                    : const AssetImage('assets/user.png') as ImageProvider,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user.name,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                    Text(user.email,
                        style: const TextStyle(color: Colors.white70)),
                    if (user.phone != null && user.phone!.isNotEmpty)
                      Text(user.phone!,
                          style: const TextStyle(color: Colors.white70)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (user.address != null && user.address!.isNotEmpty)
            Row(
              children: [
                const Icon(Icons.home, color: Colors.white70, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(user.address!,
                      style: const TextStyle(color: Colors.white70)),
                ),
              ],
            ),
          if (user.birthDate != null && user.birthDate!.isNotEmpty)
            Row(
              children: [
                const Icon(Icons.cake, color: Colors.white70, size: 20),
                const SizedBox(width: 8),
                Text(user.birthDate!,
                    style: const TextStyle(color: Colors.white70)),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildProfileCardLoading() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue.shade700,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: const Row(
        children: [
          CircleAvatar(
            radius: 30,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          SizedBox(width: 16),
          Text("Memuat profil...", style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildProfileCardError() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.red.shade700,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white24,
            child: Icon(Icons.error, color: Colors.white),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Gagal memuat profil",
                    style: TextStyle(color: Colors.white, fontSize: 16)),
                ElevatedButton(
                  onPressed: () => setState(() => futureUser = fetchUser()),
                  child: const Text("Coba Lagi"),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildMenuList() {
    return Expanded(
      child: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text("Profil"),
            subtitle: const Text("Mari lengkapi data dirimu."),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => Get.to(() => const ProfileScreen()),
          ),
          const SizedBox(height: 16),
          const Text("Lainnya", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text("History"),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => Get.snackbar("Info", "Fitur History belum tersedia"),
          ),
          ListTile(
            leading: _isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.logout, color: Colors.red),
            title: Text(
              _isLoading ? "Logging out..." : "Keluar",
              style: TextStyle(color: _isLoading ? Colors.grey : Colors.red),
            ),
            trailing: _isLoading
                ? null
                : const Icon(Icons.arrow_forward_ios,
                    size: 16, color: Colors.red),
            onTap: _isLoading ? null : _logout,
          ),
        ],
      ),
    );
  }
}
