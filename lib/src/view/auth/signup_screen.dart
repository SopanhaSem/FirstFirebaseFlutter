import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_setup/src/firebase_auth_implementation/firebase_auth_service.dart';
import 'package:firebase_setup/src/view/auth/login_screen.dart';
import 'package:firebase_setup/src/widget/textfield_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final FirebaseAuthService _auth = FirebaseAuthService();
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late bool isPasswordVisible = true;
  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 25),
                  width: double.infinity,
                  height: 300,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/3.png"),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const Text(
                  "Sign-Up",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                TextFielWidget(
                  hintText: 'Username',
                  prefixIcon: Icons.person,
                  controller: usernameController,
                ),
                TextFielWidget(
                  hintText: "Email",
                  prefixIcon: Icons.email,
                  controller: emailController,
                ),
                TextFielWidget(
                  prefixIcon: Icons.lock_open_rounded,
                  hintText: 'Enter password',
                  hintPassword: isPasswordVisible,
                  controller: passwordController,
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        isPasswordVisible = !isPasswordVisible;
                      });
                    },
                    icon: Icon(isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off),
                  ),
                ),
                CupertinoButton(
                  color: Colors.blueAccent,
                  child: Text('Sign-Up'),
                  onPressed: () => _SignUp(),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _SignUp() async {
    String email = emailController.text;
    String password = passwordController.text;
    User? user = await _auth.createUserWithEmailAndPassword(
      email,
      password,
    );
    if (user!.getIdToken() != null) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
    } else {
      print("Sign-up failed");
    }
  }
}
