import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/components/widget.dart';
import 'package:to_do_app/cubit/cubit.dart';
import 'package:to_do_app/cubit/states.dart';

class myTasks extends StatelessWidget {
  myTasks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<myCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = myCubit.get(context);
        return ListView.separated(
            itemBuilder: ((context, index) =>
                defaultTasks(cubit.new_tasks[index], context)),
            separatorBuilder: (context, index) => SizedBox(
                  height: 10,
                ),
            itemCount: cubit.new_tasks.length);
      },
    );
  }
}
