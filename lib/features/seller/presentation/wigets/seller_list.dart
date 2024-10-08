import 'package:alfath_stoer_app/core/utils/strings.dart';
import 'package:alfath_stoer_app/features/seller/data/models/seller_model.dart';
import 'package:alfath_stoer_app/features/seller/presentation/cubit/seller_list_cubit.dart';
import 'package:alfath_stoer_app/features/seller/presentation/cubit/seller_list_state.dart';
import 'package:alfath_stoer_app/features/seller/presentation/pages/seller_add_edit_page%20.dart';
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
                      edit: edit,
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
    return Directionality(
        textDirection: TextDirection.rtl,
        child: edit
            ? GestureDetector(
                onTap: () {
                  SellerModel seller = SellerModel(
                    id: item.id,
                    name: item.name,
                    adress: item.adress,
                    brancheId: item.brancheId,
                    startAccount: item.startAccount,
                  );
                  Navigator.pop(context, seller);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
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
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              onPressed: () async {
                                final editedCustomer =
                                    await Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => SellerAddEditPage(
                                      seller: item,
                                    ),
                                  ),
                                );

                                if (editedCustomer != null) {
                                  context
                                      .read<SellerListCubit>()
                                      .update(editedCustomer);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.green, // لون النص
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8), // التباعد الداخلي
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
                                  MyRouts.sellerDetailPage,
                                  arguments: {'id': item.id},
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.amber, // لون النص
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8), // التباعد الداخلي
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
              ));
  }
}
