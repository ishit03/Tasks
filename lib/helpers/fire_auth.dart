import 'package:firebase_auth/firebase_auth.dart'
    show User, UserCredential, FirebaseAuthException;
import 'package:todo_list/helpers/globals.dart';

class FireAuth {
  static Future<User?> registerUsingEmailPassword({
    required String name,
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
    } catch (e) {}

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
    } on FirebaseAuthException catch (e) {
    } catch (e) {}
    return user;
  }
}
