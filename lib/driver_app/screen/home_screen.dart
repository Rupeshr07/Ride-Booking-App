import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../constent/String.dart';

class WebViewHomeScreen extends StatefulWidget {
  final String ApiURl;

  const WebViewHomeScreen({super.key, required this.ApiURl});

  @override
  State<WebViewHomeScreen> createState() => _WebViewHomeScreenState();
}

class _WebViewHomeScreenState extends State<WebViewHomeScreen> {
  late final WebViewController webViewController;
  bool _isLoading = true;
  double _loadingProgress = 0;

  @override
  void initState() {
    super.initState();
    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..enableZoom(false) // Keep zoom disabled
      ..setNavigationDelegate(NavigationDelegate(
        onProgress: (progress) {
          setState(() {
            _loadingProgress = progress / 100.0;
          });
        },
        onPageStarted: (url) {
          setState(() {
            _isLoading = true;
          });
        },
        onPageFinished: (url) {
          setState(() {
            _isLoading = false;
          });
          if (url.contains('/vendor/dashboard')) {
            _saveLoginState();
          }
        },
        onNavigationRequest: (NavigationRequest request) async {
          if (request.url.contains("mailto:")) {
            await launchUrl(Uri.parse(request.url));
            return NavigationDecision.prevent;
          } else if (request.url.contains("tel:")) {
            await launchUrl(Uri.parse(request.url));
            return NavigationDecision.prevent;
          } else if (request.url.startsWith("https://api.whatsapp.com/send")) {
            await launchUrl(Uri.parse(request.url), mode: LaunchMode.externalApplication);
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ))
      ..loadRequest(Uri.parse(widget.ApiURl));
  }

  Future<void> _saveLoginState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        
        body: SafeArea(
          child: Stack(
            children: [
              WebViewWidget(controller: webViewController),
              if (_isLoading) ...[
                Align(
                  alignment: Alignment.topCenter,
                  child: LinearProgressIndicator(
                    value: _loadingProgress,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(defaultColor),
                  ),
                ),
                Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(defaultColor),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _onBackPressed() async {
    if (await webViewController.canGoBack()) {
      webViewController.goBack();
      return false;
    } else {
      return await showDialog(
        context: context,
        builder: (context) => Dialog(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 35),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0), color: Colors.white),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Do you want to exit?',
                  style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 10.0),
                const Text(
                  'Are you sure you want to exit this app!',
                  style: TextStyle(fontSize: 14.0, color: Colors.black45),
                ),
                const SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context, true);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 5),

                        decoration: BoxDecoration(
                          color: defaultColor,
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: const Text(
                          "Yes",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context, false);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 39, vertical: 4),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            border: Border.all(color: Colors.red, width: 2)),
                        child: const Text(
                          "No",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}
