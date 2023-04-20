import 'package:flutter/material.dart';
import 'package:todo_app/models/db_helper_tasks.dart';
import 'package:todo_app/models/task.dart';

class TaskController {

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  DBHelper? dbHelper;
  late Future<List<Task>> tasks;



  Future<List<Task>> getPendingTasks() {
    var pendingTasks = dbHelper!.getTasks();
    pendingTasks.then((value) {
      value.removeWhere((element) => element.status == 1);
    });
    return pendingTasks as Future<List<Task>>;
  }

  Future<List<Task>> getDoneTasks() {
    var doneTasks = dbHelper!.getTasks();
    doneTasks.then((value) {
      value.removeWhere((element) => element.status == 0);
    });
    return doneTasks as Future<List<Task>>;
  }

  updateTaskStatus(taskId, todoTitle, todoDescription) {
      var task = Task(
        id: taskId,
        title: todoTitle.toString().trim(),
        description: todoDescription.toString().trim(),
        date:
        "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
        time: "${DateTime.now().hour}:${DateTime.now().minute}",
        status: 1,
      );
      dbHelper!.update(task, taskId);
      tasks = dbHelper!.getTasks();

  }


  addTask() {
    var task = Task(
      title: titleController.text,
      description: descriptionController.text,
      date:
          "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
      time: "${DateTime.now().hour}:${DateTime.now().minute}",
      status: 0,
    );

    dbHelper!.insert(task);
    tasks = dbHelper!.getTasks();
    titleController.clear();
    descriptionController.clear();
    // print("Task Added Successfully");
  }



  updateTask(taskId) {
    var task = Task(
      id: taskId,
      title: titleController.text.toString().trim(),
      description: descriptionController.text.toString().trim(),
      date:
          "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
      time: "${DateTime.now().hour}:${DateTime.now().minute}",
      status: 0,
    );

    dbHelper!.update(task, taskId);
    tasks = dbHelper!.getTasks();
    titleController.clear();
    descriptionController.clear();
    descriptionController.clear();
    // print("Task Updated Successfully");
  }

}
