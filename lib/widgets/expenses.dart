import 'package:flutter/material.dart';
import 'package:yourexpense/widgets/expenses_list/expenses_list.dart';
import 'package:yourexpense/models/expense.dart';
import 'package:yourexpense/widgets/new_expense.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [
    Expense(
      title: '플러터 강의',
      amount: 19000,
      date: DateTime.now(),
      category: Category.work,
    ),
    Expense(
      title: '밥',
      amount: 20000,
      date: DateTime.now(),
      category: Category.food,
    ),
  ];

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewExpense(
        onAddExpense: _addExpense,
      ),
    );
  }

  void _addExpense(Expense expense) {
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

  void _removeExpense(Expense expense) {
    final expenseIdx = _registeredExpenses.indexOf(expense);

    setState(() {
      _registeredExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text('삭제되었습니다.'),
        action: SnackBarAction(
          label: '취소',
          onPressed: () {
            setState(() {
              _registeredExpenses.insert(
                  expenseIdx, expense); //다시 같은 index에 동일한 expense를 추가
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget mainContent = const Center(
      child: Text('기록이 없습니다. 새롭게 추가해보세요!'),
    );

    if (_registeredExpenses.isNotEmpty) {
      mainContent = ExpensesList(
        expenses: _registeredExpenses,
        onRemoveExpense: _removeExpense,
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('💰돈을 모으자!'),
        backgroundColor: const Color(0xFFDB7624),
        actions: [
          IconButton(
            onPressed: _openAddExpenseOverlay,
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: Column(children: [
        Expanded(
          child: mainContent,
        ),
      ]),
    );
  }
}
