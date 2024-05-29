import 'dart:developer';
import 'package:flutter/material.dart';
import '../../const/AppColors.dart';
import '../../widgets/buttonWidget.dart';
import '../../widgets/textFieldWidgets.dart';
import '../bottomNavCont.dart';
import 'auth_serivce.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = AuthService();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    super.dispose();
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
        padding: const EdgeInsets.only(left: 25, right: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SizedBox(height: 40),
            const Column(
              children: [
                Text(
                  "Welcome",
                  style: TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.w500,
                    color: AppColors.white_Color,
                  ),
                ),
                Text(
                  "Please enter your email and password",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    color: AppColors.whiteOp_Color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                CustomTextField(
                  hint: "Enter Email",
                  label: "Email",
                  controller: _email,
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  hint: "Enter Password",
                  label: "Password",
                  controller: _password,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Forgot Password?',
                  style: TextStyle(color: AppColors.whiteOp_Color),
                ),
              ],
            ),
            CustomButton(
              label: "Login",
              onPressed: _login,
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Already have an account? ",
                  style: TextStyle(
                    color: AppColors.white_Color,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(width: 10),
                InkWell(
                  onTap: () => goToSignup(context),
                  child: const Text(
                    "Sign Up",
                    style: TextStyle(
                      color: AppColors.white_Color,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
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

  goToSignup(BuildContext context) => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SignUpScreen()),
      );

  _login() async {
    final user =
        await _auth.loginUserWithEmailAndPassword(_email.text, _password.text);

    if (user != null) {
      log("User Logged In");
      goToHome(context, user);
    }
  }

  goToHome(BuildContext contex, dynamic user) => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => BottomNavController(user: user)),
      );
}
