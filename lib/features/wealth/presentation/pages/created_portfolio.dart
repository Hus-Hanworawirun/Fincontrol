import 'package:fincontrol/features/wealth/presentation/pages/invest_page.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:fincontrol/core/widgets/glass_container.dart';

import 'package:fincontrol/features/wealth/data/models/portfolio_model.dart';
import 'package:fincontrol/features/wealth/data/models/asset_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fincontrol/features/wealth/bloc/asset_bloc.dart';
import 'package:fincontrol/features/wealth/bloc/asset_event.dart';
import 'package:fincontrol/features/wealth/bloc/asset_state.dart';
import 'package:fincontrol/features/wealth/data/repositories/asset_repository.dart';
import 'package:fincontrol/features/wealth/presentation/widgets/add_entry_sheet.dart';

class CreatedPortfolio extends StatefulWidget {
  final PortfolioModel? portfolio;
  final double? currentAmount;

  const CreatedPortfolio({
    super.key,
    this.portfolio,
    this.currentAmount,
  });

  @override
  State<CreatedPortfolio> createState() => _CreatedPortfolioState();
}

class _CreatedPortfolioState extends State<CreatedPortfolio> {

  @override
  void initState() {
    super.initState();
    context.read<AssetBloc>().add(LoadAssets(widget.portfolio?.id));
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;
    final mutedTextColor = Theme.of(context).textTheme.bodySmall?.color ?? Colors.grey;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return BlocBuilder<AssetBloc, AssetState>(
      builder: (context, state) {
        List<AssetModel> assets = [];
        double totalBalance = 0.0;
        double totalInvested = 0.0;
        
        if (state is AssetLoaded) {
          assets = state.assets;
          for (var asset in assets) {
            totalBalance += asset.currentPrice * asset.totalQuantity;
            totalInvested += asset.averageBuyPrice * asset.totalQuantity;
          }
        } else {
          totalBalance = widget.currentAmount ?? 0.0;
        }

        final double totalReturn = totalBalance - totalInvested;
        final double returnPercentage = totalInvested > 0 ? (totalReturn / totalInvested) * 100 : 0.0;
        final bool isPositive = totalReturn >= 0;
        final Color returnColor = isPositive ? Colors.greenAccent.shade400 : Colors.redAccent.shade400;

        final double? targetGoal = widget.portfolio?.targetGoal;
        final bool hasGoal = targetGoal != null && targetGoal > 0;
        final double goalProgress = hasGoal
            ? (totalBalance / targetGoal).clamp(0.0, 1.0)
            : 0.0;

        final List<Color> sectionColors = const [
          Colors.blueAccent,
          Colors.orangeAccent,
          Colors.purpleAccent,
          Colors.greenAccent,
          Colors.redAccent,
          Colors.tealAccent,
        ];

        List<PieChartSectionData> pieChartSections = [];
        if (assets.isNotEmpty && totalBalance > 0) {
          for (int i = 0; i < assets.length; i++) {
            final asset = assets[i];
            final double assetValue = asset.currentPrice * asset.totalQuantity;
            final double percentage = (assetValue / totalBalance) * 100;
            pieChartSections.add(
              PieChartSectionData(
                color: sectionColors[i % sectionColors.length],
                value: percentage,
                title: percentage > 5 ? '${percentage.toStringAsFixed(0)}%' : '',
                radius: 40,
                titleStyle: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            );
          }
        }

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
            widget.portfolio?.name ?? 'My Portfolio',
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
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
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
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
                            '\$${totalBalance.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: textColor,
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -1,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: (assets.isEmpty ? primaryColor : returnColor).withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      assets.isEmpty
                                          ? Icons.info_outline
                                          : (isPositive ? Icons.arrow_upward : Icons.arrow_downward),
                                      size: 14,
                                      color: assets.isEmpty ? primaryColor : returnColor,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      assets.isNotEmpty
                                          ? '${isPositive ? '+' : '-'}\$${totalReturn.abs().toStringAsFixed(2)} (${returnPercentage.abs().toStringAsFixed(1)}%)'
                                          : (hasGoal
                                              ? '${(goalProgress * 100).toStringAsFixed(0)}% of Target'
                                              : 'No assets yet'),
                                      style: TextStyle(
                                        color: assets.isEmpty ? primaryColor : returnColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (assets.isNotEmpty) ...[
                                const SizedBox(width: 8),
                                Text(
                                  'Total Return',
                                  style: TextStyle(
                                    color: mutedTextColor,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ],
                          ),
                          if (hasGoal) ...[
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Target: \$${targetGoal.toStringAsFixed(0)}',
                                  style: TextStyle(
                                    color: mutedTextColor,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  '${(goalProgress * 100).toStringAsFixed(1)}%',
                                  style: TextStyle(
                                    color: primaryColor,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: LinearProgressIndicator(
                                value: goalProgress,
                                minHeight: 6,
                                backgroundColor: isDarkMode ? Colors.white10 : Colors.black.withValues(alpha: 0.06),
                                valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (assets.isNotEmpty && totalBalance > 0)
                      SizedBox(
                        width: 100,
                        height: 100,
                        child: PieChart(
                          PieChartData(
                            sections: pieChartSections,
                            centerSpaceRadius: 16,
                            sectionsSpace: 2,
                            borderData: FlBorderData(show: false),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'My Investments',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (assets.isNotEmpty)
                    TextButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => InvestPage(portfolioId: widget.portfolio?.id),
                          ),
                        );
                      },
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('Add Asset'),
                      style: TextButton.styleFrom(
                        foregroundColor: primaryColor,
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: assets.isEmpty
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
                                      builder: (context) => InvestPage(portfolioId: widget.portfolio?.id),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Add Asset',
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
                        itemCount: assets.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final asset = assets[index];
                          IconData iconData = Icons.account_balance_wallet;
                          if (asset.category == 'Stock') iconData = Icons.trending_up;
                          if (asset.category == 'Crypto') iconData = Icons.currency_bitcoin;

                          final bool isCrypto = asset.category == 'Crypto';
                          
                          // Calculate profit/loss for this individual asset
                          final double assetInvested = asset.averageBuyPrice * asset.totalQuantity;
                          final double assetCurrentValue = asset.currentPrice * asset.totalQuantity;
                          final double assetProfit = assetCurrentValue - assetInvested;
                          final double assetReturnPct = assetInvested > 0 ? (assetProfit / assetInvested) * 100 : 0.0;
                          final bool assetIsPositive = assetProfit >= 0;
                          final Color assetReturnColor = assetIsPositive ? Colors.greenAccent.shade400 : Colors.redAccent.shade400;

                          return Dismissible(
                            key: Key(asset.id),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.circular(20)),
                              child: const Icon(Icons.delete, color: Colors.white),
                            ),
                            onDismissed: (direction) {
                              context.read<AssetBloc>().add(DeleteAsset(asset.id));
                            },
                            child: GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  builder: (context) => AddEntrySheet(asset: asset, portfolioId: widget.portfolio?.id),
                                );
                              },
                              child: GlassContainer(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: isDarkMode ? Colors.white.withValues(alpha: 0.1) : primaryColor.withValues(alpha: 0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Image.asset(
                                        'assets/icons/${asset.tickerSymbol}.png',
                                        width: 24,
                                        height: 24,
                                        errorBuilder: (context, error, stackTrace) =>
                                            Center(
                                              child: Text(
                                                asset.tickerSymbol.isNotEmpty ? asset.tickerSymbol.substring(0, 1) : '?',
                                                style: TextStyle(
                                                  color: primaryColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            asset.name,
                                            style: TextStyle(
                                              color: textColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              Container(
                                                width: 8,
                                                height: 8,
                                                decoration: BoxDecoration(
                                                  color: sectionColors[index % sectionColors.length],
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                              const SizedBox(width: 6),
                                              Text(
                                                '${asset.tickerSymbol} • ${totalBalance > 0 ? ((assetCurrentValue / totalBalance) * 100).toStringAsFixed(1) : 0}%',
                                                style: TextStyle(
                                                  color: mutedTextColor,
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          '\$${assetCurrentValue.toStringAsFixed(2)}',
                                          style: TextStyle(
                                            color: textColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          'Qty: ${isCrypto ? asset.totalQuantity.toStringAsFixed(6) : asset.totalQuantity.toStringAsFixed(2)}',
                                          style: TextStyle(
                                            color: mutedTextColor,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          '${assetIsPositive ? '+' : '-'}\$${assetProfit.abs().toStringAsFixed(2)} (${assetReturnPct.abs().toStringAsFixed(2)}%)',
                                          style: TextStyle(
                                            color: assetReturnColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
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
    );
      },
    );
  }
}