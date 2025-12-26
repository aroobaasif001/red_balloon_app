import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/custom_appbar.dart';
import 'package:webview_flutter/webview_flutter.dart';

class FatoraCheckoutScreen extends StatefulWidget {
  final String checkoutUrl;
  final Function(String invoiceId) onSuccess;
  final VoidCallback onFailure;

  const FatoraCheckoutScreen({
    super.key,
    required this.checkoutUrl,
    required this.onSuccess,
    required this.onFailure,
  });

  @override
  State<FatoraCheckoutScreen> createState() => _FatoraCheckoutScreenState();
}

class _FatoraCheckoutScreenState extends State<FatoraCheckoutScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setUserAgent("Mozilla/5.0 (Linux; Android 10; Mobile) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.162 Mobile Safari/537.36")
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            debugPrint('WebView loading progress: $progress%');
          },
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
            });
            _checkUrl(url);
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
            _checkUrl(url);
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('Web Resource Error: ${error.description}');
          },
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.checkoutUrl));
  }

  void _checkUrl(String url) {
    debugPrint('Current URL: $url');
    // Fatora.io typically redirects to the success_url or failure_url
    if (url.contains('success') || url.contains('PaySuccess')) {
      // Try to extract transaction/invoice ID from URL if possible
      final uri = Uri.parse(url);
      final invoiceId = uri.queryParameters['id'] ?? 'FATORA-SUCCESS';
      widget.onSuccess(invoiceId);
    } else if (url.contains('failure') || 
               url.contains('error') || 
               url.contains('BlockPayment') || 
               url.contains('Decline')) {
      widget.onFailure();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        titleText: 'Payment Checkout',
        // leading: IconButton(
        //   icon: const Icon(Icons.close),
        //   onPressed: () => Get.back(),
        // ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
