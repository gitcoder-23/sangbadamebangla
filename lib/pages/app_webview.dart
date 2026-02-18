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
  // Function to show the exit confirmation dialog
  Future<bool> _showExitDialog(BuildContext context) async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: const Text(
              'Exit App',
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
            content: const Text('Do you want to close the app?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(
                    0xFFD32F2F,
                  ), // Matching brand red
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () =>
                    SystemNavigator.pop(), // Closes the app completely
                child: const Text('Yes', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.url!.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'Error',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          backgroundColor: Colors.black87,
          centerTitle: true,
          shadowColor: Colors.transparent,
          elevation: 0,
        ),
        body: const Center(child: Text('Invalid URL')),
      );
    }

    WebViewController controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..loadRequest(Uri.parse(widget.url!));

    return PopScope(
      canPop: false, // Prevents automatic back navigation
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        await _showExitDialog(context);
      },
      child: Scaffold(
        // appBar: AppBar(
        //   title: Text(
        //     widget.name!,
        //     style: TextStyle(color: Colors.white, fontSize: 20),
        //   ),
        //   backgroundColor: Colors.black87,
        //   centerTitle: true,
        //   shadowColor: Colors.transparent,
        //   elevation: 0,
        // ),
        body: SafeArea(
          child: Builder(
            builder: (BuildContext context) {
              return WebViewWidget(controller: controller);
            },
          ),
        ),
      ),
    );
  }
}
