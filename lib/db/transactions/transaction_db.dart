import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import 'package:money_manager_app/models/transaction/transaction_model.dart';

const TRANSACTION_DB_NAME = "transaction-db";

abstract class TransactionDbFunctions {
  Future<void> addTransaction(TransactionModel obj);
  Future<List<TransactionModel>> getAllTransactions();
  Future<void> deleteTransaction(String id);
}

class TransactionDB implements TransactionDbFunctions {
  TransactionDB._internal();

  static TransactionDB instance = TransactionDB._internal();

  factory TransactionDB() {
    return instance;
  }

  ValueNotifier<List<TransactionModel>> transactionListNotifier =
      ValueNotifier([]);

  @override
  Future<void> addTransaction(TransactionModel obj) async {
    final _db = await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
    await _db.put(obj.id, obj);
  }

  Future<void> refresh() async {
    final _list = await getAllTransactions();
    transactionListNotifier.value.clear();
    _list.sort((first, second) => second.date.compareTo(first.date));
    transactionListNotifier.value.addAll(_list);
    transactionListNotifier.notifyListeners();
  }

  @override
  Future<List<TransactionModel>> getAllTransactions() async {
    final _db = await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
    return _db.values.toList();
  }

  @override
  Future<void> deleteTransaction(String _id) async {
    final _db = await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
    await _db.delete(_id);
    refresh();
  }
}
