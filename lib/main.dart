import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_manager_app/models/category/category_model.dart';
import 'package:money_manager_app/models/transaction/transaction_model.dart';
import 'package:money_manager_app/screens/add_transaction/screen_add_transaction.dart';
import 'package:money_manager_app/screens/home/screen_home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  if (!Hive.isAdapterRegistered(CategoryTypeAdapter().typeId)) {
    Hive.registerAdapter(CategoryTypeAdapter());
  }

  if (!Hive.isAdapterRegistered(CategoryModelAdapter().typeId)) {
    Hive.registerAdapter(CategoryModelAdapter());
  }

  if (!Hive.isAdapterRegistered(TransactionModelAdapter().typeId)) {
    Hive.registerAdapter(TransactionModelAdapter());
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const ScreenHome(),
      routes: {
        ScreenAddTransaction.routeName: (ctx) => ScreenAddTransaction(),
      },
    );
  }
}
