import 'package:alfath_stoer_app/features/customer/presentation/cubit/customer_list_cubit.dart';
import 'package:alfath_stoer_app/features/customer/presentation/widgets/customer_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomerListPage extends StatelessWidget {
  final bool edit;
  final String? branche;
  const CustomerListPage({super.key, this.branche, this.edit = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(' العملاء - ${branche == null ? " " : branche!} ')),
      body: BlocProvider(
        create: (_) => CustomerListCubit()..fetchData(),
        child: CustomerList(
          edit: edit,
        ),
      ),
    );
  }
}
