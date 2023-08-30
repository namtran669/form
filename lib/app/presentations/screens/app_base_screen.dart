import 'package:flutter/material.dart';

class AppBaseScreen extends StatelessWidget {
  const AppBaseScreen({Key? key, this.appBar, required this.body}) : super(key: key);
  final Widget body;
  final PreferredSizeWidget? appBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar,
      body: body,
    );
  }
}
