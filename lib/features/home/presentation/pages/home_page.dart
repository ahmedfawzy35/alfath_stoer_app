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
        title: const Text('الرئيسية'),
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
                    fontFamily: 'Cairo',
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
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
                _showBranchesDialog(context, 'Customer');
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
                _showBranchesDialog(context, 'Supplier');
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

  void _showBranchesDialog(BuildContext context, String type) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'اختار الفرع',
            style: TextStyle(
                fontFamily: 'Cairo', fontSize: 16, fontWeight: FontWeight.bold),
          ),
          content: SizedBox(
            width: double.minPositive,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: allBranches!.length,
              itemBuilder: (BuildContext context, int index) {
                final branch = allBranches![index];
                return ListTile(
                  title: Text(
                    branch,
                    style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
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
      showAlertDialog(context, branch);
    }
  }

  void showAlertDialog(BuildContext context, String branche) {
    // إعداد زر الموافقة
    Widget okButton = Builder(
      builder: (BuildContext dialogContext) {
        return TextButton(
          child: const Text("OK"),
          onPressed: () {
            Navigator.of(dialogContext)
                .pop(); // استخدام context الخاص بـ AlertDialog لإغلاقه
          },
        );
      },
    );

    // إعداد AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("غير مصرح بالوصول"),
      content: Text("غير مصرح لك بالوصول الى بيانات  ${branche} !"),
      actions: [
        okButton,
      ],
    );

    // عرض الحوار
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
