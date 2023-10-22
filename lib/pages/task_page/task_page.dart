import 'package:accounting_assistant/data_classes/active_task.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'task_page_provider.dart';
import 'package:provider/provider.dart';

class TaskPage extends StatelessWidget {
  const TaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TaskPageProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Активные задачи',
          style: TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 24.0,
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 2.0),
          child: TextButton(
            child: const Icon(
              Icons.save,
              size: 30,
            ),
            onPressed: () {}, // TODO: Implement uploading tasks
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(5.0),
        itemCount: provider.tasks.length,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(13),
              color: Theme.of(context).cardColor,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 2.0,
                  spreadRadius: 1.0,
                  offset: Offset(0.0, 1.0),
                ),
              ],
            ),
            child: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 12.0),
                  child: Icon(Icons.circle, size: 12.0),
                ),
                Expanded(
                  child: TextButton(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          provider.tasks[index].title,
                          style: const TextStyle(
                            fontSize: 24.0,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    onPressed: () =>
                        showTaskAlert(context, provider.tasks[index]),
                    onLongPress: () => showDeleteAlert(context,
                        provider.tasks[index]), // TODO: Implement deleting task
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Checkbox(
                    value: provider.tasks[index].isDone,
                    onChanged: (value) => provider.changed(index),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).cardColor,
        onPressed: () => showInputAlert(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<dynamic> showDeleteAlert(BuildContext context, Task task) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        title: Text(
          'Удаление ${task.title}',
          textAlign: TextAlign.start,
          style: const TextStyle(
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          'Вы уверены?',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.w400,
          ),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Theme.of(context).cardColor,
                ),
                onPressed: () => GoRouter.of(context).pop(),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Отмена',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Theme.of(context).cardColor,
                ),
                onPressed: () {}, // TODO: Implement deleting task
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Удалить',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<dynamic> showTaskAlert(BuildContext context, Task task) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        title: Text(
          task.title,
          textAlign: TextAlign.start,
          style: const TextStyle(
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SingleChildScrollView(
          child: Text(
            task.description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Theme.of(context).cardColor,
                ),
                onPressed: () {},
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Изменить',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Theme.of(context).cardColor,
                ),
                onPressed: () => GoRouter.of(context).pop(),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'ОК',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<dynamic> showInputAlert(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (contextDialog) => AlertDialog(
        title: const Row(
          children: [
            Icon(
              Icons.add_circle_outline,
              size: 30,
            ),
            SizedBox(width: 10.0),
            Text(
              'Добавить задачу',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ],
        ),
        content: SizedBox(
          width: 500,
          height: 250,
          child: Form(
            key: context.read<TaskPageProvider>().taskSaveFormKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(hintText: 'Название'),
                  onSaved: context.read<TaskPageProvider>().saveName,
                ),
                TextFormField(
                  minLines: 1,
                  maxLines: 6,
                  decoration: const InputDecoration(hintText: 'Описание'),
                  onSaved: context.read<TaskPageProvider>().saveDescription,
                ),
              ],
            ),
          ),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Theme.of(context).cardColor,
                ),
                onPressed: () => GoRouter.of(context).pop(),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Отменить',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Theme.of(context).cardColor,
                ),
                onPressed: () {
                  context.read<TaskPageProvider>().addNewTask();
                  GoRouter.of(context).pop();
                },
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Сохранить',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
