import 'package:fincontrol/view/wealth/created_portfolio.dart';
import 'package:fincontrol/view/wealth/invest_page.dart';
import 'package:flutter/material.dart';

class CreatePortfolioPage extends StatefulWidget {
  const CreatePortfolioPage({super.key});

  @override
  State<CreatePortfolioPage> createState() => _CreatePortfolioPageState();
}

class _CreatePortfolioPageState extends State<CreatePortfolioPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _goalController = TextEditingController();
  bool _setGoal = false;

  final List<String> _suggestions = [
    'Passive Income',
    'Growth Stocks',
    'Retire Ready',
    'Save',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _noteController.dispose();
    _goalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8E84FF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Create New Portfolio',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Center(
            child: Stack(
              children: [
                Container(
                  width: 96,
                  height: 96,
                  decoration: const BoxDecoration(
                    color: Color(0xFF9B41FF),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.monetization_on,
                      size: 48,
                      color: Colors.greenAccent,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Color(0xFF1C1C1E),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.edit,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _nameController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: 'Create Portfolio Name',
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 18),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF333333)),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                      onChanged: (value) => setState(() {}),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${_nameController.text.length}/25 characters.',
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    const SizedBox(height: 16),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: _suggestions.map((suggestion) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Colors.grey),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  _nameController.text = suggestion;
                                });
                              },
                              child: Text(
                                suggestion,
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => setState(() => _setGoal = !_setGoal),
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.grey,
                                width: 1.5,
                              ),
                            ),
                            child: _setGoal
                                ? const Icon(
                                    Icons.check,
                                    size: 16,
                                    color: Colors.white,
                                  )
                                : null,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Set Goal',
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                      ],
                    ),
                    if (_setGoal) ...[
                      const SizedBox(height: 16),
                      TextField(
                        controller: _goalController,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          hintText: 'Enter Goal Amount',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 18,
                          ),
                          prefixIcon: Icon(
                            Icons.attach_money,
                            color: Colors.grey,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF333333)),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 32),
                    Row(
                      children: const [
                        Icon(
                          Icons.description_outlined,
                          color: Colors.grey,
                          size: 16,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Note',
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 80,
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFF333333)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        controller: _noteController,
                        style: const TextStyle(color: Colors.white),
                        maxLines: null,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      'Add Assets to This Portfolio',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Each stock or asset supports assignment to one portfolio. Adding an asset to a new portfolio removes it from its previous portfolio.',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF4F3FF0),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        title: const Text(
                          'Select Assets',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: 20,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const InvestPage(),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4F3FF0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: ((context) => const CreatedPortfolio()),
                            ),
                          );
                        },
                        child: const Text(
                          'Create',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
