import 'package:alfath_stoer_app/features/customer_supplier/presentation/cubit/customer_list_cubit.dart';
import 'package:alfath_stoer_app/features/customer_supplier/presentation/pages/customer_list_page.dart';
import 'package:alfath_stoer_app/features/purchases/datat/models/purchase.dart';
import 'package:alfath_stoer_app/features/purchases/presentation/cubit/cubit/purchase_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart' as date;

class EditPurchasePage extends StatelessWidget {
  final Purchase purchase;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  EditPurchasePage({Key? key, required this.purchase}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController dateController = TextEditingController(
        text: date.DateFormat('yyyy-MM-dd')
            .format(DateTime.parse(purchase.date!)));
    final TextEditingController totalController =
        TextEditingController(text: purchase.total?.toString());
    final TextEditingController paidController =
        TextEditingController(text: purchase.paid?.toString());
    final TextEditingController discountController =
        TextEditingController(text: purchase.discount?.toString());
    final TextEditingController remainingAmountController =
        TextEditingController(
            text: (purchase.total! -
                    (purchase.paid ?? 0) -
                    (purchase.discount ?? 0))
                .toString());
    final TextEditingController orderNumberController =
        TextEditingController(text: purchase.orderNumber?.toString());
    final TextEditingController notesController =
        TextEditingController(text: purchase.notes);
    final TextEditingController customerNameController =
        TextEditingController(text: purchase.sellerName);

    final TextEditingController customerNumberController =
        TextEditingController(text: purchase.sellerrId?.toString());

    DateTime selectedDate = DateTime.parse(purchase.date!);

    void updateRemainingAmount() {
      final double? total = double.tryParse(totalController.text);
      final double? paid = double.tryParse(paidController.text);
      final double? discount = double.tryParse(discountController.text);
      final double remaining = (total ?? 0) - (paid ?? 0) - (discount ?? 0);
      remainingAmountController.text = remaining.toString();
      purchase.total = total;
      purchase.paid = paid;
      purchase.discount = discount;
      context.read<PurchaseCubit>().updatePurchaseField(purchase);
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider<PurchaseCubit>(
          create: (_) => context.read<PurchaseCubit>(),
        ),
        BlocProvider<CustomerListCubit>(
          create: (context) => CustomerListCubit()..fetchData(),
        ),
      ],
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: Text('تعديل الفاتورة رقم ${purchase.id}'),
          ),
          body: BlocBuilder<PurchaseCubit, PurchaseState>(
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
                                purchase.sellerName = selectedCustomer.name;
                                purchase.sellerrId = selectedCustomer.id;
                                context
                                    .read<PurchaseCubit>()
                                    .updatePurchaseField(purchase);
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
                              purchase.orderNumber = int.tryParse(value);
                              context
                                  .read<PurchaseCubit>()
                                  .updatePurchaseField(purchase);
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
                              purchase.notes = value;
                              context
                                  .read<PurchaseCubit>()
                                  .updatePurchaseField(purchase);
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
                                        context.read<PurchaseCubit>();
                                    orderCubit.editPurchase(purchase);

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
