import 'package:alfath_stoer_app/features/customer/presentation/cubit/customer_list_cubit.dart';
import 'package:alfath_stoer_app/features/customer/presentation/pages/customer_list_page.dart';
import 'package:alfath_stoer_app/features/orders_back/data/models/order_back.dart';
import 'package:alfath_stoer_app/features/orders_back/presentation/cubit/cubit/order_back_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart' as date;

class AddOrderBackPage extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final OrderBack orderBack;
  AddOrderBackPage({
    Key? key,
    required this.orderBack,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController dateController = TextEditingController(
        text: date.DateFormat('yyyy-MM-dd').format(DateTime.now()));
    final TextEditingController totalController = TextEditingController();
    final TextEditingController paidController = TextEditingController();
    final TextEditingController discountController =
        TextEditingController(text: '0');
    final TextEditingController remainingAmountController =
        TextEditingController(
            text: ((orderBack.total ?? 0) -
                    (orderBack.paid ?? 0) -
                    (orderBack.discount ?? 0))
                .toString());
    final TextEditingController orderNumberController = TextEditingController();
    final TextEditingController notesController = TextEditingController();
    final TextEditingController customerNameController =
        TextEditingController();

    final TextEditingController customerNumberController =
        TextEditingController();

    DateTime selectedDate = DateTime.now();

    void updateRemainingAmount() {
      final double? total = double.tryParse(totalController.text);
      final double? paid = double.tryParse(paidController.text);
      final double? discount = double.tryParse(discountController.text);
      final double remaining = (total ?? 0) - (paid ?? 0) - (discount ?? 0);

      remainingAmountController.text = remaining.toString();
      orderBack.date = dateController.text;
      orderBack.customerId = int.parse(customerNumberController.text);
      orderBack.total = total;
      orderBack.paid = paid ?? 0;
      orderBack.discount = discount ?? 0;
      orderBack.remainingAmount = remaining;
      context.read<OrderBackCubit>().updateOrderField(orderBack);
    }

    void clearText() {
      totalController.clear();
      paidController.text = '0';
      discountController.text = '0';
      final int? orderumber = int.tryParse(orderNumberController.text);

      orderNumberController.text = (orderumber! + 1).toString();
      notesController.clear();
      updateRemainingAmount();
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
            title: const Text('اضافة مرتجع '),
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
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
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
                              ),
                              Expanded(
                                  child: Container(
                                width: 1,
                              )),
                              Expanded(
                                child: TextFormField(
                                  controller: customerNumberController,
                                  decoration: const InputDecoration(
                                      labelText: 'رقم العميل'),
                                  readOnly: true,
                                ),
                              )
                            ],
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
                                // ignore: use_build_context_synchronously
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
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: totalController,
                                  decoration: const InputDecoration(
                                      labelText: 'الإجمالي'),
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
                              ),
                              const Expanded(child: SizedBox(width: 15)),
                              Expanded(
                                child: TextFormField(
                                  controller: paidController,
                                  decoration: const InputDecoration(
                                      labelText: 'المدفوع'),
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
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
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
                              ),
                              const Expanded(child: SizedBox()),
                              Expanded(
                                child: TextFormField(
                                  controller: remainingAmountController,
                                  decoration: const InputDecoration(
                                      labelText: 'المتبقي'),
                                  readOnly: true,
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 10),
                          const SizedBox(height: 10),
                          TextFormField(
                            maxLines: 3,
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
                                onPressed: () async {
                                  if (_formKey.currentState?.validate() ??
                                      false) {
                                    final orderBackCubit =
                                        context.read<OrderBackCubit>();
                                    await orderBackCubit
                                        .addOrderBack(orderBack);
                                    clearText();
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
