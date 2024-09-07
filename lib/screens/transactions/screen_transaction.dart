import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:money_manager_app/db/category/category_db.dart';
import 'package:money_manager_app/db/transactions/transaction_db.dart';
import 'package:money_manager_app/models/category/category_model.dart';
import 'package:money_manager_app/models/transaction/transaction_model.dart';

class ScreenTransaction extends StatelessWidget {
  const ScreenTransaction({super.key});

  @override
  Widget build(BuildContext context) {
    TransactionDB.instance.refresh();
    CategoryDB.instance.refreshUI();
    return ValueListenableBuilder(
        valueListenable: TransactionDB.instance.transactionListNotifier,
        builder: (BuildContext ctx, List<TransactionModel> newList, Widget? _) {
          return ListView.separated(
            padding: const EdgeInsets.all(10),
            itemBuilder: (ctx, index) {
              final _value = newList[index];
              return Slidable(
                key: Key(_value.id!),
                startActionPane: ActionPane(motion: ScrollMotion(), children: [
                  SlidableAction(
                    onPressed: (ctx) {
                      TransactionDB.instance.deleteTransaction(_value.id!);
                    },
                    icon: Icons.delete,
                    label: 'Delete',
                  ),
                ]),
                child: Card(
                  elevation: 0,
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 50,
                      backgroundColor: _value.type == CategoryType.income
                          ? Colors.green
                          : Colors.red,
                      child: Text(
                        parseDate(_value.date),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    title: Text(_value.amount.toString()),
                    subtitle: Text(_value.category.name),
                  ),
                ),
              );
            },
            separatorBuilder: (ctx, index) {
              return const SizedBox(
                height: 10,
              );
            },
            itemCount: newList.length,
          );
        });
  }

  String parseDate(DateTime date) {
    final _date = DateFormat.MMMd().format(date);
    final _splitedDate = _date.split(' ');
    return '${_splitedDate[1]} \n ${_splitedDate[0]}';
  }
}
