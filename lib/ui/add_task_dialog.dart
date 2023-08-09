import 'package:flutter/material.dart ';

class AddTask extends StatefulWidget {
  const AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  bool _isValid = true;
  TimeOfDay time = TimeOfDay.now();
  String currPri = "Moderate";
  var priority = {"Low": 65280, "Moderate": 16576515, "High": 16711680};
  TextEditingController subtaskController = TextEditingController();
  TextEditingController taskController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: Container(
            padding:
                const EdgeInsets.symmetric(vertical: 20.0, horizontal: 5.0),
            height: 300,
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
                      horizontal: 10.0, vertical: 15.0),
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
                        child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10.0),
                      padding: EdgeInsets.zero,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          border: Border.all(
                              color: Theme.of(context).colorScheme.primary)),
                      child: GestureDetector(
                        child: ListTile(
                          visualDensity: const VisualDensity(
                              horizontal: -4.0, vertical: -4.0),
                          leading: const Icon(
                            Icons.notifications_active_outlined,
                            size: 20.0,
                          ),
                          minLeadingWidth: 10,
                          title: Text(
                            time.format(context),
                            style: const TextStyle(fontSize: 16.0),
                          ),
                          onTap: () async {
                            final TimeOfDay? newTime = await showTimePicker(
                                context: context,
                                initialTime: time,
                                initialEntryMode: TimePickerEntryMode.dialOnly);
                            if (newTime != null) {
                              setState(() {
                                time = newTime;
                              });
                            }
                          },
                        ),
                      ),
                    )),
                    Flexible(
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
                          if (taskController.text.isNotEmpty) {
                            var task = {
                              "priority": priority[currPri],
                              "Due": time.format(context),
                              "task": taskController.text,
                              "isDone": false
                            };
                            Navigator.of(context).pop(task);
                          } else {
                            setState(() {
                              _isValid = false;
                            });
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
}
