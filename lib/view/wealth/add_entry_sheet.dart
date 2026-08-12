import 'package:flutter/material.dart';
import '../../data/models/asset_model.dart';
import '../widgets/glass_container.dart';

class AddEntrySheet extends StatefulWidget {
  final AssetModel? asset;
  
  const AddEntrySheet({super.key, this.asset});

  @override
  State<AddEntrySheet> createState() => _AddEntrySheetState();
}

class _AddEntrySheetState extends State<AddEntrySheet> {
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _symbolController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  String _selectedCategory = 'Investment';
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.asset != null) {
      _symbolController.text = widget.asset!.tickerSymbol;
    }
  }

  @override
  void dispose() {
    _noteController.dispose();
    _amountController.dispose();
    _symbolController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  Future<void> _pickDate(Color primaryColor) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light().copyWith(primary: primaryColor),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  void _saveEntry() {
    // TODO: implement save logic
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;
    final mutedTextColor = Theme.of(context).textTheme.bodySmall?.color;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final fieldBg = isDarkMode ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.05);

    return GlassContainer(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(32),
        topRight: Radius.circular(32),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: mutedTextColor?.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            Text(
              'Add Asset',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: textColor,
              ),
            ),
            const SizedBox(height: 24),
            
            _buildLabel('Category', textColor),
            DropdownButtonFormField<String>(
              initialValue: _selectedCategory,
              icon: Icon(Icons.keyboard_arrow_down, color: textColor),
              dropdownColor: isDarkMode ? const Color(0xFF2C2C2E) : Colors.white,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.category_outlined, color: primaryColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: fieldBg,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
              style: TextStyle(fontSize: 16, color: textColor, fontWeight: FontWeight.w600),
              items: ['Investment', 'Deposit', 'Withdrawal']
                  .map((String category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedCategory = newValue;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            
            _buildLabel('Note', textColor),
            TextField(
              controller: _noteController,
              style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
              decoration: InputDecoration(
                hintText: 'What is this for?',
                hintStyle: TextStyle(color: mutedTextColor),
                prefixIcon: Icon(Icons.notes, color: mutedTextColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: fieldBg,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
            ),
            const SizedBox(height: 16),
            
            _buildLabel('Amount', textColor),
            TextField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: TextStyle(color: textColor, fontWeight: FontWeight.w600, fontSize: 18),
              decoration: InputDecoration(
                hintText: '0.00',
                hintStyle: TextStyle(color: mutedTextColor),
                prefixIcon: Icon(Icons.attach_money, color: primaryColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: fieldBg,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
            ),
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel('Symbol', textColor),
                      TextField(
                        controller: _symbolController,
                        style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
                        decoration: InputDecoration(
                          hintText: 'AAPL',
                          hintStyle: TextStyle(color: mutedTextColor),
                          prefixIcon: Icon(Icons.tag, color: mutedTextColor),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: fieldBg,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel('Quantity', textColor),
                      TextField(
                        controller: _quantityController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
                        decoration: InputDecoration(
                          hintText: '1.5',
                          hintStyle: TextStyle(color: mutedTextColor),
                          prefixIcon: Icon(Icons.numbers, color: mutedTextColor),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: fieldBg,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            _buildLabel('Date', textColor),
            InkWell(
              onTap: () => _pickDate(primaryColor),
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  color: fieldBg,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Icon(Icons.calendar_today_outlined, color: primaryColor),
                    const SizedBox(width: 12),
                    Text(
                      "${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}",
                      style: TextStyle(
                        fontSize: 16,
                        color: textColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _saveEntry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Save Asset',
                  style: TextStyle(
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
    );
  }

  Widget _buildLabel(String text, Color? textColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
