import 'package:alfath_stoer_app/features/customer_supplier/data/models/customer_supplier_model.dart';
import 'package:alfath_stoer_app/features/customer_supplier/data/repositories/customer_supplier_detail_repository.dart';
import 'package:alfath_stoer_app/features/customer_supplier/presentation/cubit/customer_supplier_detail_cubit.dart';
import 'package:alfath_stoer_app/features/customer_supplier/presentation/cubit/customer_supplier_list_cubit.dart';
import 'package:alfath_stoer_app/features/customer_supplier/presentation/pages/customer_supplier_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomerSupplierList extends StatelessWidget {
  final CustomerSupplierDetailRepository customeRepository;
  final bool edit;
  const CustomerSupplierList(
      {super.key, required this.customeRepository, required this.edit});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: const InputDecoration(
              labelText: 'Search',
              border: OutlineInputBorder(),
            ),
            onChanged: (query) {
              context.read<CustomerSupplierListCubit>().filterItems(query);
            },
          ),
        ),
        Expanded(
          child:
              BlocBuilder<CustomerSupplierListCubit, CustomerSupplierListState>(
            builder: (context, state) {
              if (state is CustomerSupplierListLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is CustomerSupplierListLoaded) {
                return ListView.builder(
                  itemCount: state.filteredItems.length,
                  itemBuilder: (context, index) {
                    final item = state.filteredItems[index];

                    return SellerListItem(
                      item: item,
                      customeRepository: customeRepository,
                      edit: edit,
                    );
                  },
                );
              } else if (state is CustomerSupplierListError) {
                return Center(child: Text(state.message));
              } else {
                return const Center(child: Text('Unknown state'));
              }
            },
          ),
        ),
      ],
    );
  }
}

class SellerListItem extends StatelessWidget {
  const SellerListItem(
      {super.key,
      required this.item,
      required this.customeRepository,
      required this.edit});
  final CustomerSupplierModel item;
  final CustomerSupplierDetailRepository customeRepository;
  final bool edit;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (edit == false) {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (_) => CustomerSupplierDetailCubit(customeRepository)
                ..fetchCustomerSupplierDetail('Customer', item.id),
              child: CustomerSupplierDetailPage(
                  type: 'Customer', id: item.id, repository: customeRepository),
            ),
          ));
        } else {
          CustomerSupplierModel customer = CustomerSupplierModel(
              id: item.id,
              name: item.name,
              adress: item.adress,
              brancheId: item.brancheId,
              startAccount: item.startAccount,
              customerAccount: item.customerAccount,
              customertypeId: item.customertypeId,
              stopDealing: item.stopDealing);
          Navigator.pop(context, customer);
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 5, 10),
                    child: Text(
                      item.name,
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                          fontSize: 15,
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
/*

ListTile(
          
          title: Text(item.name),
          subtitle: Text(item.adress),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => BlocProvider(
                create: (_) => CustomerSupplierDetailCubit(customeRepository)
                  ..fetchCustomerSupplierDetail('Customer', item.id),
                child: CustomerSupplierDetailPage(
                    type: 'Customer',
                    id: item.id,
                    repository: customeRepository),
              ),
            ));
          },
        ),

        */
