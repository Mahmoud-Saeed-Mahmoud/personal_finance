class Transaction {
  const Transaction({
    required this.id,
    required this.title,
    required this.category,
    required this.amount,
    required this.date,
    required this.isExpense,
  });

  final String id;
  final String title;
  final String category;
  final double amount;
  final String date;
  final bool isExpense;
}

class DashboardData {
  const DashboardData({
    required this.weeklyExpenses,
    required this.transactions,
    required this.categoryBreakdown,
    required this.totalIncome,
    required this.totalExpenses,
    required this.balance,
  });

  final List<double> weeklyExpenses;
  final List<Transaction> transactions;
  final Map<String, double> categoryBreakdown;
  final double totalIncome;
  final double totalExpenses;
  final double balance;
}
