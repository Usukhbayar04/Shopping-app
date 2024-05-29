import 'dart:developer';
import 'package:flutter/material.dart';
import '../../const/AppColors.dart';
import '../../widgets/buttonWidget.dart';
import '../../widgets/textFieldWidgets.dart';
import '../home_screen.dart';
import 'auth_serivce.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _auth = AuthService();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _name.dispose();
    _email.dispose();
    _password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          iconSize: 30,
          color: AppColors.text_bold_Color,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: AppColors.brand_Color,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SizedBox(height: 30),
            const Text(
              "Sign Up",
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w500,
                color: AppColors.white_Color,
              ),
            ),
            const SizedBox(height: 50),
            Column(
              children: [
                CustomTextField(
                  hint: "Enter Name",
                  label: "Name",
                  controller: _name,
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  hint: "Enter Email",
                  label: "Email",
                  controller: _email,
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  hint: "Enter Password",
                  label: "Password",
                  isPassword: true,
                  controller: _password,
                ),
              ],
            ),
            const SizedBox(height: 30),
            CustomButton(
              label: "Signup",
              onPressed: _signup,
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Already have an account?",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(width: 10),
                InkWell(
                  onTap: () => goToLogin(context),
                  child: const Text(
                    "Login",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  goToLogin(BuildContext context) => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );

  goToHome(BuildContext context) => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );

  _signup() async {
    final user =
        await _auth.createUserWithEmailAndPassword(_email.text, _password.text);
    if (user != null) {
      log("User Created Succesfully");
      goToHome(context);
    }
  }
}
