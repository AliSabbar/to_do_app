import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do_app/cubit/states.dart';

import '../screens/ArchiveTasks/archiveTasks.dart';
import '../screens/Done Tasks/doneTasks.dart';
import '../screens/My Tasks/myTasks.dart';

class myCubit extends Cubit<AppStates> {
  myCubit() : super(InitalState());
  static myCubit get(context) => BlocProvider.of(context);

  List<String> title = ["My Tasks", "Done Tasks", "Archive Tasks"];
  List<Widget> screens = [
    myTasks(),
    doneTasks(),
    archiveTasks(),
  ];
  //! var
  int currentPage = 0;
  Database? database;

  IconData fabicon = Icons.edit;
  bool isBottomsheet = false;
  List<Map> new_tasks = [];
  List<Map> done_tasks = [];
  List<Map> archive_tasks = [];
  //! Function

  void changeIndex(int index) {
    currentPage = index;
    emit(ChangeIndexState());
  }

  void changeBottomSheet({required bool isBottom, required IconData icon}) {
    fabicon = icon;
    isBottomsheet = isBottom;
    emit(ChangeBottomSheetState());
  }

  //! DATA BASE

  //! Create Database
  void createDatabase() {
    openDatabase('todo.db', version: 1, onCreate: (database, version) {
      print("DataBase Created");
      database
          .execute(
              'CREATE TABLE tasks(id INTEGER PRIMARY KEY , title TEXT , time TEXT , date TEXT , status TEXT)')
          .then((value) {
        print("Table Created ");
      }).catchError((e) {
        print("Error when Created Table ${e.toString()}");
      });
    }, onOpen: (database) {
      getFromDatabase(database);
      print("Database Opened");
    }).then((value) {
      database = value;
      emit(CreateDataBaseState());
    });
  }

//! get Data from database

  void getFromDatabase(database) {
    new_tasks = [];
    done_tasks = [];
    archive_tasks = [];
    emit(DataBaseLoadingState());
    database!.rawQuery('SELECT * FROM tasks').then((value) {
      value.forEach((element) {
        if (element['status'] == 'new')
          new_tasks.add(element);
        else if (element['status'] == 'done')
          done_tasks.add(element);
        else
          archive_tasks.add(element);
      });
      emit(GetDataFromDataBaseState());
    });
  }

//! Insert to  Database
  insertDatabase({
    required String title,
    required String time,
    required String date,
  }) async {
    await database!.transaction((txn) async {
      txn
          .rawInsert(
              'INSERT INTO tasks(title , time , date , status) VALUES("$title" , "$time" , "$date" , "new")')
          .then((value) {
        getFromDatabase(database);
        print("${value.toString()} inserted successfully");
        emit(InsertDataBaseState());
      }).catchError((e) {
        print("Error when Inserted Records ${e.toString()}");
      });
    });
  }

//! Update Database
  void updateDatabase({
    required String status,
    required int id,
  }) async {
    database!.rawUpdate('UPDATE tasks SET status = ? WHERE id = ?',
        ['$status', id]).then((value) {
      getFromDatabase(database);
      emit(UpdateDatabaseState());
    });
  }

//! Delete Data From Database
  void deleteData({
    required int id,
  }) async {
    database!.rawDelete(
        'DELETE FROM tasks WHERE id = ?', [id]).then((value) {
      getFromDatabase(database); 
      emit(DeleteDataFromDatabaseState());
    });
  }
}
