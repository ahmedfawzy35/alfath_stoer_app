import 'package:alfath_stoer_app/features/outgoing/presentation/cubit/outgoing_list_cubit.dart';
import 'package:alfath_stoer_app/features/outgoing/presentation/wigets/outgoing_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OutGoingListPage extends StatelessWidget {
  final String? branche;
  final bool edit;
  const OutGoingListPage({
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
          title: Text('بنود المصروفات - ${branche == null ? " " : branche!}'),
        ),
        body: BlocProvider(
          create: (_) => OutGoigListCubit()..fetchData(),
          child: OutGoingList(edit: edit),
        ),
      ),
    );
  }
}
