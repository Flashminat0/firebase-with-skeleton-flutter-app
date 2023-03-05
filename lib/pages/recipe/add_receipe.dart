import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddRecipePage extends StatefulWidget {
  const AddRecipePage({Key? key}) : super(key: key);

  @override
  State<AddRecipePage> createState() => _AddRecipePageState();
}

class _AddRecipePageState extends State<AddRecipePage> {
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

  // add this data to firebase
  Future addRecipeToFireStore() async {
    try {
      await FirebaseFirestore.instance.collection('recipes').add({
        'title': _titleController.text,
        'description': _descriptionController.text,
        'ingredients': _ingredients,
        'email': FirebaseAuth.instance.currentUser!.email,
      });

      //   go to home page
      Navigator.of(context).pop();
    } catch (e) {
      print(e);
    }
  }

  // dispose controllers
  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _ingredientController.dispose();
    super.dispose();
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
              //   Add recipe button on the bottom of the page
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
                onPressed: () {
                  addRecipeToFireStore();
                },
                child: const Text(
                  'Add Recipe',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
        ));
  }
}
