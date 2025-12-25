import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../../../custom_widgets/custom_appbar.dart';
import '../../../../../../custom_widgets/custom_container.dart';
import '../../../../../../custom_widgets/customtext.dart';
import '../../../../../../utils/colors.dart';
import '../controllers/admin_transaction_details_controller.dart';

class AdminTransactionDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> transactionData;
  final String userUid;
  final String? taskId;

  const AdminTransactionDetailsScreen({
    super.key,
    required this.transactionData,
    required this.userUid,
    this.taskId,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      AdminTransactionDetailsController(
        transactionData: transactionData,
        userUid: userUid,
        taskId: taskId,
      ),
      tag: transactionData['id'] ?? DateTime.now().toString(),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: const CustomAppBar(titleText: 'Transaction Details'),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: redColor));
        }

        final data = controller.transactionData;
        final timestamp = data['createdAt'] as Timestamp?;
        final dateStr = timestamp != null
            ? DateFormat('MMMM dd, yyyy \'at\' hh:mm a').format(timestamp.toDate())
            : 'Unknown Date';
        
        final amount = (data['amount'] ?? 0.0).toDouble();
        final status = data['status'] ?? 'Completed';
        final title = data['title'] ?? 'Transaction';
        final tId = data['id'] ?? 'N/A';
        final displayTaskId = controller.userMapping[userUid] ?? taskId ?? 'N/A';

        // Fee calculations if not present
        double serviceFee = (data['feesDeducted'] ?? 0.0).toDouble();
        double netAmount = amount; 
        
        // If it was a credit and we know the percentage logic:
        if (serviceFee == 0 && (title.contains('Payment') || title.contains('Released'))) {
          // Calculation as seen in wallet_service: 85% to helper, 15% combined fees
          // In some cases amount is already 85%? 
          // If title is "Payment Received", amount is helperAmount (85%)
          // total = amount / 0.85
          // serviceFee = total * 0.15
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Summary Card
              _buildTopCard(title, amount, dateStr, status),
              const SizedBox(height: 20),

              // Details Section
              const CustomText(
                'Details',
                fontSize: 18,
                fontWeight: FontVariant.bold,
                color: blackColor,
              ),
              const SizedBox(height: 12),
              _buildDetailsCard(tId, displayTaskId, serviceFee, netAmount),
              const SizedBox(height: 24),

              // Task Details Section (if available)
              if (controller.task.value != null) ...[
                const CustomText(
                  'Task Details',
                  fontSize: 18,
                  fontWeight: FontVariant.bold,
                  color: blackColor,
                ),
                const SizedBox(height: 12),
                _buildTaskDetailsCard(controller.task.value!),
              ],
              const SizedBox(height: 40),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildTopCard(String title, double amount, String date, String status) {
    return CustomContainer(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
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
            title,
            fontSize: 14,
            fontWeight: FontVariant.medium,
            color: txColor,
          ),
          const SizedBox(height: 8),
          CustomText(
            'SAR ${amount.toStringAsFixed(2)}',
            fontSize: 28,
            fontWeight: FontVariant.bold,
            color: blackColor,
          ),
          const SizedBox(height: 8),
          CustomText(
            date,
            fontSize: 12,
            fontWeight: FontVariant.regular,
            color: txColor,
          ),
          const SizedBox(height: 16),
          _buildStatusBadge(status),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color bgColor;
    Color textColor;
    IconData icon;

    switch (status.toLowerCase()) {
      case 'pending':
        bgColor = const Color(0xFFEEEEEE);
        textColor = const Color(0xFF757575);
        icon = Icons.hourglass_empty;
        break;
      case 'completed':
      case 'success':
        bgColor = const Color(0xFFE8F5E9);
        textColor = const Color(0xFF2E7D32);
        icon = Icons.check_circle_outline;
        break;
      default:
        bgColor = const Color(0xFFE3F2FD);
        textColor = const Color(0xFF1976D2);
        icon = Icons.info_outline;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: textColor),
          const SizedBox(width: 4),
          CustomText(
            status,
            fontSize: 12,
            fontWeight: FontVariant.medium,
            color: textColor,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsCard(String tId, String taskCode, double fee, double net) {
    return CustomContainer(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
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
          _buildDetailRow('Transaction ID', tId),
          const Divider(height: 24),
          _buildDetailRow('Task ID', taskCode),
          if (fee > 0) ...[
            const Divider(height: 24),
            _buildDetailRow('Service Fee', 'SAR ${fee.toStringAsFixed(2)}'),
          ],
          const Divider(height: 24),
          _buildDetailRow('Net Amount', 'SAR ${net.toStringAsFixed(2)}', isBold: true),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          label,
          fontSize: 14,
          fontWeight: FontVariant.medium,
          color: txColor,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: CustomText(
            value,
            fontSize: 14,
            fontWeight: isBold ? FontVariant.bold : FontVariant.medium,
            color: blackColor,
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  Widget _buildTaskDetailsCard(dynamic task) {
    return CustomContainer(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomText(
            'Description',
            fontSize: 14,
            fontWeight: FontVariant.bold,
            color: blackColor,
          ),
          const SizedBox(height: 8),
          const Divider(),
          const SizedBox(height: 8),
          CustomText(
            task.description,
            fontSize: 14,
            fontWeight: FontVariant.regular,
            color: txColor,
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              _buildTaskInfoItem('Escrow Amount', 'SAR ${task.budget}'),
              _buildTaskInfoItem('Task Category', task.taskType),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildTaskInfoItem('Posed At', DateFormat('MMM dd, hh:mm a').format(task.createdAt)),
              _buildTaskInfoItem('Status', task.status.toUpperCase()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTaskInfoItem(String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            label,
            fontSize: 12,
            fontWeight: FontVariant.regular,
            color: txColor,
          ),
          const SizedBox(height: 4),
          CustomText(
            value,
            fontSize: 14,
            fontWeight: FontVariant.bold,
            color: blackColor,
          ),
        ],
      ),
    );
  }
}
