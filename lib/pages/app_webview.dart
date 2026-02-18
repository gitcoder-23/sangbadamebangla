import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AppWebview extends StatefulWidget {
  final String? url;
  final String? name;
  const AppWebview({this.url, this.name, super.key});

  @override
  State<AppWebview> createState() => _AppWebviewState();
}

class _AppWebviewState extends State<AppWebview> {
  late final WebViewController _controller;
  DateTime? _lastPressedAt; // Tracks the time of the last back press

  @override
  void initState() {
    super.initState();
    // Initialize controller once in initState
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..loadRequest(Uri.parse(widget.url ?? ''));
  }

  @override
  Widget build(BuildContext context) {
    if (widget.url == null || widget.url!.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.black87,
        ),
        body: const Center(child: Text('Invalid URL')),
      );
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        // 1. Check if the WebView can go back internally
        if (await _controller.canGoBack()) {
          _controller.goBack();
          return;
        }

        // 2. Logic for Double Tap to Exit
        final now = DateTime.now();
        final backButtonHasNotBeenPressedOrTimeHasExpired =
            _lastPressedAt == null ||
            now.difference(_lastPressedAt!) > const Duration(seconds: 2);

        if (backButtonHasNotBeenPressedOrTimeHasExpired) {
          _lastPressedAt = now;

          // Show the Toast/SnackBar
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Please double tap to exit.',
                textAlign: TextAlign.center,
              ),
              duration: Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              shape: StadiumBorder(),
            ),
          );
        } else {
          // If pressed again within 2 seconds, close the app
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        body: SafeArea(child: WebViewWidget(controller: _controller)),
      ),
    );
  }
}
