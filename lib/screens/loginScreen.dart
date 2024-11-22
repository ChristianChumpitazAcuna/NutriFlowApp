import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/auth/authService.dart';
import 'package:myapp/mainScreen.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton.icon(
          icon: const Icon(Icons.login),
          label: const Text('Sign in with Google'),
          onPressed: () async {
            final UserCredential result =
                await _authService.signInWithGoogle();
            if (result != null) {
              // ignore: avoid_print
              print('User signed in: ${result.user?.displayName}');
              // Navigator.pushReplacement(
              //   context,
              //   MaterialPageRoute(builder: (context) => const MainScreen()),
              // );
            } else {
              // ignore: avoid_print
              print('Sign in failed');
            }
          },
        ),
      ),
    );
  }
}
