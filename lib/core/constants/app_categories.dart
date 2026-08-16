class AppCategories {
  AppCategories._();

  static const List<CategoryItem> income = [
    CategoryItem(id: 'salary',           label: 'Salary',           group: 'Active Income'),
    CategoryItem(id: 'bonus',            label: 'Bonus',            group: 'Active Income'),
    CategoryItem(id: 'interest_saving',  label: 'Savings Interest', group: 'Passive Income'),
    CategoryItem(id: 'interest_fixed',   label: 'Fixed Deposit',    group: 'Passive Income'),
    CategoryItem(id: 'dividend_stock',   label: 'Stock Dividend',   group: 'Passive Income'),
    CategoryItem(id: 'dividend_fund',    label: 'Fund Dividend',    group: 'Passive Income'),
    CategoryItem(id: 'dividend_other',   label: 'Other Dividend',   group: 'Passive Income'),
    CategoryItem(id: 'rental',           label: 'Rental Income',    group: 'Passive Income'),
    CategoryItem(id: 'income_other',     label: 'Other Income',     group: 'Passive Income'),
  ];

  static const List<CategoryItem> expense = [
    CategoryItem(id: 'saving_invest',    label: 'Investment Saving',  group: 'Saving'),
    CategoryItem(id: 'saving_fund',      label: 'Fund Saving',        group: 'Saving'),
    CategoryItem(id: 'social_security',  label: 'Social Security',    group: 'Fixed'),
    CategoryItem(id: 'provident_fund',   label: 'Provident Fund',     group: 'Fixed'),
    CategoryItem(id: 'life_insurance',   label: 'Life Insurance',     group: 'Fixed'),
    CategoryItem(id: 'car_insurance',    label: 'Car Insurance',      group: 'Fixed'),
    CategoryItem(id: 'home_insurance',   label: 'Home Insurance',     group: 'Fixed'),
    CategoryItem(id: 'common_fee',       label: 'Common Area Fee',    group: 'Fixed'),
    CategoryItem(id: 'fixed_other',      label: 'Other Fixed',        group: 'Fixed'),
    CategoryItem(id: 'home_loan',        label: 'Home Loan',          group: 'Installment'),
    CategoryItem(id: 'property_invest',  label: 'Investment Property',group: 'Installment'),
    CategoryItem(id: 'car_loan',         label: 'Car Loan',           group: 'Installment'),
    CategoryItem(id: 'credit_card',      label: 'Credit Card',        group: 'Installment'),
    CategoryItem(id: 'personal_loan',    label: 'Personal Loan',      group: 'Installment'),
    CategoryItem(id: 'clothing',         label: 'Clothing',           group: 'Variable'),
    CategoryItem(id: 'travel_entertain', label: 'Travel & Leisure',   group: 'Variable'),
    CategoryItem(id: 'car_maintenance',  label: 'Car Maintenance',    group: 'Variable'),
    CategoryItem(id: 'grocery',          label: 'Grocery',            group: 'Variable'),
    CategoryItem(id: 'food',             label: 'Food & Dining',      group: 'Variable'),
    CategoryItem(id: 'transport_fuel',   label: 'Transport & Fuel',   group: 'Variable'),
    CategoryItem(id: 'child_care',       label: 'Child Care',         group: 'Variable'),
    CategoryItem(id: 'parent_care',      label: 'Parent Care',        group: 'Variable'),
    CategoryItem(id: 'income_tax',       label: 'Income Tax',         group: 'Variable'),
    CategoryItem(id: 'expense_other',    label: 'Other Expense',      group: 'Variable'),
  ];

  static List<String> get incomeLabels  => income.map((c) => c.label).toList();
  static List<String> get expenseLabels => expense.map((c) => c.label).toList();
  static List<CategoryItem> forType(bool isIncome) => isIncome ? income : expense;
}

class CategoryItem {
  final String id;
  final String label;
  final String group;
  const CategoryItem({required this.id, required this.label, required this.group});
}
