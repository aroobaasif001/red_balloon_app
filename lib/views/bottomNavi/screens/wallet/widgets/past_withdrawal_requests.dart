import 'package:flutter/material.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';
import 'package:red_balloon_app/custom_widgets/customtext.dart';
import 'package:red_balloon_app/utils/colors.dart';

class WithdrawalRequest {
  final String date;
  final String amount;
  final String status;

  WithdrawalRequest({
    required this.date,
    required this.amount,
    required this.status,
  });
}

class PastWithdrawalRequests extends StatelessWidget {
  final String titleText;
  final String dateHeaderText;
  final String amountHeaderText;
  final String statusHeaderText;
  final List<WithdrawalRequest> withdrawalRequests;
  final double cardHorizontalPadding;
  final double cardVerticalPadding;
  final Color cardBackgroundColor;
  final Color cardBorderColor;
  final double cardBorderWidth;
  final double cardBorderRadius;
  final double titleFontSize;
  final FontVariant titleFontVariant;
  final Color titleTextColor;
  final double headerFontSize;
  final FontVariant headerFontVariant;
  final Color headerTextColor;
  final double rowFontSize;
  final FontVariant rowFontVariant;
  final Color rowTextColor;
  final Color completedStatusColor;
  final Color pendingStatusColor;
  final Color tableHeaderBgColor;
  final Color tableRowBgColor;
  final Color tableAlternateRowBgColor;

  const PastWithdrawalRequests({
    super.key,
    this.titleText = 'Past Withdrawal Requests',
    this.dateHeaderText = 'DATE',
    this.amountHeaderText = 'AMOUNT',
    this.statusHeaderText = 'STATUS',
    this.withdrawalRequests = const [],
    this.cardHorizontalPadding = 16,
    this.cardVerticalPadding = 20,
    this.cardBackgroundColor = white1Color,
    this.cardBorderColor = walletCardBorderColor,
    this.cardBorderWidth = 1,
    this.cardBorderRadius = 12,
    this.titleFontSize = 16,
    this.titleFontVariant = FontVariant.bold,
    this.titleTextColor = walletBalanceTextColor,
    this.headerFontSize = 12,
    this.headerFontVariant = FontVariant.bold,
    this.headerTextColor = grey5Color,
    this.rowFontSize = 14,
    this.rowFontVariant = FontVariant.regular,
    this.rowTextColor = blackLightColor,
    this.completedStatusColor = walletSuccessColor,
    this.pendingStatusColor = walletErrorColor,
    this.tableHeaderBgColor = white2Color,
    this.tableRowBgColor = whiteColor,
    this.tableAlternateRowBgColor = white1Color,
  });

  Color _getStatusColor(String status) {
    if (status.toLowerCase().contains('completed')) {
      return completedStatusColor;
    } else if (status.toLowerCase().contains('pending')) {
      return pendingStatusColor;
    }
    return rowTextColor;
  }

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      padding: EdgeInsets.symmetric(
        horizontal: cardHorizontalPadding,
        vertical: cardVerticalPadding,
      ),
      width: double.infinity,
      conColor: cardBackgroundColor,
      border: Border.all(color: cardBorderColor, width: cardBorderWidth),
      borderRadius: BorderRadius.circular(cardBorderRadius),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            titleText,
            fontSize: titleFontSize,
            fontWeight: titleFontVariant,
            color: titleTextColor,
          ),
          SizedBox(height: 20),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columnSpacing: 30,
              // decoration: BoxDecoration(color: Colors.grey),
              headingRowColor: MaterialStatePropertyAll(cardBackgroundColor),
              dataRowColor: MaterialStatePropertyAll(cardBackgroundColor),
              columns: [
                DataColumn(
                  label: CustomText(
                    dateHeaderText,
                    fontSize: headerFontSize,
                    fontWeight: headerFontVariant,
                    color: headerTextColor,
                  ),
                ),
                DataColumn(
                  label: CustomText(
                    amountHeaderText,
                    fontSize: headerFontSize,
                    fontWeight: headerFontVariant,
                    color: headerTextColor,
                  ),
                ),
                DataColumn(
                  label: CustomText(
                    statusHeaderText,
                    fontSize: headerFontSize,
                    fontWeight: headerFontVariant,
                    color: headerTextColor,
                  ),
                ),
              ],
              rows: List.generate(withdrawalRequests.length, (index) {
                final request = withdrawalRequests[index];
                final statusColor = _getStatusColor(request.status);

                return DataRow(
                  cells: [
                    DataCell(
                      CustomText(
                        request.date,
                        fontSize: rowFontSize,
                        fontWeight: rowFontVariant,
                        color: rowTextColor,
                      ),
                    ),
                    DataCell(
                      CustomText(
                        request.amount,
                        fontSize: rowFontSize,
                        fontWeight: FontVariant.bold,
                        color: rowTextColor,
                      ),
                    ),
                    DataCell(
                      Row(
                        children: [
                          Icon(
                            request.status.toLowerCase().contains('completed')
                                ? Icons.check
                                : Icons.schedule,
                            color: statusColor,
                            size: 16,
                          ),
                          SizedBox(width: 6),
                          CustomText(
                            request.status,
                            fontSize: rowFontSize,
                            fontWeight: rowFontVariant,
                            color: statusColor,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
