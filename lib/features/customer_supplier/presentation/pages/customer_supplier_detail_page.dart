import 'package:alfath_stoer_app/features/customer_supplier/data/models/customer_supplier_detail_model.dart';
import 'package:alfath_stoer_app/features/customer_supplier/data/repositories/customer_supplier_detail_repository.dart';
import 'package:alfath_stoer_app/features/customer_supplier/presentation/cubit/customer_supplier_detail_cubit.dart';
import 'package:alfath_stoer_app/features/customer_supplier/presentation/cubit/customer_supplier_detail_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' hide TextDirection;

class CustomerSupplierDetailPage extends StatelessWidget {
  final String type;
  final int id;
  final CustomerSupplierDetailRepository repository;

  CustomerSupplierDetailPage({
    required this.type,
    required this.id,
    required this.repository,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CustomerSupplierDetailCubit(repository)
        ..fetchCustomerSupplierDetail(type, id),
      child: Scaffold(
        appBar: AppBar(
          title: Text(type == 'Customer' ? 'كشف حساب عميل' : 'كشف حساب مورد'),
        ),
        body: BlocBuilder<CustomerSupplierDetailCubit,
            CustomerSupplierDetailState>(
          builder: (context, state) {
            if (state is CustomerSupplierDetailLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is CustomerSupplierDetailLoaded) {
              final detail = state.detail;
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'رقم العميل :        ${detail.customerId}',
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Text(
                    'الاسم:      ${detail.name}',
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'بداية الحساب :        ${detail.lastAccount}',
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'الحساب النهائي:        ${detail.finalCustomerAccount}',
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  // Add more fields as needed

                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                        itemCount: detail.elements.length,
                        itemBuilder: (context, index) {
                          final item = detail.elements[index];

                          return ItemProcess(
                            item: item,
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  )
                ],
              );
            } else if (state is CustomerSupplierDetailError) {
              return Center(child: Text(state.message));
            } else {
              return Center(child: Text('Unknown state'));
            }
          },
        ),
      ),
    );
  }
}

class ItemProcess extends StatelessWidget {
  const ItemProcess({super.key, required this.item});
  final ProcessElement item;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
              color: item.add! ? Colors.green[300] : Colors.amber[600]),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 15,
                  ),
                  Text(
                    item.value.toString(),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    item.notes.toString(),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    (item.date!).substring(0, 10),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  item.number! > 0
                      ? Text(
                          '[رقم الفاتورة ${item.number!.round().toString()}]')
                      : SizedBox()
                ],
              )
            ],
          ),
        ),
        Container(
          height: 2,
          decoration: BoxDecoration(color: Colors.black),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              (item.accountAfterElement!.round()).toString(),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        )
      ],
    );
  }
}
