import 'package:alfath_stoer_app/features/customer/data/models/customer_model.dart';
import 'package:alfath_stoer_app/features/customer/presentation/cubit/customer_detail_cubit.dart';
import 'package:alfath_stoer_app/features/customer/presentation/cubit/customer_detail_state.dart';
import 'package:alfath_stoer_app/features/customer/presentation/widgets/item_process.dart';
import 'package:alfath_stoer_app/features/customer_adding_settlements/presentation/cubit/cubit/customer_a_s_cubit.dart';
import 'package:alfath_stoer_app/features/customer_adding_settlements/presentation/pages/customer_a_s_add_edit_page.dart';
import 'package:alfath_stoer_app/features/orders/presentation/cubit/cubit/order_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomerDetailPage extends StatelessWidget {
  final int id;

  const CustomerDetailPage({
    super.key,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CustomerDetailCubit>(
          create: (_) => CustomerDetailCubit()..fetchCustomerSupplierDetail(id),
        ),
        BlocProvider<OrderCubit>(
          create: (context) => OrderCubit(),
        ),
        BlocProvider<OrderCubit>(
          create: (context) => OrderCubit(),
        ),
        BlocProvider<CustomerAddingSettlementCubit>(
          create: (context) => CustomerAddingSettlementCubit(),
        )
      ],
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('كشف حساب عميل'),
            actions: [
              IconButton(
                icon: Icon(Icons.refresh),
                onPressed: () {
                  context
                      .read<CustomerDetailCubit>()
                      .fetchCustomerSupplierDetail(id);
                },
              ),
            ],
          ),
          body: BlocListener<CustomerDetailCubit, CustomerSupplierDetailState>(
            listener: (context, state) {
              if (state is CustomerSupplierDetailLoaded) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('تم تحديث البيانات')),
                );
              } else if (state is CustomerSupplierDetailError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text('فشل في تحديث البيانات: ${state.message}')),
                );
              }
            },
            child:
                BlocBuilder<CustomerDetailCubit, CustomerSupplierDetailState>(
              builder: (context, state) {
                if (state is CustomerSupplierDetailLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is CustomerSupplierDetailLoaded) {
                  final detail = state.detail;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'رقم العميل :        ${detail.customerId}',
                                    textDirection: TextDirection.rtl,
                                    style: const TextStyle(
                                        fontFamily: 'Cairo',
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Text(
                                'الاسم:      ${detail.name}',
                                textDirection: TextDirection.rtl,
                                style: const TextStyle(
                                    fontFamily: 'Cairo',
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'بداية الحساب :        ${detail.lastAccount}',
                                textDirection: TextDirection.rtl,
                                style: const TextStyle(
                                    fontFamily: 'Cairo',
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'الحساب النهائي:        ${detail.finalCustomerAccount}',
                                textDirection: TextDirection.rtl,
                                style: const TextStyle(
                                    fontFamily: 'Cairo',
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          Spacer(),
                          Column(
                            children: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .push(
                                      MaterialPageRoute(
                                        builder: (context) => BlocProvider<
                                            CustomerAddingSettlementCubit>(
                                          create: (context) =>
                                              CustomerAddingSettlementCubit(),
                                          child:
                                              CustomerAddingSettlementAddEditPage(
                                                  customer: CustomerModel(
                                                      id: detail.customerId,
                                                      name: detail.name)),
                                        ),
                                      ),
                                    )
                                        .then((_) {
                                      context
                                          .read<CustomerDetailCubit>()
                                          .fetchCustomerSupplierDetail(id);
                                    });
                                  },
                                  child: Text('اضافة تسوية اضافة')),
                              TextButton(
                                  onPressed: () {},
                                  child: Text('اضافة تسوية خصم')),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListView.builder(
                            itemCount: detail.elements.length,
                            itemBuilder: (context, index) {
                              final item = detail.elements[index];
                              return ItemProcess(
                                context: context,
                                item: item,
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      )
                    ],
                  );
                } else if (state is CustomerSupplierDetailError) {
                  return Center(child: Text(state.message));
                } else {
                  return const Center(child: Text('Unknown state'));
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
