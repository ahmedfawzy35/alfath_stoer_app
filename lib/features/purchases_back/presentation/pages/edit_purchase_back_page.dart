import 'package:alfath_stoer_app/features/seller/presentation/cubit/seller_list_cubit.dart';
import 'package:alfath_stoer_app/features/seller/presentation/pages/seller_list_page.dart';
import 'package:alfath_stoer_app/features/purchases_back/datat/models/purchase_back.dart';
import 'package:alfath_stoer_app/features/purchases_back/presentation/cubit/cubit/purchase_back_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart' as date;

class EditPurchaseBackPage extends StatelessWidget {
  final PurchaseBack purchaseBack;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  EditPurchaseBackPage({Key? key, required this.purchaseBack})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController dateController = TextEditingController(
        text: date.DateFormat('yyyy-MM-dd')
            .format(DateTime.parse(purchaseBack.date!)));
    final TextEditingController totalController =
        TextEditingController(text: purchaseBack.total?.toString());
    final TextEditingController paidController =
        TextEditingController(text: purchaseBack.paid?.toString());
    final TextEditingController discountController =
        TextEditingController(text: purchaseBack.discount?.toString());
    final TextEditingController remainingAmountController =
        TextEditingController(
            text: (purchaseBack.total! -
                    (purchaseBack.paid ?? 0) -
                    (purchaseBack.discount ?? 0))
                .toString());
    final TextEditingController orderNumberController =
        TextEditingController(text: purchaseBack.orderNumber?.toString());
    final TextEditingController notesController =
        TextEditingController(text: purchaseBack.notes);
    final TextEditingController sellerNameController =
        TextEditingController(text: purchaseBack.sellerName);

    final TextEditingController sellerNumberController =
        TextEditingController(text: purchaseBack.sellerrId?.toString());

    DateTime selectedDate = DateTime.parse(purchaseBack.date!);

    void updateRemainingAmount() {
      final double? total = double.tryParse(totalController.text);
      final double? paid = double.tryParse(paidController.text);
      final double? discount = double.tryParse(discountController.text);
      final double remaining = (total ?? 0) - (paid ?? 0) - (discount ?? 0);
      remainingAmountController.text = remaining.toString();
      purchaseBack.orderNumber = int.parse(orderNumberController.text);
      purchaseBack.notes = notesController.text;
      purchaseBack.total = total;
      purchaseBack.paid = paid;
      purchaseBack.discount = discount;
      context.read<PurchaseBackCubit>().updatePurchaseField(purchaseBack);
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider<PurchaseBackCubit>(
          create: (_) => context.read<PurchaseBackCubit>(),
        ),
        BlocProvider<SellerListCubit>(
          create: (context) => SellerListCubit()..fetchData(),
        ),
      ],
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: Text('تعديل الفاتورة رقم ${purchaseBack.id}'),
          ),
          body: BlocBuilder<PurchaseBackCubit, PurchaseBackState>(
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
                            controller: sellerNumberController,
                            decoration:
                                const InputDecoration(labelText: 'رقم العميل'),
                            readOnly: true,
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
                                purchaseBack.sellerName = selectedSeller.name;
                                purchaseBack.sellerrId = selectedSeller.id;
                                context
                                    .read<PurchaseBackCubit>()
                                    .updatePurchaseField(purchaseBack);
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
                              purchaseBack.orderNumber = int.tryParse(value);
                              context
                                  .read<PurchaseBackCubit>()
                                  .updatePurchaseField(purchaseBack);
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
                              purchaseBack.notes = value;
                              context
                                  .read<PurchaseBackCubit>()
                                  .updatePurchaseField(purchaseBack);
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
                                        context.read<PurchaseBackCubit>();
                                    orderCubit.editPurchase(purchaseBack);

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
