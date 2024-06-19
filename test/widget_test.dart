import 'package:alfath_stoer_app/features/customer_supplier/data/repositories/customer_supplier_detail_repository.dart';
import 'package:alfath_stoer_app/features/customer_supplier/data/repositories/customer_supplier_list_repository.dart';
import 'package:alfath_stoer_app/features/customer_supplier/data/repositories/seller_list_repository.dart';
import 'package:alfath_stoer_app/features/home/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('HomePage has a title and buttons', (WidgetTester tester) async {
    // Create a mock repository
    final mockRepository =
        CustomerSupplierListRepository('http://alfathstore.runasp.net/api/');
    final sellerListRepository =
        SellerListRepository('http://alfathstore.runasp.net/api');
    final customerSupplierDetailRepository = CustomerSupplierDetailRepository(
        baseUrl: 'http://alfathstore.runasp.net/api');

    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(
      home: HomePage(
        customeRepository: mockRepository,
        sellerRepository: sellerListRepository,
        customeDetailsRepository: customerSupplierDetailRepository,
      ),
    ));

    // Verify that the HomePage has a title
    expect(find.text('Home Page'), findsOneWidget);

    // Verify that the HomePage has buttons
    expect(find.text('Customers'), findsOneWidget);
    expect(find.text('Suppliers'), findsOneWidget);

    // Tap the Customers button and trigger a frame.
    await tester.tap(find.text('Customers'));
    await tester.pump();

    // Verify that we navigate to the CustomerSupplierPage with type 'Customer'
    expect(find.text('Customer List'), findsOneWidget);

    // Navigate back to the HomePage
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pump();

    // Tap the Suppliers button and trigger a frame.
    await tester.tap(find.text('Suppliers'));
    await tester.pump();

    // Verify that we navigate to the CustomerSupplierPage with type 'Supplier'
    expect(find.text('Supplier List'), findsOneWidget);
  });
}
