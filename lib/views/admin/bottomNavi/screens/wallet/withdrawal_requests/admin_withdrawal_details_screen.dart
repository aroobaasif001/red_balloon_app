import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:red_balloon_app/custom_widgets/custom_appbar.dart';
import 'package:red_balloon_app/custom_widgets/custom_button.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/services/wallet_service.dart';
import 'package:red_balloon_app/services/notification_services.dart';
import 'package:red_balloon_app/utils/colors.dart';

class AdminWithdrawalDetailsScreen extends StatefulWidget {
  const AdminWithdrawalDetailsScreen({super.key});

  @override
  State<AdminWithdrawalDetailsScreen> createState() => _AdminWithdrawalDetailsScreenState();
}

class _AdminWithdrawalDetailsScreenState extends State<AdminWithdrawalDetailsScreen> {
  final WalletService _walletService = WalletService();
  final NotificationService _notificationService = NotificationService.instance;
  late Map<String, dynamic> request;
  
  File? _receiptImage;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    request = Get.arguments as Map<String, dynamic>;
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
    
    if (pickedFile != null) {
      setState(() {
        _receiptImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _processRequest(String status) async {
    if (status == 'Completed' && _receiptImage == null) {
      Get.snackbar('Error', 'Please upload a payment receipt before approving');
      return;
    }

    setState(() => _isProcessing = true);
    try {
      String? receiptUrl;
      if (status == 'Completed' && _receiptImage != null) {
        receiptUrl = await _walletService.uploadWithdrawalReceipt(_receiptImage!, request['id']);
      }

      final result = await _walletService.processWithdrawalRequest(
        requestId: request['id'],
        userUid: request['uid'],
        status: status,
        receiptUrl: receiptUrl,
      );

      if (result['success']) {
        // Send notification
        await _notificationService.notifyWithdrawalStatusUpdate(
          userUid: request['uid'],
          amount: (request['amount'] ?? 0.0).toDouble(),
          status: status,
        );

        Get.back();
        Get.snackbar('Success', 'Withdrawal request $status successfully');
      } else {
        Get.snackbar('Error', result['message'] ?? 'Failed to process request');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final amount = (request['amount'] ?? 0.0).toDouble();
    
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: const CustomAppBar(titleText: 'Withdrawal Request'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildInfoCard(amount),
            const SizedBox(height: 24),
            _buildReceiptSection(),
            const SizedBox(height: 32),
            if (!_isProcessing) ...[
              CustomButton(
                label: 'Approve & Deduct from Escrow',
                onPressed: () => _processRequest('Completed'),
              ),
              const SizedBox(height: 12),
              CustomButton(
                label: 'Reject & Refund to Balance',
                bgColor: Colors.transparent,
                textColor: redColor,
                border: Border.all(color: redColor),
                onPressed: () => _processRequest('Rejected'),
              ),
            ] else
              const Center(child: CircularProgressIndicator(color: redColor)),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(double amount) {
    final date = request['createdAt'] != null 
        ? DateFormat('MMMM dd, yyyy').format((request['createdAt'] as dynamic).toDate())
        : 'N/A';

    return CustomContainer(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      conColor: whiteColor,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: blackColor.withOpacity(0.05),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
      child: Column(
        children: [
          CustomText(
            'SAR ${amount.toStringAsFixed(2)}',
            fontSize: 28,
            fontWeight: FontVariant.bold,
            color: blackColor,
          ),
          const SizedBox(height: 8),
          _buildDetailRow('Date', date),
          const Divider(height: 24),
          _buildDetailRow('Method', request['method'] ?? 'N/A'),
          const SizedBox(height: 12),
          _buildDetailRow('Bank', request['bank'] ?? 'N/A'),
          const SizedBox(height: 12),
          _buildDetailRow('Account No / IBAN', request['accountNumber'] ?? 'N/A', isBold: true),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(label, color: txColor, fontSize: 14),
        CustomText(
          value,
          color: blackColor,
          fontSize: 14,
          fontWeight: isBold ? FontVariant.bold : FontVariant.medium,
        ),
      ],
    );
  }

  Widget _buildReceiptSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CustomText(
          'Payment Receipt',
          fontSize: 16,
          fontWeight: FontVariant.bold,
          color: blackColor,
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: _pickImage,
          child: CustomContainer(
            width: double.infinity,
            height: 200,
            conColor: whiteColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: greyColor.withOpacity(0.3), style: BorderStyle.solid),
            child: _receiptImage != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.file(_receiptImage!, fit: BoxFit.cover),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_a_photo_outlined, size: 40, color: greyColor),
                      const SizedBox(height: 8),
                      CustomText('Upload Bank Receipt', color: greyColor),
                    ],
                  ),
          ),
        ),
      ],
    );
  }
}
