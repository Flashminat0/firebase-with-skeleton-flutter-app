import 'package:flutter/material.dart';

class AddReceiptPage extends StatefulWidget {
  const AddReceiptPage({Key? key}) : super(key: key);

  @override
  State<AddReceiptPage> createState() => _AddReceiptPageState();
}

class _AddReceiptPageState extends State<AddReceiptPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // list of ingredients
  final List<String> _ingredients = <String>[];

  // typing ingredient
  final TextEditingController _ingredientController = TextEditingController();


  // Added ingredient to list
  void _addIngredient() {
    setState(() {
      _ingredients.add(_ingredientController.text.trim());
    });

    _ingredientController.clear();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Receipt'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: 'Title',
              ),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                hintText: 'Description',
              ),
            ),
            const SizedBox(height: 20),
            // Added ingredients list

            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Add Ingredient'),
                      content: TextField(
                        controller: _ingredientController,
                        decoration: const InputDecoration(
                          hintText: 'Ingredient',
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            _addIngredient();
                          },
                          child: const Text('Add'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text('Add Ingredient'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _ingredients.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_ingredients[index]),
                    trailing: IconButton(
                      onPressed: () {
                        setState(() {
                          _ingredients.removeAt(index);
                        });
                      },
                      icon: const Icon(Icons.delete),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      )
    );
  }
}
