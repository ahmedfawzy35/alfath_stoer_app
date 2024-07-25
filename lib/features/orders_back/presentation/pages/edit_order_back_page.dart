import 'package:alfath_stoer_app/features/customer/presentation/cubit/customer_list_cubit.dart';
import 'package:alfath_stoer_app/features/customer/presentation/pages/customer_list_page.dart';
import 'package:alfath_stoer_app/features/orders_back/data/models/order_back.dart';
import 'package:alfath_stoer_app/features/orders_back/presentation/cubit/cubit/order_back_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart' as date;

class EditOrderBackPage extends StatelessWidget {
  final OrderBack orderBack;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  EditOrderBackPage({Key? key, required this.orderBack}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController dateController = TextEditingController(
        text: date.DateFormat('yyyy-MM-dd')
            .format(DateTime.parse(orderBack.date!)));
    final TextEditingController totalController =
        TextEditingController(text: orderBack.total?.toString());
    final TextEditingController paidController =
        TextEditingController(text: orderBack.paid?.toString());
    final TextEditingController discountController =
        TextEditingController(text: orderBack.discount?.toString());
    final TextEditingController remainingAmountController =
        TextEditingController(
            text: (orderBack.total! -
                    (orderBack.paid ?? 0) -
                    (orderBack.discount ?? 0))
                .toString());
    final TextEditingController orderNumberController =
        TextEditingController(text: orderBack.orderNumber?.toString());
    final TextEditingController notesController =
        TextEditingController(text: orderBack.notes);
    final TextEditingController customerNameController =
        TextEditingController(text: orderBack.customerName);

    final TextEditingController customerNumberController =
        TextEditingController(text: orderBack.customerId?.toString());

    DateTime selectedDate = DateTime.parse(orderBack.date!);

    void updateRemainingAmount() {
      final double? total = double.tryParse(totalController.text);
      final double? paid = double.tryParse(paidController.text);
      final double? discount = double.tryParse(discountController.text);
      final double remaining = (total ?? 0) - (paid ?? 0) - (discount ?? 0);
      remainingAmountController.text = remaining.toString();
      orderBack.total = total;
      orderBack.paid = paid ?? 0;
      orderBack.discount = discount ?? 0;
      context.read<OrderBackCubit>().updateOrderField(orderBack);
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider<OrderBackCubit>(
          create: (_) => context.read<OrderBackCubit>(),
        ),
        BlocProvider<CustomerListCubit>(
          create: (context) => CustomerListCubit()..fetchData(),
        ),
      ],
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: Text('تعديل المرتجع رقم ${orderBack.id}'),
          ),
          body: BlocBuilder<OrderBackCubit, OrderBackState>(
            builder: (context, state) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          TextFormField(
                            controller: customerNumberController,
                            decoration:
                                const InputDecoration(labelText: 'رقم العميل'),
                            readOnly: true,
                          ),
                          const SizedBox(height: 10),
                          GestureDetector(
                            onTap: () async {
                              final selectedCustomer =
                                  await Navigator.of(context).push(
                                MaterialPageRoute(
                                  // ignore: prefer_const_constructors
                                  builder: (context) => CustomerListPage(
                                    edit: true,
                                    branche: 'selectedBranche',
                                  ),
                                ),
                              );

                              if (selectedCustomer != null) {
                                customerNameController.text =
                                    selectedCustomer.name;
                                customerNumberController.text =
                                    selectedCustomer.id.toString();
                                orderBack.customerName = selectedCustomer.name;
                                orderBack.customerId = selectedCustomer.id;
                                context
                                    .read<OrderBackCubit>()
                                    .updateOrderField(orderBack);
                              }
                            },
                            child: AbsorbPointer(
                              child: TextFormField(
                                controller: customerNameController,
                                decoration: const InputDecoration(
                                    labelText: 'اسم العميل'),
                                readOnly: true,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
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
                                    date.DateFormat('yyyy-MM-dd')
                                        .format(picked);
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
                              updateRemainingAmount();
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
                            decoration:
                                const InputDecoration(labelText: 'المدفوع'),
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            onChanged: (value) {
                              updateRemainingAmount();
                            },
                            validator: (value) {
                              if (value != null) {
                                if (value.isNotEmpty) {
                                  if (double.tryParse(value) == null) {
                                    return 'يرجى إدخال رقم صالح';
                                  }
                                }
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: discountController,
                            decoration:
                                const InputDecoration(labelText: 'الخصم'),
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            onChanged: (value) {
                              updateRemainingAmount();
                            },
                            validator: (value) {
                              if (value != null) {
                                if (value.isNotEmpty) {
                                  if (double.tryParse(value) == null) {
                                    return 'يرجى إدخال رقم صالح';
                                  }
                                }
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: remainingAmountController,
                            decoration:
                                const InputDecoration(labelText: 'المتبقي'),
                            readOnly: true,
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: orderNumberController,
                            decoration: const InputDecoration(
                                labelText: 'رقم الفاتورة'),
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            onChanged: (value) {
                              orderBack.orderNumber = int.tryParse(value);
                              context
                                  .read<OrderBackCubit>()
                                  .updateOrderField(orderBack);
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
                            decoration:
                                const InputDecoration(labelText: 'ملاحظات'),
                            onChanged: (value) {
                              orderBack.notes = value;
                              context
                                  .read<OrderBackCubit>()
                                  .updateOrderField(orderBack);
                            },
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              ElevatedButton(
                                child: const Text('حفظ'),
                                onPressed: () {
                                  if (_formKey.currentState?.validate() ??
                                      false) {
                                    final orderCubit =
                                        context.read<OrderBackCubit>();
                                    orderCubit.editOrderBack(orderBack);
                                    Navigator.of(context).pop();
                                  }
                                },
                              ),
                              const SizedBox(width: 10),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                                child: const Text('إلغاء'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
