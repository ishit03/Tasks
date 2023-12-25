import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:todo_list/Theme.dart';
import 'package:todo_list/firebase_options.dart';
import 'package:todo_list/helpers/globals.dart';
import 'package:todo_list/ui/home_page.dart';
import 'package:todo_list/ui/log_in.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initializeGlobals();
  await Permission.notification.isDenied.then((value) => {
        if (value) {Permission.notification.request()}
      });
  await notifService.initializeNotifications();
  runApp(const ToDo());
}

class ToDo extends StatefulWidget {
  const ToDo({super.key});

  @override
  State<ToDo> createState() => _ToDoState();

  static _ToDoState of(BuildContext context) =>
      context.findAncestorStateOfType<_ToDoState>()!;
}

class _ToDoState extends State<ToDo> {
  ToDoTheme theme = ToDoTheme();
  bool? prefTheme;
  ThemeMode? mode;
  String? user;

  _ToDoState() {
    prefTheme = prefs.getBool("isDark") ?? true;
    mode = (prefTheme!) ? ThemeMode.dark : ThemeMode.light;
    user = prefs.getString("user");
    ToDoTheme.setPrefTheme(prefTheme!);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ToDoTheme.lightTheme,
      darkTheme: ToDoTheme.darkTheme,
      themeMode: mode,
      home: (user != null)
          ? HomePage(user: user.toString())
          : const LogIn(
              email: '',
            ),
      navigatorObservers: [FlutterSmartDialog.observer],
      builder: FlutterSmartDialog.init(),
      debugShowCheckedModeBanner: false,
    );
  }

  void changeTheme(ThemeMode mode) {
    setState(() {
      this.mode = mode;
    });
  }
}
