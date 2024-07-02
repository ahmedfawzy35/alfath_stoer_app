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
import 'package:alfath_stoer_app/features/orders/presentation/cubit/cubit/order_cubit.dart';
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

  const MyApp({
    super.key,
    required this.customerRepository,
    required this.sellerRepository,
    required this.customerSupplierDetailRepository,
    required this.loginRepository,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LoginCubit(loginRepository),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Customer Supplier App',
        theme: ThemeData(
          primarySwatch: Colors.teal,
        ),
        home: SplashScreen(
          customerRepository: customerRepository,
          sellerRepository: sellerRepository,
          customerSupplierDetailRepository: customerSupplierDetailRepository,
        ),
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

  MaterialColor createMaterialColor(Color color) {
    List strengths = <double>[.05];
    final swatch = <int, Color>{};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(color.value, swatch);
  }
}

class SplashScreen extends StatefulWidget {
  final CustomerSupplierListRepository customerRepository;
  final SellerListRepository sellerRepository;
  final CustomerSupplierDetailRepository customerSupplierDetailRepository;

  const SplashScreen({
    super.key,
    required this.customerRepository,
    required this.sellerRepository,
    required this.customerSupplierDetailRepository,
  });

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.forward();

    // الانتقال إلى الشاشة الرئيسية بعد انتهاء الأنيميشن
    Future.delayed(const Duration(seconds: 4), () async {
      final userData = await SharedPrefsService().getUserData();
      if (userData != null) {
        Navigator.of(context).pushReplacement(_createRoute(
          HomePage(
            customeRepository: widget.customerRepository,
            sellerRepository: widget.sellerRepository,
            customeDetailsRepository: widget.customerSupplierDetailRepository,
          ),
        ));
      } else {
        Navigator.of(context).pushReplacement(_createRoute(LoginPage()));
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Route _createRoute(Widget page) {
    return PageRouteBuilder(
      transitionDuration:
          const Duration(milliseconds: 500), // ضبط مدة الأنيميشن هنا
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ScaleTransition(
              scale: _animation,
              child: Image.asset('assets/logo.png', width: 200, height: 200),
            ),
            FadeTransition(
              opacity: _animation,
              child: const Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: Text(
                  'Store M',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
