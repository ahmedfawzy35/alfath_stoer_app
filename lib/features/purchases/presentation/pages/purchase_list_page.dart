import 'package:alfath_stoer_app/features/customer_supplier/presentation/cubit/customer_list_cubit.dart';
import 'package:alfath_stoer_app/features/orders/data/models/order.dart';
import 'package:alfath_stoer_app/features/orders/presentation/cubit/cubit/order_cubit.dart';
import 'package:alfath_stoer_app/features/orders/presentation/pages/edit_order_page.dart';
import 'package:alfath_stoer_app/features/purchases/datat/models/purchase.dart';
import 'package:alfath_stoer_app/features/purchases/presentation/cubit/cubit/purchase_cubit.dart';
import 'package:alfath_stoer_app/features/purchases/presentation/pages/edit_purchase_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class PurchaseListPage extends StatelessWidget {
  final String? branche;
  final DateTime fromDate;
  final DateTime toDate;
  final bool singleDay;
  const PurchaseListPage({
    super.key,
    this.branche,
    required this.fromDate,
    required this.toDate,
    required this.singleDay,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        ' فواتير الشراء - ${singleDay ? 'لليوم  ${DateFormat('yyyy-mm-dd').format(fromDate)}' : 'للفترة من ${DateFormat('yyyy-mm-dd').format(fromDate)} الى ${DateFormat('yyyy-mm-dd').format(toDate)}'} ',
        style: const TextStyle(fontSize: 12),
      )),
      body: singleDay
          ? BlocProvider(
              create: (_) => PurchaseCubit()..getForDate(fromDate),
              child: const PurchaseList(),
            )
          : BlocProvider(
              create: (_) => PurchaseCubit()..getForTime(fromDate, toDate),
              child: const PurchaseList(),
            ),
    );
  }
}

class PurchaseList extends StatelessWidget {
  const PurchaseList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: const InputDecoration(
              labelText: 'بحث باسم المورد',
              border: OutlineInputBorder(),
            ),
            onChanged: (query) {
              context.read<PurchaseCubit>().filterItemsByName(query);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(3.0),
          child: TextField(
            decoration: const InputDecoration(
              labelText: 'بحث برقم الفاتورة',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
            ],
            onChanged: (query) {
              context.read<PurchaseCubit>().filterItems(query);
            },
          ),
        ),
        Expanded(
          child: BlocBuilder<PurchaseCubit, PurchaseState>(
            builder: (context, state) {
              if (state is OrderLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is PurchasesListLoaded) {
                return ListView.builder(
                  itemCount: state.filteredItems.length,
                  itemBuilder: (context, index) {
                    final item = state.filteredItems[index];

                    return PurchaseListItem(
                      item: item,
                    );
                  },
                );
              } else if (state is CustomerSupplierListError) {
                return const Center(child: Text('فشل تحميل البيانات'));
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

class PurchaseListItem extends StatelessWidget {
  const PurchaseListItem({
    super.key,
    required this.item,
  });
  final Purchase item;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(5)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                        DateFormat('yyyy-MM-dd')
                            .format(DateTime.parse(item.date!)),
                        style: _textStyle()),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Column(
                          children: [
                            Text('رقم الفاتورة ', style: _textStyle()),
                            Text(item.orderNumber.toString(),
                                style: _textStyle())
                          ],
                        ),
                        const SizedBox(
                          width: 25,
                        ),
                        Column(
                          children: [
                            Text(
                              'المعرف ',
                              style: _textStyle(),
                            ),
                            Text(item.id.toString(), style: _textStyle())
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 5, 10),
                    child: Text(
                      item.sellerName!,
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const Text(':اسم العميل '),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    children: [
                      ElevatedButton(
                          child: const Text('تعديل'),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => BlocProvider<OrderCubit>(
                                  create: (context) => OrderCubit(),
                                  child: EditPurchasePage(purchase: item),
                                ),
                              ),
                            );
                          }),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          final purchaseCubit = context.read<PurchaseCubit>();
                          purchaseCubit.deletePurchase(item.id!);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text('حذف'),
                      )
                    ],
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: _boxDecoration(),
                    child: Column(
                      children: [
                        Text('المتبقي ', style: _textStyle()),
                        Text(
                          item.remainingAmount.toString(),
                          style: TextStyle(
                              color: item.remainingAmount! > 0
                                  ? Colors.red
                                  : Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w600),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  _details('المدفوع', item.paid.toString()),
                  const SizedBox(
                    width: 5,
                  ),
                  _details('الخصم', item.discount.toString()),
                  const SizedBox(
                    width: 5,
                  ),
                  _details('الاجمالي', item.total.toString()),
                ],
              ),
              Text(
                item.notes!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              )
            ],
          ),
        ),
      ),
    );
  }

  TextStyle _textStyle() {
    return const TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 15,
    );
  }

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
        color: Color.fromARGB(255, 199, 199, 199),
        borderRadius: BorderRadius.circular(5));
  }

  Widget _details(String lable, String value) {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: _boxDecoration(),
      child: Column(
        children: [
          Text(lable, style: _textStyle()),
          Text(value, style: _textStyle())
        ],
      ),
    );
  }
}
