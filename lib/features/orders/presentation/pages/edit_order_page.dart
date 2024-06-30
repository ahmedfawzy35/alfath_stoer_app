import 'package:alfath_stoer_app/features/orders/data/models/order.dart';
import 'package:alfath_stoer_app/features/orders/presentation/cubit/cubit/order_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditOrderPage extends StatelessWidget {
  final Order order;

  const EditOrderPage({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController dateController =
        TextEditingController(text: order.date);
    final TextEditingController totalController =
        TextEditingController(text: order.total?.toString());
    final TextEditingController paidController =
        TextEditingController(text: order.paid?.toString());
    final TextEditingController discountController =
        TextEditingController(text: order.discount?.toString());
    final TextEditingController remainingAmountController =
        TextEditingController(text: order.remainingAmount?.toString());
    final TextEditingController orderNumberController =
        TextEditingController(text: order.orderNumber?.toString());
    final TextEditingController notesController =
        TextEditingController(text: order.notes);

    DateTime selectedDate = DateTime.parse(order.date!);

    return MultiBlocProvider(
        providers: [
          BlocProvider<OrderCubit>(
            create: (_) =>
                context.read<OrderCubit>(), // Ensure OrderCubit is available
          ),
        ],
        child: Scaffold(
          appBar: AppBar(
            title: const Text('تعديل الفاتورة'),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                GestureDetector(
                  onTap: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null && picked != selectedDate) {
                      selectedDate = picked;
                      dateController.text = picked.toString();
                    }
                  },
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: dateController,
                      decoration: const InputDecoration(labelText: 'التاريخ'),
                      readOnly: true,
                    ),
                  ),
                ),
                TextFormField(
                  controller: totalController,
                  decoration: const InputDecoration(labelText: 'الإجمالي'),
                  onChanged: (value) {
                    order.total = double.tryParse(value);
                  },
                ),
                TextFormField(
                  controller: paidController,
                  decoration: const InputDecoration(labelText: 'المدفوع'),
                  onChanged: (value) {
                    order.paid = double.tryParse(value);
                  },
                ),
                TextFormField(
                  controller: discountController,
                  decoration: const InputDecoration(labelText: 'الخصم'),
                  onChanged: (value) {
                    order.discount = double.tryParse(value);
                  },
                ),
                TextFormField(
                  controller: remainingAmountController,
                  decoration: const InputDecoration(labelText: 'المتبقي'),
                  onChanged: (value) {
                    order.remainingAmount = double.tryParse(value);
                  },
                ),
                TextFormField(
                  controller: orderNumberController,
                  decoration: const InputDecoration(labelText: 'رقم الفاتورة'),
                  onChanged: (value) {
                    order.orderNumber = int.tryParse(value);
                  },
                ),
                TextFormField(
                  controller: notesController,
                  decoration: const InputDecoration(labelText: 'ملاحظات'),
                  onChanged: (value) {
                    order.notes = value;
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    TextButton(
                      child: const Text('حفظ'),
                      onPressed: () {
                        final orderCubit = context.read<OrderCubit>();
                        orderCubit.editOrder(order);
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: const Text('إلغاء'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
