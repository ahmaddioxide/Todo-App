import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/models/db_helper_tasks.dart';
import 'package:todo_app/views/pending_tasks_screen.dart';
import '../controllers/task_controller.dart';

class DoneTasksScreen extends StatefulWidget {
  const DoneTasksScreen({super.key});

  @override
  State<DoneTasksScreen> createState() => _DoneTasksScreenState();
}

class _DoneTasksScreenState extends State<DoneTasksScreen> {
  final taskController = TaskController();

  @override
  void initState() {
    super.initState();
    taskController.dbHelper = DBHelper();
    // taskController.tasks = taskController.dbHelper!.getTasks();
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
            },
          ),
          SizedBox(
            height: Get.height * 0.01,
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: Get.height * 0.018),
              child: const Text(
                "Done Tasks",
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
                future: taskController.getDoneTasks(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: Get.height * 0.3,
                          ),
                          Text(
                            "No Tasks Completed Yet",
                            style: TextStyle(
                              color: Colors.purple[300],
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
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
                                  background: Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                    padding: const EdgeInsets.only(
                                        right: 20, left: 20),
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 4, horizontal: 2),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: const [
                                        Padding(
                                          padding: EdgeInsets.all(1.0),
                                          child: Icon(
                                            Icons.delete,
                                            color: Colors.white,
                                            size: 30,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(1.0),
                                          child: Icon(
                                            Icons.delete,
                                            color: Colors.white,
                                            size: 30,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  key: ValueKey<int>(todoId),
                                  direction: DismissDirection.horizontal,
                                  onDismissed: (direction) {
                                    setState(() {
                                      taskController.dbHelper!.delete(todoId);
                                      taskController.getDoneTasks();
                                    });
                                  },
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
                                            contentPadding:
                                                const EdgeInsets.all(10),
                                            title: Text(
                                              todoTitle,
                                              style: const TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.white,
                                              ),
                                            ),
                                            subtitle: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8.0),
                                              child: Text(
                                                todoDescription,
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.white70),
                                              ),
                                            ),
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
                                                  const Text("Completed at: ",
                                                      style: TextStyle(
                                                        fontSize: 17,
                                                        color: Colors.white,
                                                      )),
                                                  SizedBox(
                                                    width: Get.width * 0.02,
                                                  ),
                                                  Text(
                                                    todoTime,
                                                    style: const TextStyle(
                                                      fontSize: 17,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: Get.width * 0.02,
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
                }),
          ],
        ),
      ),
    );
    // ignore: empty_statements
  }
}
