import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:material_duration_picker/material_duration_picker.dart';
import 'package:myapp/firebase_options.dart';
import 'package:myapp/mainScreen.dart';
import 'package:myapp/screens/loginScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.android);
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<User?> _checkCurrentUser() async {
    final User? currentUser = FirebaseAuth.instance.currentUser;

    print(currentUser);
    return currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        localizationsDelegates: const [
          DefaultDurationPickerMaterialLocalizations.delegate
        ],
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primaryColor: Colors.grey,
        ),
        home: FutureBuilder(
          future: _checkCurrentUser(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasData && snapshot.data != null) {
              return const MainScreen();
            } else {
              return const LogInScreen();
            }
          },
        ));
  }
}
