import 'package:flutter/material.dart';
import 'package:money_manager_app/db/category/category_db.dart';
import 'package:money_manager_app/models/category/category_model.dart';

ValueNotifier<CategoryType> selectedCategoryNotifier =
    ValueNotifier(CategoryType.income);

Future<void> ShowCategoryAddPopUp(BuildContext context) async {
  final _nameEditingController = TextEditingController();

  showDialog(
      context: context,
      builder: (ctx) {
        return SimpleDialog(
          title: Text('Add Category'),
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                controller: _nameEditingController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: 'Category Name'),
              ),
            ),
            const Padding(
                padding: EdgeInsets.all(10),
                child: Row(children: [
                  RadioButton(title: 'income', type: CategoryType.income),
                  RadioButton(title: 'expense', type: CategoryType.expense)
                ])),
            Padding(
              padding: const EdgeInsets.all(10),
              child: ElevatedButton(
                  onPressed: () {
                    final _name = _nameEditingController.text;
                    if (_name.isEmpty) {
                      return;
                    }
                    final _type = selectedCategoryNotifier.value;
                    final _category = CategoryModel(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        name: _name,
                        type: _type);
                    CategoryDB.instance.insertCategory(_category);
                    Navigator.of(ctx).pop();
                  },
                  child: const Text("Add")),
            ),
          ],
        );
      });
}

class RadioButton extends StatelessWidget {
  final String title;
  final CategoryType type;

  const RadioButton({super.key, required this.title, required this.type});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ValueListenableBuilder(
            valueListenable: selectedCategoryNotifier,
            builder: (BuildContext ctx, CategoryType newCategory, Widget? _) {
              return Radio<CategoryType>(
                  value: type,
                  groupValue: selectedCategoryNotifier.value,
                  onChanged: (value) {
                    if (value == null) {
                      return;
                    }
                    selectedCategoryNotifier.value = value;
                    selectedCategoryNotifier.notifyListeners();
                  });
            }),
        Text(title),
      ],
    );
  }
}
