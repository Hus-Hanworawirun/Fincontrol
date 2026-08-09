import 'package:fincontrol/view/wealth/asset_detail_page.dart';
import 'package:flutter/material.dart';
import '../../data/models/asset_model.dart';
import '../../data/repositories/market_api_repository.dart';

class InvestPage extends StatefulWidget {
  const InvestPage({super.key});

  @override
  State<InvestPage> createState() => _InvestPageState();
}

class _InvestPageState extends State<InvestPage> {
  final MarketApiRepository _api = MarketApiRepository();
  String _selectedCategory = '';
  String _selectedSort = 'Default';

  final List<Map<String, dynamic>> _mockAssets = [
    {'name': 'Apple Inc.', 'ticker': 'AAPL', 'price': 189.30, 'change': 1.25, 'icon': Icons.apple, 'category': 'Stocks'},
    {'name': 'Tesla', 'ticker': 'TSLA', 'price': 248.50, 'change': -2.34, 'icon': Icons.electric_car, 'category': 'Stocks'},
    {'name': 'Bitcoin', 'ticker': 'BTC-USD', 'price': 42150.00, 'change': 5.67, 'icon': Icons.currency_bitcoin, 'category': 'Crypto'},
    {'name': 'Amazon', 'ticker': 'AMZN', 'price': 145.20, 'change': 0.89, 'icon': Icons.shopping_cart, 'category': 'Stocks'},
    {'name': 'S&P 500 ETF', 'ticker': 'VOO', 'price': 410.80, 'change': 0.45, 'icon': Icons.trending_up, 'category': 'ETFs'},
  ];

  @override
  void initState() {
    super.initState();
    _fetchRealPrices();
  }

  void _fetchRealPrices() async {
    for (var i = 0; i < _mockAssets.length; i++) {
      final ticker = _mockAssets[i]['ticker'] as String;
      final data = await _api.getChartData(ticker, interval: '1d', range: '5d');
      if (data.isNotEmpty && data.length >= 2 && mounted) {
        final currentPrice = data.last;
        final previousClose = data[data.length - 2];
        final change = previousClose > 0 ? ((currentPrice - previousClose) / previousClose) * 100 : 0.0;
        
        setState(() {
          _mockAssets[i]['price'] = currentPrice;
          _mockAssets[i]['change'] = double.parse(change.toStringAsFixed(2));
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F2F8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Invest',
          style: TextStyle(
            color: Colors.black,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE2DFE7),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const TextField(
                      decoration: InputDecoration(
                        hintText: 'Search assets',
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.search, color: Colors.grey),
                        contentPadding: EdgeInsets.symmetric(vertical: 15),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: _showSortSheet,
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE2DFE7),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.tune, color: Colors.black),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildCategoryButton('Stocks'),
                const SizedBox(width: 12),
                _buildCategoryButton('Crypto'),
                const SizedBox(width: 12),
                _buildCategoryButton('ETFs'),
              ],
            ),
            const SizedBox(height: 32),
            const Text(
              'Spotlight',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Builder(
              builder: (context) {
                final filteredAssets = _selectedCategory.isEmpty 
                    ? List<Map<String, dynamic>>.from(_mockAssets) 
                    : _mockAssets.where((a) => a['category'] == _selectedCategory).toList();
                
                if (_selectedSort == 'Top Gainers') {
                  filteredAssets.sort((a, b) => (b['change'] as double).compareTo(a['change'] as double));
                } else if (_selectedSort == 'Top Losers') {
                  filteredAssets.sort((a, b) => (a['change'] as double).compareTo(b['change'] as double));
                } else if (_selectedSort == 'A-Z') {
                  filteredAssets.sort((a, b) => (a['name'] as String).compareTo(b['name'] as String));
                }
                
                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredAssets.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final asset = filteredAssets[index];
                    final isPositive = (asset['change'] as double) >= 0;
                    return GestureDetector(
                      onTap: () {
                        final assetModel = AssetModel(
                          id: 'mock_$index',
                          userId: 'mock_user',
                          portfolioId: 'mock_portfolio',
                          name: asset['name'] as String,
                          tickerSymbol: asset['ticker'] as String,
                          category: asset['category'] as String,
                          totalQuantity: 0,
                          averageBuyPrice: (asset['price'] as double) - (asset['change'] as double),
                          currentPrice: asset['price'] as double,
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AssetDetailPage(asset: assetModel),
                          ),
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(12),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: const BoxDecoration(
                                color: Color(0xFFF4F2F8),
                                shape: BoxShape.circle,
                              ),
                              child: Image.asset(
                                'assets/icons/${asset['ticker']}.png',
                                width: 24,
                                height: 24,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.show_chart, color: Color(0xFF4F3FF0)),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    asset['ticker'] as String,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    asset['name'] as String,
                                    style: const TextStyle(color: Colors.grey, fontSize: 13),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '\$${(asset['price'] as double).toStringAsFixed(2)}',
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${isPositive ? '+' : ''}${asset['change']}%',
                                  style: TextStyle(
                                    color: isPositive ? Colors.green : Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showSortSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Sort By', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              _buildSortOption('Default'),
              _buildSortOption('Top Gainers'),
              _buildSortOption('Top Losers'),
              _buildSortOption('A-Z'),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSortOption(String title) {
    return ListTile(
      title: Text(title, style: TextStyle(fontWeight: _selectedSort == title ? FontWeight.bold : FontWeight.normal)),
      trailing: _selectedSort == title ? const Icon(Icons.check, color: Color(0xFF4F3FF0)) : null,
      onTap: () {
        setState(() {
          _selectedSort = title;
        });
        Navigator.pop(context);
      },
    );
  }

  Widget _buildCategoryButton(String title) {
    final isSelected = _selectedCategory == title;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            if (_selectedCategory == title) {
              _selectedCategory = '';
            } else {
              _selectedCategory = title;
            }
          });
        },
        child: Container(
          height: 36,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF4F3FF0) : const Color(0xFFE2DFE7),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            title, 
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black, 
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
