import 'package:alfath_stoer_app/core/utils/strings.dart';
import 'package:alfath_stoer_app/features/customer_supplier/data/repositories/customer_supplier_detail_repository.dart';
import 'package:alfath_stoer_app/features/customer_supplier/data/repositories/customer_supplier_list_repository.dart';
import 'package:alfath_stoer_app/features/customer_supplier/presentation/cubit/customer_supplier_list_cubit.dart';
import 'package:alfath_stoer_app/features/customer_supplier/presentation/pages/customer_supplier_page.dart';
import 'package:alfath_stoer_app/features/orders/data/models/order.dart';
import 'package:alfath_stoer_app/features/orders/presentation/cubit/cubit/order_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart' as date;

class EditOrderPage extends StatelessWidget {
  final Order order;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  EditOrderPage({Key? key, required this.order}) : super(key: key);

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
            text: (order.total! - (order.paid ?? 0) - (order.discount ?? 0))
                .toString());
    final TextEditingController orderNumberController =
        TextEditingController(text: order.orderNumber?.toString());
    final TextEditingController notesController =
        TextEditingController(text: order.notes);
    final TextEditingController customerNameController =
        TextEditingController(text: order.customerName);

    final TextEditingController customerNumberController =
        TextEditingController(text: order.customerId?.toString());
    final repo = CustomerSupplierListRepository(MyStrings.baseurl);

    DateTime selectedDate = DateTime.parse(order.date!);

    void updateRemainingAmount() {
      final double? total = double.tryParse(totalController.text);
      final double? paid = double.tryParse(paidController.text);
      final double? discount = double.tryParse(discountController.text);
      final double remaining = (total ?? 0) - (paid ?? 0) - (discount ?? 0);
      remainingAmountController.text = remaining.toString();
      order.total = total;
      order.paid = paid;
      order.discount = discount;
      context.read<OrderCubit>().updateOrderField(order);
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider<OrderCubit>(
          create: (_) => context.read<OrderCubit>(),
        ),
        BlocProvider<CustomerSupplierListCubit>(
          create: (context) =>
              CustomerSupplierListCubit(repo)..fetchData('Customer', ' '),
        ),
      ],
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: Text('تعديل الفاتورة رقم ${order.id}'),
          ),
          body: BlocBuilder<OrderCubit, OrderState>(
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
                              final customerSupplierListRepository =
                                  CustomerSupplierListRepository(
                                      MyStrings.baseurl);
                              final customerSupplierDetailRepository =
                                  CustomerSupplierDetailRepository(
                                      baseUrl: MyStrings.baseurl);

                              final selectedCustomer =
                                  await Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => CustomerSupplierPage(
                                    repository: customerSupplierListRepository,
                                    customeDetailsRepository:
                                        customerSupplierDetailRepository,
                                    type: 'Customer',
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
                                order.customerName = selectedCustomer.name;
                                order.customerId = selectedCustomer.id;
                                context
                                    .read<OrderCubit>()
                                    .updateOrderField(order);
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
                              order.orderNumber = int.tryParse(value);
                              context
                                  .read<OrderCubit>()
                                  .updateOrderField(order);
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
                              order.notes = value;
                              context
                                  .read<OrderCubit>()
                                  .updateOrderField(order);
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
                                        context.read<OrderCubit>();
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
              );
            },
          ),
        ),
      ),
    );
  }
}
