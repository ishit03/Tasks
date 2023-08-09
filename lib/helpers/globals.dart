import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

late final FirebaseAuth firebaseAuth;
late final FirebaseFirestore firestore;
late final SharedPreferences prefs;

Future<void> initializeGlobals() async {
  firebaseAuth = FirebaseAuth.instance;
  firestore = FirebaseFirestore.instance;
  prefs = await SharedPreferences.getInstance();
}
