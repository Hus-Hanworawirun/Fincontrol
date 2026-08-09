import 'package:fincontrol/view/wealth/invest_page.dart';
import 'package:fincontrol/view/widgets/income_expense_item.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fincontrol/bloc/transaction/transaction_bloc.dart';
import 'package:fincontrol/bloc/transaction/transaction_state.dart';
import 'package:fincontrol/data/models/transaction_model.dart';

class ActivityPage extends StatefulWidget {
  const ActivityPage({super.key});

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  String _selectedPeriod = 'Day';
  DateTime _currentDate = DateTime.now();
  int _selectedDay = DateTime.now().day;
  int _selectedMonth = DateTime.now().month;
  int _selectedYear = DateTime.now().year;



  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.20,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF4F3FF0), Color(0xFF8E84FF)],
              ),
            ),
          ),
          ListView(
            padding: const EdgeInsets.only(
              top: 48, 
              left: 16,
              right: 16,
              bottom: 16,
            ),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.blue.shade100,
                        radius: 32,
                        child: const Icon(Icons.person, color: Colors.blue),
                      ),
                      const SizedBox(width: 12),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hello,',
                            style: TextStyle(fontSize: 24, color: Colors.white),
                          ),
                          Text(
                            'The One Who Wait',
                            style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.search, color: Colors.black),
                        iconSize: 28, 
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.all(12),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const InvestPage(),
                            ),
                          );
                        }
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.notifications, color: Colors.black), 
                        iconSize: 28,
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.all(12),
                        ),
                        onPressed: () {}
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Material(
                color: Colors.white,
                elevation: 9,
                shadowColor: Colors.black.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(24),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      // Title & Period Selector
                      _buildTitleRow(),
                      const SizedBox(height: 32),
                      // Total Balance Card (Glassmorphic, Static Data for now)
                      _buildStaticGlassBalanceCard(),
                    ],
                  ),
                ),
              ),
                    const SizedBox(height: 24),

                    // Period Selector (Calendar view)
                    _buildPeriodSelector(),
                    const SizedBox(height: 24),

                    Text(
                      '$_selectedPeriod Breakdown',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildBreakdownContent(),
                    const SizedBox(height: 100),
                  ],
                ),
              ],
            ),
          );
  }

  Widget _buildTitleRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Activity',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w900,
            color: Colors.black87,
          ),
        ),
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: ['Day', 'Week', 'Month', 'Year'].map((String value) {
              final isSelected = _selectedPeriod == value;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedPeriod = value;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF4F3FF0) : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    value,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey.shade500,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildStaticGlassBalanceCard() {
    return BlocBuilder<TransactionBloc, TransactionState>(
      builder: (context, state) {
        double totalIncome = 0;
        double totalExpense = 0;
        if (state is TransactionLoaded) {
          for (var t in state.transactions) {
            if (t.type == 'Income') totalIncome += t.amount;
            if (t.type == 'Expense') totalExpense += t.amount;
          }
        }
        double totalBalance = totalIncome - totalExpense;

        return Material(
          elevation: 9,
          shadowColor: Colors.black.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(20),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(
                height: 200,
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.white, width: 1.5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Total Balance',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '\$${totalBalance.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 36,
                        color: Colors.black,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IncomeExpenseItem(
                          icon: Icons.add,
                          iconColor: Colors.green,
                          label: 'Income',
                          amount: '\$${totalIncome.toStringAsFixed(2)}',
                        ),
                        IncomeExpenseItem(
                          icon: Icons.remove,
                          iconColor: Colors.red,
                          label: 'Expense',
                          amount: '\$${totalExpense.toStringAsFixed(2)}',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }
    );
  }

  Widget _buildPeriodSelector() {
    if (_selectedPeriod == 'Day') {
      return _buildMonthDayView();
    } else if (_selectedPeriod == 'Month') {
      return _buildMonthView();
    } else if (_selectedPeriod == 'Year') {
      return _buildYearView();
    } else {
      return _buildWeekView();
    }
  }

  Widget _buildWeekView() {
    DateTime date = DateTime(_currentDate.year, _currentDate.month, _selectedDay);
    int daysToSubtract = date.weekday == 7 ? 0 : date.weekday;
    DateTime startOfWeek = date.subtract(Duration(days: daysToSubtract));

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(7, (index) {
        final currentDay = startOfWeek.add(Duration(days: index));
        final isSelected = currentDay.day == _selectedDay && currentDay.month == _selectedMonth && currentDay.year == _selectedYear;

        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedDay = currentDay.day;
              _selectedMonth = currentDay.month;
              _selectedYear = currentDay.year;
              _currentDate = currentDay;
            });
          },
          child: Container(
            width: 44,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF4F3FF0) : Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                if (!isSelected)
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  ['S', 'M', 'T', 'W', 'T', 'F', 'S'][index],
                  style: TextStyle(
                    color: isSelected ? Colors.white70 : Colors.grey.shade500,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  currentDay.day.toString(),
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildMonthDayView() {
    final daysInMonth = DateUtils.getDaysInMonth(_currentDate.year, _currentDate.month);
    final firstDayOfMonth = DateTime(_currentDate.year, _currentDate.month, 1);
    final firstWeekday = firstDayOfMonth.weekday; 
    final offset = firstWeekday == 7 ? 0 : firstWeekday;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    '${_getMonthNameFull(_currentDate.month)} ${_currentDate.year}',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.black87),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.arrow_drop_down, color: Colors.black54),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left, size: 20, color: Colors.black87),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () => setState(() => _currentDate = DateTime(_currentDate.year, _currentDate.month - 1)),
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                    icon: const Icon(Icons.chevron_right, size: 20, color: Colors.black87),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () => setState(() => _currentDate = DateTime(_currentDate.year, _currentDate.month + 1)),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ['S', 'M', 'T', 'W', 'T', 'F', 'S'].map((day) {
              return SizedBox(
                width: 32,
                child: Center(
                  child: Text(
                    day,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black54),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 12,
              crossAxisSpacing: 8,
            ),
            itemCount: daysInMonth + offset,
            itemBuilder: (context, index) {
              if (index < offset) return const SizedBox.shrink();
              final day = index - offset + 1;
              final isSelected = day == _selectedDay && _currentDate.month == _selectedMonth && _currentDate.year == _selectedYear;
              
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedDay = day;
                    _selectedMonth = _currentDate.month;
                    _selectedYear = _currentDate.year;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF4F3FF0) : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    day.toString(),
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontSize: 14,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  String _getMonthNameFull(int month) {
    const months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
    return months[month - 1];
  }

  Widget _buildMonthView() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.2,
        ),
        itemCount: 12,
        itemBuilder: (context, index) {
          final month = index + 1;
          final isSelected = month == _selectedMonth && _currentDate.year == _selectedYear;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedMonth = month;
                _selectedYear = _currentDate.year;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF4F3FF0) : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              alignment: Alignment.center,
              child: Text(
                _getMonthName(month),
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black54,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildYearView() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.2,
        ),
        itemCount: 8,
        itemBuilder: (context, index) {
          final year = DateTime.now().year - 4 + index;
          final isSelected = year == _selectedYear;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedYear = year;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF4F3FF0) : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              alignment: Alignment.center,
              child: Text(
                year.toString(),
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black54,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String _getMonthName(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }

  Widget _buildBreakdownContent() {
    return BlocBuilder<TransactionBloc, TransactionState>(
      builder: (context, state) {
        if (state is TransactionLoading) {
          return const Center(child: Padding(
            padding: EdgeInsets.symmetric(vertical: 40),
            child: CircularProgressIndicator(),
          ));
        }
        if (state is TransactionLoaded) {
          List<TransactionModel> filteredRecords = [];
          final records = state.transactions;
          
          if (_selectedPeriod == 'Day') {
            filteredRecords = records.where((r) => r.date.year == _selectedYear && r.date.month == _selectedMonth && r.date.day == _selectedDay).toList();
          } else if (_selectedPeriod == 'Month') {
            filteredRecords = records.where((r) => r.date.year == _selectedYear && r.date.month == _selectedMonth).toList();
          } else if (_selectedPeriod == 'Year') {
            filteredRecords = records.where((r) => r.date.year == _selectedYear).toList();
          } else {
            // Week - exact logic based on startOfWeek
            DateTime date = DateTime(_currentDate.year, _currentDate.month, _selectedDay);
            int daysToSubtract = date.weekday == 7 ? 0 : date.weekday;
            DateTime startOfWeek = date.subtract(Duration(days: daysToSubtract));
            DateTime endOfWeek = startOfWeek.add(const Duration(days: 7));
            
            filteredRecords = records.where((r) {
               return r.date.isAfter(startOfWeek.subtract(const Duration(milliseconds: 1))) && r.date.isBefore(endOfWeek);
            }).toList();
          }

          filteredRecords.sort((a, b) => b.date.compareTo(a.date));

          if (filteredRecords.isEmpty) {
            return const Center(child: Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: Text('No activity found for this period', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500)),
            ));
          }

          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filteredRecords.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final record = filteredRecords[index];
              return _buildDetailItem(record);
            },
          );
        }
        return const SizedBox();
      }
    );
  }

  Widget _buildDetailItem(TransactionModel record) {
    final isIncome = record.type == 'Income';
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isIncome ? Colors.green.withValues(alpha: 0.1) : Colors.orange.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isIncome ? Icons.arrow_downward : Icons.arrow_upward,
              color: isIncome ? Colors.green : Colors.orange,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  record.note.isNotEmpty ? record.note : record.category,
                  style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.black87, fontSize: 15),
                ),
                const SizedBox(height: 4),
                Text(
                  record.category,
                  style: TextStyle(color: Colors.grey.shade500, fontWeight: FontWeight.w600, fontSize: 13),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${isIncome ? "+" : "-"}\$${record.amount.toStringAsFixed(2)}',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                  color: isIncome ? Colors.green : Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${record.date.hour}:${record.date.minute.toString().padLeft(2, '0')}',
                style: TextStyle(color: Colors.grey.shade400, fontWeight: FontWeight.w600, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
