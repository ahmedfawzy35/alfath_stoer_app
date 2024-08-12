import 'package:alfath_stoer_app/features/cashin_from_customer/data/models/cashin_from_customer_model.dart';
import 'package:alfath_stoer_app/features/cashin_from_customer/presentation/cubit/cashin_from_customer_cubit.dart';
import 'package:alfath_stoer_app/features/cashin_from_customer/presentation/cubit/cashin_from_customer_state.dart';
import 'package:alfath_stoer_app/features/customer/presentation/pages/customer_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart' as date;

class EditCashInFromCustomerPage extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final CashInFromCustomer cash;
  EditCashInFromCustomerPage({
    Key? key,
    required this.cash,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController dateController = TextEditingController(
        text: date.DateFormat('yyyy-MM-dd').format(DateTime.parse(cash.date!)));
    final TextEditingController valueController =
        TextEditingController(text: cash.value.toString());

    final TextEditingController notesController =
        TextEditingController(text: cash.notes);
    final TextEditingController customerNameController =
        TextEditingController(text: cash.customerName);

    final TextEditingController customerNumberController =
        TextEditingController(text: cash.customerId.toString());

    DateTime selectedDate = DateTime.parse(cash.date!);

    final FocusNode dateFocusNode = FocusNode();
    final FocusNode valueFocusNode = FocusNode();
    final FocusNode customerNameFocusNode = FocusNode();
    final FocusNode noteFocusNode = FocusNode();
    final FocusNode saverFocusNode = FocusNode();

    void updateValues() {
      final double? value = double.tryParse(valueController.text);

      cash.date = dateController.text;
      cash.customerId = int.parse(customerNumberController.text);
      cash.value = value;

      context.read<CashInFromCustomerCubit>().updateCashField(cash);
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('تعديل تحصيل من عميل '),
        ),
        body: BlocBuilder<CashInFromCustomerCubit, CashInFromCustomerState>(
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
                                  branche: '',
                                ),
                              ),
                            );

                            if (selectedCustomer != null) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                customerNameController.text =
                                    selectedCustomer.name;
                                customerNumberController.text =
                                    selectedCustomer.id.toString();
                                cash.customerName = selectedCustomer.name;
                                cash.customerId = selectedCustomer.id;
                                context
                                    .read<CashInFromCustomerCubit>()
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
                                .read<CashInFromCustomerCubit>()
                                .updateCashField(cash);
                          },
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            ElevatedButton(
                              focusNode: saverFocusNode,
                              child: const Text('تعديل'),
                              onPressed: () {
                                if (_formKey.currentState?.validate() ??
                                    false) {
                                  final cashCubit =
                                      context.read<CashInFromCustomerCubit>();
                                  cashCubit.update(cash);
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
    );
  }
}
