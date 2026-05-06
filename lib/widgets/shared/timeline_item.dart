import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../data/portfolio_data.dart';

class TimelineItem extends StatelessWidget {
  final Job job;
  final bool isLast;
  const TimelineItem({super.key, required this.job, this.isLast = false});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 24,
            child: Column(
              children: [
                Container(
                  width: 9, height: 9,
                  margin: const EdgeInsets.only(top: 5),
                  decoration: BoxDecoration(
                    color: job.isCurrent ? AppTheme.accentGreen : AppTheme.accentBlue,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppTheme.bgPrimary, width: 2),
                    boxShadow: job.isCurrent
                        ? [BoxShadow(color: AppTheme.accentGreen.withOpacity(0.6), blurRadius: 8)]
                        : [],
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 1,
                      color: AppTheme.borderDefault,
                      margin: const EdgeInsets.only(left: 4),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 48),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(job.role,
                            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
                      ),
                      Text(job.dates,
                          style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(job.company, style: const TextStyle(fontSize: 13, color: AppTheme.accentBlue)),
                  const SizedBox(height: 12),
                  ...job.bullets.map((b) => _Bullet(text: b)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  final String text;
  const _Bullet({required this.text});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 4),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('▸ ', style: TextStyle(color: AppTheme.accentGreen, fontSize: 12)),
        Expanded(
          child: Text(text,
              style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary, height: 1.9)),
        ),
      ],
    ),
  );
}
