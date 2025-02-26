import 'package:expense_app/model/expense.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final List<Expense> _expense = [];
  final List<String> _categories = [
    'Food',
    'Transport',
    'Entertainment',
    'Bills'
  ];
  double _total = 0.0;

  void _addExpense(
    String title,
    double amount,
    DateTime date,
    String category,
  ) {
    setState(() {
      _expense.add(
        Expense(title: title, amount: amount, date: date, category: category),
      );
      _total += amount;
    });
  }

  void _showForm(BuildContext context) {
    TextEditingController titleController = TextEditingController();
    TextEditingController amountController = TextEditingController();
    String selectedCategory = _categories.first;
    DateTime selectedDate = DateTime.now();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 16,
              right: 16,
              top: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(labelText: "Title"),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: "Amount"),
              ),
              SizedBox(
                height: 10,
              ),
              DropdownButtonFormField<String>(
                items: _categories
                    .map((category) => DropdownMenuItem(
                        value: category, child: Text(category)))
                    .toList(),
                onChanged: (value) => selectedCategory = value!,
                decoration: InputDecoration(labelText: "Category"),
              ),
              SizedBox(
                height: 30,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () {
                      if (titleController.text.isEmpty ||
                          double.tryParse(amountController.text) == null) {
                        return;
                      }
                      _addExpense(
                          titleController.text,
                          double.parse(amountController.text),
                          selectedDate,
                          selectedCategory);
                      titleController.clear();
                      amountController.clear();
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Add Expense",
                    )),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Expense Tracker"),
        actions: [
          IconButton(
            onPressed: () => _showForm(context),
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: Column(
        children: [
          Center(
            child: Card(
              margin: EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Total: \$$_total",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _expense.length,
              itemBuilder: (ctx, index) {
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blueAccent,
                      child: Text(_expense[index].category),
                    ),
                    title: Text(_expense[index].title),
                    subtitle:
                        Text(DateFormat.yMMMd().format(_expense[index].date)),
                  ),
                );
              },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(context),
        child: Icon(Icons.add),
      ),
    );
  }
}
