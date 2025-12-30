import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:red_balloon_app/custom_widgets/custom_appbar.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';
import 'package:red_balloon_app/model/task_model.dart';

class TransactionDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> transactionData;

  const TransactionDetailsScreen({
    super.key,
    required this.transactionData,
  });

  @override
  State<TransactionDetailsScreen> createState() => _TransactionDetailsScreenState();
}

class _TransactionDetailsScreenState extends State<TransactionDetailsScreen> {
  bool isLoadingTask = false;
  TaskModel? task;

  @override
  void initState() {
    super.initState();
    _fetchTaskDetails();
  }

  Future<void> _fetchTaskDetails() async {
    final taskId = widget.transactionData['taskId'];
    if (taskId != null && taskId is String && taskId.isNotEmpty) {
      setState(() => isLoadingTask = true);
      try {
        final doc = await FirebaseFirestore.instance.collection('tasks').doc(taskId).get();
        if (doc.exists) {
          setState(() {
            task = TaskModel.fromFirestore(doc);
          });
        }
      } catch (e) {
        debugPrint('Error fetching task for transaction: $e');
      } finally {
        setState(() => isLoadingTask = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.transactionData;
    
    // Handle date formatting with fallbacks
    String dateStr = data['daysAgo'] ?? 'Unknown Date';
    final rawTimestamp = data['rawCreatedAt'] ?? data['createdAt'];
    if (rawTimestamp != null) {
      if (rawTimestamp is Timestamp) {
        dateStr = DateFormat('MMMM dd, yyyy \'at\' hh:mm a').format(rawTimestamp.toDate());
      } else if (rawTimestamp is DateTime) {
        dateStr = DateFormat('MMMM dd, yyyy \'at\' hh:mm a').format(rawTimestamp);
      } else if (rawTimestamp is String) {
        try {
          dateStr = DateFormat('MMMM dd, yyyy \'at\' hh:mm a').format(DateTime.parse(rawTimestamp));
        } catch (e) {
          debugPrint('Error parsing date string: $e');
        }
      }
    }

    final amountStr = data['amount'] ?? '0.00';
    final amountColor = data['amountColor'] != null ? Color(data['amountColor']) : blackColor;
    final status = data['status'] ?? 'Completed';
    final title = data['title'] ?? 'Transaction';
    final tId = data['id'] ?? data['transactionId'] ?? 'N/A';
    final description = data['description'] ?? '';

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: const CustomAppBar(titleText: 'Transaction Details'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Summary Card
            _buildTopCard(title, amountStr, amountColor, dateStr, status),
            const SizedBox(height: 20),

            // Details Section
            const CustomText(
              'Details',
              fontSize: 18,
              fontWeight: FontVariant.bold,
              color: blackColor,
            ),
            const SizedBox(height: 12),
            _buildDetailsCard(tId, description),
            const SizedBox(height: 24),

            // Task Details Section (if available)
            if (isLoadingTask)
              const Center(child: CircularProgressIndicator(color: redColor))
            else if (task != null) ...[
              const CustomText(
                'Related Task',
                fontSize: 18,
                fontWeight: FontVariant.bold,
                color: blackColor,
              ),
              const SizedBox(height: 12),
              _buildTaskDetailsCard(task!),
            ],

            // Receipt Section (for withdrawals)
            if (data['receiptUrl'] != null) ...[
              const SizedBox(height: 24),
              const CustomText(
                'Payment Receipt',
                fontSize: 18,
                fontWeight: FontVariant.bold,
                color: blackColor,
              ),
              const SizedBox(height: 12),
              _buildReceiptCard(data['receiptUrl']),
            ],
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildTopCard(String title, String amount, Color amountColor, String date, String status) {
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
            'SAR ${amount.replaceAll('+', '').replaceAll('-', '')}',
            fontSize: 28,
            fontWeight: FontVariant.bold,
            color: amountColor,
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

  Widget _buildDetailsCard(String tId, String description) {
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
          _buildDetailRow('Description', description),
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

  Widget _buildTaskDetailsCard(TaskModel task) {
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
          CustomText(
            task.title,
            fontSize: 16,
            fontWeight: FontVariant.bold,
            color: blackColor,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          const Divider(),
          const SizedBox(height: 8),
          CustomText(
            task.description,
            fontSize: 14,
            fontWeight: FontVariant.regular,
            color: txColor,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              _buildTaskInfoItem('Budget', 'SAR ${task.budget.toStringAsFixed(2)}'),
              _buildTaskInfoItem('Type', task.taskType.capitalizeFirst ?? task.taskType),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildTaskInfoItem('Date', DateFormat('MMM dd, yyyy').format(task.createdAt)),
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

  Widget _buildReceiptCard(String url) {
    return CustomContainer(
      width: double.infinity,
      height: 250,
      conColor: whiteColor,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: blackColor.withOpacity(0.05),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.network(
          url,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return const Center(child: CircularProgressIndicator(color: redColor));
          },
          errorBuilder: (context, error, stackTrace) => const Center(
            child: Icon(Icons.broken_image, size: 50, color: greyColor),
          ),
        ),
      ),
    );
  }
}
