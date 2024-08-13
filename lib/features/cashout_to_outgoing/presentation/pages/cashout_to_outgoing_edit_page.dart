import 'package:alfath_stoer_app/features/cashout_to_OutGoing/data/models/cashout_to_OutGoing_model.dart';
import 'package:alfath_stoer_app/features/cashout_to_OutGoing/presentation/cubit/cashout_to_OutGoing_state.dart';
import 'package:alfath_stoer_app/features/cashout_to_outgoing/presentation/cubit/cashout_to_outgoing_cubit.dart';
import 'package:alfath_stoer_app/features/customer/presentation/pages/customer_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart' as date;

class EditCashOutToOutGoingPage extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final CashOutToOutGoing cash;
  EditCashOutToOutGoingPage({
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
    final TextEditingController outGoingNameController =
        TextEditingController(text: cash.outGoingName);

    final TextEditingController outGoingNumberController =
        TextEditingController(text: cash.outGoingId.toString());

    DateTime selectedDate = DateTime.parse(cash.date!);

    final FocusNode dateFocusNode = FocusNode();
    final FocusNode valueFocusNode = FocusNode();
    final FocusNode outGoingNameFocusNode = FocusNode();
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
      cash.outGoingId = int.parse(outGoingNumberController.text);
      cash.value = value;

      context.read<CashOutToOutGoingCubit>().updateCashField(cash);
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('تعديل صرف لبند مصروفات '),
        ),
        body: BlocBuilder<CashOutToOutGoingCubit, CashOutToOutGoingState>(
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
                          controller: outGoingNumberController,
                          decoration: const InputDecoration(
                              labelText: 'رقم بند المصروفات'),
                          readOnly: true,
                        ),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: () async {
                            final selectedOutGoing =
                                await Navigator.of(context).push(
                              MaterialPageRoute(
                                // ignore: prefer_const_constructors
                                builder: (context) => CustomerListPage(
                                  edit: true,
                                  branche: '',
                                ),
                              ),
                            );

                            if (selectedOutGoing != null) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                outGoingNameController.text =
                                    selectedOutGoing.name;
                                outGoingNumberController.text =
                                    selectedOutGoing.id.toString();
                                cash.outGoingName = selectedOutGoing.name;
                                cash.outGoingId = selectedOutGoing.id;
                                context
                                    .read<CashOutToOutGoingCubit>()
                                    .updateCashField(cash);
                              });
                            }
                          },
                          child: AbsorbPointer(
                            child: TextFormField(
                              focusNode: outGoingNameFocusNode,
                              onFieldSubmitted: (_) {
                                FocusScope.of(context)
                                    .requestFocus(dateFocusNode);
                              },
                              controller: outGoingNameController,
                              decoration: const InputDecoration(
                                  labelText: 'اسم بند المصروفات'),
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
                              return 'يرجى إدخال المبلغ';
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
                                .read<CashOutToOutGoingCubit>()
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
                                      context.read<CashOutToOutGoingCubit>();
                                  cashCubit.update(cash).then((_) {
                                    showSuccessSnackbar(
                                        'تمت إضافة الصرفية بنجاح');
                                  });
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
