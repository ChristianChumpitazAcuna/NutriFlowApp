import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:myapp/auth/authService.dart';
import 'package:myapp/mainScreen.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _handleGoogleSignIn() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final user = await _authService.signInWithGoogle();
      if (!mounted) return;

      if (user != null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const MainScreen()),
        );
      }
    } catch (e, stackTrace) {
      print('Error: $e\nStackTrace: $stackTrace');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Container(
          height: 480,
          width: screenWidth - 60,
          decoration: BoxDecoration(
            color: Colors.white60,
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.5),
                blurRadius: 35,
                offset: const Offset(0, 10),
              ),
            ],
            border: Border.all(
              color: Colors.black.withOpacity(0.3),
              width: 1.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/icons/logo.svg',
                    width: 100,
                    height: 100,
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Bienvenido',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Inicia sesión para continuar',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 50),
              _isLoading
                  ? const CircularProgressIndicator(
                      color: Colors.black,
                    )
                  : const SizedBox(),
              ElevatedButton(
                onPressed: _handleGoogleSignIn,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  shadowColor: Colors.black,
                  elevation: 5,
                  // minimumSize: const Size(300, 50),
                ),
                child: const Text('Iniciar Sesión',
                    style: TextStyle(fontSize: 15, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
