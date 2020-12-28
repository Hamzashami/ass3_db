import 'package:flutter/cupertino.dart';

import 'dbHelper.dart';

class Task extends ChangeNotifier{
  int id;
  String title;
  int status;

  Task({this.id, this.title, this.status});

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      db_helper.columnTitle: title,
      db_helper.columnStatus: status,
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Dog{id: $id, title: $title, status: $status}';
  }
}