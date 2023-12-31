///TODO
///Optimize calls to firestore

import 'package:todo_list/helpers/globals.dart';

class Database {
  late String user;
  Function(List<Map>) addTasks;
  List<Map> tasks = [];

  Database(this.user, this.addTasks);

  Future getTasksFromDb(currDate) async {
    tasks.clear();
    Future fut = firestore
        .collection("tasks")
        .doc(user)
        .collection(currDate)
        .get()
        .then((value) => {
              value.docs.forEach((element) {
                tasks.add(element.data());
              })
            });
    addTasks(tasks);
    return fut;
  }

  void addTaskToDB(newTask, currDate) {
    if (newTask != null) {
      firestore
          .collection("tasks")
          .doc(user)
          .collection(currDate)
          .doc(newTask["task"])
          .set(newTask);
    }
  }

  void deleteTaskFromDB(String id, String date) {
    firestore.collection("tasks").doc(user).collection(date).doc(id).delete();
  }

  void setIsDone(String currDate, String taskId, bool isDone) {
    firestore
        .collection("tasks")
        .doc(user)
        .collection(currDate)
        .doc(taskId)
        .update({"isDone": isDone});
  }
}
