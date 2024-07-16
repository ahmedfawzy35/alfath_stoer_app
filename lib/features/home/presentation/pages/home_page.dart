import 'package:alfath_stoer_app/core/utils/shared_prefs_service.dart';
import 'package:alfath_stoer_app/features/auth/presentation/pages/login_view.dart';
import 'package:alfath_stoer_app/features/customer/data/models/customer_model.dart';
import 'package:alfath_stoer_app/features/customer/presentation/pages/customer_add_page.dart';
import 'package:alfath_stoer_app/features/customer/presentation/pages/customer_list_page.dart';
import 'package:alfath_stoer_app/features/orders/presentation/pages/manage_orders.dart';
import 'package:alfath_stoer_app/features/purchases/datat/models/purchase.dart';
import 'package:alfath_stoer_app/features/purchases_back/datat/models/purchase_back.dart';
import 'package:alfath_stoer_app/features/seller/presentation/pages/seller_list_page.dart';
import 'package:alfath_stoer_app/features/orders/data/models/order.dart';
import 'package:alfath_stoer_app/features/orders/presentation/cubit/cubit/order_cubit.dart';
import 'package:alfath_stoer_app/features/orders/presentation/pages/add_order.dart';
import 'package:alfath_stoer_app/features/orders_back/data/models/order_back.dart';
import 'package:alfath_stoer_app/features/orders_back/presentation/cubit/cubit/order_back_cubit.dart';
import 'package:alfath_stoer_app/features/orders_back/presentation/pages/add_order_back.dart';
import 'package:alfath_stoer_app/features/purchases/presentation/cubit/cubit/purchase_cubit.dart';
import 'package:alfath_stoer_app/features/purchases/presentation/pages/add_purchase.dart';
import 'package:alfath_stoer_app/features/purchases_back/presentation/cubit/cubit/purchase_back_cubit.dart';
import 'package:alfath_stoer_app/features/purchases_back/presentation/pages/add_purchase_back.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  String? userName;
  List<String>? allBranches;
  List<String>? userBranches;
  List<String>? climes;
  SharedPrefsService sharedPrefsService = SharedPrefsService();
  String selectedBranche = " ";
  List<Tab> myTabs = [];
  List<Widget> tabViews = [];
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _tabController = TabController(length: myTabs.length, vsync: this);
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
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LogindView()),
    );
  }

  void _addTab(String title, Widget page) {
    // Check if the tab with this page is already open
    for (int i = 0; i < tabViews.length; i++) {
      if (tabViews[i].toStringShort() == page.toStringShort()) {
        // If the tab is already open, switch to it
        _tabController.animateTo(i);
        return;
      }
    }

    // If tab is not open, add a new one
    setState(() {
      myTabs.add(Tab(
        child: Row(
          children: [
            Text(title),
            IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _removeTab(myTabs.length - 1);
              },
            ),
          ],
        ),
      ));
      tabViews.add(page);
      _tabController = TabController(length: myTabs.length, vsync: this);
      _tabController.animateTo(myTabs.length - 1);
    });
  }

  void _removeTab(int index) {
    setState(() {
      myTabs.removeAt(index);
      tabViews.removeAt(index);
      _tabController = TabController(length: myTabs.length, vsync: this);
    });
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
          bottom: myTabs.isNotEmpty
              ? TabBar(
                  controller: _tabController,
                  tabs: myTabs,
                  isScrollable: true,
                )
              : null,
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
                title: const Text(
                  'العملاء',
                  style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                children: [
                  ListTile(
                    leading: const Icon(Icons.add),
                    title: const Text(
                      'اضافة عميل',
                      style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      _addTab('اضافة عميل',
                          CustomerAddPage(customer: CustomerModel()));
                      Navigator.pop(context); // Close the drawer
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.person),
                    title: const Text(
                      'ادارة العملاء',
                      style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      _addTab(
                        'ادارة العملاء',
                        CustomerListPage(), // استخدم الصفحة الفعلية هنا
                      );
                      Navigator.pop(context); // Close the drawer
                    },
                  ),
                ],
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
                          _addTab(
                            'اضافة فاتورة بيع',
                            BlocProvider<OrderCubit>(
                              create: (context) => OrderCubit(),
                              child: AddOrderPage(order: Order()),
                            ),
                          );
                          Navigator.pop(context); // Close the drawer
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
                          _addTab('ادارة فواتير البيع', OrderManage());
                          Navigator.pop(context); // Close the drawer
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
                          _addTab(
                            'اضافة مرتجع مبيعات',
                            BlocProvider<OrderBackCubit>(
                              create: (context) => OrderBackCubit(),
                              child: AddOrderBackPage(orderBack: OrderBack()),
                            ),
                          );
                          Navigator.pop(context); // Close the drawer
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
                          _addTab('ادارة مرتجعات المبيعات',
                              Text('ادارة مرتجعات المبيعات Page'));
                          Navigator.pop(context); // Close the drawer
                        }),
                  ]),
              ExpansionTile(
                leading: const Icon(Icons.person_4),
                title: const Text(
                  'الموردين',
                  style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                children: [
                  ListTile(
                    leading: const Icon(Icons.add),
                    title: const Text(
                      'اضافة مورد',
                      style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      _addTab('اضافة مورد', Text('اضافة مورد Page'));
                      Navigator.pop(context); // Close the drawer
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.person),
                    title: const Text(
                      'ادارة الموردين',
                      style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      _addTab('ادارة الموردين', Text('ادارة الموردين Page'));
                      Navigator.pop(context); // Close the drawer
                    },
                  ),
                ],
              ),
              ExpansionTile(
                leading: const Icon(Icons.person_4),
                title: const Text(
                  'البائعين',
                  style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                children: [
                  ListTile(
                    leading: const Icon(Icons.add),
                    title: const Text(
                      'اضافة بائع',
                      style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      _addTab('اضافة بائع', Text('اضافة بائع Page'));
                      Navigator.pop(context); // Close the drawer
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.person),
                    title: const Text(
                      'ادارة البائعين',
                      style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      _addTab('ادارة البائعين', SellerListPage());
                      Navigator.pop(context); // Close the drawer
                    },
                  ),
                ],
              ),
              ExpansionTile(
                  leading: const Icon(Icons.attach_money),
                  title: const Text(
                    'المشتريات',
                    style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  children: [
                    ListTile(
                        leading: const Icon(Icons.add_card),
                        title: const Text(
                          'اضافة فاتورة شراء',
                          style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 13,
                              fontWeight: FontWeight.w500),
                        ),
                        onTap: () {
                          _addTab(
                            'اضافة فاتورة شراء',
                            BlocProvider<PurchaseCubit>(
                              create: (context) => PurchaseCubit(),
                              child: AddPurchasePage(purchase: Purchase()),
                            ),
                          );
                          Navigator.pop(context); // Close the drawer
                        }),
                    ListTile(
                        leading: const Icon(Icons.edit),
                        title: const Text(
                          'ادارة فواتير الشراء',
                          style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 13,
                              fontWeight: FontWeight.w500),
                        ),
                        onTap: () {
                          _addTab('ادارة فواتير الشراء',
                              Text('ادارة فواتير الشراء Page'));
                          Navigator.pop(context); // Close the drawer
                        }),
                    ListTile(
                        leading: const Icon(Icons.add_card),
                        title: const Text(
                          'اضافة مرتجع مشتريات',
                          style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 13,
                              fontWeight: FontWeight.w500),
                        ),
                        onTap: () {
                          _addTab(
                            'اضافة مرتجع مشتريات',
                            BlocProvider<PurchaseBackCubit>(
                              create: (context) => PurchaseBackCubit(),
                              child: AddPurchaseBackPage(
                                  purchaseBack: PurchaseBack()),
                            ),
                          );
                          Navigator.pop(context); // Close the drawer
                        }),
                    ListTile(
                        leading: const Icon(Icons.edit),
                        title: const Text(
                          'ادارة مرتجعات المشتريات',
                          style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 13,
                              fontWeight: FontWeight.w500),
                        ),
                        onTap: () {
                          _addTab('ادارة مرتجعات المشتريات',
                              Text('ادارة مرتجعات المشتريات Page'));
                          Navigator.pop(context); // Close the drawer
                        }),
                  ]),
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
        body: myTabs.isNotEmpty
            ? TabBarView(
                controller: _tabController,
                children: tabViews,
              )
            : Center(
                child: Text('اختر تبويبًا من القائمة الجانبية'),
              ),
      ),
    );
  }
}
