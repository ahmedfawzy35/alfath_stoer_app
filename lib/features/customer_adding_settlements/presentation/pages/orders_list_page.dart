// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:alfath_stoer_app/features/seller/presentation/cubit/seller_list_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' as date;

import 'package:alfath_stoer_app/features/customer/presentation/cubit/customer_list_cubit.dart';
import 'package:alfath_stoer_app/features/main_widgets/rosponsiv_layout.dart';
import 'package:alfath_stoer_app/features/orders/data/models/order.dart';
import 'package:alfath_stoer_app/features/orders/presentation/cubit/cubit/order_cubit.dart';
import 'package:alfath_stoer_app/features/orders/presentation/pages/edit_order_page.dart';

class OrderListPage extends StatelessWidget {
  final String? branche;
  final DateTime fromDate;
  final DateTime toDate;
  final bool singleDay;
  const OrderListPage({
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
          ' الفواتير - ${singleDay ? 'لليوم  ${date.DateFormat('yyyy-MM-dd').format(fromDate)}' : 'للفترة من ${date.DateFormat('yyyy-MM-dd').format(fromDate)} الى ${date.DateFormat('yyyy-MM-dd').format(toDate)}'} ',
          style: const TextStyle(fontSize: 14),
        )),
        body: singleDay
            ? BlocProvider(
                create: (_) => OrderCubit()..getForDate(fromDate),
                child: const OrderList(),
              )
            : BlocProvider(
                create: (_) => OrderCubit()..getForTime(fromDate, toDate),
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
              context.read<OrderCubit>().filterItemsByName(query);
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
              context.read<OrderCubit>().filterItems(query);
            },
          ),
        ),
        Expanded(
          child: BlocBuilder<OrderCubit, OrderState>(
            builder: (context, state) {
              if (state is OrderLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is OrdersListLoaded) {
                return ListView.builder(
                  itemCount: state.filteredItems.length,
                  itemBuilder: (context, index) {
                    final item = state.filteredItems[index];

                    return OrderListItemRe(
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

class OrderListItem extends StatelessWidget {
  const OrderListItem({
    super.key,
    required this.item,
  });
  final Order item;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.amber, borderRadius: BorderRadius.circular(5)),
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
                          Text(item.orderNumber.toString(), style: _textStyle())
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
                              builder: (context) => BlocProvider<OrderCubit>(
                                create: (context) => OrderCubit(),
                                child: EditOrderPage(order: item),
                              ),
                            ),
                          );
                        }),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        final orderCubit = context.read<OrderCubit>();
                        orderCubit.deleteOrder(item.id!);
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

class OrderListItemRe extends StatelessWidget {
  const OrderListItemRe({
    super.key,
    required this.item,
  });
  final Order item;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool ismobil = constraints.maxWidth < 600;

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            child: ismobil
                ? _buildMobileContent(context)
                : _buildNarrowContent(context),
          ),
        );
      },
    );
  }

  Widget _buildMobileContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          decoration: BoxDecoration(
              color: Colors.amber, borderRadius: BorderRadius.circular(5)),
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
                      Text(item.orderNumber.toString(), style: _textStyle())
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
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
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
                            child: EditOrderPage(order: item),
                          ),
                        ),
                      );
                    }),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    final orderCubit = context.read<OrderCubit>();
                    orderCubit.deleteOrder(item.id!);
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
    );
  }

  Widget _buildNarrowContent(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
                date.DateFormat('yyyy-MM-dd')
                    .format(DateTime.parse(item.date!)),
                style: _textStyle()),
            _mySizeBox(),
            Column(
              children: [
                Text('رقم الفاتورة ', style: _textStyle()),
                Text(item.orderNumber.toString(), style: _textStyle())
              ],
            ),
            const SizedBox(
              width: 5,
            ),
            _mySizeBox(),
            Column(
              children: [
                Text(
                  'المعرف ',
                  style: _textStyle(),
                ),
                Text(item.id.toString(), style: _textStyle())
              ],
            ),
            _mySizeBox(),
            Container(
              width: width * .20,
              child: Column(
                children: [
                  Text(item.customerName.toString(), style: _textStyle())
                ],
              ),
            ),
            _mySizeBox(),
          ],
        ),
        const SizedBox(
          width: 15,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _details('الاجمالي', item.total.toString()),
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
          ],
        ),
        Text(
          item.notes!,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const Spacer(),
        Column(
          children: [
            ElevatedButton(
                child: const Text('تعديل'),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => BlocProvider<OrderCubit>(
                        create: (context) => OrderCubit(),
                        child: EditOrderPage(order: item),
                      ),
                    ),
                  );
                }),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                final orderCubit = context.read<OrderCubit>();
                orderCubit.deleteOrder(item.id!);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('حذف'),
            )
          ],
        ),
      ],
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
      width: 100,
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

Widget _mySizeBox() {
  return Row(
    children: [
      const SizedBox(
        width: 10,
      ),
      Container(
        width: 1,
        height: 50,
        decoration: const BoxDecoration(color: Color.fromARGB(255, 66, 57, 57)),
      ),
      const SizedBox(
        width: 10,
      ),
    ],
  );
}
