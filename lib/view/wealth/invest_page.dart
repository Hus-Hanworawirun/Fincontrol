import 'package:fincontrol/view/wealth/asset_detail_page.dart';
import 'package:flutter/material.dart';

class InvestPage extends StatefulWidget {
  const InvestPage({super.key});

  @override
  State<InvestPage> createState() => _InvestPageState();
}

class _InvestPageState extends State<InvestPage> {
  final List<Map<String, dynamic>> _mockAssets = [
    {'name': 'Apple Inc.', 'ticker': 'AAPL', 'price': 189.30, 'change': 1.25, 'icon': Icons.apple},
    {'name': 'Tesla', 'ticker': 'TSLA', 'price': 248.50, 'change': -2.34, 'icon': Icons.electric_car},
    {'name': 'Bitcoin', 'ticker': 'BTC', 'price': 42150.00, 'change': 5.67, 'icon': Icons.currency_bitcoin},
    {'name': 'Amazon', 'ticker': 'AMZN', 'price': 145.20, 'change': 0.89, 'icon': Icons.shopping_cart},
    {'name': 'S&P 500 ETF', 'ticker': 'VOO', 'price': 410.80, 'change': 0.45, 'icon': Icons.trending_up},
  ];

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
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2DFE7),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.tune, color: Colors.black),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 36,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xFF4F3FF0),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text('Stocks', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    height: 36,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE2DFE7),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text('Crypto', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    height: 36,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE2DFE7),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text('ETFs', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                  ),
                ),
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
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _mockAssets.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final asset = _mockAssets[index];
                final isPositive = (asset['change'] as double) >= 0;
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AssetDetailPage(asset: asset),
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
                        child: Icon(asset['icon'] as IconData, color: const Color(0xFF4F3FF0)),
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
                            '\$${asset['price']}',
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
            ),
          ],
        ),
      ),
    );
  }
}
