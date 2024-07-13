import 'package:alfath_stoer_app/features/auth/presentation/pages/login_page.dart';
import 'package:alfath_stoer_app/features/auth/presentation/pages/login_page_desktop.dart';
import 'package:alfath_stoer_app/features/main_widgets/rosponsiv_layout.dart';
import 'package:flutter/material.dart';

class LogindView extends StatelessWidget {
  const LogindView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
          mobilLayout: (context) => LoginPage(),
          tabletLayout: (context) => LoginPage(),
          diskTopLayout: (context) => LoginPageDeskTop()),
    );
  }
}
