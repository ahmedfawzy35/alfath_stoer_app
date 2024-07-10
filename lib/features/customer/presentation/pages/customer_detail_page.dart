import 'package:alfath_stoer_app/features/customer/presentation/cubit/customer_detail_cubit.dart';
import 'package:alfath_stoer_app/features/customer/presentation/cubit/customer_detail_state.dart';
import 'package:alfath_stoer_app/features/customer/presentation/widgets/item_process.dart';
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
        )
      ], // Ensure OrderCubit is available

      child: Scaffold(
        appBar: AppBar(
          title: const Text('كشف حساب عميل'),
        ),
        body: BlocBuilder<CustomerDetailCubit, CustomerSupplierDetailState>(
          builder: (context, state) {
            if (state is CustomerSupplierDetailLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is CustomerSupplierDetailLoaded) {
              final detail = state.detail;
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
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
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  // Add more fields as needed

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
    );
  }
}
