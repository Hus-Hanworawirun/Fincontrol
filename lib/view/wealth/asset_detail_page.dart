import 'dart:ui';
import 'package:fincontrol/view/wealth/add_entry_sheet.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
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
  
  Map<String, dynamic>? _fetchedStats;

  // Colors
  static const Color _bg = Color(0xFFF4F3F9);
  static const Color _card = Color(0xFFFFFFFF);
  static const Color _ink = Color(0xFF14151F);
  static const Color _inkSoft = Color(0xFF6E7080);
  static const Color _inkFaint = Color(0xFFA6A7B5);
  static const Color _indigo = Color(0xFF4B3FE4);
  static const Color _indigoSoft = Color(0xFFEDEBFC);
  static const Color _green = Color(0xFF14944B);
  static const Color _greenSoft = Color(0xFFE4F5EA);
  static const Color _red = Color(0xFFD23A3A);
  static const Color _amber = Color(0xFFB8790E);
  static const Color _line = Color(0xFFE7E6F0);

  @override
  void initState() {
    super.initState();
    _fetchChartData(_selectedTimeframe);
    _fetchStats();
  }

  void _fetchStats() async {
    final stats = await _apiRepository.getAssetStats(widget.asset.tickerSymbol);
    if (mounted) {
      setState(() {
        _fetchedStats = stats;
      });
    }
  }

  void _fetchChartData(String timeframe) {
    String range = '1d';
    String interval = '15m';

    switch (timeframe) {
      case '1W': range = '5d'; interval = '1h'; break;
      case '1M': range = '1mo'; interval = '1d'; break;
      case '6M': range = '6mo'; interval = '1d'; break;
      case 'YTD': range = 'ytd'; interval = '1d'; break;
      case '1Y': range = '1y'; interval = '1d'; break;
      case '1D':
      default: range = '1d'; interval = '15m'; break;
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

  String _formatNumber(num? value) {
    if (value == null) return '-';
    if (value >= 1e12) return '${(value / 1e12).toStringAsFixed(2)}T';
    if (value >= 1e9) return '${(value / 1e9).toStringAsFixed(2)}B';
    if (value >= 1e6) return '${(value / 1e6).toStringAsFixed(2)}M';
    if (value >= 1e3) return '${(value / 1e3).toStringAsFixed(2)}k';
    return value.toStringAsFixed(2);
  }

  Widget _buildChart(List<double> data, bool isPositive) {
    if (data.isEmpty) {
      return Icon(Icons.show_chart, size: 100, color: isPositive ? _green : _red);
    }
    
    final spots = data.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value)).toList();
    final minY = data.reduce((a, b) => a < b ? a : b);
    final maxY = data.reduce((a, b) => a > b ? a : b);
    final color = isPositive ? _green : _red;

    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: (data.length - 1).toDouble(),
        minY: minY * 0.999,
        maxY: maxY * 1.001,
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: color,
            barWidth: 2.25,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  color.withValues(alpha: 0.22),
                  color.withValues(alpha: 0.0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
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
    final double displayPrice = _fetchedPrice ?? _fetchedStats?['regularMarketPrice']?.toDouble() ?? asset.currentPrice;
    final double changeValue = _fetchedChangeValue ?? _fetchedStats?['regularMarketChange']?.toDouble() ?? (asset.currentPrice - asset.averageBuyPrice);
    final double changePercent = _fetchedChangePercent ?? _fetchedStats?['regularMarketChangePercent']?.toDouble() ?? (asset.averageBuyPrice > 0 ? (changeValue / asset.averageBuyPrice) * 100 : 0.0);
    final bool isPositive = changeValue >= 0;
    
    final open = _fetchedStats?['regularMarketOpen'];
    final high = _fetchedStats?['regularMarketDayHigh'];
    final low = _fetchedStats?['regularMarketDayLow'];
    final prevClose = _fetchedStats?['regularMarketPreviousClose'];
    final volume = _fetchedStats?['regularMarketVolume'];
    final mktCap = _fetchedStats?['marketCap'];

    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Column(
              children: [
                _buildTopBar(context),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(left: 20, right: 20, top: 4, bottom: 128),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildIdentityRow(asset),
                        const SizedBox(height: 14),
                        _buildTagsRow(asset),
                        const SizedBox(height: 22),
                        _buildPriceBlock(displayPrice, changeValue, changePercent, isPositive),
                        const SizedBox(height: 18),
                        _buildChartCard(displayPrice, isPositive),
                        const SizedBox(height: 14),
                        _buildRangeRow(),
                        const SizedBox(height: 22),
                        _buildStatsCard(open, high, low, prevClose, volume, mktCap),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            _buildBottomBar(asset),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildIconButton(Icons.arrow_back, () => Navigator.pop(context), _card, _ink),
          Row(
            children: [
              _buildIconButton(Icons.notifications_outlined, () {}, _card, _ink),
              const SizedBox(width: 8),
              _buildIconButton(Icons.bookmark, () {}, _indigoSoft, _indigo),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback onTap, Color bgColor, Color iconColor) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: bgColor == _card ? _line : Colors.transparent),
          boxShadow: bgColor == _card ? [
            BoxShadow(color: _ink.withValues(alpha: 0.04), blurRadius: 2, offset: const Offset(0, 1)),
          ] : null,
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
    );
  }

  Widget _buildIdentityRow(AssetModel asset) {
    final exchange = _fetchedStats?['exchange'] ?? 'MARKET';
    final type = _fetchedStats?['quoteType'] ?? 'Asset';
    
    return Row(
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: _card,
            borderRadius: BorderRadius.circular(13),
            boxShadow: [
              BoxShadow(color: _ink.withValues(alpha: 0.04), blurRadius: 2, offset: const Offset(0, 1)),
              BoxShadow(color: _ink.withValues(alpha: 0.06), blurRadius: 24, offset: const Offset(0, 8)),
            ],
          ),
          alignment: Alignment.center,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(13),
            child: Image.asset(
              'assets/icons/${asset.tickerSymbol}.png',
              width: 46,
              height: 46,
              errorBuilder: (context, error, stackTrace) => Text(
                asset.tickerSymbol.isNotEmpty ? asset.tickerSymbol : asset.name,
                style: TextStyle(
                  color: _indigo,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                asset.name,
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: _ink,
                  letterSpacing: -0.01,
                ),
              ),
              const SizedBox(height: 1),
              Text(
                '$exchange · $type',
                style: TextStyle(
                  fontSize: 13,
                  color: _inkSoft,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTagsRow(AssetModel asset) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        if (asset.category.isNotEmpty) _buildTag(asset.category, false),
        if (asset.tickerSymbol.isNotEmpty) _buildTag(asset.tickerSymbol, false),
        _buildTag('Tracked Market', true),
      ],
    );
  }

  Widget _buildTag(String text, bool isMarket) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
      decoration: BoxDecoration(
        color: isMarket ? _indigoSoft : _card,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: isMarket ? Colors.transparent : _line),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11.5,
          fontWeight: FontWeight.w600,
          color: isMarket ? _indigo : _inkSoft,
        ),
      ),
    );
  }

  Widget _buildPriceBlock(double price, double changeValue, double changePercent, bool isPositive) {
    final now = DateFormat('dd MMM yyyy, HH:mm').format(DateTime.now());
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              price.toStringAsFixed(2),
              style: TextStyle(
                fontSize: 38,
                fontWeight: FontWeight.bold,
                color: _ink,
                letterSpacing: -0.02,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              _fetchedStats?['currency'] ?? 'USD',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: _inkFaint,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 7, right: 9, top: 4, bottom: 4),
              decoration: BoxDecoration(
                color: isPositive ? _greenSoft : const Color(0xFFFBE4E4),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                    color: isPositive ? _green : _red,
                    size: 12,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${isPositive ? '+' : ''}${changeValue.toStringAsFixed(2)} (${changePercent.toStringAsFixed(2)}%)',
                    style: TextStyle(
                      color: isPositive ? _green : _red,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'today',
              style: TextStyle(
                fontSize: 13,
                color: _inkFaint,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Last updated $now (delayed 15 min)',
          style: TextStyle(
            fontSize: 12,
            color: _inkFaint,
          ),
        ),
      ],
    );
  }

  Widget _buildChartCard(double displayPrice, bool isPositive) {
    return Container(
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(color: _ink.withValues(alpha: 0.04), blurRadius: 2, offset: const Offset(0, 1)),
          BoxShadow(color: _ink.withValues(alpha: 0.06), blurRadius: 24, offset: const Offset(0, 8)),
        ],
      ),
      padding: const EdgeInsets.only(top: 18, left: 6, right: 6, bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'PRICE AT',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: _inkFaint,
                    letterSpacing: 0.03,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  displayPrice.toStringAsFixed(2),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isPositive ? _green : _red,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  'Now · 15:00', // Simplified for demo
                  style: TextStyle(
                    fontSize: 11.5,
                    color: _inkSoft,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 150,
            width: double.infinity,
            child: FutureBuilder<List<double>>(
              future: _chartDataFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Icon(Icons.show_chart, size: 60, color: isPositive ? _green : _red),
                  );
                }
                return _buildChart(snapshot.data!, isPositive);
              },
            ),
          ),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildAxisText('10:24', false),
                _buildAxisText('11:33', false),
                _buildAxisText('12:42', false),
                _buildAxisText('13:51', false),
                _buildAxisText('15:00', true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAxisText(String text, bool isNow) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 11,
        fontWeight: isNow ? FontWeight.w700 : FontWeight.w500,
        color: isNow ? _indigo : _inkFaint,
      ),
    );
  }

  Widget _buildRangeRow() {
    return Row(
      children: [
        _buildRangePill('1D'),
        _buildRangePill('1W'),
        _buildRangePill('1M'),
        _buildRangePill('6M'),
        _buildRangePill('YTD'),
        _buildRangePill('1Y'),
      ],
    );
  }

  Widget _buildRangePill(String text) {
    final bool isActive = _selectedTimeframe == text;
    return Expanded(
      child: GestureDetector(
        onTap: () => _fetchChartData(text),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 9),
          decoration: BoxDecoration(
            color: isActive ? _indigo : Colors.transparent,
            borderRadius: BorderRadius.circular(11),
            boxShadow: isActive ? [
              BoxShadow(color: _indigo.withValues(alpha: 0.28), blurRadius: 14, offset: const Offset(0, 6)),
            ] : null,
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: isActive ? Colors.white : _inkSoft,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatsCard(num? open, num? high, num? low, num? prevClose, num? volume, num? mktCap) {
    return Container(
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: _ink.withValues(alpha: 0.04), blurRadius: 2, offset: const Offset(0, 1)),
          BoxShadow(color: _ink.withValues(alpha: 0.06), blurRadius: 24, offset: const Offset(0, 8)),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'KEY STATS',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: _inkFaint,
              letterSpacing: 0.04,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildStatItem('Open', _formatNumber(open), null)),
              Expanded(child: _buildStatItem('High', _formatNumber(high), _green)),
              Expanded(child: _buildStatItem('Low', _formatNumber(low), _red)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildStatItem('Prev. close', _formatNumber(prevClose), null)),
              Expanded(child: _buildStatItem('Volume', _formatNumber(volume), null)),
              Expanded(child: _buildStatItem('Mkt cap', _formatNumber(mktCap), null)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color? color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11.5,
            color: _inkFaint,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: TextStyle(
            fontSize: 14.5,
            fontWeight: FontWeight.bold,
            color: color ?? _ink,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar(AssetModel asset) {
    final state = _fetchedStats?['marketState'] ?? 'REGULAR';
    String stateLabel = 'Market Open';
    if (state == 'CLOSED') stateLabel = 'Market Closed';
    if (state == 'PRE') stateLabel = 'Pre-market';
    if (state == 'POST') stateLabel = 'Post-market';

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
          child: Container(
            decoration: BoxDecoration(
              color: _bg.withValues(alpha: 0.9),
              border: const Border(top: BorderSide(color: _line)),
            ),
            padding: const EdgeInsets.only(left: 20, right: 20, top: 14, bottom: 32),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${_fetchedStats?['exchange'] ?? 'Market'} session',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: _inkFaint,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: _amber,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            stateLabel,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: _ink,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Trades on ${_fetchedStats?['exchange'] ?? 'Exchange'}',
                        style: TextStyle(
                          fontSize: 11.5,
                          color: _inkSoft,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 14),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _indigo,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 6,
                    shadowColor: _indigo.withValues(alpha: 0.5),
                  ),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => AddEntrySheet(asset: asset),
                    );
                  },
                  child: Text(
                    'Invest',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
