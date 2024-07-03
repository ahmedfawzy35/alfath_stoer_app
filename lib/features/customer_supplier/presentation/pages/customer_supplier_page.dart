import 'package:alfath_stoer_app/features/customer_supplier/data/repositories/customer_supplier_detail_repository.dart';
import 'package:alfath_stoer_app/features/customer_supplier/data/repositories/customer_supplier_list_repository.dart';
import 'package:alfath_stoer_app/features/customer_supplier/presentation/cubit/customer_supplier_list_cubit.dart';
import 'package:alfath_stoer_app/features/customer_supplier/presentation/widgets/customer_supplier_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomerSupplierPage extends StatelessWidget {
  final String type;
  final bool edit;
  final CustomerSupplierListRepository repository;
  final CustomerSupplierDetailRepository customeDetailsRepository;
  final String? branche;
  const CustomerSupplierPage(
      {super.key,
      required this.type,
      required this.repository,
      required this.customeDetailsRepository,
      this.branche,
      this.edit = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(type == 'Customer'
              ? ' العملاء - ${branche == null ? " " : branche!} '
              : 'الموردين')),
      body: BlocProvider(
        create: (_) =>
            CustomerSupplierListCubit(repository)..fetchData(type, branche!),
        child: CustomerSupplierList(
          customeRepository: customeDetailsRepository,
          edit: edit,
        ),
      ),
    );
  }
}
