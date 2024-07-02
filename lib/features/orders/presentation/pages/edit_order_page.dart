import 'package:alfath_stoer_app/features/orders/data/models/order.dart';
import 'package:alfath_stoer_app/features/orders/presentation/cubit/cubit/order_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart' as date;

class EditOrderPage extends StatelessWidget {
  final Order order;

  const EditOrderPage({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController dateController = TextEditingController(
        text:
            date.DateFormat('yyyy-MM-dd').format(DateTime.parse(order.date!)));
    final TextEditingController totalController =
        TextEditingController(text: order.total?.toString());
    final TextEditingController paidController =
        TextEditingController(text: order.paid?.toString());
    final TextEditingController discountController =
        TextEditingController(text: order.discount?.toString());
    final TextEditingController remainingAmountController =
        TextEditingController(
            text: (order.total! - (order.paid ?? 0)).toString());
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
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('تعديل الفاتورة'),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
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
                            dateController.text =
                                date.DateFormat('yyyy-MM-dd').format(picked);
                          }
                        },
                        child: AbsorbPointer(
                          child: TextFormField(
                            controller: dateController,
                            decoration:
                                const InputDecoration(labelText: 'التاريخ'),
                            readOnly: true,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: totalController,
                        decoration:
                            const InputDecoration(labelText: 'الإجمالي'),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        onChanged: (value) {
                          final double? total = double.tryParse(value);
                          final double? paid =
                              double.tryParse(paidController.text);
                          if (total != null && paid != null) {
                            remainingAmountController.text =
                                (total - paid).toString();
                          }
                          order.total = total;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'يرجى إدخال الإجمالي';
                          }
                          if (double.tryParse(value) == null) {
                            return 'يرجى إدخال رقم صالح';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: paidController,
                        decoration: const InputDecoration(labelText: 'المدفوع'),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        onChanged: (value) {
                          final double? total =
                              double.tryParse(totalController.text);
                          final double? paid = double.tryParse(value);
                          if (total != null && paid != null) {
                            remainingAmountController.text =
                                (total - paid).toString();
                          }
                          order.paid = paid;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'يرجى إدخال المدفوع';
                          }
                          if (double.tryParse(value) == null) {
                            return 'يرجى إدخال رقم صالح';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: discountController,
                        decoration: const InputDecoration(labelText: 'الخصم'),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        onChanged: (value) {
                          order.discount = double.tryParse(value);
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'يرجى إدخال الخصم';
                          }
                          if (double.tryParse(value) == null) {
                            return 'يرجى إدخال رقم صالح';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: remainingAmountController,
                        decoration: const InputDecoration(labelText: 'المتبقي'),
                        readOnly: true,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: orderNumberController,
                        decoration:
                            const InputDecoration(labelText: 'رقم الفاتورة'),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        onChanged: (value) {
                          order.orderNumber = int.tryParse(value);
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'يرجى إدخال رقم الفاتورة';
                          }
                          if (int.tryParse(value) == null) {
                            return 'يرجى إدخال رقم صالح';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
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
                          ElevatedButton(
                            child: const Text('حفظ'),
                            onPressed: () {
                              if (Form.of(context)?.validate() ?? false) {
                                final orderCubit = context.read<OrderCubit>();
                                orderCubit.editOrder(order);
                                Navigator.of(context).pop();
                              }
                            },
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            child: const Text('إلغاء'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
