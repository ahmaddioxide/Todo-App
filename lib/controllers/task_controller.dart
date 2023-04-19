import 'package:flutter/material.dart';
import 'package:todo_app/models/db_helper_tasks.dart';
import 'package:todo_app/models/task.dart';
import 'package:get/get.dart';

class TaskController  {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  DBHelper? dbHelper;
  late Future<List<Task>> tasks;
  Stream<List<Task>>? streamTasks;



  Future<void> showTaskInput(context) async {
    return showDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Add New Task"),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                        hintText: "Enter Task Title",
                        labelText: "Task Title",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        )),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: descriptionController,
                    keyboardType: TextInputType.multiline,
                    minLines: 1,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      hintText: "Enter Task Description",
                      labelText: "Task Description",
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 30, horizontal: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              Container(
                  decoration: const BoxDecoration(
                    color: Colors.pink,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: const Icon(Icons.close))),
              Container(
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                      onPressed: () {
                        addTask();
                        Get.back();
                        Get.snackbar("Added", "Task Added Successfully",
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.green,
                            colorText: Colors.white);
                      },
                      icon: const Icon(Icons.add))),
            ],
          );
        });
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
    print("Task Added Successfully");
  }

  doneTask(taskId) {
    var task = Task(
      id: taskId,
      title: titleController.text.toString().trim(),
      description: descriptionController.text.toString().trim(),
      date:
          "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
      time: "${DateTime.now().hour}:${DateTime.now().minute}",
      status: 1,
    );

    dbHelper!.update(task, taskId);
    tasks = dbHelper!.getTasks();
    titleController.clear();
    descriptionController.clear();
    print("Task Updated Successfully");
  }

  updateTask(taskId){
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
    print("Task Updated Successfully");
  }

  Future<void> promtUpdateTask(context,taskId,title,description) async {
    titleController.text = title;
    descriptionController.text = description;
    return showDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Update Task"),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                        hintText: "Enter Task Title",
                        labelText: "Task Title",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        )),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: descriptionController,
                    keyboardType: TextInputType.multiline,
                    minLines: 1,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      hintText: "Enter Task Description",
                      labelText: "Task Description",
                      contentPadding:
                      EdgeInsets.symmetric(vertical: 30, horizontal: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              Container(
                  decoration: const BoxDecoration(
                    color: Colors.pink,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: const Icon(Icons.close))),
              Container(
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                      onPressed: () {
                        updateTask(taskId);
                        Get.back();
                      },
                      icon: const Icon(Icons.add))),
            ],
          );
        });
  }
}
