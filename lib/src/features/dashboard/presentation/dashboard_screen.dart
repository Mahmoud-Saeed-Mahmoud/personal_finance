import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_provider.dart';
import '../domain/dashboard_models.dart';
import 'dashboard_controller.dart';
import 'widgets/animated_counter.dart';
import 'widgets/category_pie_chart.dart';
import 'widgets/skeleton_loader.dart';
import 'widgets/time_period_selector.dart';
import 'widgets/transaction_card.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  TimePeriod _selectedPeriod = TimePeriod.week;

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeControllerProvider);
    final dashboardState = ref.watch(dashboardControllerProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () =>
            ref.read(dashboardControllerProvider.notifier).refresh(),
        child: CustomScrollView(
          slivers: [
            _buildAppBar(context, themeMode, isDark),
            SliverPadding(
              padding: const EdgeInsets.all(16.0),
              sliver: dashboardState.when(
                loading: () => SliverToBoxAdapter(child: _DashboardSkeleton()),
                error: (error, stack) => SliverToBoxAdapter(
                  child: Center(child: Text('Error: $error')),
                ),
                data: (data) => _buildDashboardContent(data, isDark),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, ThemeMode themeMode, bool isDark) {
    return SliverAppBar(
      expandedHeight: 120,
      floating: true,
      pinned: true,
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      flexibleSpace: FlexibleSpaceBar(
        title: const Text('Personal Finance'),
        titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
        background: Container(
          decoration: BoxDecoration(
            gradient: isDark
                ? AppColors.darkPrimaryGradient
                : AppColors.primaryGradient,
          ),
        ),
      ),
      actions: [
        Row(
          children: [
            Icon(
              themeMode == ThemeMode.dark
                  ? PhosphorIconsRegular.moon
                  : PhosphorIconsRegular.sun,
              size: 20,
            ),
            Switch(
              value: themeMode == ThemeMode.dark,
              onChanged: (value) {
                ref.read(themeControllerProvider.notifier).toggleTheme();
              },
            ),
            const SizedBox(width: 8),
          ],
        ),
      ],
    );
  }

  Widget _buildDashboardContent(DashboardData data, bool isDark) {
    return SliverList(
      delegate: SliverChildListDelegate([
        const SizedBox(height: 8),

        // Time Period Selector
        TimePeriodSelector(
          selected: _selectedPeriod,
          onChanged: (period) => setState(() => _selectedPeriod = period),
        ),

        const SizedBox(height: 24),

        // Summary Cards with Gradient
        _buildSummaryCards(data, isDark),

        const SizedBox(height: 24),

        // Bar Chart Section
        _buildChartSection(data, isDark),

        const SizedBox(height: 24),

        // Pie Chart Section
        _buildPieChartSection(data, isDark),

        const SizedBox(height: 24),

        // Transactions Section
        _buildTransactionsSection(data),
      ]),
    );
  }

  Widget _buildSummaryCards(DashboardData data, bool isDark) {
    return Row(
      children: [
        Expanded(
          child: _GradientSummaryCard(
            title: 'Income',
            amount: data.totalIncome,
            icon: PhosphorIconsRegular.trendUp,
            gradient: AppColors.successGradient,
            delay: 0,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _GradientSummaryCard(
            title: 'Expenses',
            amount: data.totalExpenses,
            icon: PhosphorIconsRegular.trendDown,
            gradient: AppColors.warningGradient,
            delay: 100,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _GradientSummaryCard(
            title: 'Balance',
            amount: data.balance,
            icon: PhosphorIconsRegular.wallet,
            gradient: isDark
                ? AppColors.darkPrimaryGradient
                : AppColors.primaryGradient,
            delay: 200,
          ),
        ),
      ],
    );
  }

  Widget _buildChartSection(DashboardData data, bool isDark) {
    return _SectionCard(
      delay: 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Weekly Expenses',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: _AnimatedBarChart(data: data.weeklyExpenses, isDark: isDark),
          ),
        ],
      ),
    );
  }

  Widget _buildPieChartSection(DashboardData data, bool isDark) {
    return _SectionCard(
      delay: 400,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Category Breakdown',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          CategoryPieChart(data: data.categoryBreakdown),
          const SizedBox(height: 16),
          CategoryLegend(data: data.categoryBreakdown),
        ],
      ),
    );
  }

  Widget _buildTransactionsSection(DashboardData data) {
    return _SectionCard(
      delay: 500,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Transactions',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              TextButton(onPressed: () {}, child: const Text('See All')),
            ],
          ),
          const SizedBox(height: 12),
          ...data.transactions.map((transaction) {
            return TweenAnimationBuilder<double>(
              duration: Duration(
                milliseconds:
                    300 + (data.transactions.indexOf(transaction) * 50),
              ),
              tween: Tween(begin: 0.0, end: 1.0),
              curve: Curves.easeOut,
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(0, 20 * (1 - value)),
                  child: Opacity(opacity: value, child: child),
                );
              },
              child: TransactionCard(
                title: transaction.title,
                category: transaction.category,
                amount: transaction.amount,
                date: transaction.date,
                isExpense: transaction.isExpense,
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _DashboardSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SkeletonLoader(
          child: SkeletonBox(width: double.infinity, height: 40),
        ),
        const SizedBox(height: 24),
        Row(
          children: List.generate(
            3,
            (index) => const Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 6),
                child: SkeletonLoader(
                  child: SkeletonBox(width: 100, height: 100),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        const SkeletonLoader(
          child: SkeletonBox(width: double.infinity, height: 200),
        ),
        const SizedBox(height: 24),
        const SkeletonLoader(
          child: SkeletonBox(width: double.infinity, height: 200),
        ),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.child, this.delay = 0});

  final Widget child;
  final int delay;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 400 + delay),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: (isDark
                  ? AppColors.darkCardShadow
                  : AppColors.lightCardShadow),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}

class _GradientSummaryCard extends StatelessWidget {
  const _GradientSummaryCard({
    required this.title,
    required this.amount,
    required this.icon,
    required this.gradient,
    this.delay = 0,
  });

  final String title;
  final double amount;
  final IconData icon;
  final LinearGradient gradient;
  final int delay;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 400 + delay),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.8 + (0.2 * value),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: gradient.colors.first.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 24, color: Colors.white.withValues(alpha: 0.9)),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
            const SizedBox(height: 4),
            AnimatedCounter(
              value: amount,
              prefix: '\$',
              decimalPlaces: 0,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnimatedBarChart extends StatefulWidget {
  const _AnimatedBarChart({required this.data, required this.isDark});

  final List<double> data;
  final bool isDark;

  @override
  State<_AnimatedBarChart> createState() => _AnimatedBarChartState();
}

class _AnimatedBarChartState extends State<_AnimatedBarChart> {
  late List<BarChartGroupData> _barGroups;

  @override
  void initState() {
    super.initState();
    // Initialize with 0 height
    _barGroups = List.generate(
      widget.data.length,
      (index) => BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: 0,
            gradient: widget.isDark
                ? AppColors.darkPrimaryGradient
                : AppColors.primaryGradient,
            width: 20,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(6),
              topRight: Radius.circular(6),
            ),
          ),
        ],
      ),
    );

    // Trigger animation after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _barGroups = List.generate(
            widget.data.length,
            (index) => BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: widget.data[index],
                  gradient: widget.isDark
                      ? AppColors.darkPrimaryGradient
                      : AppColors.primaryGradient,
                  width: 20,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(6),
                    topRight: Radius.circular(6),
                  ),
                ),
              ],
            ),
          );
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (group) => AppColors.lightPrimary,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                '\$${rod.toY.toStringAsFixed(0)}',
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (double value, TitleMeta meta) {
                const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                if (value.toInt() < 0 || value.toInt() >= days.length) {
                  return const SizedBox();
                }
                return SideTitleWidget(
                  meta: meta,
                  child: Text(
                    days[value.toInt()],
                    style: const TextStyle(fontSize: 12),
                  ),
                );
              },
            ),
          ),
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(show: false),
        barGroups: _barGroups,
        gridData: const FlGridData(show: false),
        maxY: (widget.data.reduce((a, b) => a > b ? a : b) * 1.2),
      ),
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeInOut,
    );
  }
}
