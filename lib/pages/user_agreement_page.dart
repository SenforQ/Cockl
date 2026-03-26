import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../constants/app_constants.dart';

class UserAgreementPage extends StatefulWidget {
  const UserAgreementPage({super.key});

  @override
  State<UserAgreementPage> createState() => _UserAgreementPageState();
}

class _UserAgreementPageState extends State<UserAgreementPage> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(AppConstants.technicalSupportUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Agreement'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            child: SizedBox(
              width: MediaQuery.sizeOf(context).width,
              height: constraints.maxHeight,
              child: WebViewWidget(controller: _controller),
            ),
          );
        },
      ),
    );
  }
}
