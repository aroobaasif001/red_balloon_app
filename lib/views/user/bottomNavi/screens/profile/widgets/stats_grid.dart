import 'package:flutter/material.dart';
import 'stat_card.dart';

class StatsGrid extends StatelessWidget {
  final String? postedCount;
  final String? pendingCount;
  final String? completedCount;
  final String? ratingValue;
  final double? spacing;
  final double? verticalSpacing;

  const StatsGrid({
    super.key,
    this.postedCount = '12',
    this.pendingCount = '09',
    this.completedCount = '03',
    this.ratingValue = '4.8',
    this.spacing = 12,
    this.verticalSpacing = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // First Row
        Row(
          children: [
            Expanded(
              child: StatCard(
                number: postedCount ?? '12',
                label: 'Posted',
              ),
            ),
            SizedBox(width: spacing ?? 12),
            Expanded(
              child: StatCard(
                number: pendingCount ?? '09',
                label: 'Pending',
              ),
            ),
          ],
        ),
        SizedBox(height: verticalSpacing ?? 12),
        // Second Row
        Row(
          children: [
            Expanded(
              child: StatCard(
                number: completedCount ?? '03',
                label: 'Completed',
              ),
            ),
            SizedBox(width: spacing ?? 12),
            Expanded(
              child: StatCard(
                number: ratingValue ?? '4.8',
                label: 'Rating',
              ),
            ),
          ],
        ),
      ],
    );
  }
}
