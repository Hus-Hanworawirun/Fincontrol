import 'package:fincontrol/view/wealth/create_new_portfolio.dart';
import 'package:fincontrol/view/wealth/invest_page.dart';
import 'package:fincontrol/view/notifications/notifications_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fincontrol/bloc/transaction/transaction_bloc.dart';
import 'package:fincontrol/bloc/transaction/transaction_state.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import '../widgets/glass_container.dart';

class HomePage extends StatelessWidget {
  final VoidCallback? onSeeAllActivity;
  final VoidCallback? onGoToWealth;
  
  const HomePage({super.key, this.onSeeAllActivity, this.onGoToWealth});

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;
    final mutedTextColor = Theme.of(context).textTheme.bodySmall?.color;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Stack(
      children: [
        ListView(
          padding: const EdgeInsets.only(top: 64, left: 16, right: 16, bottom: 120),
          children: [
            _buildHeader(context, textColor, primaryColor),
            const SizedBox(height: 24),
            _buildBalanceCard(context, textColor, mutedTextColor, primaryColor),
            const SizedBox(height: 20),
            _buildQuickActions(context, textColor, mutedTextColor, primaryColor),
            const SizedBox(height: 20),
            _buildAiInsightCard(context, textColor, primaryColor),
            const SizedBox(height: 24),
            _buildRecentTransactions(context, textColor, mutedTextColor, primaryColor),
          ],
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, Color? textColor, Color primaryColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: primaryColor.withValues(alpha: 0.2),
                radius: 28,
                child: Icon(Icons.person, color: primaryColor),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Good Morning,', style: TextStyle(fontSize: 14, color: textColor?.withValues(alpha: 0.7))),
                    Text('The One Who Wait', style: TextStyle(fontSize: 20, color: textColor, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis, maxLines: 1),
                  ],
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            GlassContainer(
              padding: const EdgeInsets.all(8),
              borderRadius: BorderRadius.circular(30),
              child: IconButton(
                icon: Icon(Icons.search, color: textColor),
                iconSize: 24,
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const InvestPage()));
                },
              ),
            ),
            const SizedBox(width: 8),
            GlassContainer(
              padding: const EdgeInsets.all(8),
              borderRadius: BorderRadius.circular(30),
              child: IconButton(
                icon: Icon(Icons.notifications_outlined, color: textColor),
                iconSize: 24,
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationsPage()));
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBalanceCard(BuildContext context, Color? textColor, Color? mutedTextColor, Color primaryColor) {
    return BlocBuilder<TransactionBloc, TransactionState>(
      builder: (context, state) {
        double currentMonthIncome = 0;
        double currentMonthExpense = 0;
        double totalBalance = 0; 

        if (state is TransactionLoaded) {
          final now = DateTime.now();
          for (var t in state.transactions) {
            if (t.type == 'Income') totalBalance += t.amount;
            if (t.type == 'Expense') totalBalance -= t.amount;

            if (t.date.year == now.year && t.date.month == now.month) {
              if (t.type == 'Income') currentMonthIncome += t.amount;
              if (t.type == 'Expense') currentMonthExpense += t.amount;
            }
          }
        }

        final double spendRatio = currentMonthIncome > 0 
            ? (currentMonthExpense / currentMonthIncome).clamp(0.0, 1.0) 
            : 0.0;

        return GlassContainer(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          borderRadius: BorderRadius.circular(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Available Balance', style: TextStyle(fontSize: 14, color: mutedTextColor, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('\$${totalBalance.toStringAsFixed(2)}', style: TextStyle(fontSize: 32, color: textColor, fontWeight: FontWeight.w900)),
                  SizedBox(
                    width: 70,
                    height: 40,
                    child: LineChart(
                      LineChartData(
                        gridData: const FlGridData(show: false),
                        titlesData: const FlTitlesData(show: false),
                        borderData: FlBorderData(show: false),
                        minX: 0,
                        maxX: 6,
                        minY: 0,
                        maxY: 10,
                        lineBarsData: [
                          LineChartBarData(
                            spots: const [
                              FlSpot(0, 3), FlSpot(1, 4), FlSpot(2, 3.5), FlSpot(3, 6), FlSpot(4, 5), FlSpot(5, 8), FlSpot(6, 7),
                            ],
                            isCurved: true,
                            color: primaryColor,
                            barWidth: 2.5,
                            isStrokeCapRound: true,
                            dotData: const FlDotData(show: false),
                            belowBarData: BarAreaData(
                              show: true,
                              color: primaryColor.withValues(alpha: 0.15),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Divider(height: 1, thickness: 0.5, color: mutedTextColor?.withValues(alpha: 0.2)),
              const SizedBox(height: 16),
              Text('This Month\'s Cash Flow', style: TextStyle(fontSize: 14, color: textColor, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Income', style: TextStyle(fontSize: 12, color: mutedTextColor)),
                      Text('\$${currentMonthIncome.toStringAsFixed(2)}', style: const TextStyle(fontSize: 15, color: Colors.green, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('Expense', style: TextStyle(fontSize: 12, color: mutedTextColor)),
                      Text('\$${currentMonthExpense.toStringAsFixed(2)}', style: const TextStyle(fontSize: 15, color: Colors.red, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: spendRatio,
                  minHeight: 6,
                  backgroundColor: Colors.green.withValues(alpha: 0.2),
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.red),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAiInsightCard(BuildContext context, Color? textColor, Color primaryColor) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            primaryColor.withValues(alpha: 0.15),
            primaryColor.withValues(alpha: 0.05),
          ],
        ),
        border: Border.all(color: primaryColor.withValues(alpha: 0.3), width: 1),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.auto_awesome, color: primaryColor, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('AI Insight', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textColor)),
                const SizedBox(height: 4),
                Text('You spent 15% less on Food this week compared to last week. Great job staying on budget!', 
                  style: TextStyle(fontSize: 13, color: textColor?.withValues(alpha: 0.8), height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context, Color? textColor, Color? mutedTextColor, Color primaryColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildActionBtn(context, Icons.trending_up, 'Invest', primaryColor, textColor, () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const InvestPage()));
        }),
        _buildActionBtn(context, Icons.track_changes, 'New Goal', primaryColor, textColor, () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const CreatePortfolioPage()));
        }),
        _buildActionBtn(context, Icons.account_balance_wallet, 'Wealth', primaryColor, textColor, () {
          onGoToWealth?.call();
        }),
        _buildActionBtn(context, Icons.history, 'Activity', primaryColor, textColor, () {
          onSeeAllActivity?.call();
        }),
      ],
    );
  }

  Widget _buildActionBtn(BuildContext context, IconData icon, String label, Color primaryColor, Color? textColor, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          GlassContainer(
            borderRadius: BorderRadius.circular(16),
            padding: const EdgeInsets.all(16),
            child: Icon(icon, color: primaryColor, size: 28),
          ),
          const SizedBox(height: 8),
          Text(label, style: TextStyle(fontSize: 12, color: textColor, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildRecentTransactions(BuildContext context, Color? textColor, Color? mutedTextColor, Color primaryColor) {
    return GlassContainer(
      padding: const EdgeInsets.all(20),
      borderRadius: BorderRadius.circular(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Recent Transactions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: textColor)),
              TextButton(
                onPressed: onSeeAllActivity,
                style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                child: Text('See all', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: primaryColor)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          BlocBuilder<TransactionBloc, TransactionState>(
            builder: (context, state) {
              if (state is TransactionLoading) return const Center(child: CircularProgressIndicator());
              if (state is TransactionLoaded) {
                var sorted = List.of(state.transactions)..sort((a, b) => b.date.compareTo(a.date));
                var recent = sorted.take(4).toList();
                
                if (recent.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        children: [
                          Icon(Icons.receipt_long, color: mutedTextColor?.withValues(alpha: 0.5), size: 48),
                          const SizedBox(height: 16),
                          Text('No recent transactions', style: TextStyle(color: mutedTextColor, fontWeight: FontWeight.bold, fontSize: 16)),
                        ],
                      ),
                    ),
                  );
                }
                
                return Column(
                  children: recent.map((t) {
                    bool isIncome = t.type == 'Income';
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: (isIncome ? Colors.green : Colors.orange).withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(_getCategoryIcon(t.category), color: isIncome ? Colors.green : Colors.orange, size: 24),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(t.note.isNotEmpty ? t.note : t.category, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor)),
                                const SizedBox(height: 4),
                                Text(DateFormat('MMM dd, hh:mm a').format(t.date), style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: mutedTextColor)),
                              ],
                            ),
                          ),
                          Text('${isIncome ? "+" : "-"}\$${t.amount.toStringAsFixed(2)}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor)),
                        ],
                      ),
                    );
                  }).toList(),
                );
              }
              if (state is TransactionError) return Center(child: Text('Error: ${state.message}', style: const TextStyle(color: Colors.red)));
              return const SizedBox();
            },
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Food': return Icons.fastfood;
      case 'Transport': return Icons.directions_car;
      case 'Shopping': return Icons.shopping_cart;
      case 'Entertainment': return Icons.movie;
      case 'Work': return Icons.work;
      case 'Salary': return Icons.attach_money;
      default: return Icons.category_outlined;
    }
  }
}
