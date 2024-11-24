import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:myapp/models/userModel.dart';
import 'package:myapp/services/userService.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final UserService _userService = UserService();

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw Exception('Sign-in canceled by user');
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create credentials of firebase
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      if (userCredential.user == null) {
        throw Exception('Failed to sign in with Google');
      }

      await verifiAndSaveUser(userCredential.user!);

      return userCredential.user;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> verifiAndSaveUser(User user) async {
    try {
      if (user.email == null ||
          user.displayName == null ||
          user.photoURL == null) {
        throw Exception("User data is missing");
      }
      final UserModel? userModel = await _userService.findByEmail(user.email!);

      if (userModel != null) return;
      await _userService.postData(UserModel(
        displayName: user.displayName!,
        email: user.email!,
        avatarUrl: user.photoURL!,
      ));
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  Future<int?> getUserId() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      final UserModel? userModel = await _userService.findByEmail(user.email!);
      return userModel?.id;
    }
    return null;
  }

  Future<Map<String, String>> getUserData() async {
    final User? user = _auth.currentUser;
    if (user == null) {
      return {};
    }
    return {
      'displayName': user.displayName ?? '',
      'email': user.email ?? '',
      'photoUrl': user.photoURL ?? ''
    };
  }
}
