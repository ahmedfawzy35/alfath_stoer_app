import 'package:alfath_stoer_app/features/customer/data/models/customer_model.dart';
import 'package:alfath_stoer_app/features/customer/presentation/cubit/customer_list_cubit.dart';
import 'package:alfath_stoer_app/features/customer/presentation/pages/customer_list_page.dart';
import 'package:alfath_stoer_app/features/customer_discount_settlements/data/models/customer_discount_settlement.dart';
import 'package:alfath_stoer_app/features/customer_discount_settlements/presentation/cubit/cubit/customer_a_s_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart' as date;

class CustomerDiscountSettlementAddEditPage extends StatelessWidget {
  final CustomerDiscountSettlement? customerDiscountSettlement;
  final CustomerModel? customer;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  CustomerDiscountSettlementAddEditPage(
      {Key? key, this.customerDiscountSettlement, this.customer})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController dateController = TextEditingController(
        text: customerDiscountSettlement == null
            ? date.DateFormat('yyyy-MM-dd').format(DateTime.now())
            : date.DateFormat('yyyy-MM-dd')
                .format(DateTime.parse(customerDiscountSettlement!.date!)));
    final TextEditingController valueController = TextEditingController(
        text: customerDiscountSettlement == null
            ? ""
            : customerDiscountSettlement!.value?.toString());

    final TextEditingController notesController = TextEditingController(
        text: customerDiscountSettlement == null
            ? ""
            : customerDiscountSettlement!.notes);
    final TextEditingController customerNameController = TextEditingController(
        text: customerDiscountSettlement == null
            ? customer == null
                ? ""
                : customer!.name.toString()
            : customerDiscountSettlement!.customerName);

    final TextEditingController customerNumberController =
        TextEditingController(
            text: customerDiscountSettlement == null
                ? customer == null
                    ? ""
                    : customer!.id.toString()
                : customerDiscountSettlement!.customerId?.toString());

    DateTime selectedDate = customerDiscountSettlement == null
        ? DateTime.now()
        : DateTime.parse(customerDiscountSettlement!.date!);

    void showSuccessSnackbar(String message) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.green,
        ),
      );
    }

    void ClearText() {
      valueController.clear();
      notesController.clear();
    }

    void submit() {
      CustomerDiscountSettlement myCustomerDiscountSettlement =
          CustomerDiscountSettlement(
        value: double.parse(valueController.text),
        brancheId: 1,
        customerId: int.parse(customerNumberController.text),
        customerName: customerNameController.text,
        date: dateController.text,
        notes: notesController.text,
        id: customerDiscountSettlement == null
            ? 1
            : customerDiscountSettlement!.id,
      );
      final customerDiscountSettlementCubit =
          context.read<CustomerDiscountSettlementCubit>();

      if (customerDiscountSettlement == null) {
        customerDiscountSettlementCubit
            .addCustomerDiscountSettlement(myCustomerDiscountSettlement)
            .then((_) {
          showSuccessSnackbar('تمت إضافة الخصم بنجاح');
          ClearText();
        });
      } else {
        customerDiscountSettlementCubit
            .editCustomerDiscountSettlement(myCustomerDiscountSettlement)
            .then((_) {
          showSuccessSnackbar('تم تعديل الخصم بنجاح');
          Navigator.of(context).pop();
        });
      }
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider<CustomerDiscountSettlementCubit>(
          create: (_) => context.read<CustomerDiscountSettlementCubit>(),
        ),
        BlocProvider<CustomerListCubit>(
          create: (context) => CustomerListCubit()..fetchData(),
        ),
      ],
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: customerDiscountSettlement == null
                ? const Text('اضافة تسوية خصم لعميل')
                : Text(
                    'تعديل التسوية خصم لعميل رقم ${customerDiscountSettlement!.id}'),
          ),
          body: BlocBuilder<CustomerDiscountSettlementCubit,
              CustomerDiscountSettlementState>(
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
                            controller: valueController,
                            decoration:
                                const InputDecoration(labelText: 'المبلغ'),
                            keyboardType: TextInputType.number,
                            onChanged: (value) {},
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
                            decoration:
                                const InputDecoration(labelText: 'ملاحظات'),
                            onChanged: (value) {},
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              ElevatedButton(
                                child: customerDiscountSettlement == null
                                    ? const Text('انشاء')
                                    : const Text('تعديل'),
                                onPressed: () {
                                  if (_formKey.currentState?.validate() ??
                                      false) {
                                    submit();
                                    ClearText();
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
