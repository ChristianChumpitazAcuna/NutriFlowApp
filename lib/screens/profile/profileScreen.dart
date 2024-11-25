import 'package:flutter/material.dart';
import 'package:myapp/services/auth/authService.dart';
import 'package:myapp/screens/loginScreen.dart';
import 'package:myapp/screens/profile/widgets/userInfoWidget.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class UserData {
  final String displayName;
  final String email;
  final String photoUrl;

  UserData({
    required this.displayName,
    required this.email,
    required this.photoUrl,
  });
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  UserData? userData;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final user = await _authService.getUserData();
      setState(() {
        userData = UserData(
            displayName: user['displayName']!,
            email: user['email']!,
            photoUrl: user['photoUrl']!);
      });
    } catch (e) {
      rethrow;
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _handleLogout() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await _authService.signOut();
      if (!mounted) return;

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LogInScreen()),
      );
    } catch (e) {
      rethrow;
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (userData == null) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.black,
        body: Stack(children: [
          Column(
            children: [
              SizedBox(
                  height: screenHeight / 2,
                  width: screenWidth,
                  child: UserInfoWidget(
                      displayName: userData!.displayName,
                      email: userData!.email,
                      photoUrl: userData!.photoUrl)),
              Expanded(
                  child: Container(
                color: const Color.fromARGB(255, 12, 12, 12),
              ))
            ],
          ),
          Positioned(
              top: 25,
              right: 10,
              child: IconButton(
                onPressed: _showMenuOptions,
                icon: const Icon(Icons.more_vert_rounded),
                color: Colors.white,
              ))
        ]));
  }

  void _showMenuOptions() {
    WoltModalSheet.show(
        context: context,
        pageListBuilder: (context) => [
              WoltModalSheetPage(
                  backgroundColor: const Color.fromARGB(255, 32, 32, 32),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ListTile(
                          leading: const Icon(
                            Icons.settings,
                            color: Colors.white,
                          ),
                          title: const Text(
                            'Configuración',
                            style: TextStyle(color: Colors.white),
                          ),
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        ListTile(
                          leading: const Icon(
                            Icons.logout,
                            color: Colors.white,
                          ),
                          title: const Text(
                            'Cerrar sesión',
                            style: TextStyle(color: Colors.white),
                          ),
                          onTap: () {
                            Navigator.of(context).pop();
                            _handleLogout();
                          },
                        ),
                      ]))
            ]);
  }
}
