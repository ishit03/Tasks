import 'package:firebase_auth/firebase_auth.dart'
    show User, UserCredential, FirebaseAuthException;
import 'package:todo_list/helpers/globals.dart';

class FireAuth {
  static String errorCode = "";

  static Future<User?> registerUsingEmailPassword({
    required String email,
    required String password,
  }) async {
    User? user;
    try {
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      user = userCredential.user;
      user = firebaseAuth.currentUser;
    } on FirebaseAuthException catch (e) {
      errorCode = e.code.replaceAll("-", " ");
    }

    return user;
  }

  static Future<User?> signInUsingEmailPassword({
    required String email,
    required String password,
  }) async {
    User? user;
    try {
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      user = userCredential.user;
      if (!userCredential.user!.emailVerified) {
        throw FirebaseAuthException(code: 'Email is not verified');
      }
    } on FirebaseAuthException catch (e) {
      errorCode = e.code.replaceAll("-", " ");
    }
    return user;
  }
}
