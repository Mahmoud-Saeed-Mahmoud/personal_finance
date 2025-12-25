import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class TransactionCard extends StatelessWidget {
  const TransactionCard({
    super.key,
    required this.title,
    required this.category,
    required this.amount,
    required this.date,
    required this.isExpense,
  });

  final String title;
  final String category;
  final double amount;
  final String date;
  final bool isExpense;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: _getCategoryColor().withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _getCategoryIcon(),
              color: _getCategoryColor(),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  '$category • $date',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(
                      context,
                    ).textTheme.bodySmall?.color?.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${isExpense ? '-' : '+'}\$${amount.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: isExpense ? Colors.red[400] : Colors.green[400],
            ),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor() {
    switch (category.toLowerCase()) {
      case 'food':
        return const Color(0xFFEF4444);
      case 'transport':
        return const Color(0xFFF59E0B);
      case 'shopping':
        return const Color(0xFF8B5CF6);
      case 'entertainment':
        return const Color(0xFFEC4899);
      case 'bills':
        return const Color(0xFF3B82F6);
      case 'income':
        return const Color(0xFF10B981);
      default:
        return const Color(0xFF6B7280);
    }
  }

  IconData _getCategoryIcon() {
    switch (category.toLowerCase()) {
      case 'food':
        return PhosphorIconsRegular.forkKnife;
      case 'transport':
        return PhosphorIconsRegular.car;
      case 'shopping':
        return PhosphorIconsRegular.shoppingBag;
      case 'entertainment':
        return PhosphorIconsRegular.gameController;
      case 'bills':
        return PhosphorIconsRegular.receipt;
      case 'income':
        return PhosphorIconsRegular.arrowUp;
      default:
        return PhosphorIconsRegular.wallet;
    }
  }
}
