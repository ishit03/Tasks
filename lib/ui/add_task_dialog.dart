import 'dart:math';

import 'package:flutter/material.dart ';
import 'package:intl/intl.dart';

class AddTask extends StatefulWidget {
  final DateTime datetime;
  const AddTask({super.key, required this.datetime});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> with TickerProviderStateMixin {
  bool isValidTime = true;
  bool _isValid = true;
  TimeOfDay time = TimeOfDay.now();
  String currPri = "Moderate";
  var priority = {"Low": 65280, "Moderate": 16576515, "High": 16711680};
  TextEditingController subtaskController = TextEditingController();
  TextEditingController taskController = TextEditingController();
  late final controller = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 500));

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: Container(
            padding:
                const EdgeInsets.symmetric(vertical: 20.0, horizontal: 5.0),
            height: 320,
            decoration:
                BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Align(
                  alignment: Alignment.center,
                  child: Text(
                    'New Task',
                    style: TextStyle(fontSize: 30.0),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 30.0),
                  child: TextField(
                      controller: taskController,
                      maxLines: 2,
                      minLines: 1,
                      decoration: InputDecoration(
                        prefixIconConstraints: const BoxConstraints(
                            maxHeight: 20.0, minWidth: 20.0),
                        prefixIcon: const Padding(
                            padding: EdgeInsets.only(right: 10.0, left: 10.0),
                            child: Icon(
                              Icons.edit,
                              size: 20.0,
                            )),
                        contentPadding: const EdgeInsets.all(5.0),
                        labelText: 'Task',
                        errorText: !_isValid ? "Task cannot be empty" : null,
                        errorBorder: !_isValid
                            ? const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red))
                            : null,
                      )),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                        flex: 2,
                        child: AnimatedBuilder(
                            animation: controller,
                            child: Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              padding: EdgeInsets.zero,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  border: Border.all(
                                      color: (isValidTime)
                                          ? Theme.of(context)
                                              .colorScheme
                                              .primary
                                          : Colors.red)),
                              child: GestureDetector(
                                child: ListTile(
                                  visualDensity: const VisualDensity(
                                      horizontal: -4.0, vertical: -4.0),
                                  leading: Icon(
                                    Icons.notifications_active_outlined,
                                    size: 20.0,
                                    color: (isValidTime)
                                        ? Theme.of(context).hintColor
                                        : Theme.of(context).colorScheme.error,
                                  ),
                                  minLeadingWidth: 10,
                                  title: Text(
                                    time.format(context),
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        color: (isValidTime)
                                            ? Theme.of(context).hintColor
                                            : Theme.of(context)
                                                .colorScheme
                                                .error),
                                  ),
                                  onTap: () async {
                                    final TimeOfDay? newTime =
                                        await showTimePicker(
                                            context: context,
                                            initialTime: time,
                                            initialEntryMode:
                                                TimePickerEntryMode.dialOnly);
                                    if (newTime != null) {
                                      setState(() {
                                        time = newTime;
                                      });
                                    }
                                  },
                                ),
                              ),
                            ),
                            builder: (context, child) {
                              final sinevalue =
                                  sin(2 * 2 * pi * controller.value);
                              return Transform.translate(
                                offset: Offset(sinevalue * 10, 0),
                                child: child,
                              );
                            })),
                    Flexible(
                        flex: 2,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: DropdownButton(
                              isDense: true,
                              isExpanded: true,
                              value: currPri,
                              items: priority.keys.map((item) {
                                return DropdownMenuItem(
                                    value: item, child: Text(item));
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  currPri = value as String;
                                });
                              }),
                        )),
                  ],
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'Cancel',
                          style: TextStyle(fontSize: 20.0),
                        )),
                    TextButton(
                        onPressed: () {
                          if (taskController.text.isEmpty) {
                            setState(() {
                              _isValid = false;
                            });
                          } else if (!validateTime(time)) {
                            controller.forward(from: 0.0);
                            setState(() {
                              _isValid = true;
                              isValidTime = false;
                            });
                          } else {
                            Map<String, dynamic> task = {
                              "priority": priority[currPri],
                              "hour": time.hour,
                              "minute": time.minute,
                              "Due": time.format(context),
                              "task": taskController.text,
                              "isDone": false,
                              "id": generateId()
                            };
                            Navigator.of(context).pop(task);
                          }
                        },
                        child: const Text(
                          'Add',
                          style: TextStyle(fontSize: 20.0),
                        )),
                  ],
                )
              ],
            )));
  }

  int generateId() =>
      int.parse(DateFormat("ddHms").format(DateTime.now()).replaceAll(":", ""));

  bool validateTime(TimeOfDay time) {
    DateTime now = DateTime.now();
    return DateTime(widget.datetime.year, widget.datetime.month,
            widget.datetime.day, time.hour, time.minute)
        .isAfter(now);
  }
}
