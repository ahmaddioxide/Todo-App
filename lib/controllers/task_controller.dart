import 'package:flutter/material.dart';
import 'package:todo_app/controllers/database_controller.dart';
import 'package:todo_app/models/task.dart';

class TaskController {
  // TODO: UI Cpde should not be used in the Bussiness logic and vice versa.
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  DatabaseController? databaseController;
  late Future<List<Task>> tasks;

  Future<List<Task>> getPendingTasks() {
    var pendingTasks = databaseController!.getTasks(); // TODO: Avoid to use the var keyword whereever possible. Follow proper data types 
    pendingTasks.then((value) {
      value.removeWhere((element) => element.status == 1);
    });
    return pendingTasks; // TODO: remove unnessary type casting.
  }

  Future<List<Task>> getDoneTasks() {
    var doneTasks = databaseController!.getTasks();
    doneTasks.then((value) {
      value.removeWhere((element) => element.status == 0);
    });
    return doneTasks;  // TODO: remove unnessary type casting.
  }

  updateTaskStatus(taskId, todoTitle, todoDescription) {  // TODO: Always define your function return types
    // TODO: Make it locallize or globalize If a constant value using again and gain i.e. DateTime.now() can be defined locally to this function
   
    var task = Task(
      id: taskId,
      title: todoTitle.toString().trim(),
      description: todoDescription.toString().trim(),
      date:
          "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
      time: "${DateTime.now().hour}:${DateTime.now().minute}",
      status: 1,
    );
    databaseController!.update(task, taskId); // TODO: Use async await keywords to explain the language compiler about asynchronous operations
    tasks = databaseController!.getTasks();
  }

  addTask() {  // TODO: Always define your function return types 
        // TODO: Make it locallize or globalize If a constant value using again and gain i.e. DateTime.now() can be defined locally to this function

    var task = Task(
      title: titleController.text,
      description: descriptionController.text,
      date:
          "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
      time: "${DateTime.now().hour}:${DateTime.now().minute}",
      status: 0,
    );

    databaseController!.insert(task);  // TODO: Use async await keywords to explain the language compiler about asynchronous operations
    tasks = databaseController!.getTasks();
    titleController.clear();
    descriptionController.clear();
    // print("Task Added Successfully");
  }

  updateTask(taskId) { // TODO: Always define your function return types
        // TODO: Make it locallize or globalize If a constant value using again and gain i.e. DateTime.now() can be defined locally to this function
 
    var task = Task(
      id: taskId,
      title: titleController.text.toString().trim(),
      description: descriptionController.text.toString().trim(),
      date:
          "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
      time: "${DateTime.now().hour}:${DateTime.now().minute}",
      status: 0,
    );

    databaseController!.update(task, taskId);
    tasks = databaseController!.getTasks();
    titleController.clear();
    descriptionController.clear();
    descriptionController.clear();
    // print("Task Updated Successfully");
  }
}
