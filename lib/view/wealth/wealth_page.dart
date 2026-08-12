import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fincontrol/bloc/asset/asset_bloc.dart';
import 'package:fincontrol/bloc/asset/asset_state.dart';
import '../widgets/glass_container.dart';
import 'add_entry_sheet.dart';
import 'invest_page.dart';

class WealthPage extends StatefulWidget {
  const WealthPage({super.key});

  @override
  State<WealthPage> createState() => _WealthPageState();
}

class _WealthPageState extends State<WealthPage> {
  // Mock data for Financial Goals
  final List<Map<String, dynamic>> _mockGoals = [
    {
      'title': 'Emergency Fund',
      'icon': Icons.security,
      'color': Colors.blueAccent,
      'current': 5000.0,
      'target': 10000.0,
    },
    {
      'title': 'House Down Payment',
      'icon': Icons.home,
      'color': Colors.greenAccent,
      'current': 15000.0,
      'target': 80000.0,
    },
    {
      'title': 'Dream Vacation',
      'icon': Icons.flight_takeoff,
      'color': Colors.purpleAccent,
      'current': 2000.0,
      'target': 5000.0,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;
    final mutedTextColor = Theme.of(context).textTheme.bodySmall?.color;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          children: [
            _buildHeader(context, textColor),
            const SizedBox(height: 32),
            _buildNetWorthOverview(context, textColor, mutedTextColor, primaryColor),
            const SizedBox(height: 32),
            _buildGoalsSection(context, textColor, mutedTextColor),
            const SizedBox(height: 32),
            _buildAssetsSection(context, textColor, mutedTextColor, primaryColor),
            const SizedBox(height: 100),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => const AddEntrySheet(),
          );
        },
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Add Asset', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Color? textColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Wealth',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w900,
            color: textColor,
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const InvestPage(),
                    ),
                  );
                },
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNetWorthOverview(BuildContext context, Color? textColor, Color? mutedTextColor, Color primaryColor) {
    return BlocBuilder<AssetBloc, AssetState>(
      builder: (context, state) {
        double totalAssets = 0;
        if (state is AssetLoaded) {
          for (var asset in state.assets) {
            totalAssets += (asset.totalQuantity * asset.currentPrice);
          }
        }

        return GlassContainer(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Net Worth',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: mutedTextColor),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.greenAccent.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.trending_up, color: Colors.green, size: 16),
                        SizedBox(width: 4),
                        Text(
                          '+5.2%',
                          style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '\$${totalAssets.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w900,
                  color: textColor,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Assets', style: TextStyle(color: mutedTextColor, fontSize: 13)),
                        const SizedBox(height: 4),
                        Text('\$${totalAssets.toStringAsFixed(2)}', style: TextStyle(color: Colors.greenAccent.shade400, fontWeight: FontWeight.bold, fontSize: 18)),
                      ],
                    ),
                  ),
                  Container(width: 1, height: 30, color: mutedTextColor?.withValues(alpha: 0.3)),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Liabilities', style: TextStyle(color: mutedTextColor, fontSize: 13)),
                        const SizedBox(height: 4),
                        Text('\$0.00', style: TextStyle(color: Colors.redAccent.shade400, fontWeight: FontWeight.bold, fontSize: 18)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGoalsSection(BuildContext context, Color? textColor, Color? mutedTextColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Financial Goals',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: textColor,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                'Add Goal',
                style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 180,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _mockGoals.length,
            separatorBuilder: (context, index) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final goal = _mockGoals[index];
              final double progress = goal['current'] / goal['target'];
              return _buildGoalCard(context, goal, progress, textColor, mutedTextColor);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildGoalCard(BuildContext context, Map<String, dynamic> goal, double progress, Color? textColor, Color? mutedTextColor) {
    return SizedBox(
      width: 240,
      child: GlassContainer(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: goal['color'].withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(goal['icon'], color: goal['color'], size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    goal['title'],
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: textColor),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$${goal['current'].toStringAsFixed(0)}',
                      style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: textColor),
                    ),
                    Text(
                      '\$${goal['target'].toStringAsFixed(0)}',
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: mutedTextColor),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    backgroundColor: mutedTextColor?.withValues(alpha: 0.2),
                    valueColor: AlwaysStoppedAnimation<Color>(goal['color']),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${(progress * 100).toStringAsFixed(1)}% Completed',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: goal['color']),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAssetsSection(BuildContext context, Color? textColor, Color? mutedTextColor, Color primaryColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Asset Portfolio',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: textColor,
          ),
        ),
        const SizedBox(height: 16),
        BlocBuilder<AssetBloc, AssetState>(
          builder: (context, state) {
            if (state is AssetLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is AssetLoaded) {
              if (state.assets.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: Text(
                      'No assets added yet.',
                      style: TextStyle(color: mutedTextColor, fontSize: 16),
                    ),
                  ),
                );
              }
              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: state.assets.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final asset = state.assets[index];
                  return GlassContainer(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: primaryColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(Icons.account_balance_wallet, color: primaryColor),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                asset.tickerSymbol.isNotEmpty ? asset.tickerSymbol : 'Asset',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: textColor,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${asset.totalQuantity} Shares/Units',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: mutedTextColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '\$${(asset.totalQuantity * asset.currentPrice).toStringAsFixed(2)}',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                            color: textColor,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }
            return const SizedBox();
          },
        ),
      ],
    );
  }
}
