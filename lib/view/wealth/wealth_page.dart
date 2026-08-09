import 'dart:ui';
import 'package:fincontrol/view/wealth/create_new_portfolio.dart';
import 'package:fincontrol/view/wealth/invest_page.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fincontrol/bloc/asset/asset_bloc.dart';
import 'package:fincontrol/bloc/asset/asset_state.dart';
import 'package:fincontrol/bloc/portfolio/portfolio_bloc.dart';
import 'package:fincontrol/bloc/portfolio/portfolio_state.dart';

class WealthPage extends StatefulWidget {
  const WealthPage({super.key});

  @override
  State<WealthPage> createState() => _WealthPageState();
}

class _WealthPageState extends State<WealthPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
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
            _buildHeader(context),
            const SizedBox(height: 32),
            _buildInvestmentBalanceCard(),
            const SizedBox(height: 24),
             _buildMyGoals(),
            const SizedBox(height: 24),
            _buildNetWorthChart(),
            const SizedBox(height: 24),
            _buildAssetAllocation(),
            const SizedBox(height: 24),
            _buildMarketOverview(),
            const SizedBox(height: 24),
            _buildCurrentHoldings(),
            const SizedBox(height: 100),
          ],
        ),
      ],
    ));
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
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
    );
  }

  Widget _buildInvestmentBalanceCard() {
    return BlocBuilder<AssetBloc, AssetState>(
      builder: (context, state) {
        double totalValue = 0;
        if (state is AssetLoaded) {
          for (var asset in state.assets) {
            totalValue += (asset.currentPrice * asset.totalQuantity);
          }
        }

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
                      'Total Investment Value',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '\$${totalValue.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 36,
                        color: Colors.black,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.green.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: const [
                              Icon(Icons.trending_up, color: Colors.green, size: 20),
                              SizedBox(width: 4),
                              Text(
                                '+\$0.00 (0.0%)', // Real profit requires historical data tracking
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'All time',
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }
    );
  }

  Widget _buildNetWorthChart() {
    return Material(
      color: Colors.white,
      elevation: 9,
      shadowColor: Colors.black.withValues(alpha: 0.2),
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Net Worth Growth',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const style = TextStyle(color: Colors.grey, fontSize: 12);
                          String text;
                          switch (value.toInt()) {
                            case 0:
                              text = 'Jan';
                              break;
                            case 3:
                              text = 'Apr';
                              break;
                            case 6:
                              text = 'Jul';
                              break;
                            case 9:
                              text = 'Oct';
                              break;
                            case 11:
                              text = 'Dec';
                              break;
                            default:
                              text = '';
                          }
                          return SideTitleWidget(
                            meta: meta,
                            space: 8,
                            child: Text(text, style: style),
                          );
                        },
                        reservedSize: 30,
                        interval: 1,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '\$${value.toInt()}k',
                            style: const TextStyle(color: Colors.grey, fontSize: 12),
                          );
                        },
                        reservedSize: 40,
                        interval: 10,
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  minX: 0,
                  maxX: 11,
                  minY: 20,
                  maxY: 60,
                  lineBarsData: [
                    LineChartBarData(
                      spots: const [
                        FlSpot(0, 25),
                        FlSpot(2, 28),
                        FlSpot(4, 35),
                        FlSpot(6, 32),
                        FlSpot(8, 40),
                        FlSpot(10, 43),
                        FlSpot(11, 45.2),
                      ],
                      isCurved: true,
                      color: const Color(0xFF4F3FF0),
                      barWidth: 4,
                      isStrokeCapRound: true,
                      dotData: FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: const Color(0xFF4F3FF0).withValues(alpha: 0.1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAssetAllocation() {
    return BlocBuilder<AssetBloc, AssetState>(
      builder: (context, state) {
        double stockValue = 0;
        double cryptoValue = 0;
        double cashValue = 0;
        
        if (state is AssetLoaded) {
          for (var asset in state.assets) {
            final value = asset.totalQuantity * asset.currentPrice;
            if (asset.category == 'Stocks' || asset.category == 'Stock') {
              stockValue += value;
            } else if (asset.category == 'Crypto' || asset.category == 'Cryptocurrency') {
              cryptoValue += value;
            } else {
              cashValue += value;
            }
          }
        }

        final total = stockValue + cryptoValue + cashValue;
        final hasAssets = total > 0;

        final double stockPct = hasAssets ? (stockValue / total * 100) : 0.0;
        final double cryptoPct = hasAssets ? (cryptoValue / total * 100) : 0.0;
        final double cashPct = hasAssets ? (cashValue / total * 100) : 0.0;

        return Material(
          color: Colors.white,
          elevation: 9,
          shadowColor: Colors.black.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Asset Allocation',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 24),
                if (!hasAssets)
                   const Center(child: Text('No assets to allocate', style: TextStyle(color: Colors.grey)))
                else Row(
                  children: [
                    SizedBox(
                      width: 120,
                      height: 120,
                      child: PieChart(
                        PieChartData(
                          sectionsSpace: 2,
                          centerSpaceRadius: 30,
                          sections: [
                            if (stockPct > 0) PieChartSectionData(
                              color: const Color(0xFF4F3FF0),
                              value: stockPct,
                              title: '${stockPct.toStringAsFixed(0)}%',
                              radius: 20,
                              titleStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                            if (cryptoPct > 0) PieChartSectionData(
                              color: Colors.orange,
                              value: cryptoPct,
                              title: '${cryptoPct.toStringAsFixed(0)}%',
                              radius: 20,
                              titleStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                            if (cashPct > 0) PieChartSectionData(
                              color: Colors.green,
                              value: cashPct,
                              title: '${cashPct.toStringAsFixed(0)}%',
                              radius: 20,
                              titleStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (stockPct > 0) ...[
                             _buildAllocationLegend(const Color(0xFF4F3FF0), 'Stocks', '\$${stockValue.toStringAsFixed(2)}'),
                             const SizedBox(height: 12),
                          ],
                          if (cryptoPct > 0) ...[
                             _buildAllocationLegend(Colors.orange, 'Crypto', '\$${cryptoValue.toStringAsFixed(2)}'),
                             const SizedBox(height: 12),
                          ],
                          if (cashPct > 0) ...[
                             _buildAllocationLegend(Colors.green, 'Cash', '\$${cashValue.toStringAsFixed(2)}'),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }
    );
  }

  Widget _buildAllocationLegend(Color color, String label, String amount) {
    return Row(
      children: [
        Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 8),
        Expanded(child: Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black54))),
        Text(amount, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black)),
      ],
    );
  }

  Widget _buildMyGoals() {
    return Material(
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
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CreatePortfolioPage(),
                      ),
                    );
                  }, 
                  icon: const Icon(Icons.add_rounded),
                )
              ],
            ),
            const SizedBox(height: 16),
            BlocBuilder<PortfolioBloc, PortfolioState>(
              builder: (context, state) {
                if (state is PortfolioLoading) {
                  return const SizedBox(height: 160, child: Center(child: CircularProgressIndicator()));
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
    );
  }

  Widget _buildMarketOverview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Market Overview',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 120,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildMarketCard('S&P 500', '4,500.20', '+1.2%', true),
              const SizedBox(width: 16),
              _buildMarketCard('Gold (oz)', '1,950.00', '-0.5%', false),
              const SizedBox(width: 16),
              _buildMarketCard('Bitcoin', '42,150.00', '+5.6%', true),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMarketCard(String name, String price, String change, bool isPositive) {
    return Material(
      color: Colors.white,
      elevation: 9,
      shadowColor: Colors.black.withValues(alpha: 0.15),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 140,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              name,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black54),
            ),
            const SizedBox(height: 8),
            Text(
              price,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  isPositive ? Icons.trending_up : Icons.trending_down,
                  color: isPositive ? Colors.green : Colors.red,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  change,
                  style: TextStyle(
                    color: isPositive ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentHoldings() {
    return Material(
      color: Colors.white,
      elevation: 9,
      shadowColor: Colors.black.withValues(alpha: 0.2),
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
                  'Current Holdings',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('See all', style: TextStyle(color: Color(0xFF4F3FF0), fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            BlocBuilder<AssetBloc, AssetState>(
              builder: (context, state) {
                if (state is AssetLoading) {
                   return const Center(child: CircularProgressIndicator());
                }
                if (state is AssetLoaded) {
                   if (state.assets.isEmpty) {
                      return Padding(
                         padding: const EdgeInsets.symmetric(vertical: 32),
                         child: Center(
                            child: Column(
                              children: [
                                Icon(Icons.account_balance_wallet, color: Colors.grey.shade300, size: 48),
                                const SizedBox(height: 16),
                                Text('No holdings yet', style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.bold, fontSize: 16)),
                                const SizedBox(height: 4),
                                Text('Create a goal and add assets', style: TextStyle(color: Colors.grey.shade400, fontSize: 14)),
                              ],
                            ),
                         ),
                      );
                   }
                   return Column(
                      children: state.assets.map((asset) {
                         final isCrypto = asset.category == 'Crypto' || asset.category == 'Cryptocurrency';
                         return Column(
                            children: [
                               _buildHoldingItem(
                                  icon: isCrypto ? Icons.currency_bitcoin : Icons.business,
                                  color: isCrypto ? Colors.orange : Colors.blueAccent,
                                  ticker: asset.tickerSymbol,
                                  name: asset.name,
                                  shares: asset.totalQuantity.toStringAsFixed(2),
                                  price: '\$${(asset.totalQuantity * asset.currentPrice).toStringAsFixed(2)}',
                                  change: '${asset.currentPrice > 0 ? '+' : ''}0.0%', // Need historical for real change
                               ),
                               if (asset != state.assets.last) const Divider(height: 24, thickness: 0.5),
                            ],
                         );
                      }).toList(),
                   );
                }
                return const SizedBox();
              }
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHoldingItem({
    required IconData icon,
    required Color color,
    required String ticker,
    required String name,
    required String shares,
    required String price,
    required String change,
  }) {
    final isPositive = change.startsWith('+');
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
              Text(ticker, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
              const SizedBox(height: 4),
              Text('$name • $shares shares', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.grey)),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(price, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
            const SizedBox(height: 4),
            Text(
              change,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: isPositive ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
