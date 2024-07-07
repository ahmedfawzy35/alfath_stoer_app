import 'package:alfath_stoer_app/core/utils/shared_prefs_service.dart';
import 'package:alfath_stoer_app/core/utils/strings.dart';
import 'package:alfath_stoer_app/features/auth/presentation/pages/login_page.dart';
import 'package:alfath_stoer_app/features/customer_supplier/presentation/pages/seller_list_page.dart';
import 'package:alfath_stoer_app/features/orders/data/models/order.dart';
import 'package:alfath_stoer_app/features/orders/presentation/cubit/cubit/order_cubit.dart';
import 'package:alfath_stoer_app/features/orders/presentation/pages/add_order.dart';
import 'package:alfath_stoer_app/features/orders_back/data/models/order_back.dart';
import 'package:alfath_stoer_app/features/orders_back/presentation/cubit/cubit/order_back_cubit.dart';
import 'package:alfath_stoer_app/features/orders_back/presentation/pages/add_order_back.dart';
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
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text(
                'العملاء',
                style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              onTap: () {
                //selectedBranche
                Navigator.pushNamed(
                  context,
                  MyRouts.customerListPage,
                  arguments: {'branche': selectedBranche},
                );
              },
            ),
            ExpansionTile(
                leading: const Icon(Icons.attach_money),
                title: const Text(
                  'المبيعات',
                  style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                children: [
                  ListTile(
                      leading: const Icon(Icons.add_card),
                      title: const Text(
                        'اضافة فاتورة بيع',
                        style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 13,
                            fontWeight: FontWeight.w500),
                      ),
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
                      title: const Text(
                        'ادارة فواتير البيع',
                        style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 13,
                            fontWeight: FontWeight.w500),
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, MyRouts.orderListPage);
                      }),
                  ListTile(
                      leading: const Icon(Icons.add_card),
                      title: const Text(
                        'اضافة مرتجع مبيعات',
                        style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 13,
                            fontWeight: FontWeight.w500),
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => BlocProvider<OrderBackCubit>(
                              create: (context) => OrderBackCubit(),
                              child: AddOrderBackPage(orderBack: OrderBack()),
                            ),
                          ),
                        );
                      }),
                  ListTile(
                      leading: const Icon(Icons.edit),
                      title: const Text(
                        'ادارة مرتجعات المبيعات',
                        style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 13,
                            fontWeight: FontWeight.w500),
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, MyRouts.orderBackListPage);
                      }),
                ]),
            ListTile(
              leading: const Icon(Icons.store),
              title: const Text(
                'الموردين',
                style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
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
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text(
                'تسجيل الخروج',
                style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
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
    );
  }
}
