import 'package:flutter/material.dart';
import '../auth/auth_serivce.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? userEmail;

  @override
  void initState() {
    super.initState();
    _getUserEmail();
  }

  Future<void> _getUserEmail() async {
    try {
      print("Fetching user email...");
      final authService = AuthService();
      final email = await authService.getCurrentUserEmail();
      print("User email: $email");
      setState(() {
        userEmail = email;
      });
    } catch (e) {
      print("Error fetching user email: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Center(
        child: userEmail != null
            ? Text('Logged in as: $userEmail')
            : const CircularProgressIndicator(),
      ),
    );
  }
}
