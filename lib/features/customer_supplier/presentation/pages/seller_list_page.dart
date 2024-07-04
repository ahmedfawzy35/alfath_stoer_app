import 'package:alfath_stoer_app/features/customer_supplier/presentation/cubit/seller_list_cubit.dart';
import 'package:alfath_stoer_app/features/customer_supplier/presentation/widgets/seller_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SellerListPage extends StatelessWidget {
  final String? branche;
  final bool edit;
  const SellerListPage({
    super.key,
    this.branche,
    this.edit = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('الموردين - ${branche == null ? " " : branche!}'),
      ),
      body: BlocProvider(
        create: (_) => SellerListCubit()..fetchData(),
        child: SellerList(edit: edit),
      ),
    );
  }
}
