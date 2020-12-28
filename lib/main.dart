import 'package:flutter/material.dart';

import 'package:sqflite/sqflite.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'Task.dart';
import 'dbHelper.dart';

void main() async {
  runApp(MyApp());

  WidgetsFlutterBinding.ensureInitialized();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hamza Shami Assigment 3',
      theme: ThemeData(

        primarySwatch: Colors.blue,

        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);


  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Task> allTasks = List<Task>();
  List<Task> completedTasks;
  List<Task> inCompletedTasks;

  initState() {
    super.initState();
    getAllTasks2();
    getCompletedTasks2();
    getNotCompletedTasks2();
  }

  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(

            title: Text(widget.title),
            bottom: TabBar(
              tabs: <Widget>[
                Tab(
                  text: "All Tasks",
                ),
                Tab(
                  text: "Complete\nTasks",
                ),
                Tab(
                  text: "InComplete\nTasks",
                ),
              ],
            ),
          ),
          body: Center(

            child: TabBarView(
              children: [
                Container(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: allTasks.length,
                    itemBuilder: (BuildContext context, int position) {
                      return Container(
                        child: Row(
                          children: <Widget>[
                            new IconButton(
                                icon: new Icon(Icons.delete),
                                iconSize: 25.0,
                                onPressed: () {}),
                            new Text(
                              allTasks[position].title,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            new Container(
                                alignment: Alignment.centerRight,
                                child: new Checkbox(
                                    value: allTasks[position].status ==
                                        db_helper.completed_mark,
                                    onChanged: (bool value) {
                                      setState(() {
                                        if (value) {
                                          allTasks[position].status =
                                              db_helper.completed_mark;
                                        } else {
                                          allTasks[position].status =
                                              db_helper.not_completed_mark;
                                        }
                                        _myUpdate(
                                            new Task(
                                                id: allTasks[position].id,
                                                title: allTasks[position].title,
                                                status:
                                                allTasks[position].status),
                                            allTasks[position].status);
                                      });
                                    })),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: completedTasks.length,
                    itemBuilder: (BuildContext context, int position) {
                      return Container(
                        child: Row(
                          children: <Widget>[
                            new IconButton(
                                icon: new Icon(Icons.delete),
                                iconSize: 25.0,
                                onPressed: () {}),
                            new Text(
                              completedTasks[position].title,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            new Container(
                                alignment: Alignment.centerRight,
                                child: new Checkbox(
                                    value: completedTasks[position].status ==
                                        db_helper.completed_mark,
                                    onChanged: (bool value) {
                                      setState(() {
                                        if (value) {
                                          completedTasks[position].status =
                                              db_helper.completed_mark;
                                        } else {
                                          completedTasks[position].status =
                                              db_helper.not_completed_mark;
                                        }
                                        _myUpdate(
                                            new Task(
                                                id: completedTasks[position].id,
                                                title: completedTasks[position].title,
                                                status:
                                                completedTasks[position].status),
                                            completedTasks[position].status);
                                      });
                                    })),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: inCompletedTasks.length,
                    itemBuilder: (BuildContext context, int position) {
                      return Container(
                        child: Row(
                          children: <Widget>[
                            new IconButton(
                                icon: new Icon(Icons.delete),
                                iconSize: 25.0,
                                onPressed: () {}),
                            new Text(
                              inCompletedTasks[position].title,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            new Container(
                                alignment: Alignment.centerRight,
                                child: new Checkbox(
                                    value: inCompletedTasks[position].status ==
                                        db_helper.completed_mark,
                                    onChanged: (bool value) {
                                      setState(() {
                                        if (value) {
                                          inCompletedTasks[position].status =
                                              db_helper.completed_mark;
                                        } else {
                                          inCompletedTasks[position].status =
                                              db_helper.not_completed_mark;
                                        }
                                        _myUpdate(
                                            new Task(
                                                id: inCompletedTasks[position].id,
                                                title: inCompletedTasks[position].title,
                                                status:
                                                inCompletedTasks[position].status),
                                            inCompletedTasks[position].status);
                                      });
                                    })),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          floatingActionButton: FloatingActionButton(
            onPressed: () {
              _dialog_display(context);
              // _delete();
            },
            tooltip: 'Not Task Yet',
            child: Icon(Icons.add),
          ), // This trailing comma makes auto-formatting nicer for build methods.
        ));
  }


  myInsert(String title) async {
    Database db = await db_helper.instance.database;
    Map<String, dynamic> row = {
      db_helper.columnTitle: title,
      db_helper.columnStatus: db_helper.not_completed_mark
    };
    await db.insert(db_helper.table, row);
  }


  _myUpdate(Task task, int newStatus) async {
    Database db = await db_helper.instance.database;

    Map<String, dynamic> map = {
      db_helper.columnTitle: task.title,
      db_helper.columnId: task.id,
      db_helper.columnStatus: newStatus
    };

    await db.update(db_helper.table, map,
        where: "_id = ?", whereArgs: [task.id]);
  }

  //Not Important

  getAllTasks2() async {
    allTasks = List<Task>();
    final Database db = await db_helper.instance.database;
    var tasks = await db.query(db_helper.table);
    tasks.forEach((element) {
      setState(() {
        var task = new Task();
        task.id = element["_id"];
        task.title = element["title"];
        task.status = element["status"];
        allTasks.add(task);
      });
    });
  }

  getCompletedTasks2() async {
    completedTasks = List<Task>();
    final Database db = await db_helper.instance.database;
    var tasks = await db.query(db_helper.table,
        where: "status = ?", whereArgs: [db_helper.completed_mark]);
    tasks.forEach((element) {
      setState(() {
        var task = new Task();
        task.id = element["_id"];
        task.title = element["title"];
        task.status = element["status"];
        completedTasks.add(task);
      });
    });
  }

  getNotCompletedTasks2() async {
    inCompletedTasks = List<Task>();
    final Database db = await db_helper.instance.database;
    var tasks = await db.query(db_helper.table,
        where: "status = ?", whereArgs: [db_helper.not_completed_mark]);
    tasks.forEach((element) {
      setState(() {
        var task = new Task();
        task.id = element["_id"];
        task.title = element["title"];
        task.status = element["status"];
        inCompletedTasks.add(task);
      });
    });
  }

  TextEditingController _textEditingController = TextEditingController();

  _dialog_display(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Write Task Name'),
            content: TextField(
              controller: _textEditingController,
              textInputAction: TextInputAction.go,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(hintText: "Write Task Name"),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('Submit'),
                onPressed: () {
                  var enteredText = _textEditingController.text;
                  print('Entered Text is $enteredText');
                  if (enteredText.isEmpty) {
                    Fluttertoast.showToast(
                        msg: "Can't create empty task",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  } else {
                    myInsert(_textEditingController.text);
                    Navigator.of(context).pop();
                  }
                },
              )
            ],
          );
        });
  }
}
