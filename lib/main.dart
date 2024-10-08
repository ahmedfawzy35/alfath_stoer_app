import 'package:alfath_stoer_app/core/utils/get_cash_page.dart';
import 'package:alfath_stoer_app/core/utils/my_types.dart';
import 'package:alfath_stoer_app/core/utils/shared_prefs_service.dart';
import 'package:alfath_stoer_app/core/utils/strings.dart';
import 'package:alfath_stoer_app/features/auth/presentation/cubit/login_cubit.dart';
import 'package:alfath_stoer_app/features/auth/presentation/pages/login_view.dart';
import 'package:alfath_stoer_app/features/cashout_to_outgoing/presentation/pages/cashout_to_outgoing_edit_page.dart';
import 'package:alfath_stoer_app/features/customer/data/models/customer_model.dart';
import 'package:alfath_stoer_app/features/customer/presentation/cubit/customer_detail_cubit.dart';
import 'package:alfath_stoer_app/features/customer/presentation/cubit/customer_list_cubit.dart';
import 'package:alfath_stoer_app/features/customer/presentation/pages/customer_add_page.dart';
import 'package:alfath_stoer_app/features/customer/presentation/pages/customer_detail_page.dart';
import 'package:alfath_stoer_app/features/customer/presentation/pages/customer_list_page.dart';
import 'package:alfath_stoer_app/features/employee/presentation/cubit/employee_list_cubit.dart';
import 'package:alfath_stoer_app/features/employee/presentation/pages/employee_add_edit_page%20.dart';
import 'package:alfath_stoer_app/features/outgoing/presentation/cubit/outgoing_list_cubit.dart';
import 'package:alfath_stoer_app/features/outgoing/presentation/pages/outgoing_add_edit_page%20.dart';
import 'package:alfath_stoer_app/features/seller/presentation/cubit/seller_detail_cubit.dart';
import 'package:alfath_stoer_app/features/seller/presentation/cubit/seller_list_cubit.dart';
import 'package:alfath_stoer_app/features/seller/presentation/pages/seller_add_edit_page%20.dart';
import 'package:alfath_stoer_app/features/seller/presentation/pages/seller_detail_page.dart';
import 'package:alfath_stoer_app/features/seller/presentation/pages/seller_list_page.dart';
import 'package:alfath_stoer_app/features/home/presentation/pages/home_page.dart';
import 'package:alfath_stoer_app/features/orders/presentation/pages/manage_orders.dart';
import 'package:alfath_stoer_app/features/orders_back/presentation/pages/manage_orders_back.dart';
import 'package:alfath_stoer_app/features/purchases/presentation/pages/manage_purchase.dart';
import 'package:alfath_stoer_app/features/purchases_back/presentation/pages/manage_purchase_back.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

var shredPref = SharedPrefsService();

void main() {
  runApp(const MyApp());
}

//final userData = await SharedPrefsService().getUserData();
class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LoginCubit(),
        ),
        BlocProvider<CustomerListCubit>(
          create: (context) => CustomerListCubit(),
        ),
        BlocProvider<SellerListCubit>(
          create: (context) => SellerListCubit(),
        ),
        BlocProvider<OutGoigListCubit>(
          create: (context) => OutGoigListCubit(),
        ),
        BlocProvider<EmployeeListCubit>(
          create: (context) => EmployeeListCubit(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'StoreM',
        theme: ThemeData(primarySwatch: Colors.teal, fontFamily: 'Cairo'),
        home: const SplashScreen(),
        routes: {
          MyRouts.home: (context) => const HomePage(),
          MyRouts.orderListPage: (context) => const OrderManage(),
          MyRouts.purchaseListPage: (context) => const PurchaseManage(),
          MyRouts.orderBackListPage: (context) => const OrderBackManage(),
          MyRouts.purchaseBackManage: (context) => const PurchaseBackManage(),
          MyRouts.addCashInFromCustomer: (context) =>
              GetCashBage().getAddPage(CashTypes.cashInFromCustomer),
          MyRouts.addCashInFromIncome: (context) =>
              GetCashBage().getAddPage(CashTypes.cashInFromIncome),
          MyRouts.addcCashInFromBrancheMoneySafe: (context) =>
              GetCashBage().getAddPage(CashTypes.cashInFromBrancheMoneySafe),
          MyRouts.addCashInFromMasterMoneySafe: (context) =>
              GetCashBage().getAddPage(CashTypes.cashInFromMasterMoneySafe),
          MyRouts.addCashOutToSeller: (context) =>
              GetCashBage().getAddPage(CashTypes.cashOutToSeller),
          MyRouts.addCashOutToOutGoing: (context) =>
              GetCashBage().getAddPage(CashTypes.cashOutToOutGoing),

          MyRouts.customerAddPage: (context) => CustomerAddPage(
                customer: CustomerModel(),
              ),
          MyRouts.outGoingAddPage: (context) => const OutGoingAddEditPage(),
          MyRouts.sellerAddPage: (context) => const SellerAddEditPage(),
          MyRouts.employeeAddPage: (context) => const EmployeeAddEditPage(),
          MyRouts.customerListPage: (context) {
            final Map<String, dynamic> args = ModalRoute.of(context)!
                .settings
                .arguments as Map<String, dynamic>;
            return CustomerListPage(
              branche: args['branche'],
            );
          },
          MyRouts.sellerListPage: (context) => const SellerListPage(),

          MyRouts.customerDetailPage: (context) {
            final args = ModalRoute.of(context)!.settings.arguments
                as Map<String, dynamic>;
            return BlocProvider(
              create: (_) => CustomerDetailCubit()
                ..fetchCustomerSupplierDetail(args['id'] as int),
              child: CustomerDetailPage(id: args['id'] as int),
            );
          },
          MyRouts.sellerDetailPage: (context) {
            final args = ModalRoute.of(context)!.settings.arguments
                as Map<String, dynamic>;
            return BlocProvider(
              create: (_) =>
                  SellerDetailCubit()..fetchSellerDetail(args['id'] as int),
              child: SellrDetailPage(id: args['id'] as int),
            );
          },
          // إضافة المسارات الأخر
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
  const SplashScreen({
    super.key,
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
          const HomePage(),
        ));
      } else {
        Navigator.of(context).pushReplacement(_createRoute(LogindView()));

        //Navigator.of(context).pushReplacement(_createRoute(LoginPage()));
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
