import 'package:flutter/material.dart';
import 'package:todo_list/helpers/globals.dart';

class TasksListView extends StatefulWidget {
  final List<Map> tasks;
  final Function setIsDone;
  final Function(String id, String date) deleteTask;
  final String currDate;

  const TasksListView(
      {super.key,
      required this.tasks,
      required this.currDate,
      required this.setIsDone,
      required this.deleteTask});

  @override
  State<TasksListView> createState() => _TasksListViewState();
}

class _TasksListViewState extends State<TasksListView> {
  bool isChecked = false;
  double maxWidthOfRow = 0;
  @override
  Widget build(BuildContext context) {
    widget.tasks.sort((a, b) => (b["priority"].compareTo(a["priority"])));
    return ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: widget.tasks.length,
        itemBuilder: (BuildContext context, int index) {
          return Dismissible(
            key: Key(widget.tasks[index]["task"]),
            direction: DismissDirection.endToStart,
            background: Container(
                height: 60,
                margin: const EdgeInsets.symmetric(
                    horizontal: 15.0, vertical: 10.0),
                child: const Card(
                  color: Colors.redAccent,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [Text('Delete Task'), Icon(Icons.delete_outline)],
                  ),
                )),
            onDismissed: (val) {
              widget.deleteTask(widget.tasks[index]["task"], widget.currDate);
              notifService.cancelNotification(widget.tasks[index]["id"]);
              setState(() {
                widget.tasks.removeAt(index);
              });

              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: const Text('Task was removed'),
                backgroundColor:
                    Theme.of(context).snackBarTheme.backgroundColor,
              ));
            },
            child: Container(
              height: 60,
              margin:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              child: GestureDetector(
                  onLongPress: () {
                    setState(() {
                      widget.tasks[index]["isDone"] = true;
                      widget.setIsDone(
                          widget.currDate, widget.tasks[index]["task"], true);
                      notifService
                          .cancelNotification(widget.tasks[index]["id"]);
                    });
                  },
                  child: Card(
                      surfaceTintColor:
                          Theme.of(context).cardTheme.surfaceTintColor,
                      shadowColor: Theme.of(context).cardTheme.shadowColor,
                      elevation: 1.0,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ConstrainedBox(
                                constraints:
                                    const BoxConstraints(maxWidth: 300),
                                child: LayoutBuilder(
                                    builder: (context, constraints) {
                                  maxWidthOfRow = constraints.maxWidth;
                                  return ConstrainedBox(
                                      constraints: BoxConstraints(
                                          maxWidth: maxWidthOfRow),
                                      child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 20.0),
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                    widget.tasks[index]["task"],
                                                    softWrap: false,
                                                    maxLines: 3,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontSize: 18.0,
                                                      color: (widget
                                                                  .tasks[index]
                                                              ["isDone"])
                                                          ? Theme.of(context)
                                                              .primaryColor
                                                          : Theme.of(context)
                                                              .colorScheme
                                                              .onBackground,
                                                    )),
                                                Text(
                                                    "Remind at ${widget.tasks[index]["Due"]}",
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                      fontSize: 10.0,
                                                      color: (widget
                                                                  .tasks[index]
                                                              ["isDone"])
                                                          ? Theme.of(context)
                                                              .primaryColor
                                                          : Theme.of(context)
                                                              .colorScheme
                                                              .onBackground,
                                                    ))
                                              ])));
                                })),
                            const Spacer(),
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 2.0),
                              width: 2.0,
                              color: Color.fromARGB(
                                  (widget.tasks[index]["priority"] == 0)
                                      ? 0
                                      : 255,
                                  widget.tasks[index]["priority"] >> 16 & 0xff,
                                  widget.tasks[index]["priority"] >> 8 & 0xff,
                                  widget.tasks[index]["priority"] & 0xff),
                            )
                          ]))),
            ),
          );
        });
  }
}
