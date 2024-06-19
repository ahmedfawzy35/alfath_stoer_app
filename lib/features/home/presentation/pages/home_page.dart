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

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefsService = SharedPrefsService();
    final userData = await prefsService.getUserData();

    if (userData != null) {
      setState(() {
        userName = userData['userName'];
        allBranches = List<String>.from(userData['allBranches']);
        userBranches = List<String>.from(userData['userBranches']);
        climes = List<String>.from(userData['climes']);
      });
    }
  }

  Future<void> _logout(BuildContext context) async {
    final prefsService = SharedPrefsService();
    await prefsService.clearUserData();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.teal,
              ),
              child: Text(
                userName == null ? " " : userName!,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Customers'),
              onTap: () {
                _showBranchesDialog(context, 'Customer');
              },
            ),
            ListTile(
              leading: const Icon(Icons.store),
              title: const Text('Suppliers'),
              onTap: () {
                _showBranchesDialog(context, 'Supplier');
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () => _logout(context),
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
            ),
          ],
        ),
      ),
    );
  }

  void _showBranchesDialog(BuildContext context, String type) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Branch'),
          content: SizedBox(
            width: double.minPositive,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: allBranches!.length,
              itemBuilder: (BuildContext context, int index) {
                final branch = allBranches![index];
                return ListTile(
                  title: Text(branch),
                  onTap: () {
                    Navigator.of(context).pop();
                    _handleBranchSelection(context, type, branch);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _handleBranchSelection(
      BuildContext context, String type, String branch) {
    if (userBranches!.contains(branch)) {
      if (type == 'Customer') {
        final customerSupplierListRepository =
            CustomerSupplierListRepository(MyStrings.baseurl);
        final customerSupplierDetailRepository =
            CustomerSupplierDetailRepository(baseUrl: MyStrings.baseurl);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CustomerSupplierPage(
              repository: customerSupplierListRepository,
              customeDetailsRepository: customerSupplierDetailRepository,
              type: 'Customer',
              branche: branch,
            ),
          ),
        );
      } else {
        Navigator.of(context).pushNamed('/sellerListPage');
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You do not have access to this branch.')),
      );
    }
  }
}
