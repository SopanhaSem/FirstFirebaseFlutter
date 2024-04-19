import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_setup/src/firebase_auth_implementation/firebase_auth_service.dart';
import 'package:firebase_setup/src/view/auth/homescreen.dart';
import 'package:firebase_setup/src/view/auth/signup_screen.dart';
import 'package:firebase_setup/src/widget/textfield_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late bool isHintPassword = true;
  final FirebaseAuthService _auth = FirebaseAuthService();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  @override
  void dispose() {
    emailcontroller.dispose();
    passwordcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          // physics: NeverScrollableScrollPhysics(),
          children: [
            Column(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 25),
                  width: double.infinity,
                  height: 300,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/3.png"), fit: BoxFit.contain),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Login",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    TextFielWidget(
                      prefixIcon: Icons.email,
                      hintText: 'Enter E-mail',
                      controller: emailcontroller,
                    ),
                    TextFielWidget(
                      controller: passwordcontroller,
                      prefixIcon: Icons.lock_open_rounded,
                      hintText: 'Enter password',
                      hintPassword: isHintPassword,
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              isHintPassword = !isHintPassword;
                            });
                          },
                          icon: Icon(isHintPassword
                              ? Icons.visibility
                              : Icons.visibility_off)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CupertinoButton(
                          color: Colors.blueAccent,
                          child: const Text('Sign In'),
                          onPressed: () {
                            loginUser();
                          }),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "You don't have account?",
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignUpScreen()));
                          },
                          child: Text("Create account"),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 100),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            onTap: () {},
                            child: const CircleAvatar(
                              child: Icon(
                                Icons.facebook,
                                size: 40,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              // // Trigger the authentication flow
                              // final GoogleSignInAccount? googleUser =
                              //     await GoogleSignIn().signIn();

                              // // Obtain the auth details from the request
                              // final GoogleSignInAuthentication? googleAuth =
                              //     await googleUser?.authentication;

                              // // Create a new credential
                              // final credential = GoogleAuthProvider.credential(
                              //   accessToken: googleAuth?.accessToken,
                              //   idToken: googleAuth?.idToken,
                              // );
                              // var userCredentail = await FirebaseAuth.instance
                              //     .signInWithCredential(credential);
                              // if (userCredentail != null) {
                              //   // ignore: use_build_context_synchronously
                              //   Navigator.pushAndRemoveUntil(
                              //       context,
                              //       MaterialPageRoute(
                              //           builder: (context) => HomeScreen()),
                              //       (route) => false);
                              // }
                            },
                            child: const CircleAvatar(
                              child: Icon(
                                Icons.language,
                                size: 40,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void loginUser() async {
    User? user = await _auth.signInWithEmailAndPassword(
        emailcontroller.text, passwordcontroller.text);
    if (user != null) {
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => HomeScreen()),
      // );
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
          (route) => false);
    } else {
      print("Login failed");
    }
  }
}
