import 'package:alfath_stoer_app/features/customer_supplier/presentation/cubit/seller_list_cubit.dart';
import 'package:alfath_stoer_app/features/customer_supplier/presentation/cubit/seller_list_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SellerList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: InputDecoration(
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
                return Center(child: CircularProgressIndicator());
              } else if (state is SellerListLoaded) {
                return ListView.builder(
                  itemCount: state.filteredItems.length,
                  itemBuilder: (context, index) {
                    final item = state.filteredItems[index];
                    return ListTile(
                      title: Text(item.name),
                      subtitle: Text(item.adress),
                      onTap: () {
                        // Navigate to detail page
                      },
                    );
                  },
                );
              } else if (state is SellerListError) {
                return Center(child: Text(state.message));
              } else {
                return Center(child: Text('Unknown state'));
              }
            },
          ),
        ),
      ],
    );
  }
}
