import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fincontrol/features/wealth/bloc/asset_bloc.dart';
import 'package:fincontrol/features/wealth/bloc/asset_state.dart';
import 'package:fincontrol/features/wealth/bloc/portfolio_bloc.dart';
import 'package:fincontrol/features/wealth/bloc/portfolio_event.dart';
import 'package:fincontrol/features/wealth/bloc/portfolio_state.dart';
import 'package:fincontrol/features/wealth/presentation/pages/create_new_portfolio.dart';
import 'package:fincontrol/features/settings/bloc/currency_cubit.dart';
import 'package:fincontrol/core/utils/currency_formatter.dart';
import 'package:fincontrol/l10n/app_localizations.dart';
import 'package:fincontrol/core/widgets/glass_container.dart';
import 'package:fincontrol/features/wealth/presentation/pages/invest_page.dart';
import 'package:fincontrol/features/wealth/presentation/pages/created_portfolio.dart';

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
        child: BlocBuilder<CurrencyCubit, CurrencyState>(
          builder: (context, currencyState) {
            return ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              children: [
                _buildHeader(context, textColor),
                const SizedBox(height: 32),
                _buildNetWorthOverview(context, textColor, mutedTextColor, primaryColor, currencyState),
                const SizedBox(height: 32),
                _buildGoalsSection(context, textColor, mutedTextColor, currencyState),
                const SizedBox(height: 32),
                _buildAssetsSection(context, textColor, mutedTextColor, primaryColor, currencyState),
                const SizedBox(height: 100),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Color? textColor) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final glassColor = isDarkMode 
        ? const Color(0x99192134) 
        : const Color(0xCCFFFFFF);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          AppLocalizations.of(context)!.wealth,
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w900,
            color: textColor,
          ),
        ),
        Row(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: Colors.white.withValues(alpha:0.1),
                  width: 1,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: glassColor,
                    ),
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
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNetWorthOverview(BuildContext context, Color? textColor, Color? mutedTextColor, Color primaryColor, CurrencyState currencyState) {
    return BlocBuilder<AssetBloc, AssetState>(
      builder: (context, state) {
        double totalAssets = 0;
        double totalCost = 0;
        if (state is AssetLoaded) {
          for (var asset in state.assets) {
            String baseCurrency = asset.tickerSymbol.endsWith('.BK') ? 'THB' : 'USD';
            double assetValue = CurrencyFormatter.convert(asset.totalQuantity * asset.currentPrice, currencyState, fromCurrency: baseCurrency);
            double assetCost = CurrencyFormatter.convert(asset.totalQuantity * asset.averageBuyPrice, currencyState, fromCurrency: baseCurrency);
            totalAssets += assetValue;
            totalCost += assetCost;
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
                    AppLocalizations.of(context)!.totalNetWorth,
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
                CurrencyFormatter.format(totalAssets, currencyState, fromCurrency: currencyState.selectedCurrency),
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
                        Text(AppLocalizations.of(context)!.assets, style: TextStyle(color: mutedTextColor, fontSize: 13)),
                        const SizedBox(height: 4),
                        Text(CurrencyFormatter.format(totalAssets, currencyState, fromCurrency: currencyState.selectedCurrency), style: TextStyle(color: Colors.greenAccent.shade400, fontWeight: FontWeight.bold, fontSize: 18)),
                      ],
                    ),
                  ),
                  Container(width: 1, height: 30, color: mutedTextColor?.withValues(alpha: 0.3)),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(AppLocalizations.of(context)!.liabilities, style: TextStyle(color: mutedTextColor, fontSize: 13)),
                        const SizedBox(height: 4),
                        Text(AppLocalizations.of(context)!.notAvailable, style: TextStyle(color: mutedTextColor, fontWeight: FontWeight.bold, fontSize: 18)),
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

  Widget _buildGoalsSection(BuildContext context, Color? textColor, Color? mutedTextColor, CurrencyState currencyState) {
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
                  AppLocalizations.of(context)!.financialGoals,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: textColor),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const CreatePortfolioPage()));
                  },
                  child: Text(
                    AppLocalizations.of(context)!.addGoal,
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
                  child: Text(AppLocalizations.of(context)!.noGoalsYet, style: TextStyle(color: mutedTextColor)),
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
                               String baseCurrency = asset.tickerSymbol.endsWith('.BK') ? 'THB' : 'USD';
                               double assetValue = CurrencyFormatter.convert(asset.totalQuantity * asset.currentPrice, currencyState, fromCurrency: baseCurrency);
                               currentAmount += assetValue;
                             }
                           }
                        }
                        
                        double target = goal.targetGoal ?? 1.0;
                        if (target == 0) target = 1.0;
                        // Assuming target goal is entered in USD for this demo logic (since the app didn't have currency selector before)
                        double convertedTarget = CurrencyFormatter.convert(target, currencyState, fromCurrency: 'USD');
                        double progress = (currentAmount / convertedTarget).clamp(0.0, 1.0);
                        
                        return _buildGoalCard(context, goal, currentAmount, convertedTarget, progress, textColor, mutedTextColor, currencyState);
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

  Widget _buildGoalCard(BuildContext context, dynamic goal, double currentAmount, double targetAmount, double progress, Color? textColor, Color? mutedTextColor, CurrencyState currencyState) {
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
        onLongPress: () {
          _showGoalOptions(context, goal);
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
                      CurrencyFormatter.format(currentAmount, currencyState, decimals: 0, fromCurrency: currencyState.selectedCurrency), // Already converted
                      style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: textColor),
                    ),
                    Text(
                      CurrencyFormatter.format(targetAmount, currencyState, decimals: 0, fromCurrency: currencyState.selectedCurrency),
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
                  AppLocalizations.of(context)!.percentCompleted((progress * 100).toStringAsFixed(1)),
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color),
                ),
              ],
            ),
          ],
        ),
      ),
    ));
  }

  Widget _buildAssetsSection(BuildContext context, Color? textColor, Color? mutedTextColor, Color primaryColor, CurrencyState currencyState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.assetPortfolio,
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
                      AppLocalizations.of(context)!.noAssetsAddedYet,
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
                          width: 48,
                          height: 48,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: primaryColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Image.asset(
                            'assets/icons/${asset.tickerSymbol}.png',
                            width: 24,
                            height: 24,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(Icons.account_balance_wallet, color: primaryColor, size: 24);
                            },
                          ),
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
                                AppLocalizations.of(context)!.sharesUnits(asset.totalQuantity.toString()),
                                style: TextStyle(
                                  fontSize: 13,
                                  color: mutedTextColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          CurrencyFormatter.format(
                            asset.totalQuantity * asset.currentPrice,
                            currencyState,
                            fromCurrency: asset.tickerSymbol.endsWith('.BK') ? 'THB' : 'USD'
                          ),
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

  void _showGoalOptions(BuildContext context, dynamic goal) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => GlassContainer(
        padding: const EdgeInsets.all(24),
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 24),
            ListTile(
              leading: const Icon(Icons.edit, color: Colors.blue),
              title: Text('Update Goal', style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color, fontWeight: FontWeight.bold)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => CreatePortfolioPage(existingPortfolio: goal)));
              },
            ),
            const Divider(color: Colors.white24),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: Text('Delete Goal', style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color, fontWeight: FontWeight.bold)),
              onTap: () {
                Navigator.pop(context);
                _showDeleteConfirmation(context, goal);
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, dynamic goal) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E2C),
        title: const Text('Delete Goal', style: TextStyle(color: Colors.white)),
        content: const Text('Are you sure you want to delete this goal? Assets will remain orphaned.', style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
          ),
          TextButton(
            onPressed: () {
              context.read<PortfolioBloc>().add(DeletePortfolio(goal.id));
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}