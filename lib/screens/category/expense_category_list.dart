import 'package:flutter/material.dart';
import 'package:money_manager_app/db/category/category_db.dart';
import 'package:money_manager_app/models/category/category_model.dart';

class ExpenseCategoryList extends StatelessWidget {
  const ExpenseCategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: CategoryDB().expenseCategoryListListener,
        builder: (BuildContext ctx, List<CategoryModel> newList, Widget? _) {
          return ListView.separated(
              padding: EdgeInsets.all(10),
              itemBuilder: (ctx, index) {
                final category = newList[index];
                return Card(
                  child: ListTile(
                    title: Text(category.name),
                    trailing: IconButton(
                        onPressed: () {
                          CategoryDB.instance.deleteCategory(category.id);
                        },
                        icon: Icon(Icons.delete)),
                  ),
                );
              },
              separatorBuilder: (ctx, index) {
                return const SizedBox(height: 10);
              },
              itemCount: newList.length);
        });
  }
}
