import 'package:todo_list/helpers/globals.dart';
import 'package:cloud_firestore/cloud_firestore.dart' show FieldValue;

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

  void updateSubTaskInDB(String currDate, String taskId, updateField) {
    if (updateField.runtimeType == List<Map<String, Object>>) {
      firestore
          .collection("tasks")
          .doc(user)
          .collection(currDate)
          .doc(taskId)
          .update({"subtasks": FieldValue.arrayUnion(updateField)});
    } else if (updateField.runtimeType == bool) {
      firestore
          .collection("tasks")
          .doc(user)
          .collection(currDate)
          .doc(taskId)
          .update({"isDone": updateField});
    }
  }
}
