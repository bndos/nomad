import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nomad/widgets/map/rounded_icon_button.dart';
import 'package:nomad/widgets/textfield/custom_text_field.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  SignUpPageState createState() => SignUpPageState();
}

class SignUpPageState extends State<SignUpPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _signUp() async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (e) {
      // Handle error
    }
  }

  Future<void> _signUpWithGoogle() async {
    // Implement Google Sign-Up logic
  }

  Future<void> _signUpWithFacebook() async {
    // Implement Facebook Sign-Up logic
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
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
                    onPressed: _signUpWithGoogle,
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
                    onPressed: _signUpWithFacebook,
                    isDisabled: false,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _signUp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 40),
                ),
                child: const Text('Sign Up'),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  if (!mounted) return;
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Already have an account? Sign In',
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
