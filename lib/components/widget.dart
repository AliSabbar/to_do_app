import 'package:flutter/material.dart';
import 'package:to_do_app/cubit/cubit.dart';

//! Text field

Widget defaultTextfield({
  required String hintText,
  // required String validator,
  String? Function(String?)? validator,
  required Widget prefix,
  required controller,
  VoidCallback? onTap,
}) =>
    Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
      child: TextFormField(
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: hintText,
          prefixIcon: prefix,
        ),
        validator: validator,
        onTap: onTap,
        controller: controller,
      ),
    );

//! Tasks

Widget defaultTasks(Map model, context) => Dismissible(
      background: Container(
        color: Colors.red,
        child: Center(
            child: Text(
          "Delete",
          style: TextStyle(fontSize: 30, color: Colors.white),
        )),
      ),
      key: ValueKey(model['id'].toString()),
      onDismissed: (dirction) {
        myCubit.get(context).deleteData(id: model['id']);
      },
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40.0,
              child: Text("${model['time']}"),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                children: [
                  Text(
                    "${model['title']}",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "${model['date']}",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            IconButton(
                onPressed: () {
                  myCubit
                      .get(context)
                      .updateDatabase(status: 'done', id: model['id']);
                },
                icon: Icon(
                  Icons.check_circle_outline_rounded,
                  color: Colors.greenAccent,
                )),
            IconButton(
                onPressed: () {
                  myCubit
                      .get(context)
                      .updateDatabase(status: 'archive', id: model['id']);
                },
                icon: Icon(
                  Icons.archive_outlined,
                  color: Colors.black54,
                )),
          ],
        ),
      ),
    );
