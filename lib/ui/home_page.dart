import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:todo_list/Theme.dart';
import 'package:todo_list/main.dart';
import 'package:todo_list/ui/list_view.dart';

import '../helpers/firestore_helper.dart';
import '../helpers/globals.dart';
import 'add_task_dialog.dart';
import 'log_in.dart';

class HomePage extends StatefulWidget {
  final String user;

  const HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool swiped = false;
  bool? currentTheme;
  String currDate = DateFormat("yyyyMMdd").format(DateTime.now());

  late DateTime datetime;
  List<Map> tasks = [];
  late Database db = Database(widget.user, addTasks);
  late Future getTasks = db.getTasksFromDb(currDate);

  _HomePageState() {
    datetime = DateTime.parse(currDate);
    currentTheme = prefs.getBool("isDark") ?? true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tasks',
          style: TextStyle(fontFamily: GoogleFonts.viga().fontFamily),
        ),
        actions: <Widget>[
          IconButton(
              onPressed: () {
                (currentTheme!)
                    ? ToDo.of(context).changeTheme(ThemeMode.light)
                    : ToDo.of(context).changeTheme(ThemeMode.dark);
                ToDoTheme.switchTheme();
                setState(() {
                  currentTheme = ToDoTheme.isDark;
                });
                prefs.setBool("isDark", currentTheme!);
              },
              icon: Icon((currentTheme!)
                  ? Icons.light_mode_outlined
                  : Icons.dark_mode_outlined)),
          IconButton(
              onPressed: () async {
                SmartDialog.showLoading(
                    msg: 'Signing Out..',
                    animationType: SmartAnimationType.centerScale_otherSlide,
                    maskColor: const Color.fromRGBO(255, 255, 255, 0.3));
                await firebaseAuth.signOut();
                prefs.remove("user");
                SmartDialog.dismiss();
                if (context.mounted) {
                  Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                          pageBuilder: (_, __, ___) => const LogIn(email: ''),
                          transitionDuration: const Duration(milliseconds: 500),
                          transitionsBuilder: (_, a, __, c) => SlideTransition(
                                position: Tween(
                                        begin: const Offset(0.0, -1.0),
                                        end: Offset.zero)
                                    .animate(CurvedAnimation(
                                        parent: a, curve: Curves.ease)),
                                child: c,
                              )));
                }
              },
              icon: const Icon(
                Icons.logout,
              ))
        ],
      ),
      body: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onHorizontalDragStart: (val) {
            swiped = false;
          },
          onHorizontalDragUpdate: (update) {
            if (update.delta.dx < -10 && !swiped) {
              //left swipe
              swiped = true;
              datetime = datetime.add(const Duration(days: 1));
            } else if (update.delta.dx > 10 && !swiped) {
              //right swipe
              swiped = true;
              datetime = datetime.subtract(const Duration(days: 1));
            }
          },
          onHorizontalDragEnd: (val) {
            if (swiped) {
              setState(() {
                currDate = DateFormat("yyyyMMdd").format(datetime);
                getTasks = db.getTasksFromDb(currDate);
              });
            }
            //print(currDate);
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                      onPressed: () {
                        setState(() {
                          datetime = datetime.subtract(const Duration(days: 1));
                          currDate = DateFormat("yyyyMMdd").format(datetime);
                          getTasks = db.getTasksFromDb(currDate);
                        });
                      },
                      icon: const Icon(
                        Icons.arrow_left_sharp,
                        size: 30.0,
                      )),
                  Text(
                    displayString(datetime),
                    style: const TextStyle(fontSize: 16.0),
                  ),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          datetime = datetime.add(const Duration(days: 1));
                          currDate = DateFormat("yyyyMMdd").format(datetime);
                          getTasks = db.getTasksFromDb(currDate);
                        });
                      },
                      icon: const Icon(
                        Icons.arrow_right_sharp,
                        size: 30.0,
                      )),
                ],
              ),
              FutureBuilder(
                  future: getTasks,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 50.0),
                          child: CircularProgressIndicator());
                    } else if (tasks.isNotEmpty) {
                      return Expanded(
                          child: TasksListView(
                              tasks: tasks,
                              currDate: currDate,
                              setIsDone: db.setIsDone,
                              deleteTask: db.deleteTaskFromDB));
                    } else {
                      return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 50.0),
                          child: Text("There are no tasks today... :("));
                    }
                  }),
            ],
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Map<String, dynamic>? newTask = await showDialog(
              context: context,
              builder: (context) {
                return AddTask(
                  datetime: datetime,
                );
              },
              barrierDismissible: false);
          if (newTask != null) {
            notifService.scheduleNotification(
                date: datetime,
                hour: newTask["hour"],
                minute: newTask["minute"],
                id: newTask["id"],
                task: newTask["task"]);
            newTask.remove("hour");
            newTask.remove("minute");

            db.addTaskToDB(newTask, currDate);
            setState(() {
              tasks.add(newTask);
            });
          }
        },
        child: const Icon(
          Icons.add_outlined,
          size: 25.0,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  void addTasks(dbtasks) {
    tasks = dbtasks;
  }

  String displayString(DateTime date) {
    final DateTime dt = DateTime.now();
    final int difference = DateTime(date.year, date.month, date.day)
        .difference(DateTime(dt.year, dt.month, dt.day))
        .inDays;
    if (difference == 0) {
      return "Today";
    } else if (difference == -1) {
      return "Yesterday";
    } else if (difference == 1) {
      return "Tomorrow";
    } else {
      return DateFormat("dd/MM/yyyy").format(date).toString();
    }
  }
}
