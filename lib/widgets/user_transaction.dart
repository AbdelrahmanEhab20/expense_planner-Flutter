import 'package:flutter/material.dart';
import './new_transaction.dart';
import './transaction_list.dart';
import '../models/transaction.dart';

class UserTransactions extends StatefulWidget {
  @override
  State<UserTransactions> createState() => _UserTransactionsState();
}

class _UserTransactionsState extends State<UserTransactions> {
  final List<Transaction> _userTransactions = [
    Transaction(
        id: 't1', amount: 72.99, title: 'New Shoes', date: DateTime.now()),
    Transaction(
        id: 't2',
        amount: 90.55,
        title: 'Weekly Groceries',
        date: DateTime.now())
  ];

  void _addNewTransaction(String txTittle, double txAmount) {
    final newTxt = Transaction(
        amount: txAmount,
        date: DateTime.now(),
        id: DateTime.now().toString(),
        title: txTittle);

    setState(() {
      _userTransactions.add(newTxt);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        NewTransaction(_addNewTransaction),
        TransactionList(_userTransactions)
      ],
    );
  }
}
