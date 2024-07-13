import 'package:alfath_stoer_app/features/customer/presentation/cubit/customer_list_cubit.dart';
import 'package:alfath_stoer_app/features/orders_back/data/models/order_back.dart';
import 'package:alfath_stoer_app/features/orders_back/presentation/cubit/cubit/order_back_cubit.dart';
import 'package:alfath_stoer_app/features/orders_back/presentation/pages/edit_order_back_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' as date;

class OrderBackListPage extends StatelessWidget {
  final String? branche;
  final DateTime fromDate;
  final DateTime toDate;
  final bool singleDay;
  const OrderBackListPage({
    super.key,
    this.branche,
    required this.fromDate,
    required this.toDate,
    required this.singleDay,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
            title: Text(
          ' المرتجعات - ${singleDay ? 'لليوم  ${date.DateFormat('dd-MM-yyyy').format(fromDate)}' : 'للفترة من ${date.DateFormat('yyyy-MM-dd').format(fromDate)} الى ${date.DateFormat('yyyy-MM-dd').format(toDate)}'} ',
          style: const TextStyle(fontSize: 14),
        )),
        body: singleDay
            ? BlocProvider(
                create: (_) => OrderBackCubit()..getForDate(fromDate),
                child: const OrderList(),
              )
            : BlocProvider(
                create: (_) => OrderBackCubit()..getForTime(fromDate, toDate),
                child: const OrderList(),
              ),
      ),
    );
  }
}

class OrderList extends StatelessWidget {
  const OrderList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: const InputDecoration(
              labelText: 'بحث باسم العميل',
              border: OutlineInputBorder(),
            ),
            onChanged: (query) {
              context.read<OrderBackCubit>().filterItemsByName(query);
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
              context.read<OrderBackCubit>().filterItems(query);
            },
          ),
        ),
        Expanded(
          child: BlocBuilder<OrderBackCubit, OrderBackState>(
            builder: (context, state) {
              if (state is OrderLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is OrdersListLoaded) {
                return ListView.builder(
                  itemCount: state.filteredItems.length,
                  itemBuilder: (context, index) {
                    final item = state.filteredItems[index];

                    return OrderBackListItem(
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

class OrderBackListItem extends StatelessWidget {
  const OrderBackListItem({
    super.key,
    required this.item,
  });
  final OrderBack item;
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
                        date.DateFormat('yyyy-MM-dd')
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
                      item.customerName!,
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
                                builder: (context) =>
                                    BlocProvider<OrderBackCubit>(
                                  create: (context) => OrderBackCubit(),
                                  child: EditOrderBackPage(orderBack: item),
                                ),
                              ),
                            );
                          }),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          final orderCubit = context.read<OrderBackCubit>();
                          orderCubit.deleteOrderBack(item.id!);
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
        color: Colors.deepOrange[100], borderRadius: BorderRadius.circular(5));
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
