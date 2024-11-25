import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:myapp/models/userModel.dart';
import 'package:myapp/services/userService.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final UserService _userService = UserService();

  Future<User> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) throw Exception('Sign-in canceled by user');

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      if (googleAuth.accessToken == null || googleAuth.idToken == null) {
        throw Exception('Google sign-in failed');
      }

      // Create credentials of firebase
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      final User? user = userCredential.user;

      if (user == null) throw Exception('User is null');

      await verifiAndSaveUser(user);

      return user;
    } catch (e) {
      print('Error al iniciar sesión con Google: $e');
      throw Exception("Error: $e");
    }
  }

  Future<void> verifiAndSaveUser(User user) async {
    try {
      if (!_validateUserData(user)) return;

      final UserModel? existingUser =
          await _userService.findByEmail(user.email!);

      if (existingUser != null) {
        print('Usuario ya existente: ${existingUser.email}');
        return;
      }

      final newUser = UserModel(
          displayName: user.displayName!,
          avatarUrl: user.photoURL!,
          email: user.email!);

      final userSaved = await _userService.postData(newUser);
      print('Usuario guardado con éxito: $userSaved');
    } catch (e) {
      print('Error al verificar y guardar usuario: $e');
      throw Exception("Error: $e");
    }
  }

  Future<void> signOut() async {
    try {
      await Future.wait([_googleSignIn.signOut(), _auth.signOut()]);
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  Future<int> getUserId() async {
    try {
      final User? user = _auth.currentUser;

      if (user == null || user.email == null) {
        throw Exception('User no logged in');
      }

      final UserModel? userModel = await _userService.findByEmail(user.email!);

      if (userModel!.id == null && userModel.id! >= 0) {
        throw Exception('User not found');
      }

      return userModel.id!;
    } catch (e) {
      print('Error al obtener el ID del usuario: $e');
      throw Exception("Error: $e");
    }
  }

  Future<Map<String, String>> getUserData() async {
    try {
      final User? user = _auth.currentUser;
      if (user == null) throw Exception('User no logged in');
      return {
        'displayName': user.displayName ?? '',
        'email': user.email ?? '',
        'photoUrl': user.photoURL ?? ''
      };
    } catch (e) {
      print('Error al obtener datos del usuario: $e');
      throw Exception("Error: $e");
    }
  }

  bool _validateUserData(User user) {
    return user.email != null &&
        user.email!.isNotEmpty &&
        user.displayName != null &&
        user.displayName!.isNotEmpty &&
        user.photoURL != null &&
        user.photoURL!.isNotEmpty;
  }
}
