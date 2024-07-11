import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout(
      {super.key,
      required this.mobilLayout,
      required this.tabletLayout,
      required this.diskTopLayout});

  final WidgetBuilder mobilLayout, tabletLayout, diskTopLayout;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constrains) {
      if (constrains.maxHeight < 600) {
        return mobilLayout(context);
      } else if (constrains.maxHeight < 900) {
        return tabletLayout(context);
      } else {
        return diskTopLayout(context);
      }
    });
  }
}
