import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_list/helpers/notification_service.dart';

late final FirebaseAuth firebaseAuth;
late final FirebaseFirestore firestore;
late final SharedPreferences prefs;
late final NotifService notifService;

Future<void> initializeGlobals() async {
  firebaseAuth = FirebaseAuth.instance;
  firestore = FirebaseFirestore.instance;
  prefs = await SharedPreferences.getInstance();
  notifService = NotifService();
}
