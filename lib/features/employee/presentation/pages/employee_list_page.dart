import 'package:alfath_stoer_app/features/employee/presentation/cubit/employee_list_cubit.dart';
import 'package:alfath_stoer_app/features/employee/presentation/wigets/outgoing_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmployeeListPage extends StatelessWidget {
  final String? branche;
  final bool edit;
  const EmployeeListPage({
    super.key,
    this.branche,
    this.edit = false,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(' الموظفون - ${branche == null ? " " : branche!}'),
        ),
        body: BlocProvider(
          create: (_) => EmployeeListCubit()..fetchData(),
          child: EmployeeList(edit: edit),
        ),
      ),
    );
  }
}
