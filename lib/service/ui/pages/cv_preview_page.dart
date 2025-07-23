/*import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CvPreviewPage extends StatefulWidget {
  const CvPreviewPage({super.key});

  @override
  State<CvPreviewPage> createState() => _CvPreviewPageState();
}

class _CvPreviewPageState extends State<CvPreviewPage> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..loadRequest(Uri.parse("https://flutter.dev"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: WebViewWidget(controller: _controller));
  }
}*/
