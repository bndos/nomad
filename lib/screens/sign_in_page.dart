import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nomad/widgets/map/rounded_icon_button.dart';
import 'package:nomad/widgets/textfield/custom_text_field.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  SignInPageState createState() => SignInPageState();
}

class SignInPageState extends State<SignInPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _signIn() async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      // Navigate to home page or handle successful sign in
    } catch (e) {
      // Handle error
    }
  }

  Future<void> _signInWithGoogle() async {
    // Implement Google Sign-In logic
  }

  Future<void> _signInWithFacebook() async {
    // Implement Facebook Sign-In logic
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/icons/tipi.png', // Your custom PNG icon
              width: 100, // Adjust the width as needed
              height: 100, // Adjust the height as needed
            ),
            const SizedBox(height: 32), // Space between icon and text field
            CustomTextField(
              controller: _emailController,
              label: 'Email',
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 24),
            CustomTextField(
              controller: _passwordController,
              label: 'Password',
              obscureText: true,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RoundedIconButton(
                  iconColor: Colors.white,
                  icon: FontAwesomeIcons.google,
                  containerColor: Colors.red,
                  label: '',
                  height: 44,
                  width: 44,
                  expanded: false,
                  radius: 30,
                  onPressed: _signInWithGoogle,
                  isDisabled: false,
                ),
                RoundedIconButton(
                  iconColor: Colors.white,
                  icon: FontAwesomeIcons.facebookF,
                  containerColor: Colors.blue,
                  label: '',
                  height: 44,
                  width: 44,
                  expanded: false,
                  radius: 30,
                  onPressed: _signInWithFacebook,
                  isDisabled: false,
                ),
              ],
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _signIn,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 40),
              ),
              child: const Text('Sign In'),
            ),
            const SizedBox(height: 12),
            const Text('or'),
            TextButton(
              onPressed: () {
                // Navigate to sign up page
              },
              child: const Text(
                'Sign Up',
                style: TextStyle(
                  color: Colors.blue, // Adjust the color as needed
                  decoration: TextDecoration
                      .underline, // Underline to make it look like a link
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
