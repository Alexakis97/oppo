import 'package:flutter/cupertino.dart';
import 'package:webview_flutter/webview_flutter.dart';


class WebViewExample extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return WebView(
      initialUrl: 'https://google.com',
    );
  }
}