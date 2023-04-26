import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/controllers/database_controller.dart';
import 'package:todo_app/views/done_tasks_screen.dart';
import '../controllers/task_controller.dart';

class PendingTasksScreen extends StatefulWidget {
  const PendingTasksScreen({super.key});

  @override
  State<PendingTasksScreen> createState() => _PendingTasksScreenState();
}

class _PendingTasksScreenState extends State<PendingTasksScreen> {
  //TODO: All Global variables and funcions must be private. So, that dart compiler can notify to you about unsed / dead code. 
  final taskController = TaskController(); 
  final newFormKey = GlobalKey<FormState>();
  final updateFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    taskController.databaseController = DatabaseController(); // TODO: The Database Controller instance should not be created from Tasks controller. There should be only one reason or source of truth to create a new instance. READ about "Single Responsibilitiy principal".
    taskController.tasks = taskController.databaseController!.getTasks();
  }

  //TODO: custom functions should come after the bulid method.
//This function is used to update the task data by showing alert dialogue and getting input into it.
  Future<void> updateTaskInput(context, taskId, title, description) async {
    taskController.titleController.text = title;
    taskController.descriptionController.text = description;
    return showDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Update Task"),
            content: SingleChildScrollView(
              child: Form(
                key: updateFormKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: taskController.titleController,
                      decoration: const InputDecoration(
                          hintText: "Enter Task Title",
                          labelText: "Task Title",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          )),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please Enter Task Title";
                        }
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    //TODO: If a widget is using more than once try to make it separate common useable component
                    TextFormField(
                      controller: taskController.descriptionController,
                      keyboardType: TextInputType.multiline,
                      minLines: 1,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: "Enter Task Description",
                        labelText: "Task Description",
                        contentPadding: EdgeInsets.symmetric(
                            vertical: Get.height * 0.06,
                            horizontal: Get.width * 0.03),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please Enter Task Description";
                        }
                      },
                    ),
                  ],
                ),
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
                        taskController.titleController.clear();
                        taskController.descriptionController.clear();
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
                        try {
                          if (updateFormKey.currentState!.validate()) {
                            taskController.updateTask(taskId);
                            Get.back();
                          } else {
                            Get.snackbar("Error", "Please Fill All Fields",
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.red,
                                colorText: Colors.white);
                          }
                        } on Exception catch (e) {
                          debugPrint(e.toString());
                        }
                      },
                      icon: const Icon(Icons.add))),
            ],
          );
        }).whenComplete(() {
      setState(() {});
    });
  }

  //This function is used to add new task by showing alert dialogue and getting input into it.
  Future<void> newTaskInput(context) async {
    return showDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Add New Task"),
            content: SingleChildScrollView(
              child: Form(
                key: newFormKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: taskController.titleController,
                      decoration: const InputDecoration(
                          hintText: "Enter Task Title",
                          labelText: "Task Title",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          )),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please Enter Task Title";
                        }
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: taskController.descriptionController,
                      keyboardType: TextInputType.multiline,
                      minLines: 1,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: "Enter Task Description",
                        labelText: "Task Description",
                        contentPadding: EdgeInsets.symmetric(
                            vertical: Get.height * 0.06,
                            horizontal: Get.width * 0.03),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please Enter Task Description";
                        }
                      },
                    ),
                  ],
                ),
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
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.close))),
              Container(
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                      onPressed: () {
                        try {
                          if (newFormKey.currentState!.validate()) {
                            taskController.addTask();
                            Get.back();
                          } else {
                            Get.snackbar("Error", "Please Fill All Fields",
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.red,
                                colorText: Colors.white);
                          }
                        } on Exception catch (e) {
                          debugPrint(e.toString());
                        }
                      },
                      icon: const Icon(Icons.add))),
            ],
          );
        }).whenComplete(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawerScrimColor: Colors.black.withOpacity(0.5),
      drawer: Drawer(
          child: Column(
        children: [
          const DrawerHeader(
            child: Text("Todo App",
                style: TextStyle(
                  color: Colors.purple,
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                )),
          ),
          ListTile(
            tileColor: Colors.purple[100],
            leading: const Icon(
              Icons.pending_actions_rounded,
              color: Colors.purple,
              size: 28,
            ),
            title: const Text(
              "Pending",
              style: TextStyle(
                color: Colors.purple,
                fontSize: 25,
                fontWeight: FontWeight.w700,
              ),
            ),
            onTap: () {
              Get.offAll(() => (const PendingTasksScreen()));
              // Navigator.pop(context);
            },
          ),
          SizedBox(
            height: Get.height * 0.015,
          ),
          ListTile(
            tileColor: Colors.purple[100],
            leading: const Icon(
              Icons.done_outline_rounded,
              color: Colors.purple,
              size: 28,
            ),
            title: const Text(
              "Done",
              style: TextStyle(
                color: Colors.purple,
                fontSize: 25,
                fontWeight: FontWeight.w700,
              ),
            ),
            onTap: () {
              Get.offAll(const DoneTasksScreen());
              // Navigator.pop(context);
            },
          ),
        ],
      )),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.purple),
        title: const Text("Todo App",
            style: TextStyle(
              color: Colors.purple,
              fontSize: 28,
              fontWeight: FontWeight.w700,
            )),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        elevation: 40,
        onPressed: () async {
          await newTaskInput(context);
        },
        label: const Text("Add New Task"),
        icon: const Icon(Icons.task),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: Get.height * 0.017, horizontal: Get.width * 0.05),
              child: const Text(
                "Pending Tasks",
                style: TextStyle(
                  color: Colors.purple,
                  fontSize: 28,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Divider(
              color: Colors.purple,
              thickness: 2,
              indent: 20,
              endIndent: 20,
            ),
            FutureBuilder(
                future: taskController.getPendingTasks(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: Get.height * 0.02,
                          ),
                          const Text(
                            "No Tasks",
                            style: TextStyle(
                              color: Colors.purple,
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(
                            height: Get.height * 0.02,
                          ),
                          Text(
                            "Tap on button to add new task",
                            style: TextStyle(
                              color: Colors.purple[300],
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return const Center(
                      child: Text("Error"),
                    );
                  } else if (snapshot.hasData) {
                    return Column(
                      children: [
                        ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              int todoId = snapshot.data![index].id!.toInt();
                              String todoTitle =
                                  snapshot.data![index].title!.toString();
                              String todoDescription =
                                  snapshot.data![index].description!.toString();
                              String todoDate =
                                  snapshot.data![index].date!.toString();
                              String todoTime =
                                  snapshot.data![index].time!.toString();
                              // int todoStatus = snapshot.data![index].status!.toInt();

                              return Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Dismissible(
                                  key: ValueKey<int>(todoId),
                                  direction: DismissDirection.startToEnd,
                                  onDismissed: (DismissDirection direction) {
                                    setState(() {
                                      taskController.updateTaskStatus(
                                          todoId, todoTitle, todoDescription);
                                      taskController.databaseController!
                                          .getTasks();
                                      snapshot.data!
                                          .remove(snapshot.data![index]);
                                    });
                                  },
                                  background: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 16.0),
                                        child: Row(
                                          children: const [
                                            Icon(Icons.done_outline_rounded,
                                                color: Colors.white),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text("Mark as Done",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600,
                                                )),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  child: Container(
                                      // margin: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Colors.purple.shade300,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 3,
                                            blurRadius: 4,
                                            offset: const Offset(0,
                                                3), // changes position of shadow
                                          ),
                                        ],
                                      ),
                                      // margin: const EdgeInsets.all(10.0),
                                      child: Column(
                                        children: [
                                          ListTile(
                                            // contentPadding: EdgeInsets.all(10),
                                            title: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8.0),
                                              child: Text(
                                                todoTitle,
                                                style: const TextStyle(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                            subtitle: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8.0, bottom: 4.0),
                                              child: Text(
                                                todoDescription,
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.white70),
                                              ),
                                            ),
                                            trailing: Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.yellow,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12)),
                                              child: IconButton(
                                                icon: const Icon(
                                                  Icons.edit,
                                                  color: Colors.purple,
                                                  size: 25,
                                                ),
                                                onPressed: () {
                                                  updateTaskInput(
                                                      context,
                                                      todoId,
                                                      todoTitle,
                                                      todoDescription);
                                                },
                                              ),
                                            ),
                                            onTap: () {
                                              // taskController.showTaskInput(context);
                                            },
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: Divider(
                                              color: Colors.white,
                                              thickness: 1.2,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 3,
                                              horizontal: 10,
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 8.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    todoTime,
                                                    style: const TextStyle(
                                                      fontSize: 17,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    todoDate,
                                                    style: const TextStyle(
                                                      fontSize: 17,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      )),
                                ),
                              );
                            }),
                      ],
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }), // TODO: Always use trailing commas to veritically format your code
          ],
        ),
      ),
    );
    // ignore: empty_statements
  }
}
