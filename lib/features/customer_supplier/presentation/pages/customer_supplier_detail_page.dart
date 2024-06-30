import 'package:alfath_stoer_app/features/customer_supplier/data/repositories/customer_supplier_detail_repository.dart';
import 'package:alfath_stoer_app/features/customer_supplier/presentation/cubit/customer_supplier_detail_cubit.dart';
import 'package:alfath_stoer_app/features/customer_supplier/presentation/cubit/customer_supplier_detail_state.dart';
import 'package:alfath_stoer_app/features/customer_supplier/presentation/widgets/item_process.dart';
import 'package:alfath_stoer_app/features/orders/presentation/cubit/cubit/order_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomerSupplierDetailPage extends StatelessWidget {
  final String type;
  final int id;
  final CustomerSupplierDetailRepository repository;

  const CustomerSupplierDetailPage({
    super.key,
    required this.type,
    required this.id,
    required this.repository,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CustomerSupplierDetailCubit>(
          create: (_) => CustomerSupplierDetailCubit(repository)
            ..fetchCustomerSupplierDetail(type, id),
        ),
        BlocProvider<OrderCubit>(
          create: (_) => context.read<OrderCubit>(),
        )
      ], // Ensure OrderCubit is available

      child: Scaffold(
        appBar: AppBar(
          title: Text(type == 'Customer' ? 'كشف حساب عميل' : 'كشف حساب مورد'),
        ),
        body: BlocBuilder<CustomerSupplierDetailCubit,
            CustomerSupplierDetailState>(
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
