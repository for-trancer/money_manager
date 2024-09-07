import 'package:flutter/material.dart';
import 'package:money_manager_app/db/category/category_db.dart';
import 'package:money_manager_app/models/category/category_model.dart';
import 'package:money_manager_app/screens/add_transaction/screen_add_transaction.dart';
import 'package:money_manager_app/screens/category/category_add_popup.dart';
import 'package:money_manager_app/screens/category/screen_category.dart';
import 'package:money_manager_app/screens/home/widgets/bottom_navigation.dart';
import 'package:money_manager_app/screens/transactions/screen_transaction.dart';

class ScreenHome extends StatelessWidget {
  const ScreenHome({super.key});

  static ValueNotifier<int> selectedIndexNotifier = ValueNotifier(0);
  final _pages = const [ScreenTransaction(), ScreenCategory()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(
          'MONEY MANAGER',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      bottomNavigationBar: MoneyManagerBottomNavigation(),
      body: SafeArea(
          child: ValueListenableBuilder(
        valueListenable: selectedIndexNotifier,
        builder: (BuildContext context, int updatedIndex, _) {
          return _pages[updatedIndex];
        },
      )),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (selectedIndexNotifier.value == 0) {
              Navigator.of(context).pushNamed(ScreenAddTransaction.routeName);
            } else {
              ShowCategoryAddPopUp(context);
            }
          },
          child: Icon(Icons.add)),
    );
  }
}
