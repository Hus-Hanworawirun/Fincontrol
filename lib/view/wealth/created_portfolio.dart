import 'package:fincontrol/view/wealth/invest_page.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../widgets/glass_container.dart';

class CreatedPortfolio extends StatefulWidget {
  const CreatedPortfolio({super.key});

  @override
  State<CreatedPortfolio> createState() => _CreatedPortfolioState();
}

class _CreatedPortfolioState extends State<CreatedPortfolio> {
  // Use this list to control the UI state
  // Empty list shows the 'Invest Now' state
  // Populated list shows the investment cards
  final List<Map<String, dynamic>> _assets = [
    {
      'name': 'Apple Inc.',
      'ticker': 'AAPL',
      'value': 4520.50,
      'change': 1.2,
      'isUp': true,
      'icon': Icons.apple,
      'color': Colors.grey.shade800,
    },
    {
      'name': 'Bitcoin',
      'ticker': 'BTC',
      'value': 12050.00,
      'change': 4.5,
      'isUp': true,
      'icon': Icons.currency_bitcoin,
      'color': Colors.orange,
    },
    {
      'name': 'S&P 500 ETF',
      'ticker': 'VOO',
      'value': 8340.25,
      'change': 0.8,
      'isUp': false,
      'icon': Icons.trending_up,
      'color': Colors.blue,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;
    final mutedTextColor = Theme.of(context).textTheme.bodySmall?.color ?? Colors.grey;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Container(
      decoration: BoxDecoration(
        gradient: isDarkMode 
          ? const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF0F172A), Color(0xFF1E1B4B)],
            )
          : const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFF8FAFC), Color(0xFFE0E7FF)],
            ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: textColor),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'My Growth Portfolio',
            style: TextStyle(
              color: textColor,
              fontWeight: 
              FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Summary Card
              GlassContainer(
                height: 220,
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                child: Stack(
                  children: [
                    // Background chart
                    Positioned.fill(
                      top: 60,
                      child: Opacity(
                        opacity: 0.4,
                        child: LineChart(
                          LineChartData(
                            gridData: const FlGridData(show: false),
                            titlesData: const FlTitlesData(show: false),
                            borderData: FlBorderData(show: false),
                            lineBarsData: [
                              LineChartBarData(
                                spots: const [
                                  FlSpot(0, 3),
                                  FlSpot(1, 4),
                                  FlSpot(2, 3.5),
                                  FlSpot(3, 5),
                                  FlSpot(4, 4.5),
                                  FlSpot(5, 7),
                                ],
                                isCurved: true,
                                color: Colors.greenAccent.shade400,
                                barWidth: 3,
                                isStrokeCapRound: true,
                                dotData: const FlDotData(show: false),
                                belowBarData: BarAreaData(
                                  show: true,
                                  color: Colors.greenAccent.shade400.withValues(alpha: 0.15),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Content
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Balance',
                          style: TextStyle(
                            color: mutedTextColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '\$24,910.75',
                          style: TextStyle(
                            color: textColor,
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -1,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.greenAccent.shade400.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.arrow_upward, size: 14, color: Colors.greenAccent.shade400),
                                  const SizedBox(width: 4),
                                  Text(
                                    '\$430.50 (1.7%)',
                                    style: TextStyle(
                                      color: Colors.greenAccent.shade400,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Today',
                              style: TextStyle(
                                color: mutedTextColor,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'My Investments',
                style: TextStyle(
                  color: textColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: _assets.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'This portfolio is currently empty',
                              style: TextStyle(
                                color: textColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: 180,
                              height: 48,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryColor,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const InvestPage(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Invest Now',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.separated(
                        itemCount: _assets.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final asset = _assets[index];
                          final isUp = asset['isUp'] as bool;
                          final returnColor = isUp ? Colors.greenAccent.shade400 : Colors.redAccent.shade400;

                          return GlassContainer(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: asset['color'].withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(asset['icon'], color: asset['color']),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        asset['name'],
                                        style: TextStyle(
                                          color: textColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        asset['ticker'],
                                        style: TextStyle(
                                          color: mutedTextColor,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '\$${asset['value'].toStringAsFixed(2)}',
                                      style: TextStyle(
                                        color: textColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          isUp ? Icons.trending_up : Icons.trending_down,
                                          size: 14,
                                          color: returnColor,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${isUp ? '+' : '-'}${asset['change']}%',
                                          style: TextStyle(
                                            color: returnColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}