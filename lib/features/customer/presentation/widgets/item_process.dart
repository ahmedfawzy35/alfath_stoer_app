import 'package:alfath_stoer_app/core/utils/my_types.dart';
import 'package:alfath_stoer_app/features/customer/data/models/customer_detail_model.dart';
import 'package:alfath_stoer_app/features/customer_adding_settlements/data/repositories/customer_a_s_repository.dart';
import 'package:alfath_stoer_app/features/customer_adding_settlements/presentation/cubit/cubit/customer_a_s_cubit.dart';
import 'package:alfath_stoer_app/features/customer_adding_settlements/presentation/pages/customer_a_s_add_edit_page.dart';
import 'package:alfath_stoer_app/features/orders/data/repositories/order_repository.dart';
import 'package:alfath_stoer_app/features/orders/presentation/cubit/cubit/order_cubit.dart';
import 'package:alfath_stoer_app/features/orders/presentation/pages/edit_order_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ItemProcess extends StatelessWidget {
  const ItemProcess(
      {required BuildContext context, super.key, required this.item});
  final ProcessElement item;
  @override
  Widget build(context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
              color: item.add! ? Colors.green[300] : Colors.amber[600],
              borderRadius: BorderRadius.circular(5)),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  PopupMenuButton<String>(
                    onSelected: (String result) {
                      switch (result) {
                        case 'Edit':
                          _editItem(context, item.id!, item.type!);
                          break;
                        case 'Delete':
                          _deleteItem(context, item.id!, item.type!);

                          break;
                        case 'Show':
                          _showItem(context, item.id!, item.type!);
                          break;
                      }
                    },
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<String>>[
                      const PopupMenuItem<String>(
                        value: 'Edit',
                        child: Text('تعديل'),
                      ),
                      const PopupMenuItem<String>(
                        value: 'Delete',
                        child: Text('حذف'),
                      ),
                      const PopupMenuItem<String>(
                        value: 'Show',
                        child: Text('عرض'),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Text(item.value.toString()),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(item.notes.toString()),
                ],
              ),
              Row(
                children: [
                  Text((item.date!).substring(0, 10)),
                  const SizedBox(width: 10),
                  item.number! > 0
                      ? Text(
                          '[رقم الفاتورة ${item.number!.round().toString()}]')
                      : const SizedBox(),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Container(
          height: 2,
          decoration: const BoxDecoration(color: Colors.black),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              (item.accountAfterElement!.round()).toString(),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }

  void _editItem(BuildContext context, int id, String processType) async {
    switch (processType) {
      case CustomerAccountElementTyps.Order:
        _editOrder(context, id);
      case CustomerAccountElementTyps.CustomerAddingSettlement:
        _editCustomerAddingSettlement(context, id);
    }
  }

  void _deleteItem(BuildContext context, int id, String processType) async {
    switch (processType) {
      case CustomerAccountElementTyps.Order:
        _deleteOrder(context, id);
    }
  }

  void _showItem(BuildContext context, int id, String processType) async {
    switch (processType) {
      case CustomerAccountElementTyps.Order:
        _showOrder(context, id);
    }
  }

  void _editOrder(BuildContext context, int id) async {
    final repo = OrderRepository();
    final order = await repo.getById(id);

    // ignore: use_build_context_synchronously
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BlocProvider<OrderCubit>(
          create: (context) => OrderCubit(),
          child: EditOrderPage(order: order),
        ),
      ),
    );
  }

  void _editCustomerAddingSettlement(BuildContext context, int id) async {
    final repo = CustomerAddingSettlementRepository();
    final customerAddingSettlement = await repo.getById(id);

    // ignore: use_build_context_synchronously
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BlocProvider<CustomerAddingSettlementCubit>(
          create: (context) => CustomerAddingSettlementCubit(),
          child: CustomerAddingSettlementAddEditPage(
              customerAddingSettlement: customerAddingSettlement),
        ),
      ),
    );
  }

  void _deleteOrder(BuildContext context, int id) {
    // هنا يمكنك إضافة منطق الحذف باستخدام OrderCubit
    final orderCubit = context.read<OrderCubit>();
    orderCubit.deleteOrder(id);
  }

  void _showOrder(BuildContext context, int id) {
    // هنا يمكنك إضافة منطق عرض باستخدام OrderCubit
  }
}
