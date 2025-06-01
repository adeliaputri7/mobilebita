import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobilebita/profile.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/login_screens.dart';

class User {
  final String name;
  final String email;
  final String? phone;
  final String? profileImage;

  User({
    required this.name,
    required this.email,
    this.phone,
    this.profileImage,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    // Handle berbagai struktur response
    Map<String, dynamic> userData;

    if (json.containsKey('user') && json['user'] != null) {
      userData = json['user'];
    } else {
      userData = json;
    }

    return User(
      name: userData['name'] ?? 'User',
      email: userData['email'] ?? '',
      phone: userData['phone'],
      profileImage: userData['profile_image'],
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
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 15));

      print('Profile Response status: ${response.statusCode}');
      print('Profile Response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return User.fromJson(jsonResponse);
      } else if (response.statusCode == 401) {
        await _handleTokenExpired();
        throw Exception('Token tidak valid atau expired');
      } else {
        throw Exception('Gagal memuat data user: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in fetchUser: $e');
      rethrow;
    }
  }

  Future<void> _handleTokenExpired() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear semua data

    Get.snackbar(
      "Session Expired",
      "Silakan login kembali",
      backgroundColor: Colors.orange,
      colorText: Colors.white,
    );

    Get.offAll(() => const LoginPage());
  }

  Future<void> _logout() async {
    // Show confirmation dialog
    bool? shouldLogout = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi'),
          content: const Text('Apakah Anda yakin ingin keluar?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text('Keluar'),
            ),
          ],
        );
      },
    );

    if (shouldLogout == true) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Optional: Call logout API
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('auth_token');

        if (token != null) {
          // Try to call logout API
          try {
            await http.post(
              Uri.parse('https://bisiktangan.my.id/api/logout'),
              headers: {
                'Authorization': 'Bearer $token',
                'Accept': 'application/json',
              },
            ).timeout(const Duration(seconds: 10));
          } catch (e) {
            print('Logout API error: $e');
            // Continue with local logout even if API fails
          }
        }

        // Clear local storage
        await prefs.clear();

        Get.snackbar(
          "Berhasil",
          "Anda telah keluar dari aplikasi",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Navigate to login
        Get.offAll(() => const LoginPage());
      } catch (e) {
        Get.snackbar(
          "Error",
          "Gagal logout: ${e.toString()}",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  "Profil",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),

              // User Profile Card
              FutureBuilder<User>(
                future: futureUser,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
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
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                          SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Loading...",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "Memuat data...",
                                style: TextStyle(color: Colors.white70),
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  } else if (snapshot.hasError) {
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
                                const Text(
                                  "Error",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "Gagal memuat data profil",
                                  style: const TextStyle(color: Colors.white70),
                                ),
                                const SizedBox(height: 8),
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      futureUser = fetchUser();
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.red.shade700,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 4),
                                  ),
                                  child: const Text('Coba Lagi'),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  } else if (snapshot.hasData) {
                    final user = snapshot.data!;
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.blue.shade700,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundImage: user.profileImage != null
                                ? NetworkImage(user.profileImage!)
                                : const AssetImage('assets/user.png')
                                    as ImageProvider,
                            onBackgroundImageError:
                                user.profileImage != null ? (_, __) {} : null,
                            child: user.profileImage == null
                                ? null
                                : const Icon(Icons.person, color: Colors.white),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user.name,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  user.email,
                                  style: const TextStyle(color: Colors.white70),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                if (user.phone != null &&
                                    user.phone!.isNotEmpty)
                                  Text(
                                    user.phone!,
                                    style:
                                        const TextStyle(color: Colors.white70),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),

              const SizedBox(height: 24),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text("Profil"),
                subtitle: const Text("Mari lengkapi data dirimu."),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Get.to(() => ProfileScreen());
                },
              ),
              const SizedBox(height: 16),
              const Text("Lainnya",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ListTile(
                leading: const Icon(Icons.history),
                title: const Text("History"),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Get.snackbar("Info", "Fitur History belum tersedia");
                },
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
                  style: TextStyle(
                    color: _isLoading ? Colors.grey : Colors.red,
                  ),
                ),
                trailing: _isLoading
                    ? null
                    : const Icon(Icons.arrow_forward_ios,
                        size: 16, color: Colors.red),
                onTap: _isLoading ? null : _logout,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
