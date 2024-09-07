import 'package:flutter/material.dart';
import 'package:money_manager_app/db/category/category_db.dart';
import 'package:money_manager_app/db/transactions/transaction_db.dart';
import 'package:money_manager_app/models/category/category_model.dart';
import 'package:money_manager_app/models/transaction/transaction_model.dart';

class ScreenAddTransaction extends StatefulWidget {
  static const routeName = 'add-transaction';
  const ScreenAddTransaction({super.key});

  @override
  State<ScreenAddTransaction> createState() => _ScreenAddTransactionState();
}

class _ScreenAddTransactionState extends State<ScreenAddTransaction> {
  DateTime? _selectedDate;
  CategoryType? _selectedCategoryType;
  CategoryModel? _selectedCategoryModel;

  String? _categoryId;

  final _purposeTextEditingController = TextEditingController();
  final _amountTextEditingController = TextEditingController();

  @override
  void initState() {
    _selectedCategoryType = CategoryType.income;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _purposeTextEditingController,
            decoration: const InputDecoration(
                border: OutlineInputBorder(), hintText: 'Purpose'),
          ),
          const SizedBox(
            height: 20,
          ),
          TextFormField(
            controller: _amountTextEditingController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Amount',
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          TextButton.icon(
              onPressed: () async {
                final _selectedDateTemp = await showDatePicker(
                    context: context,
                    firstDate:
                        DateTime.now().subtract(const Duration(days: 30)),
                    lastDate: DateTime.now(),
                    initialDate: DateTime.now());

                if (_selectedDateTemp == null) {
                  return;
                } else {
                  setState(() {
                    _selectedDate = _selectedDateTemp;
                  });
                }
              },
              icon: const Icon(Icons.calendar_today),
              label: Text(_selectedDate == null
                  ? 'Select Date'
                  : _selectedDate.toString())),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                children: [
                  Radio(
                      value: CategoryType.income,
                      groupValue: _selectedCategoryType,
                      onChanged: (newValue) {
                        setState(() {
                          _selectedCategoryType = CategoryType.income;
                          _categoryId = null;
                        });
                      }),
                  const Text('Income'),
                ],
              ),
              Radio(
                  value: CategoryType.expense,
                  groupValue: _selectedCategoryType,
                  onChanged: (newValue) {
                    setState(() {
                      _selectedCategoryType = CategoryType.expense;
                      _categoryId = null;
                    });
                  }),
              const Text('Expense'),
            ],
          ),
          DropdownButton(
            hint: const Text('Select Category'),
            value: _categoryId,
            items: (_selectedCategoryType == CategoryType.income
                    ? CategoryDB().incomeCategoryListListener
                    : CategoryDB().expenseCategoryListListener)
                .value
                .map((e) {
              return DropdownMenuItem(
                child: Text(e.name),
                value: e.id,
                onTap: () {
                  _selectedCategoryModel = e;
                },
              );
            }).toList(),
            onChanged: (selectedValue) {
              setState(() {
                _categoryId = selectedValue;
              });
            },
            onTap: () {},
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              addTransaction();
            },
            child: const Text('Submit'),
          )
        ],
      ),
    )));
  }

  Future<void> addTransaction() async {
    final _purposeText = _purposeTextEditingController.text;
    final _amountText = _amountTextEditingController.text;
    if (_purposeText.isEmpty) {
      return;
    } else {
      if (_amountText.isEmpty) {
        return;
      }
      if (_categoryId == null) {
        return;
      }
      if (_selectedDate == null) {
        return;
      }

      if (_selectedCategoryModel == null) {
        return;
      }

      final _parsedAmount = double.tryParse(_amountText);

      if (_parsedAmount == null) {
        return;
      }

      final _model = TransactionModel(
          purpose: _purposeText,
          amount: _parsedAmount,
          date: _selectedDate!,
          type: _selectedCategoryType!,
          category: _selectedCategoryModel!);

      await TransactionDB.instance.addTransaction(_model);
      Navigator.of(context).pop();

      TransactionDB.instance.refresh();
    }
  }
}
