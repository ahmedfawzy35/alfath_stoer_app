import 'package:alfath_stoer_app/core/utils/shared_prefs_service.dart';
import 'package:alfath_stoer_app/core/utils/strings.dart';
import 'package:alfath_stoer_app/features/auth/data/repositories/login_repository.dart';
import 'package:alfath_stoer_app/features/auth/presentation/cubit/login_cubit.dart';
import 'package:alfath_stoer_app/features/auth/presentation/pages/login_page.dart';
import 'package:alfath_stoer_app/features/customer_supplier/data/repositories/customer_supplier_detail_repository.dart';
import 'package:alfath_stoer_app/features/customer_supplier/data/repositories/customer_supplier_list_repository.dart';
import 'package:alfath_stoer_app/features/customer_supplier/data/repositories/seller_list_repository.dart';
import 'package:alfath_stoer_app/features/customer_supplier/presentation/pages/customer_supplier_page.dart';
import 'package:alfath_stoer_app/features/customer_supplier/presentation/pages/seller_list_page.dart';
import 'package:alfath_stoer_app/features/home/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  final customerSupplierListRepository =
      CustomerSupplierListRepository(MyStrings.baseurl);
  final sellerListRepository = SellerListRepository(MyStrings.baseurl);

  final customerSupplierDetailRepository =
      CustomerSupplierDetailRepository(baseUrl: MyStrings.baseurl);
  final loginRepository = LoginRepository(baseUrl: MyStrings.baseurl);

  runApp(MyApp(
    customerRepository: customerSupplierListRepository,
    sellerRepository: sellerListRepository,
    customerSupplierDetailRepository: customerSupplierDetailRepository,
    loginRepository: loginRepository,
  ));
}

class MyApp extends StatelessWidget {
  final CustomerSupplierListRepository customerRepository;
  final SellerListRepository sellerRepository;
  final CustomerSupplierDetailRepository customerSupplierDetailRepository;
  final LoginRepository loginRepository;

  MyApp(
      {required this.customerRepository,
      required this.sellerRepository,
      required this.customerSupplierDetailRepository,
      required this.loginRepository});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LoginCubit(loginRepository),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Customer Supplier App',
        theme: ThemeData(
          primarySwatch: Colors.teal,
        ),
        home: FutureBuilder<Map<String, dynamic>?>(
            future: SharedPrefsService().getUserData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }
              if (snapshot.hasData && snapshot.data != null) {
                return HomePage(
                  customeRepository: customerRepository,
                  sellerRepository: sellerRepository,
                  customeDetailsRepository: customerSupplierDetailRepository,
                );
              } else {
                return LoginPage();
              }
            }),
        routes: {
          '/home': (context) => HomePage(
                customeRepository: customerRepository,
                sellerRepository: sellerRepository,
                customeDetailsRepository: customerSupplierDetailRepository,
              ),
          '/customerSupplierPage': (context) => CustomerSupplierPage(
                type: 'Customer',
                repository: customerRepository,
                customeDetailsRepository: customerSupplierDetailRepository,
              ),
          '/sellerListPage': (context) => SellerListPage(
                type: 'Seller',
                repository: sellerRepository,
              ),
          // قم بإضافة المسارات الأخرى إذا لزم الأمر
        },
      ),
    );
  }
}
