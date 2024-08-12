import 'package:alfath_stoer_app/core/utils/shared_prefs_service.dart';
import 'package:alfath_stoer_app/core/utils/strings.dart';
import 'package:alfath_stoer_app/features/auth/presentation/pages/login_view.dart';
import 'package:alfath_stoer_app/features/cashin_from_customer/data/models/cashin_from_customer_model.dart';
import 'package:alfath_stoer_app/features/cashin_from_customer/presentation/cubit/cashin_from_customer_cubit.dart';
import 'package:alfath_stoer_app/features/cashin_from_customer/presentation/pages/cashin_from_customer_add_page%20.dart';
import 'package:alfath_stoer_app/features/seller/presentation/pages/seller_list_page.dart';
import 'package:alfath_stoer_app/features/orders/data/models/order.dart';
import 'package:alfath_stoer_app/features/orders/presentation/cubit/cubit/order_cubit.dart';
import 'package:alfath_stoer_app/features/orders/presentation/pages/add_order.dart';
import 'package:alfath_stoer_app/features/orders_back/data/models/order_back.dart';
import 'package:alfath_stoer_app/features/orders_back/presentation/cubit/cubit/order_back_cubit.dart';
import 'package:alfath_stoer_app/features/orders_back/presentation/pages/add_order_back.dart';
import 'package:alfath_stoer_app/features/purchases/datat/models/purchase.dart';
import 'package:alfath_stoer_app/features/purchases/presentation/cubit/cubit/purchase_cubit.dart';
import 'package:alfath_stoer_app/features/purchases/presentation/pages/add_purchase.dart';
import 'package:alfath_stoer_app/features/purchases_back/datat/models/purchase_back.dart';
import 'package:alfath_stoer_app/features/purchases_back/presentation/cubit/cubit/purchase_back_cubit.dart';
import 'package:alfath_stoer_app/features/purchases_back/presentation/pages/add_purchase_back.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? userName;
  List<String>? allBranches;
  List<String>? userBranches;
  List<String>? climes;
  SharedPrefsService sharedPrefsService = SharedPrefsService();
  String selectedBranche = " ";
  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefsService = SharedPrefsService();
    final userData = await prefsService.getUserData();
    final selectedBranche1 = await sharedPrefsService.getSelectedBrancheName();
    if (userData != null) {
      setState(() {
        userName = userData['userName'];
        allBranches = List<String>.from(userData['allBranches']);
        userBranches = List<String>.from(userData['userBranches']);
        climes = List<String>.from(userData['climes']);
        selectedBranche = selectedBranche1;
      });
    }
  }

  Future<void> _logout(BuildContext context) async {
    final prefsService = SharedPrefsService();
    await prefsService.clearUserData();
    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LogindView()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'الرئيسية -  $selectedBranche',
            style: const TextStyle(
              fontFamily: 'Cairo',
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: const BoxDecoration(
                  color: Colors.teal,
                ),
                child: Column(
                  children: [
                    Text(
                      userName == null ? " " : userName!,
                      style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      selectedBranche,
                      style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              ExpansionTile(
                leading: const Icon(Icons.person_4),
                title: Text(
                  'العملاء',
                  style: firstTextStyle(),
                ),
                children: [
                  ListTile(
                    leading: const Icon(Icons.add),
                    title: Text(
                      'اضافة عميل',
                      style: secondStyle(),
                    ),
                    onTap: () {
                      //selectedBranche
                      Navigator.pushNamed(
                        context,
                        MyRouts.customerAddPage,
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.person),
                    title: Text('ادارة العملاء', style: secondStyle()),
                    onTap: () {
                      //selectedBranche
                      Navigator.pushNamed(
                        context,
                        MyRouts.customerListPage,
                        arguments: {'branche': selectedBranche},
                      );
                    },
                  ),
                ],
              ),
              ExpansionTile(
                  leading: const Icon(Icons.attach_money),
                  title: Text('المبيعات', style: firstTextStyle()),
                  children: [
                    ListTile(
                        leading: const Icon(Icons.add_card),
                        title: Text('اضافة فاتورة بيع', style: secondStyle()),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => BlocProvider<OrderCubit>(
                                create: (context) => OrderCubit(),
                                child: AddOrderPage(order: Order()),
                              ),
                            ),
                          );
                        }),
                    ListTile(
                        leading: const Icon(Icons.edit),
                        title: Text(
                          'ادارة فواتير البيع',
                          style: secondStyle(),
                        ),
                        onTap: () {
                          Navigator.pushNamed(context, MyRouts.orderListPage);
                        }),
                    ListTile(
                        leading: const Icon(Icons.add_card),
                        title: Text(
                          'اضافة مرتجع مبيعات',
                          style: secondStyle(),
                        ),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  BlocProvider<OrderBackCubit>(
                                create: (context) => OrderBackCubit(),
                                child: AddOrderBackPage(orderBack: OrderBack()),
                              ),
                            ),
                          );
                        }),
                    ListTile(
                        leading: const Icon(Icons.edit),
                        title: Text(
                          'ادارة مرتجعات المبيعات',
                          style: secondStyle(),
                        ),
                        onTap: () {
                          Navigator.pushNamed(
                              context, MyRouts.orderBackListPage);
                        }),
                  ]),
              ExpansionTile(
                leading: const Icon(Icons.person_4),
                title: Text(
                  'الموردين',
                  style: firstTextStyle(),
                ),
                children: [
                  ListTile(
                    leading: const Icon(Icons.add),
                    title: Text('اضافة مورد', style: secondStyle()),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        MyRouts.sellerAddPage,
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.store),
                    title: Text('ادارة الموردين', style: secondStyle()),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SellerListPage(
                            edit: false,
                            branche: selectedBranche,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
              ExpansionTile(
                  leading: const Icon(Icons.attach_money),
                  title: Text('المشتريات', style: firstTextStyle()),
                  children: [
                    ListTile(
                        leading: const Icon(Icons.add_card),
                        title: Text(
                          'اضافة فاتورة شراء',
                          style: secondStyle(),
                        ),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => BlocProvider<PurchaseCubit>(
                                create: (context) => PurchaseCubit(),
                                child: AddPurchasePage(purchase: Purchase()),
                              ),
                            ),
                          );
                        }),
                    ListTile(
                        leading: const Icon(Icons.edit),
                        title: Text(
                          'ادارة فواتير الشراء',
                          style: secondStyle(),
                        ),
                        onTap: () {
                          Navigator.pushNamed(
                              context, MyRouts.purchaseListPage);
                        }),
                    ListTile(
                        leading: const Icon(Icons.add_card),
                        title: Text(
                          'اضافة مرتجع شراء',
                          style: secondStyle(),
                        ),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  BlocProvider<PurchaseBackCubit>(
                                create: (context) => PurchaseBackCubit(),
                                child: AddPurchaseBackPage(
                                    purchaseBack: PurchaseBack()),
                              ),
                            ),
                          );
                        }),
                    ListTile(
                        leading: const Icon(Icons.edit),
                        title: Text(
                          'ادارة مرتجعات المشتريات',
                          style: secondStyle(),
                        ),
                        onTap: () {
                          Navigator.pushNamed(
                              context, MyRouts.purchaseBackManage);
                        }),
                  ]),
              ExpansionTile(
                  leading: const Icon(Icons.attach_money),
                  title: Text('استلام نقدية', style: firstTextStyle()),
                  children: [
                    ListTile(
                        leading: const Icon(Icons.add_card),
                        title: Text(
                          'تحصيل من عميل',
                          style: secondStyle(),
                        ),
                        onTap: () {
                          Navigator.pushNamed(
                              context, MyRouts.addCashInFromCustomer);
                          /*  Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  BlocProvider<CashInFromCustomerCubit>(
                                create: (context) => CashInFromCustomerCubit(),
                                child: AddCashInFromCustomerPage(
                                    cash: CashInFromCustomer()),
                              ),
                            ),
                          );*/
                        }),
                  ]),
              ListTile(
                leading: const Icon(Icons.logout),
                title: Text(
                  'تسجيل الخروج',
                  style: firstTextStyle(),
                ),
                onTap: () => _logout(context),
              ),
            ],
          ),
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /*
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/customerSupplierPage');
                    },
                    child: const Text('Customers'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/sellerListPage');
                    },
                    child: const Text('Suppliers'),
                  ),*/
            ],
          ),
        ),
      ),
    );
  }

  TextStyle firstTextStyle() {
    return const TextStyle(
        fontFamily: 'Cairo', fontSize: 16, fontWeight: FontWeight.bold);
  }

  TextStyle secondStyle() {
    return const TextStyle(
        fontFamily: 'Cairo', fontSize: 13, fontWeight: FontWeight.w500);
  }
}
