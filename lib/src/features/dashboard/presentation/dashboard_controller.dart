import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/dashboard_models.dart';

part 'dashboard_controller.g.dart';

@riverpod
class DashboardController extends _$DashboardController {
  @override
  Future<DashboardData> build() async {
    // Simulate network delay for skeleton loading
    await Future.delayed(const Duration(seconds: 2));

    // Return rich dummy data
    return const DashboardData(
      weeklyExpenses: [45, 78, 62, 95, 53, 88, 110],
      transactions: [
        Transaction(
          id: '1',
          title: 'Grocery Shopping',
          category: 'Food',
          amount: 45.50,
          date: 'Today',
          isExpense: true,
        ),
        Transaction(
          id: '2',
          title: 'Uber Ride',
          category: 'Transport',
          amount: 12.30,
          date: 'Today',
          isExpense: true,
        ),
        Transaction(
          id: '3',
          title: 'Netflix Subscription',
          category: 'Entertainment',
          amount: 15.99,
          date: 'Yesterday',
          isExpense: true,
        ),
        Transaction(
          id: '4',
          title: 'Salary Deposit',
          category: 'Income',
          amount: 4500.00,
          date: 'Yesterday',
          isExpense: false,
        ),
        Transaction(
          id: '5',
          title: 'Electric Bill',
          category: 'Bills',
          amount: 85.00,
          date: '2 days ago',
          isExpense: true,
        ),
      ],
      categoryBreakdown: {
        'Food': 35,
        'Transport': 20,
        'Shopping': 15,
        'Entertainment': 18,
        'Bills': 12,
      },
      totalIncome: 4500,
      totalExpenses: 1200,
      balance: 3300,
    );
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => build());
  }
}
