
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fincontrol/bloc/transaction/transaction_bloc.dart';
import 'package:fincontrol/bloc/transaction/transaction_state.dart';
import 'package:fincontrol/bloc/transaction/transaction_event.dart';
import 'package:fincontrol/data/models/transaction_model.dart';
import 'package:fincontrol/view/navigationbar/add_transaction_sheet.dart';
import '../widgets/glass_container.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:fincontrol/view/notifications/notifications_page.dart';

class ActivityPage extends StatefulWidget {
  const ActivityPage({super.key});

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  String _selectedPeriod = 'Month';
  String _selectedFilter = 'All';
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;
    final mutedTextColor = Theme.of(context).textTheme.bodySmall?.color;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<TransactionBloc, TransactionState>(
          builder: (context, state) {
            List<TransactionModel> allTransactions = [];
            if (state is TransactionLoaded) {
              allTransactions = state.transactions;
            }

            // Filter by Period
            final now = DateTime.now();
            List<TransactionModel> periodTransactions = allTransactions.where((t) {
              if (_selectedPeriod == 'Month') {
                return t.date.year == now.year && t.date.month == now.month;
              } else if (_selectedPeriod == 'Year') {
                return t.date.year == now.year;
              } else if (_selectedPeriod == 'Week') {
                return now.difference(t.date).inDays <= 7;
              } else {
                return t.date.year == now.year && t.date.month == now.month && t.date.day == now.day;
              }
            }).toList();

            // Filter by Search & Filter Chip
            List<TransactionModel> filteredTransactions = periodTransactions.where((t) {
              final matchesSearch = t.note.toLowerCase().contains(_searchQuery.toLowerCase()) || 
                                    t.category.toLowerCase().contains(_searchQuery.toLowerCase());
              if (!matchesSearch) return false;

              if (_selectedFilter == 'Income') return t.type == 'Income';
              if (_selectedFilter == 'Expense') return t.type == 'Expense';
              return true;
            }).toList();

            filteredTransactions.sort((a, b) => b.date.compareTo(a.date));

            return ListView(
              padding: const EdgeInsets.only(
                top: 16, 
                left: 16,
                right: 16,
                bottom: 120,
              ),
              children: [
                _buildHeader(context, textColor),
                const SizedBox(height: 24),
                _buildSearchBar(textColor, mutedTextColor, primaryColor, isDarkMode),
                const SizedBox(height: 24),
                _buildPeriodTabs(textColor, mutedTextColor, primaryColor),
                const SizedBox(height: 24),
                _buildCashFlowChart(periodTransactions, textColor, mutedTextColor, primaryColor),
                const SizedBox(height: 24),
                _buildSpendingBreakdown(periodTransactions, textColor, mutedTextColor),
                const SizedBox(height: 32),
                Text(
                  'Transactions',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 16),
                _buildTransactionList(filteredTransactions, textColor, mutedTextColor),
              ],
            );
          }
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Color? textColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Activity Dashboard',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        GlassContainer(
          padding: const EdgeInsets.all(8),
          borderRadius: BorderRadius.circular(30),
          child: IconButton(
            icon: Icon(Icons.notifications_outlined, color: textColor), 
            iconSize: 24,
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationsPage()));
            }
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar(Color? textColor, Color? mutedTextColor, Color primaryColor, bool isDarkMode) {
    return Column(
      children: [
        GlassContainer(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          borderRadius: BorderRadius.circular(20),
          child: TextField(
            controller: _searchController,
            style: TextStyle(color: textColor),
            onChanged: (val) => setState(() => _searchQuery = val),
            decoration: InputDecoration(
              icon: Icon(Icons.search, color: mutedTextColor),
              hintText: 'Search transactions...',
              hintStyle: TextStyle(color: mutedTextColor),
              border: InputBorder.none,
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 36,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: ['All', 'Income', 'Expense'].map((filter) {
              final isSelected = _selectedFilter == filter;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () => setState(() => _selectedFilter = filter),
                  child: GlassContainer(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    borderRadius: BorderRadius.circular(20),
                    color: isSelected ? primaryColor : Colors.white.withValues(alpha: isDarkMode ? 0.05 : 0.2),
                    child: Center(
                      child: Text(
                        filter,
                        style: TextStyle(
                          color: isSelected ? Colors.white : textColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildPeriodTabs(Color? textColor, Color? mutedTextColor, Color primaryColor) {
    return GlassContainer(
      padding: const EdgeInsets.all(4),
      borderRadius: BorderRadius.circular(16),
      child: Row(
        children: ['Day', 'Week', 'Month', 'Year'].map((String value) {
          final isSelected = _selectedPeriod == value;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedPeriod = value),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? primaryColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    value,
                    style: TextStyle(
                      color: isSelected ? Colors.white : mutedTextColor,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCashFlowChart(List<TransactionModel> transactions, Color? textColor, Color? mutedTextColor, Color primaryColor) {
    double income = 0;
    double expense = 0;
    for (var t in transactions) {
      if (t.type == 'Income') income += t.amount;
      if (t.type == 'Expense') expense += t.amount;
    }

    return GlassContainer(
      padding: const EdgeInsets.all(24),
      borderRadius: BorderRadius.circular(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Cash Flow',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: (income > expense ? income : expense) * 1.2,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            value == 0 ? 'Income' : 'Expense',
                            style: TextStyle(color: mutedTextColor, fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                barGroups: [
                  BarChartGroupData(
                    x: 0,
                    barRods: [
                      BarChartRodData(
                        toY: income,
                        color: Colors.greenAccent,
                        width: 40,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                      ),
                    ],
                  ),
                  BarChartGroupData(
                    x: 1,
                    barRods: [
                      BarChartRodData(
                        toY: expense,
                        color: Colors.redAccent,
                        width: 40,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpendingBreakdown(List<TransactionModel> transactions, Color? textColor, Color? mutedTextColor) {
    Map<String, double> categoryTotals = {};
    double totalExpense = 0;

    for (var t in transactions) {
      if (t.type == 'Expense') {
        categoryTotals[t.category] = (categoryTotals[t.category] ?? 0) + t.amount;
        totalExpense += t.amount;
      }
    }

    if (totalExpense == 0) {
      return const SizedBox.shrink(); 
    }

    final colors = [
      Colors.blueAccent,
      Colors.orangeAccent,
      Colors.purpleAccent,
      Colors.amberAccent,
      Colors.cyanAccent,
      Colors.pinkAccent,
    ];

    int colorIndex = 0;
    List<PieChartSectionData> sections = [];
    List<Widget> legendItems = [];

    categoryTotals.forEach((category, amount) {
      final color = colors[colorIndex % colors.length];
      final percentage = (amount / totalExpense) * 100;
      
      sections.add(
        PieChartSectionData(
          color: color,
          value: amount,
          title: '${percentage.toStringAsFixed(0)}%',
          radius: 50,
          titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      );

      legendItems.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(category, style: TextStyle(color: textColor, fontWeight: FontWeight.w500, fontSize: 13), overflow: TextOverflow.ellipsis),
              ),
              Text('\$${amount.toStringAsFixed(0)}', style: TextStyle(color: textColor, fontWeight: FontWeight.w700)),
            ],
          ),
        )
      );

      colorIndex++;
    });

    return GlassContainer(
      padding: const EdgeInsets.all(24),
      borderRadius: BorderRadius.circular(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Spending Breakdown',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
          ),
          const SizedBox(height: 32),
          SizedBox(
            height: 200,
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 2,
                      centerSpaceRadius: 40,
                      sections: sections,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: legendItems,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionList(List<TransactionModel> transactions, Color? textColor, Color? mutedTextColor) {
    if (transactions.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: Text('No transactions match your criteria', style: TextStyle(color: mutedTextColor, fontWeight: FontWeight.w500)),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: transactions.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final record = transactions[index];
        final isIncome = record.type == 'Income';
        
        return Dismissible(
          key: Key(record.id),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.circular(20)),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          onDismissed: (direction) {
            context.read<TransactionBloc>().add(DeleteTransaction(record.id));
          },
          child: GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => AddTransactionSheet(existingTransaction: record),
              );
            },
            child: GlassContainer(
              padding: const EdgeInsets.all(16),
              borderRadius: BorderRadius.circular(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isIncome ? Colors.green.withValues(alpha: 0.1) : Colors.orange.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isIncome ? Icons.arrow_downward : Icons.arrow_upward,
                  color: isIncome ? Colors.green : Colors.orange,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      record.note.isNotEmpty ? record.note : record.category,
                      style: TextStyle(fontWeight: FontWeight.w700, color: textColor, fontSize: 15),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      record.category,
                      style: TextStyle(color: mutedTextColor, fontWeight: FontWeight.w600, fontSize: 13),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${isIncome ? "+" : "-"}\$${record.amount.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: textColor,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${record.date.month}/${record.date.day}/${record.date.year}',
                    style: TextStyle(color: mutedTextColor, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        )));
      },
    );
  }
}
