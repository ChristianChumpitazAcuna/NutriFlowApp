import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:myapp/services/auth/authService.dart';
import 'package:myapp/services/notificationService.dart';
import 'package:myapp/widgets/navigationMenu.dart';
import 'package:toastification/toastification.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final AuthService _authService = AuthService();
  final NotificationService _notificationService = NotificationService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _handleGoogleSignIn(BuildContext context) async {
    try {
      setState(() {
        _isLoading = true;
      });

      await _authService.signInWithGoogle();
      if (context.mounted == false) return;

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const NavigationMenu()),
      );
    } catch (e) {
      _notificationService.showNotification(
          type: ToastificationType.error,
          context: context,
          message: 'Error al iniciar sesión');
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
        body: Stack(
          children: [
            Center(
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
                    ElevatedButton(
                      onPressed: _isLoading
                          ? null
                          : () {
                              _handleGoogleSignIn(context);
                            },
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
            if (_isLoading)
              Stack(
                children: [
                  Container(
                    color: Colors.black.withOpacity(0.5),
                    width: double.infinity,
                    height: double.infinity,
                  ),
                  // Widget de animación de carga
                  Center(
                    child: LoadingAnimationWidget.dotsTriangle(
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ],
              ),
          ],
        ));
  }
}
