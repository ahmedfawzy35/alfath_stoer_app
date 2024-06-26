import 'package:alfath_stoer_app/core/utils/shared_prefs_service.dart';
import 'package:alfath_stoer_app/core/utils/strings.dart';
import 'package:alfath_stoer_app/features/auth/presentation/pages/login_page.dart';
import 'package:alfath_stoer_app/features/customer_supplier/data/repositories/customer_supplier_detail_repository.dart';
import 'package:alfath_stoer_app/features/customer_supplier/data/repositories/customer_supplier_list_repository.dart';
import 'package:alfath_stoer_app/features/customer_supplier/data/repositories/seller_list_repository.dart';
import 'package:alfath_stoer_app/features/customer_supplier/presentation/pages/customer_supplier_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final CustomerSupplierListRepository customeRepository;
  final SellerListRepository sellerRepository;
  final CustomerSupplierDetailRepository customeDetailsRepository;

  const HomePage({
    super.key,
    required this.customeRepository,
    required this.sellerRepository,
    required this.customeDetailsRepository,
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
                final customerSupplierListRepository =
                    CustomerSupplierListRepository(MyStrings.baseurl);
                final customerSupplierDetailRepository =
                    CustomerSupplierDetailRepository(
                        baseUrl: MyStrings.baseurl);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CustomerSupplierPage(
                      repository: customerSupplierListRepository,
                      customeDetailsRepository:
                          customerSupplierDetailRepository,
                      type: 'Customer',
                      branche: selectedBranche,
                    ),
                  ),
                );
              },
            ),
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
                Navigator.of(context).pushNamed('/sellerListPage');
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
