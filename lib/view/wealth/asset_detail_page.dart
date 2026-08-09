import 'package:fincontrol/view/wealth/add_entry_sheet.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../data/models/asset_model.dart';
import '../../data/repositories/market_api_repository.dart';

class AssetDetailPage extends StatefulWidget {
  final AssetModel asset;

  const AssetDetailPage({super.key, required this.asset});

  @override
  State<AssetDetailPage> createState() => _AssetDetailPageState();
}

class _AssetDetailPageState extends State<AssetDetailPage> {
  final MarketApiRepository _apiRepository = MarketApiRepository();
  String _selectedTimeframe = '1D';
  Future<List<double>>? _chartDataFuture;
  
  double? _fetchedPrice;
  double? _fetchedChangeValue;
  double? _fetchedChangePercent;

  @override
  void initState() {
    super.initState();
    _fetchChartData(_selectedTimeframe);
  }

  void _fetchChartData(String timeframe) {
    String range = '1d';
    String interval = '15m';

    switch (timeframe) {
      case '1W':
        range = '5d';
        interval = '1h';
        break;
      case '1M':
        range = '1mo';
        interval = '1d';
        break;
      case '6M':
        range = '6mo';
        interval = '1d';
        break;
      case 'YTD':
        range = 'ytd';
        interval = '1d';
        break;
      case '1Y':
        range = '1y';
        interval = '1d';
        break;
      case '1D':
      default:
        range = '1d';
        interval = '15m';
        break;
    }

    final future = _apiRepository.getChartData(widget.asset.tickerSymbol, interval: interval, range: range);

    future.then((data) {
      if (data.isNotEmpty && mounted) {
        final current = data.last;
        final first = data.first;
        final change = current - first;
        final percent = first > 0 ? (change / first) * 100 : 0.0;
        
        setState(() {
          _fetchedPrice = current;
          _fetchedChangeValue = change;
          _fetchedChangePercent = percent;
        });
      }
    });

    setState(() {
      _selectedTimeframe = timeframe;
      _chartDataFuture = future;
    });
  }

  Widget _buildChart(List<double> data, bool isPositive) {
    if (data.isEmpty) {
      return Icon(Icons.show_chart, size: 100, color: isPositive ? Colors.green : Colors.red);
    }
    
    final spots = data.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value)).toList();
    
    final minY = data.reduce((a, b) => a < b ? a : b);
    final maxY = data.reduce((a, b) => a > b ? a : b);
    final color = isPositive ? Colors.green : Colors.red;

    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: (data.length - 1).toDouble(),
        minY: minY * 0.99,
        maxY: maxY * 1.01,
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: color,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: color.withValues(alpha: 0.1),
            ),
          ),
        ],
        lineTouchData: const LineTouchData(enabled: false),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final asset = widget.asset;
    final double displayPrice = _fetchedPrice ?? asset.currentPrice;
    final double changeValue = _fetchedChangeValue ?? (asset.currentPrice - asset.averageBuyPrice);
    final double changePercent = _fetchedChangePercent ?? (asset.averageBuyPrice > 0 ? (changeValue / asset.averageBuyPrice) * 100 : 0.0);
    final isPositive = changeValue >= 0;
    
    return Scaffold(
      backgroundColor: const Color(0xFFF4F2F8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          'assets/icons/${asset.tickerSymbol}.png',
                          width: 40,
                          height: 40,
                          errorBuilder: (context, error, stackTrace) => Text(
                            asset.tickerSymbol.isNotEmpty ? asset.tickerSymbol : asset.name,
                            style: const TextStyle(
                              color: Color(0xFF4F3FF0),
                              fontWeight: FontWeight.bold,
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
                            asset.tickerSymbol.isNotEmpty ? asset.tickerSymbol : asset.name,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            asset.name,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    if (asset.category.isNotEmpty) ...[
                      _buildTag(asset.category),
                      const SizedBox(width: 8),
                    ],
                    if (asset.tickerSymbol.isNotEmpty) _buildTag(asset.tickerSymbol),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      displayPrice.toStringAsFixed(2),
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'USD',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      isPositive ? Icons.trending_up : Icons.trending_down,
                      color: isPositive ? Colors.green : Colors.red,
                      size: 20,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${isPositive ? '+' : ''}${changeValue.toStringAsFixed(2)} (${isPositive ? '+' : ''}${changePercent.toStringAsFixed(2)}%)',
                      style: TextStyle(
                        color: isPositive ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Today',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Last Updated: 14 Jul 2026, 12:40',
                  style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  height: 250,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Expanded(
                        child: FutureBuilder<List<double>>(
                          future: _chartDataFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            }
                            if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                              return Center(
                                child: Icon(Icons.show_chart, size: 100, color: isPositive ? Colors.green : Colors.red),
                              );
                            }
                            return _buildChart(snapshot.data!, isPositive);
                          },
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text('10:24', style: TextStyle(color: Colors.grey, fontSize: 12)),
                          Text('11:33', style: TextStyle(color: Colors.grey, fontSize: 12)),
                          Text('12:42', style: TextStyle(color: Colors.grey, fontSize: 12)),
                          Text('13:51', style: TextStyle(color: Colors.grey, fontSize: 12)),
                          Text('15:00', style: TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildTimeframe('1D'),
                    _buildTimeframe('1W'),
                    _buildTimeframe('1M'),
                    _buildTimeframe('6M'),
                    _buildTimeframe('YTD'),
                    _buildTimeframe('1Y'),
                  ],
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Market Status',
                          style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: const [
                            Text(
                              'Intermission1',
                              style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 4),
                            Icon(Icons.info_outline, color: Colors.grey, size: 16),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 120,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4F3FF0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) => AddEntrySheet(asset: asset),
                          );
                        },
                        child: const Text(
                          'Invest',
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
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFE2DFE7).withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildTimeframe(String text) {
    final bool isSelected = _selectedTimeframe == text;
    return GestureDetector(
      onTap: () => _fetchChartData(text),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF4F3FF0) : const Color(0xFFE2DFE7).withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
