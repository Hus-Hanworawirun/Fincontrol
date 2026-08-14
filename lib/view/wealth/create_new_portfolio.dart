import 'package:fincontrol/view/wealth/created_portfolio.dart';
import 'package:fincontrol/view/wealth/invest_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fincontrol/bloc/portfolio/portfolio_bloc.dart';
import 'package:fincontrol/bloc/portfolio/portfolio_event.dart';
import 'package:fincontrol/data/models/portfolio_model.dart';
import '../widgets/glass_container.dart';

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
  IconData _selectedIcon = Icons.monetization_on;

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
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;
    final mutedTextColor = Theme.of(context).textTheme.bodySmall?.color;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'New Goal',
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Center(
            child: GestureDetector(
              onTap: () => _showIconPicker(context, textColor, primaryColor),
              child: Stack(
                children: [
                  GlassContainer(
                    width: 96,
                    height: 96,
                    borderRadius: BorderRadius.circular(48),
                    color: primaryColor.withValues(alpha: 0.2),
                    child: Center(
                      child: Icon(
                        _selectedIcon,
                        size: 40,
                        color: primaryColor,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        shape: BoxShape.circle,
                        border: Border.all(color: Theme.of(context).scaffoldBackgroundColor, width: 2),
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
          ),
          const SizedBox(height: 32),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              children: [
                _buildInputField(
                  controller: _nameController,
                  hint: 'Goal Name',
                  textColor: textColor,
                  mutedTextColor: mutedTextColor,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8, left: 16, bottom: 24),
                  child: Text(
                    '${_nameController.text.length}/25 characters',
                    style: TextStyle(color: mutedTextColor, fontSize: 12),
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _suggestions.map((suggestion) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _nameController.text = suggestion;
                            });
                          },
                          child: GlassContainer(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            borderRadius: BorderRadius.circular(20),
                            child: Text(
                              suggestion,
                              style: TextStyle(color: textColor, fontWeight: FontWeight.w600, fontSize: 13),
                            ),
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
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _setGoal ? primaryColor : Colors.transparent,
                          border: Border.all(
                            color: _setGoal ? primaryColor : (mutedTextColor ?? Colors.grey),
                            width: 2,
                          ),
                        ),
                        child: _setGoal
                            ? const Icon(Icons.check, size: 16, color: Colors.white)
                            : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Set Target Amount',
                      style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                if (_setGoal) ...[
                  const SizedBox(height: 16),
                  _buildInputField(
                    controller: _goalController,
                    hint: 'Enter Target Amount',
                    prefixIcon: Icons.attach_money,
                    isNumber: true,
                    textColor: textColor,
                    mutedTextColor: mutedTextColor,
                  ),
                ],
                const SizedBox(height: 32),
                Row(
                  children: [
                    Icon(Icons.description_outlined, color: mutedTextColor, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Note',
                      style: TextStyle(color: mutedTextColor, fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                GlassContainer(
                  height: 100,
                  padding: EdgeInsets.zero,
                  borderRadius: BorderRadius.circular(16),
                  child: TextField(
                    controller: _noteController,
                    style: TextStyle(color: textColor, fontSize: 15),
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: 'Add an optional note...',
                      hintStyle: TextStyle(color: mutedTextColor?.withValues(alpha: 0.5), fontSize: 15),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(16),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Text(
                  'Assign Assets',
                  style: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),
                Text(
                  'Adding an asset to a new goal removes it from its previous assignment.',
                  style: TextStyle(color: mutedTextColor, fontSize: 13, height: 1.5),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const InvestPage()),
                    );
                  },
                  child: GlassContainer(
                    borderRadius: BorderRadius.circular(16),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    color: primaryColor.withValues(alpha: 0.1),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Select Assets',
                          style: TextStyle(color: primaryColor, fontWeight: FontWeight.w700, fontSize: 16),
                        ),
                        Icon(Icons.arrow_forward_ios, color: primaryColor, size: 16),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {
                    if (_nameController.text.isNotEmpty) {
                      final goal = PortfolioModel(
                        id: '',
                        userId: '',
                        name: _nameController.text,
                        icon: _selectedIcon.codePoint,
                        note: _noteController.text,
                        targetGoal: double.tryParse(_goalController.text),
                        createdAt: DateTime.now(),
                      );
                      context.read<PortfolioBloc>().add(AddPortfolio(goal));
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: ((context) => const CreatedPortfolio()),
                      ),
                    );
                  },
                  child: const Text(
                    'Create Goal',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    IconData? prefixIcon,
    bool isNumber = false,
    required Color? textColor,
    required Color? mutedTextColor,
  }) {
    return GlassContainer(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      borderRadius: BorderRadius.circular(16),
      child: TextField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: mutedTextColor?.withValues(alpha: 0.5), fontSize: 16, fontWeight: FontWeight.normal),
          prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: mutedTextColor) : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
        onChanged: (value) => setState(() {}),
      ),
    );
  }

  void _showIconPicker(BuildContext context, Color? textColor, Color primaryColor) {
    final icons = [
      Icons.monetization_on, Icons.house, Icons.directions_car, Icons.savings,
      Icons.account_balance, Icons.trending_up, Icons.shopping_bag, Icons.flight,
      Icons.school, Icons.favorite,
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return GlassContainer(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 24),
              Text(
                'Select Icon',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textColor),
              ),
              const SizedBox(height: 32),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: icons.length,
                itemBuilder: (context, index) {
                  final isSelected = _selectedIcon == icons[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedIcon = icons[index];
                      });
                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected ? primaryColor.withValues(alpha: 0.2) : Colors.transparent,
                        shape: BoxShape.circle,
                        border: Border.all(
                           color: isSelected ? primaryColor : (textColor?.withValues(alpha: 0.1) ?? Colors.grey),
                           width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Icon(
                        icons[index],
                        color: isSelected ? primaryColor : textColor?.withValues(alpha: 0.6),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 32),
            ],
          ),
        );
      },
    );
  }
}
