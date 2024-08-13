import 'package:alfath_stoer_app/features/cashout_to_seller/data/models/cashout_to_seller_model.dart';
import 'package:alfath_stoer_app/features/cashout_to_seller/presentation/cubit/cashout_to_seller_cubit.dart';
import 'package:alfath_stoer_app/features/cashout_to_seller/presentation/cubit/cashout_to_seller_state.dart';
import 'package:alfath_stoer_app/features/seller/presentation/pages/seller_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart' as date;

class AddCashOutToSellerPage extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final CashOutToSeller cash = CashOutToSeller();
  AddCashOutToSellerPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController dateController = TextEditingController(
        text: date.DateFormat('yyyy-MM-dd').format(DateTime.now()));
    final TextEditingController valueController = TextEditingController();

    final TextEditingController notesController = TextEditingController();
    final TextEditingController sellerNameController = TextEditingController();

    final TextEditingController sellerNumberController =
        TextEditingController();

    DateTime selectedDate = DateTime.now();

    final FocusNode dateFocusNode = FocusNode();
    final FocusNode valueFocusNode = FocusNode();
    final FocusNode customerNameFocusNode = FocusNode();
    final FocusNode noteFocusNode = FocusNode();
    final FocusNode saverFocusNode = FocusNode();

    void showSuccessSnackbar(String message) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.green,
        ),
      );
    }

    void updateValues() {
      final double? value = double.tryParse(valueController.text);

      cash.date = dateController.text;
      cash.sellerId = int.parse(sellerNumberController.text);
      cash.value = value;

      context.read<CashOutToSellerCubit>().updateCashField(cash);
    }

    void clearText() {
      valueController.clear();

      notesController.clear();
      updateValues();
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('اضافة صرف لمورد '),
        ),
        body: BlocBuilder<CashOutToSellerCubit, CashOutToSellerState>(
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
                              const InputDecoration(labelText: 'رقم المورد'),
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
                                  branche: '',
                                ),
                              ),
                            );

                            if (selectedSeller != null) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                sellerNameController.text = selectedSeller.name;
                                sellerNumberController.text =
                                    selectedSeller.id.toString();
                                cash.sellerName = selectedSeller.name;
                                cash.sellerId = selectedSeller.id;
                                context
                                    .read<CashOutToSellerCubit>()
                                    .updateCashField(cash);
                              });
                            }
                          },
                          child: AbsorbPointer(
                            child: TextFormField(
                              focusNode: customerNameFocusNode,
                              onFieldSubmitted: (_) {
                                FocusScope.of(context)
                                    .requestFocus(dateFocusNode);
                              },
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
                                  date.DateFormat('yyyy-MM-dd').format(picked);
                            }
                          },
                          child: AbsorbPointer(
                            child: TextFormField(
                              controller: dateController,
                              focusNode: dateFocusNode,
                              onFieldSubmitted: (_) {
                                FocusScope.of(context)
                                    .requestFocus(valueFocusNode);
                              },
                              decoration:
                                  const InputDecoration(labelText: 'التاريخ'),
                              readOnly: true,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: valueController,
                          focusNode: valueFocusNode,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).requestFocus(noteFocusNode);
                          },
                          decoration:
                              const InputDecoration(labelText: 'المبلغ'),
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          onChanged: (value) {
                            updateValues();
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
                          controller: notesController,
                          focusNode: noteFocusNode,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).requestFocus(saverFocusNode);
                          },
                          decoration:
                              const InputDecoration(labelText: 'ملاحظات'),
                          onChanged: (value) {
                            cash.notes = value;
                            context
                                .read<CashOutToSellerCubit>()
                                .updateCashField(cash);
                          },
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            ElevatedButton(
                              focusNode: saverFocusNode,
                              child: const Text('حفظ'),
                              onPressed: () async {
                                if (_formKey.currentState?.validate() ??
                                    false) {
                                  final cashCubit =
                                      context.read<CashOutToSellerCubit>();
                                  await cashCubit
                                      .addCashOutToSeller(cash)
                                      .then((_) {
                                    showSuccessSnackbar(
                                        'تمت إضافة الصرفية بنجاح');
                                    clearText();
                                    FocusScope.of(context)
                                        .requestFocus(valueFocusNode);
                                  });
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
    );
  }
}
