import 'package:flutter/material.dart';
import '../models/task.dart';
import '../controllers/database_controller.dart';

class TaskController {
  static final titleController = TextEditingController();
  static final descriptionController = TextEditingController();
  static final _currentDateTime = DateTime.now();
  static late Future<List<Task>> tasks;

  static Future<List<Task>> getPendingTasks() {
    Future<List<Task>> pendingTasks = DatabaseController.getTasks();
    pendingTasks.then((value) {
      value.removeWhere((element) => element.status == 1);
    });
    return pendingTasks;
  }

  static Future<List<Task>> getDoneTasks() {
    Future<List<Task>> doneTasks = DatabaseController.getTasks();
    doneTasks.then((value) {
      value.removeWhere((element) => element.status == 0);
    });
    return doneTasks;
  }

  static void updateTaskStatus(taskId, todoTitle, todoDescription) {
    Task task = Task(
      id: taskId,
      title: todoTitle.toString().trim(),
      description: todoDescription.toString().trim(),
      date:
          "${_currentDateTime.day}/${_currentDateTime.month}/${_currentDateTime.year}",
      time: "${_currentDateTime.hour}:${_currentDateTime.minute}",
      status: 1,
    );
    DatabaseController.update(task, taskId)
        .then((value) => tasks = DatabaseController.getTasks());
  }

  static Future<void> addTask() async {
    Task task = Task(
      title: titleController.text,
      description: descriptionController.text,
      date:
          "${_currentDateTime.day}/${_currentDateTime.month}/${_currentDateTime.year}",
      time: "${_currentDateTime.hour}:${_currentDateTime.minute}",
      status: 0,
    );

    await DatabaseController.insert(task)
        .then((value) => tasks = DatabaseController.getTasks());
    titleController.clear();
    descriptionController.clear();
  }

  static void updateTask(taskId) {
    Task task = Task(
      id: taskId,
      title: titleController.text.toString().trim(),
      description: descriptionController.text.toString().trim(),
      date:
          "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
      time: "${DateTime.now().hour}:${DateTime.now().minute}",
      status: 0,
    );

    DatabaseController.update(task, taskId)
        .then((value) => tasks = DatabaseController.getTasks());
    titleController.clear();
    descriptionController.clear();
    // print("Task Updated Successfully");
  }
}
