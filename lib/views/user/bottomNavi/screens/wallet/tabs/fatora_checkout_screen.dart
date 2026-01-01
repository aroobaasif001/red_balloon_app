import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_balloon_app/custom_widgets/custom_appbar.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:red_balloon_app/utils/colors.dart';
import 'package:red_balloon_app/custom_widgets/custom_button.dart';

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
  bool _hasError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            debugPrint('WebView loading progress: $progress%');
          },
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
              _hasError = false;
            });
            _checkUrl(url);
          },
          onPageFinished: (String url) {
            debugPrint('Page finished loading: $url');
            setState(() {
              _isLoading = false;
              _hasError = false; // Reset error state on success
            });
            _checkUrl(url);
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('Web Resource Error: ${error.description} (Code: ${error.errorCode}, MainFrame: ${error.isForMainFrame})');
            
            // errorCode -6 is ERR_CONNECTION_RESET. 
            // In many cases, the WebView retries and succeeds (as seen in logs).
            // We only show the error screen for other terminal errors on the main frame.
            if ((error.isForMainFrame ?? true) && error.errorCode != -6) {
              setState(() {
                _isLoading = false;
                _hasError = true;
                _errorMessage = error.description;
              });
            }
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
              child: CircularProgressIndicator(
                color: redColor,
              ),
            ),
          if (_hasError)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 60, color: redColor),
                    const SizedBox(height: 16),
                    const Text(
                      'Failed to load payment page',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _errorMessage,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: greyColor),
                    ),
                    const SizedBox(height: 24),
                    CustomButton(
                      label: 'Retry',
                      onPressed: () {
                        setState(() {
                          _hasError = false;
                          _isLoading = true;
                        });
                        _controller.reload();
                      },
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
