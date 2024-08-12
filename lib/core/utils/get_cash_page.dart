import 'package:alfath_stoer_app/core/utils/my_types.dart';
import 'package:alfath_stoer_app/features/cashin_from_customer/presentation/cubit/cashin_from_customer_cubit.dart';
import 'package:alfath_stoer_app/features/cashin_from_customer/presentation/pages/cashin_from_customer_add_page%20.dart';
import 'package:alfath_stoer_app/features/cashout_to_seller/presentation/cubit/cashout_to_seller_cubit.dart';
import 'package:alfath_stoer_app/features/cashout_to_seller/presentation/pages/cashout_to_seller_add_page%20.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetCashBage {
  Widget getAddPage(CashTypes type) {
    switch (type) {
      case CashTypes.cashInFromCustomer:
        return BlocProvider<CashInFromCustomerCubit>(
          create: (context) => CashInFromCustomerCubit(),
          child: AddCashInFromCustomerPage(),
        );
      case CashTypes.cashOutToSeller:
        return BlocProvider<CashOutToSellerCubit>(
          create: (context) => CashOutToSellerCubit(),
          child: AddCashOutToSellerPage(),
        );

      default:
        return Container();
    }
  }

  Widget getEditPage(CashTypes type, Widget page) {
    switch (type) {
      case CashTypes.cashInFromCustomer:
        return BlocProvider<CashInFromCustomerCubit>(
          create: (context) => CashInFromCustomerCubit(),
          child: page,
        );
      case CashTypes.cashOutToSeller:
        return BlocProvider<CashOutToSellerCubit>(
          create: (context) => CashOutToSellerCubit(),
          child: page,
        );

      default:
        return Container();
    }
  }
}
