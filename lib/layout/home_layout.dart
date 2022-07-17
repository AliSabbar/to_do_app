import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/cubit/cubit.dart';

import '../components/widget.dart';
import '../cubit/states.dart';

class home extends StatelessWidget {
  home({Key? key}) : super(key: key);

//! Keys

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var textfieldKey = GlobalKey<FormState>();

//! Controller

  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => myCubit()..createDatabase(),
      child: BlocConsumer<myCubit, AppStates>(
        listener: (context, state) {
          if (state is InsertDataBaseState) Navigator.pop(context);
        },
        builder: (context, state) {
          myCubit cubit = myCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(cubit.title[cubit.currentPage]),
            ),
            bottomNavigationBar: BottomNavigationBar(
              items: [
                BottomNavigationBarItem(
                    icon: Icon(Icons.menu_book_rounded), label: "My Tasks"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.check_circle_rounded),
                    label: "Done Tasks"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.archive_rounded), label: "Archive Tasks"),
              ],
              currentIndex: cubit.currentPage,
              onTap: (index) {
                cubit.changeIndex(index);
              },
            ),
            body: cubit.screens[cubit.currentPage],
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.isBottomsheet) {
                  if (textfieldKey.currentState!.validate()) {
                    cubit.insertDatabase(
                        title: titleController.text,
                        time: timeController.text,
                        date: dateController.text);
                  }
                } else {
                  scaffoldKey.currentState!
                      .showBottomSheet((context) => Form(
                            key: textfieldKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                defaultTextfield(
                                    hintText: "Enter Title",
                                    prefix: Icon(Icons.title),
                                    validator: (s) {
                                      if (s!.isEmpty)
                                        return "Title mustn't be Empty";
                                    },
                                    controller: titleController),
                                defaultTextfield(
                                    hintText: "Enter Time",
                                    prefix: Icon(Icons.access_time_filled),
                                    validator: (s) {
                                      if (s!.isEmpty)
                                        return "Time mustn't be Empty";
                                    },
                                    controller: timeController,
                                    onTap: () {
                                      showTimePicker(
                                              context: context,
                                              initialTime: TimeOfDay.now())
                                          .then((value) {
                                        timeController.text =
                                            value!.format(context).toString();
                                      });
                                    }),
                                defaultTextfield(
                                    hintText: "Enter Date",
                                    prefix: Icon(Icons.calendar_month),
                                    validator: (s) {
                                      if (s!.isEmpty)
                                        return "Date mustn't be Empty";
                                    },
                                    controller: dateController,
                                    onTap: () {
                                      showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime.parse('2040-05-05'),
                                      ).then((value) {
                                        dateController.text =
                                            DateFormat.yMMMd().format(value!);
                                      });
                                    }),
                              ],
                            ),
                          ))
                      .closed
                      .then((value) {
                    cubit.changeBottomSheet(icon: Icons.edit, isBottom: false);
                  });
                  cubit.changeBottomSheet(isBottom: true, icon: Icons.add);
                }
              },
              child: Icon(cubit.fabicon),
            ),
          );
        },
      ),
    );
  }
}
