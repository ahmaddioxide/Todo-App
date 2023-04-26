import 'package:flutter/material.dart';// UI toolkit
import 'package:get/get.dart';//Package for state management
import '../controllers/task_controller.dart';
import '../controllers/database_controller.dart';// Project level import
import 'done_tasks_screen.dart';// Project level import

class PendingTasksScreen extends StatefulWidget {
  const PendingTasksScreen({super.key});

  @override
  State<PendingTasksScreen> createState() => _PendingTasksScreenState();
}

class _PendingTasksScreenState extends State<PendingTasksScreen> {
  static final _newFormKey = GlobalKey<FormState>();
  static final _updateFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    TaskController.tasks = DatabaseController.getTasks();
  }
  @override
  void dispose() {
    super.dispose();
    TaskController.titleController.dispose();
    TaskController.descriptionController.dispose();
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
              future: TaskController.getPendingTasks(),
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
                                    TaskController.updateTaskStatus(
                                        todoId, todoTitle, todoDescription);
                                    DatabaseController
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
                                            padding:
                                                const EdgeInsets.only(top: 8.0),
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
                                                    BorderRadius.circular(12)),
                                            child: IconButton(
                                              icon: const Icon(
                                                Icons.edit,
                                                color: Colors.purple,
                                                size: 25,
                                              ),
                                              onPressed: () {
                                                updateTaskInput(context, todoId,
                                                    todoTitle, todoDescription);
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
              },
            ),
          ],
        ),
      ),
    );
    // ignore: empty_statements
  }


//This function is used to update the task data by showing alert dialogue and getting input into it.
  Future<void> updateTaskInput(context, taskId, title, description) async {
    TaskController.titleController.text = title;
    TaskController.descriptionController.text = description;
    return showDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Update Task"),
            content: SingleChildScrollView(
              child: taskInputForm(),
            ),
            actions: [
              Container(
                  decoration: const BoxDecoration(
                    color: Colors.pink,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                      onPressed: () {
                        TaskController.titleController.clear();
                        TaskController.descriptionController.clear();
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
                          if (_updateFormKey.currentState!.validate()) {
                            TaskController.updateTask(taskId);
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
              child: taskInputForm(),
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
                          if (_newFormKey.currentState!.validate()) {
                            TaskController.addTask();
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

  Form taskInputForm(){
    return Form(
      key: _newFormKey,
      child: Column(
        children: [
          TextFormField(
            controller: TaskController.titleController,
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
            controller: TaskController.descriptionController,
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
    );
  }
}
