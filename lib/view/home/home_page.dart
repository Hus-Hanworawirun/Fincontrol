import 'dart:ui';
import 'package:fincontrol/view/wealth/invest_page.dart';
import 'package:fincontrol/view/widgets/income_expense_item.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final VoidCallback? onSeeAllActivity;
  const HomePage({super.key, this.onSeeAllActivity});

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
                              style: TextStyle(fontSize: 24, color: Colors.white),
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
                      }
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.notifications, color: Colors.black), 
                      iconSize: 28,
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.all(12),
                      ),
                      onPressed: () {}
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 32), 
            Material(
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
                        const Text(
                          '\$12,450.00',
                          style: TextStyle(
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
                              amount: '\$4,500.00',
                            ),
                            IncomeExpenseItem(
                              icon: Icons.remove,
                              iconColor: Colors.red,
                              label: 'Expense',
                              amount: '\$1,200.00',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
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
                          onPressed: () {},
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
                    SizedBox(
                      height: 160, 
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 4,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 16 ,bottom: 16, left: 4),
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
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.directions_car,
                                    color: Color(0xFF4F3FF0),
                                    size: 24, // Slightly larger icon
                                  ),
                                ),
                                const Spacer(), // Use Spacer to push text to the bottom naturally
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'New Car',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    const Text(
                                      '\$5k / \$20k',
                                      style: TextStyle(
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
                                    value: 0.25,
                                    minHeight: 6,
                                    backgroundColor: Colors.grey.shade200,
                                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF4F3FF0)),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                      ),
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
                    _buildTransactionItem(
                      icon: Icons.shopping_cart,
                      color: Colors.orange,
                      title: 'Groceries',
                      subtitle: 'Today, 10:24 AM',
                      amount: '-\$45.50',
                    ),
                    const Divider(height: 24, thickness: 0.5),
                    _buildTransactionItem(
                      icon: Icons.movie,
                      color: Colors.purple,
                      title: 'Netflix Subscription',
                      subtitle: 'Yesterday, 08:00 AM',
                      amount: '-\$15.99',
                    ),
                    const Divider(height: 24, thickness: 0.5),
                    _buildTransactionItem(
                      icon: Icons.fastfood,
                      color: Colors.red,
                      title: 'Restaurant',
                      subtitle: 'Jul 21, 07:30 PM',
                      amount: '-\$32.00',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 100), // Extra padding for FloatingActionButton
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
}

