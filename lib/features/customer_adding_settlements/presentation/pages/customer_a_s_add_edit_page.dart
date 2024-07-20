import 'package:alfath_stoer_app/features/customer/data/models/customer_model.dart';
import 'package:alfath_stoer_app/features/customer/presentation/cubit/customer_list_cubit.dart';
import 'package:alfath_stoer_app/features/customer/presentation/pages/customer_list_page.dart';
import 'package:alfath_stoer_app/features/customer_adding_settlements/data/models/customer_adding_settlement.dart';
import 'package:alfath_stoer_app/features/customer_adding_settlements/presentation/cubit/cubit/customer_a_s_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart' as date;

class CustomerAddingSettlementAddEditPage extends StatelessWidget {
  final CustomerAddingSettlement? customerAddingSettlement;
  final CustomerModel? customer;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  CustomerAddingSettlementAddEditPage(
      {Key? key, this.customerAddingSettlement, this.customer})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController dateController = TextEditingController(
        text: customerAddingSettlement == null
            ? date.DateFormat('yyyy-MM-dd').format(DateTime.now())
            : date.DateFormat('yyyy-MM-dd')
                .format(DateTime.parse(customerAddingSettlement!.date!)));
    final TextEditingController valueController = TextEditingController(
        text: customerAddingSettlement == null
            ? ""
            : customerAddingSettlement!.value?.toString());

    final TextEditingController notesController = TextEditingController(
        text: customerAddingSettlement == null
            ? ""
            : customerAddingSettlement!.notes);
    final TextEditingController customerNameController = TextEditingController(
        text: customerAddingSettlement == null
            ? customer == null
                ? ""
                : customer!.name.toString()
            : customerAddingSettlement!.customerName);

    final TextEditingController customerNumberController =
        TextEditingController(
            text: customerAddingSettlement == null
                ? customer == null
                    ? ""
                    : customer!.id.toString()
                : customerAddingSettlement!.customerId?.toString());

    DateTime selectedDate = customerAddingSettlement == null
        ? DateTime.now()
        : DateTime.parse(customerAddingSettlement!.date!);

    void submit() {
      CustomerAddingSettlement mycustomerAddingSettlement =
          CustomerAddingSettlement(
        value: double.parse(valueController.text),
        brancheId: 1,
        customerId: int.parse(customerNumberController.text),
        customerName: customerNameController.text,
        date: dateController.text,
        notes: notesController.text,
        id: customerAddingSettlement == null ? 1 : customerAddingSettlement!.id,
      );
      final customerAddingSettlementCubit =
          context.read<CustomerAddingSettlementCubit>();

      if (customerAddingSettlement == null) {
        customerAddingSettlementCubit
            .addCustomerAddingSettlement(mycustomerAddingSettlement);
      } else {
        customerAddingSettlementCubit
            .editCustomerAddingSettlement(mycustomerAddingSettlement);
        Navigator.of(context).pop();
      }
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider<CustomerAddingSettlementCubit>(
          create: (_) => context.read<CustomerAddingSettlementCubit>(),
        ),
        BlocProvider<CustomerListCubit>(
          create: (context) => CustomerListCubit()..fetchData(),
        ),
      ],
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: customerAddingSettlement == null
                ? const Text('اضافة فاتورة')
                : Text('تعديل التسوية رقم ${customerAddingSettlement!.id}'),
          ),
          body: BlocBuilder<CustomerAddingSettlementCubit,
              CustomerAddingSettlementState>(
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
                            decoration:
                                const InputDecoration(labelText: 'ملاحظات'),
                            onChanged: (value) {},
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              ElevatedButton(
                                child: customerAddingSettlement == null
                                    ? const Text('انشاء')
                                    : const Text('تعديل'),
                                onPressed: () {
                                  if (_formKey.currentState?.validate() ??
                                      false) {
                                    submit();
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
