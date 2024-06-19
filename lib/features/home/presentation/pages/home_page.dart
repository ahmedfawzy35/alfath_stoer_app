import 'package:alfath_stoer_app/features/customer_supplier/data/repositories/customer_supplier_detail_repository.dart';
import 'package:alfath_stoer_app/features/customer_supplier/data/repositories/customer_supplier_list_repository.dart';
import 'package:alfath_stoer_app/features/customer_supplier/data/repositories/seller_list_repository.dart';
import 'package:alfath_stoer_app/features/customer_supplier/presentation/cubit/seller_list_cubit.dart';
import 'package:alfath_stoer_app/features/customer_supplier/presentation/cubit/customer_supplier_list_cubit.dart';
import 'package:alfath_stoer_app/features/customer_supplier/presentation/pages/customer_supplier_page.dart';
import 'package:alfath_stoer_app/features/customer_supplier/presentation/pages/seller_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  final CustomerSupplierListRepository customeRepository;
  final SellerListRepository sellerRepository;
  final CustomerSupplierDetailRepository customeDetailsRepository;

  HomePage(
      {required this.customeRepository,
      required this.sellerRepository,
      required this.customeDetailsRepository});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/customerSupplierPage');
              },
              child: Text('Customers'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/sellerListPage');
              },
              child: Text('Suppliers'),
            ),
          ],
        ),
      ),
    );
  }
}
