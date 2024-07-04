import 'package:alfath_stoer_app/features/customer_supplier/data/models/seller_model.dart';
import 'package:alfath_stoer_app/features/customer_supplier/presentation/cubit/seller_detail_cubit.dart';
import 'package:alfath_stoer_app/features/customer_supplier/presentation/cubit/seller_list_cubit.dart';
import 'package:alfath_stoer_app/features/customer_supplier/presentation/cubit/seller_list_state.dart';
import 'package:alfath_stoer_app/features/customer_supplier/presentation/pages/seller_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SellerList extends StatelessWidget {
  final bool edit;

  const SellerList({super.key, required this.edit});

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
              context.read<SellerListCubit>().filterItems(query);
            },
          ),
        ),
        Expanded(
          child: BlocBuilder<SellerListCubit, SellerListState>(
            builder: (context, state) {
              if (state is SellerListLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is SellerListLoaded) {
                return ListView.builder(
                  itemCount: state.filteredItems.length,
                  itemBuilder: (context, index) {
                    final item = state.filteredItems[index];
                    return SellerListItem(
                      edit: false,
                      item: item,
                    );
                  },
                );
              } else if (state is SellerListError) {
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
  const SellerListItem({super.key, required this.item, required this.edit});
  final SellerModel item;
  final bool edit;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (edit == false) {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (_) => SellerDetailCubit()..fetchSellerDetail(item.id),
              child: SellrDetailPage(id: item.id),
            ),
          ));
        } else {
          SellerModel customer = SellerModel(
            id: item.id,
            name: item.name,
            adress: item.adress,
            brancheId: item.brancheId,
            startAccount: item.startAccount,
          );
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
