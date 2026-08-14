import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fincontrol/bloc/asset/asset_bloc.dart';
import 'package:fincontrol/bloc/asset/asset_state.dart';
import 'package:fincontrol/bloc/portfolio/portfolio_bloc.dart';
import 'package:fincontrol/bloc/portfolio/portfolio_state.dart';
import 'package:fincontrol/view/wealth/create_new_portfolio.dart';
import '../widgets/glass_container.dart';
import 'invest_page.dart';
import 'created_portfolio.dart';

class WealthPage extends StatefulWidget {
  const WealthPage({super.key});

  @override
  State<WealthPage> createState() => _WealthPageState();
}

class _WealthPageState extends State<WealthPage> {
  // Removed _mockGoals

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
        double totalCost = 0;
        if (state is AssetLoaded) {
          for (var asset in state.assets) {
            totalAssets += (asset.totalQuantity * asset.currentPrice);
            totalCost += (asset.totalQuantity * asset.averageBuyPrice);
          }
        }
        
        double pctChange = 0.0;
        if (totalCost > 0) {
            pctChange = ((totalAssets - totalCost) / totalCost) * 100;
        }
        
        final isPositive = pctChange >= 0;
        final sign = isPositive ? '+' : '';
        final badgeColor = isPositive ? Colors.green : Colors.red;
        final badgeIcon = isPositive ? Icons.trending_up : Icons.trending_down;
        final badgeBgColor = isPositive ? Colors.greenAccent.withValues(alpha: 0.2) : Colors.redAccent.withValues(alpha: 0.2);

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
                      color: badgeBgColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(badgeIcon, color: badgeColor, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          '$sign${pctChange.toStringAsFixed(1)}%',
                          style: TextStyle(color: badgeColor, fontWeight: FontWeight.bold, fontSize: 13),
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
                        Text('N/A', style: TextStyle(color: mutedTextColor, fontWeight: FontWeight.bold, fontSize: 18)),
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
    return BlocBuilder<PortfolioBloc, PortfolioState>(
      builder: (context, state) {
        List<dynamic> goals = [];
        if (state is PortfolioLoaded) {
          goals = state.portfolios;
        }
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Financial Goals',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: textColor),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const CreatePortfolioPage()));
                  },
                  child: Text(
                    'Add Goal',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (goals.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: Text("No goals yet. Create one!", style: TextStyle(color: mutedTextColor)),
                ),
              )
            else
              SizedBox(
                height: 180,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: goals.length,
                  separatorBuilder: (context, index) => const SizedBox(width: 16),
                  itemBuilder: (context, index) {
                    final goal = goals[index];
                    return BlocBuilder<AssetBloc, AssetState>(
                      builder: (context, assetState) {
                        double currentAmount = 0.0;
                        if (assetState is AssetLoaded) {
                           for (var asset in assetState.assets) {
                             if (asset.portfolioId == goal.id) {
                               currentAmount += (asset.totalQuantity * asset.currentPrice);
                             }
                           }
                        }
                        
                        double target = goal.targetGoal ?? 1.0;
                        if (target == 0) target = 1.0;
                        double progress = (currentAmount / target).clamp(0.0, 1.0);
                        
                        return _buildGoalCard(context, goal, currentAmount, target, progress, textColor, mutedTextColor);
                      }
                    );
                  },
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildGoalCard(BuildContext context, dynamic goal, double currentAmount, double targetAmount, double progress, Color? textColor, Color? mutedTextColor) {
    final color = Theme.of(context).colorScheme.primary; 
    // ignore: non_const_argument_for_const_parameter
    final iconData = IconData(goal.icon as int, fontFamily: 'MaterialIcons');
    
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => CreatedPortfolio(
          portfolio: goal,
          currentAmount: currentAmount,
        )));
      },
      child: SizedBox(
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
                    color: color.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(iconData, color: color, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    goal.name,
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
                      '\$${currentAmount.toStringAsFixed(0)}',
                      style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: textColor),
                    ),
                    Text(
                      '\$${targetAmount.toStringAsFixed(0)}',
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
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${(progress * 100).toStringAsFixed(1)}% Completed',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color),
                ),
              ],
            ),
          ],
        ),
      ),
    ));
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
