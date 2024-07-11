import 'package:alfath_stoer_app/core/utils/strings.dart';
import 'package:alfath_stoer_app/features/customer/data/models/customer_model.dart';
import 'package:alfath_stoer_app/features/customer/presentation/cubit/customer_list_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomerList extends StatelessWidget {
  final bool edit;
  const CustomerList({super.key, required this.edit});

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
              context.read<CustomerListCubit>().filterItems(query);
            },
          ),
        ),
        Expanded(
          child: BlocBuilder<CustomerListCubit, CustomerSupplierListState>(
            builder: (context, state) {
              if (state is CustomerSupplierListLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is CustomerSupplierListLoaded) {
                return ListView.builder(
                  itemCount: state.filteredItems.length,
                  itemBuilder: (context, index) {
                    final item = state.filteredItems[index];

                    return CustomerListItem(
                      item: item,
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

class CustomerListItem extends StatelessWidget {
  const CustomerListItem({super.key, required this.item, required this.edit});
  final CustomerModel item;
  final bool edit;
  @override
  Widget build(BuildContext context) {
    return edit
        ? GestureDetector(
            onTap: () {
              CustomerModel customer = CustomerModel(
                  id: item.id,
                  name: item.name,
                  adress: item.adress,
                  brancheId: item.brancheId,
                  startAccount: item.startAccount,
                  customerAccount: item.customerAccount,
                  customertypeId: item.customertypeId,
                  stopDealing: item.stopDealing);
              Navigator.pop(context, customer);
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
          )
        : Padding(
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
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.green, // لون النص
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8), // التباعد الداخلي
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(5), // شكل الحواف
                            ),
                          ),
                          child: const Text('تعديل'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              MyRouts.customerDetailPage,
                              arguments: {'id': item.id},
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.amber, // لون النص
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8), // التباعد الداخلي
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(5), // شكل الحواف
                            ),
                          ),
                          child: const Text('كشف حساب'),
                        ),
                      ),
                    ],
                  ),
                ],
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
