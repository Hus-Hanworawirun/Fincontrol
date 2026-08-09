import 'package:fincontrol/view/wealth/invest_page.dart';
import 'package:flutter/material.dart';

class CreatedPortfolio extends StatefulWidget {
  const CreatedPortfolio({super.key});

  @override
  State<CreatedPortfolio> createState() => _CreatedPortfolioState();
}

class _CreatedPortfolioState extends State<CreatedPortfolio> {
  // Use this list to control the UI state
  // Empty list shows the 'Invest Now' state
  // Populated list shows the investment cards
  final List<String> _assets = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F2F8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'My Goals name',
          style: TextStyle(
            color: Colors.black,
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
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: const Color(0xFFE2DFE7),
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'My Investment',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
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
                          const Text(
                            'This portfolio is currently empty',
                            style: TextStyle(
                              color: Colors.black,
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
                                backgroundColor: const Color(0xFFE2DFE7),
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
                                  color: Colors.black,
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
                      separatorBuilder: (context, index) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        return Container(
                          width: double.infinity,
                          height: 80,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE2DFE7),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}