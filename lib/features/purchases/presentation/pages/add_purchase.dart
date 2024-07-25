import 'package:alfath_stoer_app/features/customer/presentation/cubit/customer_list_cubit.dart';
import 'package:alfath_stoer_app/features/seller/presentation/pages/seller_list_page.dart';
import 'package:alfath_stoer_app/features/purchases/datat/models/purchase.dart';
import 'package:alfath_stoer_app/features/purchases/presentation/cubit/cubit/purchase_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart' as date;

class AddPurchasePage extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Purchase purchase;
  AddPurchasePage({
    Key? key,
    required this.purchase,
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
            text: ((purchase.total ?? 0) -
                    (purchase.paid ?? 0) -
                    (purchase.discount ?? 0))
                .toString());
    final TextEditingController orderNumberController = TextEditingController();
    final TextEditingController notesController = TextEditingController();
    final TextEditingController sellerNameController = TextEditingController();

    final TextEditingController sellerNumberController =
        TextEditingController();

    DateTime selectedDate = DateTime.now();

    void updateRemainingAmount() {
      final double? total = double.tryParse(totalController.text);
      final double? paid = double.tryParse(paidController.text);
      final double? discount = discountController.text.isEmpty
          ? 0
          : double.tryParse(discountController.text);
      final double remaining = (total ?? 0) - (paid ?? 0) - (discount ?? 0);

      remainingAmountController.text = remaining.toString();
      purchase.date = dateController.text;
      purchase.sellerrId = int.parse(sellerNumberController.text);
      purchase.total = total;
      purchase.paid = paid ?? 0;
      purchase.discount = discount ?? 0;
      purchase.remainingAmount = remaining;
      context.read<PurchaseCubit>().updatePurchaseField(purchase);
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
            title: const Text('اضافة فاتورة مشتريات '),
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
                              ),
                              Expanded(
                                  child: Container(
                                width: 1,
                              )),
                              Expanded(
                                child: TextFormField(
                                  controller: sellerNumberController,
                                  decoration: const InputDecoration(
                                      labelText: 'رقم المورد'),
                                  readOnly: true,
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 10),
                          GestureDetector(
                            onTap: () async {
                              final selectedSeller =
                                  await Navigator.of(context).push(
                                MaterialPageRoute(
                                  // ignore: prefer_const_constructors
                                  builder: (context) => SellerListPage(
                                    edit: true,
                                    branche: 'selectedBranche',
                                  ),
                                ),
                              );

                              if (selectedSeller != null) {
                                sellerNameController.text = selectedSeller.name;
                                sellerNumberController.text =
                                    selectedSeller.id.toString();
                                purchase.sellerName = selectedSeller.name;
                                purchase.sellerrId = selectedSeller.id;
                                context
                                    .read<PurchaseCubit>()
                                    .updatePurchaseField(purchase);
                              }
                            },
                            child: AbsorbPointer(
                              child: TextFormField(
                                controller: sellerNameController,
                                decoration: const InputDecoration(
                                    labelText: 'اسم المورد'),
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
                                onPressed: () async {
                                  if (_formKey.currentState?.validate() ??
                                      false) {
                                    final orderCubit =
                                        context.read<PurchaseCubit>();
                                    await orderCubit.addPurchase(purchase);
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
