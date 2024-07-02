import 'package:alfath_stoer_app/features/customer_supplier/data/repositories/seller_list_repository.dart';
import 'package:alfath_stoer_app/features/customer_supplier/presentation/cubit/seller_list_cubit.dart';
import 'package:alfath_stoer_app/features/customer_supplier/presentation/widgets/seller_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SellerListPage extends StatelessWidget {
  final String type;
  final SellerListRepository repository;

  const SellerListPage({super.key, required this.type, required this.repository});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(type == 'Customer' ? 'Customers' : 'Suppliers'),
      ),
      body: BlocProvider(
        create: (_) => SellerListCubit(repository)..fetchData(type),
        child: const SellerList(),
      ),
    );
  }
}
