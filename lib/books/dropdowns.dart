// ignore_for_file: prefer_const_constructors

import 'package:book_proj/books/books_cubit.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

class OrderByDropdown extends StatefulWidget {
  const OrderByDropdown({Key? key}) : super(key: key);

  @override
  State<OrderByDropdown> createState() => _OrderByDropdownState();
}

class _OrderByDropdownState extends State<OrderByDropdown> {
  String dropdownValue = 'Timestamp';

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      dropdownColor: Colors.purple,
      icon: const Icon(Icons.arrow_downward, color: Colors.white),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.white,
      ),
      onChanged: (String? newValue) {
        setState(() {
          dropdownValue = newValue!;
          context.read<BooksCubit>().changeOrder(newValue);
        });
      },
      items: <String>['Timestamp', 'Author', 'Name']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value,
              style: TextStyle(
                color: Colors.white,
              )),
        );
      }).toList(),
    );
  }
}

class CategoryDropdown extends StatefulWidget {
  const CategoryDropdown({
    Key? key,
    required String Category,
  })  : category = Category,
        super(key: key);
  final String category;
  @override
  State<CategoryDropdown> createState() =>
      _CategoryDropdownState(Category: category);
}

class _CategoryDropdownState extends State<CategoryDropdown> {
  _CategoryDropdownState({required String Category}) : dropdownValue = Category;
  String dropdownValue;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward, color: Colors.white),
      dropdownColor: Colors.purple,
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.white,
      ),
      onChanged: (String? newValue) {
        setState(() {
          dropdownValue = newValue!;
          context.read<BooksCubit>().changeCategory(newValue);
        });
      },
      items: <String>['All', 'Biography', 'Fiction', 'Poetry']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        );
      }).toList(),
    );
  }
}
