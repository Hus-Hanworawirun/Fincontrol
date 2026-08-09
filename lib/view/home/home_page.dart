import 'dart:ui';
import 'package:fincontrol/view/wealth/create_new_portfolio.dart';
import 'package:fincontrol/data/models/portfolio_model.dart';
import 'package:fincontrol/view/wealth/invest_page.dart';
import 'package:fincontrol/view/widgets/income_expense_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fincontrol/bloc/transaction/transaction_bloc.dart';
import 'package:fincontrol/bloc/transaction/transaction_state.dart';
import 'package:fincontrol/bloc/portfolio/portfolio_bloc.dart';
import 'package:fincontrol/bloc/portfolio/portfolio_state.dart';
import 'package:intl/intl.dart';

class HomePage extends StatelessWidget {
  final VoidCallback? onSeeAllActivity;
  final VoidCallback? onGoToWealth;
  const HomePage({super.key, this.onSeeAllActivity, this.onGoToWealth});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.20,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF4F3FF0), Color(0xFF8E84FF)],
            ),
          ),
        ),
        ListView(
          padding: const EdgeInsets.only(
            top: 48,
            left: 16,
            right: 16,
            bottom: 16,
          ),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.blue.shade100,
                        radius: 32,
                        child: const Icon(Icons.person, color: Colors.blue),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hello,',
                              style: TextStyle(
                                fontSize: 24,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'The One Who Wait',
                              style: TextStyle(
                                fontSize: 24,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.search, color: Colors.black),
                      iconSize: 28,
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.all(12),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const InvestPage(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(
                        Icons.notifications,
                        color: Colors.black,
                      ),
                      iconSize: 28,
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.all(12),
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 32),
            BlocBuilder<TransactionBloc, TransactionState>(
              builder: (context, state) {
                double totalIncome = 0;
                double totalExpense = 0;
                if (state is TransactionLoaded) {
                  for (var t in state.transactions) {
                    if (t.type == 'Income') totalIncome += t.amount;
                    if (t.type == 'Expense') totalExpense += t.amount;
                  }
                }
                double totalBalance = totalIncome - totalExpense;

                return Material(
                  elevation: 9,
                  shadowColor: Colors.black.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(20),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                      child: Container(
                        height: 200,
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.white, width: 1.5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Total Balance',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black54,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '\$${totalBalance.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 36,
                                color: Colors.black,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.2,
                              ),
                            ),
                            const SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IncomeExpenseItem(
                                  icon: Icons.add,
                                  iconColor: Colors.green,
                                  label: 'Income',
                                  amount: '\$${totalIncome.toStringAsFixed(2)}',
                                ),
                                IncomeExpenseItem(
                                  icon: Icons.remove,
                                  iconColor: Colors.red,
                                  label: 'Expense',
                                  amount: '\$${totalExpense.toStringAsFixed(2)}',
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            Material(
              color: Colors.white,
              elevation: 9,
              shadowColor: Colors.black.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(20),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'My Goals',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight(800),
                            color: Colors.black,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            onGoToWealth?.call();
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text(
                            'See all',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight(700),
                              color: Color(0xFF4F3FF0),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    BlocBuilder<PortfolioBloc, PortfolioState>(
                      builder: (context, state) {
                        if (state is PortfolioLoading) {
                          return const SizedBox(height: 160, child: Center(child: CircularProgressIndicator()));
                        }
                        if (state is PortfolioError) {
                          return SizedBox(
                            height: 160,
                            child: Center(child: Text('Error: ${state.message}', style: const TextStyle(color: Colors.red))),
                          );
                        }
                        if (state is PortfolioLoaded) {
                          final goals = state.portfolios.where((p) => (p.targetGoal ?? 0) > 0).toList();
                          if (goals.isEmpty) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const CreatePortfolioPage()));
                                },
                                borderRadius: BorderRadius.circular(16),
                                child: Container(
                                  height: 160,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF4F3FF0).withValues(alpha: 0.05),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: const Color(0xFF4F3FF0).withValues(alpha: 0.3), width: 1.5),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.add_circle_outline, color: Color(0xFF4F3FF0), size: 40),
                                      const SizedBox(height: 12),
                                      const Text('Create your first goal', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 16)),
                                      const SizedBox(height: 4),
                                      Text('Start tracking your investments', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }
                          
                          return SizedBox(
                            height: 160,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: goals.length,
                              itemBuilder: (context, index) {
                                final goal = goals[index];
                                final currentProgress = 0.0; // Needs asset value calculation in a real app
                                final progressPercent = (currentProgress / goal.targetGoal!).clamp(0.0, 1.0);
                                return Padding(
                                  padding: const EdgeInsets.only(right: 16, bottom: 16, left: 4),
                                  child: Material(
                                    elevation: 9,
                                    shadowColor: Colors.black.withValues(alpha: 0.5),
                                    borderRadius: BorderRadius.circular(16),
                                    color: Colors.white,
                                    clipBehavior: Clip.antiAlias,
                                    child: Container(
                                      width: 140,
                                      padding: const EdgeInsets.all(16),
                                      color: const Color(0xFF4F3FF0).withValues(alpha: 0.05),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: const BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
                                              // ignore: non_const_argument_for_const_parameter
                                              IconData(goal.icon, fontFamily: 'MaterialIcons'),
                                              color: const Color(0xFF4F3FF0),
                                              size: 24,
                                            ),
                                          ),
                                          const Spacer(),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                goal.name,
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black87,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                '\$${currentProgress.toStringAsFixed(0)} / \$${goal.targetGoal!.toStringAsFixed(0)}',
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 12),
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(4),
                                            child: LinearProgressIndicator(
                                              value: progressPercent,
                                              minHeight: 6,
                                              backgroundColor: Colors.grey.shade200,
                                              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF4F3FF0)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        }
                        return const SizedBox(height: 160);
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Material(
              color: Colors.white,
              elevation: 9,
              shadowColor: Colors.black.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(20),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Recent Transactions',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Colors.black,
                          ),
                        ),
                        TextButton(
                          onPressed: onSeeAllActivity,
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text(
                            'See all',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF4F3FF0),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    BlocBuilder<TransactionBloc, TransactionState>(
                      builder: (context, state) {
                        if (state is TransactionLoading) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        if (state is TransactionLoaded) {
                          var sorted = List.of(state.transactions)
                            ..sort((a, b) => b.date.compareTo(a.date));
                          var recent = sorted.take(3).toList();
                          
                          if (recent.isEmpty) {
                            return SizedBox(
                              height: 160,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.receipt_long, color: Colors.grey.shade300, size: 48),
                                    const SizedBox(height: 16),
                                    Text('No recent transactions', style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.bold, fontSize: 16)),
                                    const SizedBox(height: 4),
                                    Text('Tap the + button to add one', style: TextStyle(color: Colors.grey.shade400, fontSize: 14)),
                                  ],
                                ),
                              ),
                            );
                          }
                          
                          return Column(
                            children: recent.map((t) {
                              bool isIncome = t.type == 'Income';
                              return Column(
                                children: [
                                  _buildTransactionItem(
                                    icon: _getCategoryIcon(t.category),
                                    color: isIncome ? Colors.green : Colors.orange,
                                    title: t.note.isNotEmpty ? t.note : t.category,
                                    subtitle: DateFormat('MMM dd, hh:mm a').format(t.date),
                                    amount: '${isIncome ? "+" : "-"}\$${t.amount.toStringAsFixed(2)}',
                                  ),
                                  if (t != recent.last) const Divider(height: 24, thickness: 0.5),
                                ],
                              );
                            }).toList(),
                          );
                        }
                        if (state is TransactionError) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 32),
                            child: Center(child: Text('Error: ${state.message}', style: const TextStyle(color: Colors.red))),
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 100,
            ), // Extra padding for FloatingActionButton
          ],
        ),
      ],
    );
  }

  Widget _buildTransactionItem({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required String amount,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
        Text(
          amount,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black, // Dark text to pop against white card
          ),
        ),
      ],
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
      default: return Icons.category;
    }
  }
}
