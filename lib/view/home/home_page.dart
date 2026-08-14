import 'package:fincontrol/view/wealth/create_new_portfolio.dart';
import 'package:fincontrol/view/wealth/invest_page.dart';
import 'package:fincontrol/view/notifications/notifications_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fincontrol/bloc/transaction/transaction_bloc.dart';
import 'package:fincontrol/bloc/transaction/transaction_state.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

class HomePage extends StatelessWidget {
  final VoidCallback? onSeeAllActivity;
  final VoidCallback? onGoToWealth;
  
  const HomePage({super.key, this.onSeeAllActivity, this.onGoToWealth});

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;
    final mutedTextColor = Theme.of(context).textTheme.bodySmall?.color;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    // Using a solid, opaque slate-grey color inspired by the example screenshot.
    // This creates strong contrast against the background without using any transparency.
    final cardColor = isDarkMode 
        ? const Color(0xFF272732) // Solid dark slate/purple-grey (like the 'Smart TV' card)
        : Colors.white;

    return Scaffold(
      backgroundColor: Colors.transparent, // Ensures the global animated background gradient shows through
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(top: 24, left: 16, right: 16, bottom: 120),
          children: [
            _buildHeader(context, textColor, primaryColor, cardColor),
            const SizedBox(height: 24),
            _buildBalanceCard(context, textColor, mutedTextColor, primaryColor, cardColor),
            const SizedBox(height: 24),
            _buildQuickActions(context, textColor, mutedTextColor, primaryColor, cardColor),
            const SizedBox(height: 24),
            _buildAiInsightCard(context, textColor, primaryColor, cardColor),
            const SizedBox(height: 32),
            _buildRecentTransactions(context, textColor, mutedTextColor, primaryColor, cardColor),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Color? textColor, Color primaryColor, Color cardColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: primaryColor.withValues(alpha: 0.1),
                radius: 24,
                child: Icon(Icons.person, color: primaryColor),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Good Morning,', style: TextStyle(fontSize: 13, color: textColor?.withValues(alpha: 0.6))),
                    Text('The One Who Wait', style: TextStyle(fontSize: 20, color: textColor, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis, maxLines: 1),
                  ],
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            _buildIconButton(context, Icons.search, textColor, cardColor, () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const InvestPage()));
            }),
            const SizedBox(width: 12),
            _buildIconButton(context, Icons.notifications_none, textColor, cardColor, () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationsPage()));
            }),
          ],
        ),
      ],
    );
  }

  Widget _buildIconButton(BuildContext context, IconData icon, Color? iconColor, Color bgColor, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, color: iconColor, size: 22),
        onPressed: onTap,
      ),
    );
  }

  Widget _buildBalanceCard(BuildContext context, Color? textColor, Color? mutedTextColor, Color primaryColor, Color cardColor) {
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

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Total Balance', style: TextStyle(fontSize: 14, color: mutedTextColor, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('\$${totalBalance.toStringAsFixed(2)}', style: TextStyle(fontSize: 36, color: textColor, fontWeight: FontWeight.w900, letterSpacing: -1)),
                  SizedBox(
                    width: 60,
                    height: 35,
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
                            barWidth: 3,
                            isStrokeCapRound: true,
                            dotData: const FlDotData(show: false),
                            belowBarData: BarAreaData(show: false),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(color: Colors.green.withValues(alpha: 0.1), shape: BoxShape.circle),
                              child: const Icon(Icons.arrow_downward, color: Colors.green, size: 12),
                            ),
                            const SizedBox(width: 8),
                            Text('Income', style: TextStyle(fontSize: 12, color: mutedTextColor, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text('\$${currentMonthIncome.toStringAsFixed(2)}', style: TextStyle(fontSize: 16, color: textColor, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  Container(width: 1, height: 40, color: mutedTextColor?.withValues(alpha: 0.2)),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(color: Colors.red.withValues(alpha: 0.1), shape: BoxShape.circle),
                              child: const Icon(Icons.arrow_upward, color: Colors.red, size: 12),
                            ),
                            const SizedBox(width: 8),
                            Text('Expenses', style: TextStyle(fontSize: 12, color: mutedTextColor, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text('\$${currentMonthExpense.toStringAsFixed(2)}', style: TextStyle(fontSize: 16, color: textColor, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
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

  Widget _buildAiInsightCard(BuildContext context, Color? textColor, Color primaryColor, Color cardColor) {
    return Container(
      decoration: BoxDecoration(
        color: primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primaryColor.withValues(alpha: 0.2), width: 1),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.lightbulb_outline, color: primaryColor, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Insight', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textColor)),
                const SizedBox(height: 4),
                Text('You spent 15% less on Food this week compared to last week. Great job staying on budget.', 
                  style: TextStyle(fontSize: 13, color: textColor?.withValues(alpha: 0.8), height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context, Color? textColor, Color? mutedTextColor, Color primaryColor, Color cardColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildActionBtn(context, Icons.trending_up, 'Invest', primaryColor, textColor, cardColor, () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const InvestPage()));
        }),
        _buildActionBtn(context, Icons.flag_outlined, 'New Goal', primaryColor, textColor, cardColor, () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const CreatePortfolioPage()));
        }),
        _buildActionBtn(context, Icons.account_balance_wallet_outlined, 'Wealth', primaryColor, textColor, cardColor, () {
          onGoToWealth?.call();
        }),
        _buildActionBtn(context, Icons.receipt_long_outlined, 'Activity', primaryColor, textColor, cardColor, () {
          onSeeAllActivity?.call();
        }),
      ],
    );
  }

  Widget _buildActionBtn(BuildContext context, IconData icon, String label, Color primaryColor, Color? textColor, Color cardColor, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: textColor, size: 24),
          ),
          const SizedBox(height: 12),
          Text(label, style: TextStyle(fontSize: 12, color: textColor, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildRecentTransactions(BuildContext context, Color? textColor, Color? mutedTextColor, Color primaryColor, Color cardColor) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Recent', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
              TextButton(
                onPressed: onSeeAllActivity,
                style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                child: Text('See all', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: primaryColor)),
              ),
            ],
          ),
          const SizedBox(height: 24),
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
                          Icon(Icons.receipt_long, color: mutedTextColor?.withValues(alpha: 0.3), size: 48),
                          const SizedBox(height: 16),
                          Text('No transactions yet', style: TextStyle(color: mutedTextColor, fontSize: 14)),
                        ],
                      ),
                    ),
                  );
                }
                
                return Column(
                  children: recent.map((t) {
                    bool isIncome = t.type == 'Income';
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isIncome ? Colors.green.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.05),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(_getCategoryIcon(t.category), color: isIncome ? Colors.green : (textColor ?? Colors.black), size: 20),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(t.note.isNotEmpty ? t.note : t.category, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: textColor)),
                                const SizedBox(height: 4),
                                Text(DateFormat('MMM dd').format(t.date), style: TextStyle(fontSize: 13, color: mutedTextColor)),
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
      case 'Food': return Icons.restaurant;
      case 'Transport': return Icons.directions_car_outlined;
      case 'Shopping': return Icons.shopping_bag_outlined;
      case 'Entertainment': return Icons.movie_creation_outlined;
      case 'Work': return Icons.work_outline;
      case 'Salary': return Icons.payments_outlined;
      default: return Icons.category_outlined;
    }
  }
}
