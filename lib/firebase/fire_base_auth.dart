import 'package:logger/logger.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
// ignore: depend_on_referenced_packages

class FireAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final Logger _logger = Logger();

  Future<void> signUp(
      String email, String pass, String name, String phone) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: pass,
      );
      User? user = userCredential.user;

      if (user != null) {
        await _createUser(user.uid, name, phone);
        _logger.i('User created: ${user.uid}');
      } else {
        _logger.w('User creation failed');
      }
    } catch (error) {
      _logger.e('Sign up error: $error');
      // Handle specific error codes here if necessary
    }
  }

  Future<void> _createUser(String userId, String name, String phone) async {
    var user = {
      "name": name,
      "phone": phone,
    };
    var ref = FirebaseDatabase.instance.ref().child("users");

    try {
      await ref.child(userId).set(user);
      _logger.i('User data stored for $userId');
    } catch (error) {
      _logger.e('Database error: $error');
      // Handle specific error codes here if necessary
    }
  }
}
